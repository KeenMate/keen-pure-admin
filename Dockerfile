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
  && apt-get install -y --no-install-recommends \
       build-essential \
       git \
       ca-certificates \
       nodejs \
       npm \
       unzip \
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

# Bundle all declared themes via PureAdmin CLI. Done BEFORE source copy so a
# source-only change doesn't bust the ~75MB themes layer.
#
# `pureadmin.json` (declarations, 15 themes) + `pureadmin.lock.json`
# (resolutions) are read by `themes ci` to reproduce exactly what's checked
# in — strict mode: fails fast on lock drift, ignores `.pureadmin.json`
# (per-developer disk overrides; gitignored and excluded from the build
# context via `.dockerignore`).
# Themes resolve to `priv/static/themes/<id>/` per `themesDir` in pureadmin.json.
# Any theme NOT in pureadmin.json can still be loaded at runtime via
# DemoWeb.ThemePlug's on-demand fetch from pureadmin.io (cached at
# /tmp/pure-admin-themes/).
COPY demo/pureadmin.json demo/pureadmin.lock.json ./
RUN npx --yes @keenmate/pureadmin themes ci

# Copy application source (paths relative to build context, destinations
# absolute). `priv/static/themes/` is .dockerignored — the only source of
# themes inside the image is the `themes ci` layer above.
COPY demo/lib /build/demo/lib
COPY demo/priv /build/demo/priv
COPY demo/assets /build/demo/assets

# Compile
RUN mix compile

# Copy app CSS to priv/static (esbuild only bundles JS; theme CSS includes the core)
RUN mkdir -p priv/static/assets/css \
  && cp assets/css/app.css priv/static/assets/css/

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
