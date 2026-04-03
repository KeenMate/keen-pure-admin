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
    {:keen_pure_admin, "~> 1.0.0-rc.2"}
  ]
end
```

## Setup

### 1. Replace CoreComponents

In your `MyAppWeb` module (or wherever `html_helpers` is defined), replace the CoreComponents import:

```elixir
defp html_helpers do
  quote do
    import Phoenix.HTML

    # Replace this:
    # import MyAppWeb.CoreComponents

    # With this:
    use PureAdmin.Components

    alias Phoenix.LiveView.JS
    unquote(verified_routes())
  end
end
```

This replaces `button/1`, `input/1`, `simple_form/1`, `modal/1`, `table/1`, `list/1`, `label/1`, `flash/1`, and `flash_group/1`. Functions **not** replaced:

- **`header/1`** — use `@page_title` in `<.navbar_title>` (layout renders it, LiveView sets it)
- **`icon/1`** — use Font Awesome directly: `<i class="fa-solid fa-user"></i>`
- **`translate_error/1`** — keep your app's Gettext-based implementation
- **`show/1`**, **`hide/1`** — use `Phoenix.LiveView.JS` directly

### 2. Include Pure Admin CSS

Install the CSS framework:

```bash
cd assets
npm install @keenmate/pure-admin-core
```

Add to your root layout (`root.html.heex`):

```heex
<link rel="stylesheet" href={~p"/assets/css/pure-admin.css"} />
```

Or use a CDN:

```html
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/@keenmate/pure-admin-core/dist/css/main.css" />
```

### 3. Register JS Hooks

```javascript
// assets/js/app.js
import { PureAdminHooks } from "keen_pure_admin"

let liveSocket = new LiveSocket("/live", Socket, {
  hooks: { ...PureAdminHooks }
})
```

### 4. Add Floating UI (for tooltips, popovers, split buttons)

```html
<script src="https://cdn.jsdelivr.net/npm/@floating-ui/core@1.6.9"></script>
<script src="https://cdn.jsdelivr.net/npm/@floating-ui/dom@1.6.13"></script>
```

### 5. Add Font Awesome (icons)

```html
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" />
```

### 6. FOUC Prevention (optional)

Add to your root layout before `{@inner_content}` to prevent flash of unstyled content:

```heex
<body>
  <.fouc_prevention_script />
  {@inner_content}
</body>
```

## Your First Layout

```heex
<.layout>
  <.navbar>
    <:start>
      <.navbar_burger />
      <.navbar_brand><.heading level="1">My App</.heading></.navbar_brand>
    </:start>
    <:center>
      <.navbar_title><.heading level="2">Dashboard</.heading></.navbar_title>
    </:center>
  </.navbar>

  <.layout_inner>
    <.sidebar>
      <.sidebar_item label="Dashboard" icon="fa-solid fa-gauge" href="/" is_active />
    </.sidebar>

    <.layout_content>
      <.main>
        <.flash_group flash={@flash} />
        {@inner_content}
      </.main>
      <.footer>
        <:start>&copy; 2026 My App</:start>
      </.footer>
    </.layout_content>
  </.layout_inner>
</.layout>
```

## Next Steps

- Browse the [component reference](PureAdmin.Components.html) for all available components
- Check the [JS hooks guide](js-hooks.html) for interactive features
- See the [live demo](https://elixir.demo.pureadmin.io) for visual examples
