# Dockerfile for the PureAdmin demo app
# Deployed at elixir.demo.pureadmin.io
#
# Build:
#   docker build -t keen-pure-admin-demo .
#   docker run -p 4000:4000 \
#     -e SECRET_KEY_BASE=$(mix phx.gen.secret) \
#     -e PHX_HOST=localhost \
#     keen-pure-admin-demo

# ==============================================================================
# Build stage
# ==============================================================================
FROM elixir:1.18-slim AS builder

RUN apt-get update \
  && apt-get install -y --no-install-recommends build-essential git ca-certificates \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /build

RUN mix local.hex --force \
  && mix local.rebar --force

ENV MIX_ENV="prod"

# Copy the parent library (keen_pure_admin) — demo depends on it via path: ".."
COPY mix.exs mix.lock ./
COPY lib lib

# Copy demo dependency manifest and fetch deps
COPY demo/mix.exs demo/mix.lock demo/
COPY demo/config/config.exs demo/config/prod.exs demo/config/

WORKDIR /build/demo
RUN mix deps.get --only $MIX_ENV
RUN mix deps.compile

# Copy application source (paths relative to build context, destinations absolute)
COPY demo/lib /build/demo/lib
COPY demo/priv /build/demo/priv
COPY demo/assets /build/demo/assets

# Compile
RUN mix compile

# Copy app CSS to priv/static (esbuild only bundles JS; theme CSS includes the core)
RUN mkdir -p priv/static/assets/css \
  && cp assets/css/app.css priv/static/assets/css/

# Bundle the starter themes via PureAdmin CLI.
# `pureadmin.json` (declarations) + `pureadmin.lock.json` (resolutions) are read
# by `themes ci` to reproduce exactly what's checked in. `.pureadmin.json`
# (per-developer overrides) is gitignored and intentionally NOT copied —
# `themes ci` would ignore it anyway.
# Themes resolve to `priv/static/themes/<id>/` per `themesDir` in pureadmin.json.
# Themes NOT bundled here (cobalt2, gruvbox, etc.) still work at runtime: the
# DemoWeb.ThemePlug downloads any unknown theme on demand from pureadmin.io and
# caches it in /tmp/pure-admin-themes/, so `?theme=<missing>` still resolves.
COPY demo/pureadmin.json demo/pureadmin.lock.json ./
RUN apt-get update && apt-get install -y --no-install-recommends nodejs npm && rm -rf /var/lib/apt/lists/* \
  && npx @keenmate/pureadmin themes ci

# Build and digest assets (esbuild + phx.digest)
RUN mix assets.deploy

# Copy runtime config last (no recompile needed)
COPY demo/config/runtime.exs config/

# Build the OTP release
RUN mix release

# ==============================================================================
# Runtime stage — minimal image
# ==============================================================================
FROM debian:trixie-slim AS final

RUN apt-get update \
  && apt-get install -y --no-install-recommends libstdc++6 openssl libncurses6 locales ca-certificates \
  && rm -rf /var/lib/apt/lists/*

RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen \
  && locale-gen

ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8

WORKDIR /app
RUN chown nobody /app

ENV MIX_ENV="prod"
ENV PHX_SERVER="true"

COPY --from=builder --chown=nobody:root /build/demo/_build/prod/rel/demo ./

USER nobody

EXPOSE 4000

CMD ["/app/bin/demo", "start"]
