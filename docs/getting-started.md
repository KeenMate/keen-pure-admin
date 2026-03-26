# Getting Started

KPureAdmin is a Phoenix LiveView component library that wraps the [Pure Admin](https://pureadmin.io) CSS framework into function components. It serves as a drop-in replacement for Phoenix's generated `CoreComponents`.

## Installation

Add `keen_pure_admin` to your `mix.exs`:

```elixir
def deps do
  [
    {:keen_pure_admin, "~> 1.0.0-rc.1"}
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
    use KPureAdmin.Components

    alias Phoenix.LiveView.JS
    unquote(verified_routes())
  end
end
```

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
      <.navbar_brand><h1>My App</h1></.navbar_brand>
    </:start>
    <:center>
      <.navbar_title><h2>Dashboard</h2></.navbar_title>
    </:center>
  </.navbar>

  <.layout_inner>
    <.sidebar>
      <.sidebar_item label="Dashboard" icon="fa-solid fa-gauge" href="/" is_active />
    </.sidebar>

    <.layout_content>
      <.main>{@inner_content}</.main>
      <.footer>
        <:start>&copy; 2026 My App</:start>
      </.footer>
    </.layout_content>
  </.layout_inner>
</.layout>
```

## Next Steps

- Browse the [component reference](KPureAdmin.Components.html) for all available components
- Check the [JS hooks guide](js-hooks.html) for interactive features
- See the [live demo](https://elixir.demo.pureadmin.io) for visual examples
