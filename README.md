# KPureAdmin

Phoenix LiveView component library wrapping the [Pure Admin](https://github.com/nicorevin/pure-admin) CSS framework into function components and LiveComponents.

Drop-in replacement for Phoenix `CoreComponents` — provides `button/1`, `badge/1`, `card/1`, `modal/1`, `table/1`, `input/1`, and 30+ more components with full BEM class support.

## Installation

Add `keen_pure_admin` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:keen_pure_admin, "~> 0.2.0"}
  ]
end
```

## Setup

### 1. Import components

Replace your `CoreComponents` import with `KPureAdmin.Components`:

```elixir
# In your app's html_helpers or MyAppWeb module
use KPureAdmin.Components
```

### 2. Register JS hooks

```javascript
// assets/js/app.js
import { PureAdminHooks } from "keen_pure_admin"

let liveSocket = new LiveSocket("/live", Socket, {
  hooks: { ...PureAdminHooks }
})
```

### 3. Add FOUC prevention (optional)

In your root layout, add the script before `{@inner_content}` to prevent flash of unstyled content when using the settings panel:

```heex
<body>
  <.fouc_prevention_script />
  {@inner_content}
</body>
```

## Components

### Layout

Full page structure matching the Pure Admin three-section navbar + sidebar + content + footer pattern:

```heex
<.layout>
  <.navbar>
    <:start>
      <.navbar_burger />
      <.navbar_brand><h1>My App</h1></.navbar_brand>
      <.navbar_nav>
        <.navbar_nav_item href="/">Dashboard</.navbar_nav_item>
        <.navbar_nav_item href="/reports" has_dropdown>
          Reports
          <:dropdown>
            <.navbar_dropdown>
              <.navbar_nav_item href="/reports/sales">Sales</.navbar_nav_item>
              <.navbar_nav_item href="/reports/users">Users</.navbar_nav_item>
            </.navbar_dropdown>
          </:dropdown>
        </.navbar_nav_item>
      </.navbar_nav>
    </:start>
    <:center>
      <.navbar_title><h2>Dashboard</h2></.navbar_title>
    </:center>
    <:end_>
      <.notifications count={3}>
        <.notification_item variant="primary" icon="fa-solid fa-bell" is_unread>
          <:title>New message</:title>
          <:text>You have a new message</:text>
          <:time>2 min ago</:time>
        </.notification_item>
      </.notifications>
      <.navbar_profile_btn name="John Doe" phx-click={toggle_profile_panel()} />
    </:end_>
  </.navbar>

  <.layout_inner>
    <.sidebar>
      <.sidebar_item label="Dashboard" icon="fa-solid fa-gauge" href="/" is_active />
      <.sidebar_submenu label="Settings" icon="fa-solid fa-gear">
        <.sidebar_item label="General" href="/settings" />
        <.sidebar_item label="Security" href="/settings/security" />
      </.sidebar_submenu>
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

### Profile Panel

Slide-out profile panel with avatar, tabs, navigation, and click-outside-to-close:

```heex
<.profile_panel name="John Doe" email="john@example.com" role="Admin">
  <:tabs>
    <div class="pa-tabs pa-tabs--full">
      <button class="pa-tabs__item pa-tabs__item--active" data-profile-tab="profile">
        <i class="fa-solid fa-user"></i>
        <span class="pa-profile-panel__tab-text">Profile</span>
      </button>
      <button class="pa-tabs__item" data-profile-tab="favorites">
        <i class="fa-solid fa-star"></i>
        <span class="pa-profile-panel__tab-text">Favorites</span>
      </button>
    </div>
  </:tabs>

  <div class="pa-tabs__panel pa-tabs__panel--active" data-profile-panel="profile">
    <nav class="pa-profile-panel__nav">
      <ul>
        <.profile_nav_item href="/profile" icon="fa-solid fa-user">Settings</.profile_nav_item>
        <.profile_nav_item href="/logout" icon="fa-solid fa-right-from-bracket">Sign Out</.profile_nav_item>
      </ul>
    </nav>
  </div>

  <:footer_>
    <button class="pa-btn pa-btn--danger pa-btn--block">Sign Out</button>
  </:footer_>
</.profile_panel>
```

### Settings Panel

Client-side settings panel for theme mode, layout width, sidebar options, fonts, and more — all persisted to localStorage:

```heex
<.settings_panel />
```

### UI Components

| Component | Description |
|---|---|
| `button/1` | Buttons with variants, sizes, loading state |
| `badge/1` | Inline badges/tags |
| `alert/1` | Dismissible alerts |
| `card/1` | Cards with header, body, footer, tabs |
| `modal/1` | Modal dialogs |
| `table/1` | Data tables with sorting |
| `tabs/1` | Tab navigation with panels |
| `input/1`, `form_group/1` | Form inputs with labels, errors |
| `grid/1`, `col/1` | 12-column grid system |
| `stat/1` | Stat cards (hero, square) |
| `timeline/1` | Timeline displays |
| `loader/1` | Loading spinners |
| `callout/1` | Callout/info boxes |
| `list/1` | Styled lists |
| `code/1` | Code blocks |
| `toast/1` | Toast notifications (LiveComponent) |

### JS Hooks

| Hook | Description |
|---|---|
| `PureAdminSettings` | Settings panel localStorage management |
| `PureAdminProfilePanel` | Profile panel tabs, favorites, click-outside |
| `PureAdminTooltip` | Tooltip positioning |
| `PureAdminPopover` | Popover positioning |
| `PureAdminToast` | Toast auto-dismiss |
| `PureAdminCommandPalette` | Command palette keyboard navigation |
| `PureAdminDetailPanel` | Detail panel toggle |
| `PureAdminSidebarResize` | Drag-to-resize sidebar |

## CSS Framework

This library generates HTML with BEM classes matching `@keenmate/pure-admin-core`. You need to include the Pure Admin CSS in your project separately.

All classes follow the pattern: `pa-{block}`, `pa-{block}--{modifier}`, `pa-{block}__{element}`.

## Development

```bash
mix deps.get      # Install dependencies
mix compile        # Compile
mix test           # Run tests
mix format         # Format code
mix quality        # Format check + credo + dialyzer
```

### Demo App

```bash
cd demo
mix deps.get
mix phx.server    # Visit http://localhost:4000
```

## License

MIT
