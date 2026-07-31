# Getting Started

PureAdmin is a Phoenix LiveView component library that wraps the [Pure Admin](https://pureadmin.io) CSS framework into function components. It serves as a drop-in replacement for Phoenix's generated `CoreComponents`.

## Prerequisites

Create a new Phoenix project **without Tailwind** — Pure Admin provides its own CSS framework:

```bash
mix phx.new my_app --no-tailwind
```

> If you have an existing project that uses Tailwind, remove the Tailwind dependency and its configuration before adding Pure Admin, as the two CSS frameworks will conflict.

## Installation

Add `keen_pure_admin` to your `mix.exs`:

```elixir
def deps do
  [
    {:keen_pure_admin, "~> 1.0"}
  ]
end
```

Then fetch dependencies:

```bash
mix deps.get
```

## Setup

### 1. Replace CoreComponents import

In your `MyAppWeb` module (`lib/my_app_web.ex`), find the `html_helpers` function and replace the CoreComponents import:

```diff
- import MyAppWeb.CoreComponents
+ use PureAdmin.Components
```

This replaces `button/1`, `input/1`, `simple_form/1`, `modal/1`, `table/1`, `list/1`, `label/1`, `flash/1`, and `flash_group/1`. Functions **not** replaced:

- **`header/1`** — use `@page_title` in `<.navbar_title>` (layout renders it, LiveView sets it)
- **`icon/1`** — use Font Awesome directly: `<i class="fa-solid fa-user"></i>`
- **`translate_error/1`** — `PureAdmin.Components.Form.translate_error/1` ships a plain `%{key}`-interpolating default. For Gettext, set `config :keen_pure_admin, :error_formatter, {MyAppWeb.CoreComponents, :translate_error}` and errors flow through your existing pipeline.
- **`show/1`**, **`hide/1`** — use `Phoenix.LiveView.JS` directly

Also clean up these generated files that use Tailwind classes or CoreComponents functions:

- **Delete** `lib/my_app_web/components/core_components.ex` — no longer needed
- **Delete** `priv/static/assets/default.css` — Phoenix default styles that conflict with Pure Admin
- **Replace** `lib/my_app_web/controllers/page_html/home.html.heex` — the generated page uses Tailwind classes and `Layouts.flash_group` which no longer exists. Swap it for a minimal page (it renders inside the `app` layout you set up in step 2):

```heex
<%!-- lib/my_app_web/controllers/page_html/home.html.heex --%>
<.card title_text="Welcome to my_app">
  <.paragraph>Your app is now using Pure Admin components.</.paragraph>
  <.button variant="primary">Get started</.button>
</.card>
```

### 2. Replace the generated layouts

Phoenix generates a `layouts.ex` with inline `app/1` and `flash_group/1` functions that conflict with PureAdmin. Replace the entire file:

```elixir
# lib/my_app_web/components/layouts.ex
defmodule MyAppWeb.Layouts do
  use MyAppWeb, :html
  embed_templates "layouts/*"
end
```

Then create `lib/my_app_web/components/layouts/app.html.heex` with a PureAdmin layout:

```heex
<.layout>
  <.navbar>
    <:start>
      <.navbar_burger />
      <.navbar_brand />
    </:start>
    <:center>
      <.navbar_title>
        <h2>{assigns[:page_title] || "Home"}</h2>
      </.navbar_title>
    </:center>
  </.navbar>

  <.layout_inner>
    <.sidebar>
      <.sidebar_item label="Home" icon="fa-solid fa-house" href="/" />
    </.sidebar>

    <.layout_content>
      <.main>
        <.flash_group flash={@flash} />
        {@inner_content}
      </.main>
      <.footer />
    </.layout_content>
  </.layout_inner>
</.layout>
```

Add the app layout to your router's browser pipeline (Phoenix 1.8 doesn't set this by default — the generated code used an inline `app/1` function instead):

```elixir
# lib/my_app_web/router.ex
pipeline :browser do
  # ... existing plugs ...
  plug :put_root_layout, html: {MyAppWeb.Layouts, :root}
  plug :put_layout, html: {MyAppWeb.Layouts, :app}       # <-- add this line
  # ...
end
```

### 3. Configure your app (optional)

```elixir
# config/config.exs
config :keen_pure_admin,
  app_name: "My App",
  app_version: "1.0.0",
  copyright: "© 2026 My Company",
  font_class: "pa-font-responsive"
```

The `navbar_brand` and `footer` components read from this config automatically. Add the font class to `<html>` in your root layout:

```heex
<html lang="en" {PureAdmin.Config.root_html_attrs()}>
```

### 4. Install a theme and update the root layout

Declare the themes your app ships with in a `pureadmin.json` at your project root:

```json
{
  "themesDir": "priv/static/themes",
  "themes": {
    "audi": {}
  }
}
```

Then resolve and download them with the PureAdmin CLI:

```bash
npx @keenmate/pureadmin themes install
```

This generates `pureadmin.lock.json` (commit it — same convention as `package-lock.json`) and extracts each theme to `priv/static/themes/<id>/`. CI / Docker builds should run `npx @keenmate/pureadmin themes ci` instead, which reproduces the lockfile exactly and fails fast if the two files drift. Add `priv/static/themes/` to `.gitignore` — themes are downloaded artifacts.

Add `themes` to your static paths so Phoenix serves the files:

```elixir
# lib/my_app_web.ex
def static_paths, do: ~w(assets fonts images themes favicon.ico robots.txt)
```

Then replace the CSS links in `lib/my_app_web/components/layouts/root.html.heex`. Remove the Phoenix-generated `default.css` and add the theme CSS, Font Awesome, and Floating UI:

```heex
<head>
  <%!-- Pure Admin theme (includes core CSS) --%>
  <link rel="stylesheet" href="/themes/audi/css/audi.css" />
  <%!-- Your app's own styles (keep this — it's where your custom CSS lives) --%>
  <link phx-track-static rel="stylesheet" href={~p"/assets/css/app.css"} />
  <%!-- Font Awesome icons --%>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" />
  <%!-- Floating UI (for tooltips, popovers, split buttons) --%>
  <script src="https://cdn.jsdelivr.net/npm/@floating-ui/core@1.6.9"></script>
  <script src="https://cdn.jsdelivr.net/npm/@floating-ui/dom@1.6.13"></script>
  <%!-- Your app JS --%>
  <script defer phx-track-static type="text/javascript" src={~p"/assets/js/app.js"}></script>
</head>
<body>
  <.fouc_prevention_script />
  {@inner_content}
</body>
```

Browse all available themes at [pureadmin.io](https://pureadmin.io).

### 5. Register JS hooks

Add `PureAdminHooks` to your LiveSocket in `assets/js/app.js` and call `initPureAdminEvents()` once to wire the delegated click handlers (popconfirm, popover, copy-to-clipboard, tabs scroll, badge-group expand/collapse):

```javascript
import { PureAdminHooks, initPureAdminEvents } from "keen_pure_admin"

// Merge with any existing hooks
const liveSocket = new LiveSocket("/live", Socket, {
  hooks: { ...colocatedHooks, ...PureAdminHooks }
})

// Wire delegated click handlers. Idempotent; safe to call once at startup.
initPureAdminEvents()
```

> The bare `from "keen_pure_admin"` import resolves because Phoenix ≥ 1.8 adds `deps/` to esbuild's `NODE_PATH` (see the `:esbuild` config in `config/config.exs`). If esbuild reports `Could not resolve "keen_pure_admin"` — e.g. on an app upgraded from an older Phoenix — either add `env: %{"NODE_PATH" => [Path.expand("../deps", __DIR__), Mix.Project.build_path()]}` to your esbuild config, or import via the relative path `from "../../deps/keen_pure_admin/lib/assets/js/keen_pure_admin"`.

All component behaviour is delivered through `PureAdminHooks` and `initPureAdminEvents` — no inline `onclick=` handlers in the rendered markup, so apps can ship with strict CSP (`script-src 'self'`) without `'unsafe-inline'`. The one exception is the optional FOUC-prevention script (`<.fouc_prevention_script />`), which must run inline in `<head>` before CSS loads; for CSP-strict apps, attach a per-request nonce.

## Next Steps

- Browse the [component reference](PureAdmin.Components.html) for all available components
- Check the [JS hooks guide](js-hooks.html) for interactive features
- See the [live demo](https://elixir.demo.pureadmin.io) for visual examples
