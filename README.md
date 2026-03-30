# PureAdmin

[![Hex.pm](https://img.shields.io/hexpm/v/keen_pure_admin.svg)](https://hex.pm/packages/keen_pure_admin)
[![Hex Docs](https://img.shields.io/badge/hex-docs-blue.svg)](https://hexdocs.pm/keen_pure_admin)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](https://opensource.org/licenses/MIT)

Phoenix LiveView component library wrapping the [Pure Admin](https://github.com/KeenMate/pure-admin) CSS framework into function components and LiveComponents.

Drop-in replacement for Phoenix `CoreComponents` -- provides `button/1`, `badge/1`, `card/1`, `modal/1`, `table/1`, `input/1`, and 35+ more components with full BEM class support.

**Main site:** [pureadmin.io](https://pureadmin.io) -- themes, documentation, and component showcase

**Live demo:** [elixir.demo.pureadmin.io](https://elixir.demo.pureadmin.io)

## Prerequisites

Create a new Phoenix project **without Tailwind** — Pure Admin provides its own CSS framework:

```bash
mix phx.new my_app --no-tailwind
```

> If you have an existing project that uses Tailwind, remove the Tailwind dependency and its configuration before adding Pure Admin, as the two CSS frameworks will conflict.

## Installation

Add `keen_pure_admin` to your list of dependencies in `mix.exs`:

### From Hex (recommended)

```elixir
def deps do
  [
    {:keen_pure_admin, "~> 1.0.0-rc.1"}
  ]
end
```

### From GitHub

```elixir
def deps do
  [
    {:keen_pure_admin, github: "KeenMate/keen-pure-admin", tag: "v1.0.0-rc.1"}
  ]
end
```

### Local path (for development)

```elixir
def deps do
  [
    {:keen_pure_admin, path: "../keen-pure-admin"}
  ]
end
```

Then fetch dependencies:

```bash
mix deps.get
```

## Setup

### 1. Import components

Replace your `CoreComponents` import with `PureAdmin.Components`:

```elixir
# In your app's html_helpers or MyAppWeb module
use PureAdmin.Components
```

This replaces `button/1`, `input/1`, `simple_form/1`, `modal/1`, `table/1`, `list/1`, `label/1`, `flash/1`, and `flash_group/1`. A few CoreComponents functions are not replaced:

- **`header/1`** — use `@page_title` in `<.navbar_title>` (the layout renders it, each LiveView sets it)
- **`icon/1`** — use Font Awesome directly: `<i class="fa-solid fa-user"></i>`
- **`translate_error/1`** — keep your app's Gettext-based implementation or copy it from the generated CoreComponents
- **`show/1`**, **`hide/1`** — use `Phoenix.LiveView.JS.show/1` and `JS.hide/1` directly

### 2. Include Pure Admin CSS

This library generates HTML with BEM classes matching [`@keenmate/pure-admin-core`](https://www.npmjs.com/package/@keenmate/pure-admin-core). You need to include the Pure Admin CSS in your project.

Install the CSS framework via npm:

```bash
cd assets
npm install @keenmate/pure-admin-core
```

Then import it in your CSS:

```css
@import "@keenmate/pure-admin-core";
```

Or use a CDN in your `root.html.heex`:

```html
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/@keenmate/pure-admin-core/dist/pure-admin.min.css" />
```

### 3. Register JS hooks

```javascript
// assets/js/app.js
import { PureAdminHooks } from "keen_pure_admin"

let liveSocket = new LiveSocket("/live", Socket, {
  hooks: { ...PureAdminHooks }
})
```

### 4. Add Floating UI (required for tooltips, popovers, split buttons)

```html
<script src="https://cdn.jsdelivr.net/npm/@floating-ui/core@1.6.9"></script>
<script src="https://cdn.jsdelivr.net/npm/@floating-ui/dom@1.6.13"></script>
```

Or install via npm:

```bash
cd assets
npm install @floating-ui/dom
```

### 5. Add Font Awesome (icons)

```html
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" />
```

### 6. Add FOUC prevention (optional)

In your root layout, add the script before `{@inner_content}` to prevent flash of unstyled content when using the settings panel or sidebar submenus:

```heex
<body>
  <.fouc_prevention_script />
  {@inner_content}
</body>
```

### 7. Add global toast service (optional)

Add a toast container to your app layout for app-wide toast notifications:

```heex
<.toast_container id="toasts" position="top-end" is_hook />
```

Then push toasts from any LiveView:

```elixir
alias PureAdmin.Components.Toast, as: PureToast

socket |> PureToast.push_toast("success", "Saved!", "Changes saved successfully.")
```

For cross-page delivery (e.g., background tasks that complete after navigation), broadcast via PubSub and handle in an `on_mount` hook:

```elixir
# In your on_mount hook
Phoenix.PubSub.subscribe(MyApp.PubSub, "toasts")

attach_hook(socket, :global_toasts, :handle_info, fn
  {:push_toast, variant, title, message, opts}, socket ->
    {:halt, PureToast.push_toast(socket, variant, title, message, opts)}
  _other, socket ->
    {:cont, socket}
end)

# From a background task
Phoenix.PubSub.broadcast(MyApp.PubSub, "toasts",
  {:push_toast, "success", "Done!", "Task completed.", duration: 0})
```

## Components

### Layout

Full page structure matching the Pure Admin three-section navbar + sidebar + content + footer pattern:

```heex
<.layout>
  <.navbar>
    <:start>
      <.navbar_burger />
      <.navbar_brand><.heading level="1">My App</.heading></.navbar_brand>
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
      <.navbar_title><.heading level="2">Dashboard</.heading></.navbar_title>
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
      <.sidebar_submenu id="settings" label="Settings" icon="fa-solid fa-gear" is_open={String.starts_with?(@current_path, "/settings")}>
        <.sidebar_item label="General" href="/settings" />
        <.sidebar_item label="Security" href="/settings/security" />
      </.sidebar_submenu>
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

Client-side settings panel for theme mode, layout width, sidebar options, fonts, and more -- all persisted to localStorage:

```heex
<.settings_panel />
```

### UI Components

| Component | Description |
|---|---|
| `button/1`, `split_button/1`, `button_group/1` | Buttons with variants, sizes, loading, split dropdown, responsive groups |
| `badge/1`, `label/1`, `composite_badge/1`, `badge_group/1` | Badges, labels, composite badges with expand/collapse |
| `alert/1` | Dismissible alerts |
| `callout/1` | Callout/info boxes |
| `card/1` | Cards with header (title/subtitle/description), body, footer, tabs |
| `modal/1` | Modal dialogs |
| `popconfirm/1` | Popconfirm dialogs anchored to trigger buttons |
| `table/1`, `table_card/1`, `table_container/1` | Data tables with sorting, card wrappers, responsive grid |
| `comparison_table/1`, `comparison_row/1`, `comparison_value/1` | Two/three-column data comparison with change/conflict highlighting |
| `tabs/1` | Tab navigation with panels |
| `input/1`, `form_group/1`, `input_wrapper/1` | Form inputs with labels, errors, clear button |
| `filter_card/1` | Expandable filter card with advanced filters |
| `grid/1`, `column/1` | Flexbox grid with percentage/fraction columns |
| `section/1` | Content section with optional `title_text` heading |
| `stat/1` | Stat cards (hero, square) |
| `timeline/1` | Timeline displays |
| `loader/1`, `loader_center/1`, `loader_overlay/1` | Loading spinners |
| `basic_list/1`, `ordered_list/1`, `definition_list/1` | HTML lists with spacing, icons, borders |
| `checkbox_list/1`, `checkbox_list_item/1`, `checkbox_box/1` | Checkbox lists with variants, layouts, actions |
| `list/1`, `list_item/1` | Complex lists with avatar, title, subtitle, meta |
| `code/1`, `code_block/1` | Inline code and code blocks |
| `tooltip/1`, `popover/1` | Tooltips and popovers with Floating UI positioning |
| `toast/1`, `toast_container/1`, `push_toast/5` | Toast notifications with client-side rendering via JS hook |
| `flash/1`, `flash_group/1`, `flash_container/1`, `push_flash/5` | Flash messages — standard `@flash` compat + independent containers with markdown body and action buttons |
| `pager/1`, `load_more/1` | Pagination with page input, first/last buttons |

### JS Hooks

| Hook | Description |
|---|---|
| `PureAdminSettings` | Settings panel localStorage management |
| `PureAdminProfilePanel` | Profile panel tabs, favorites, click-outside |
| `PureAdminTooltip` | Tooltip positioning |
| `PureAdminPopover` | Popover positioning |
| `PureAdminToast` | Toast auto-dismiss |
| `PureAdminFlash` | Independent inline flash containers with markdown and action buttons |
| `PureAdminCommandPalette` | Command palette: multi-step commands (`/`), scoped search (`:`), keyboard nav |
| `PureAdminDetailPanel` | Detail panel toggle |
| `PureAdminSidebarResize` | Drag-to-resize sidebar |
| `PureAdminCharCounter` | Character counter with translatable messages |
| `PureAdminCheckbox` | Tri-state checkbox indeterminate sync |
| `PureAdminSplitButton` | Split button dropdown via Floating UI |
| `PureAdminSidebarSubmenu` | Sidebar submenu localStorage persistence |
| `PureAdminInfiniteScroll` | IntersectionObserver-based infinite scroll |

## CSS Framework

All classes follow the BEM pattern: `pa-{block}`, `pa-{block}--{modifier}`, `pa-{block}__{element}`.

Browse the live component showcase and theme previews at [pureadmin.io](https://pureadmin.io).

### Available Themes

| Theme | Package |
|---|---|
| Default | `@keenmate/pure-admin-core` |
| Audi | `@keenmate/pure-admin-theme-audi` |
| Corporate | `@keenmate/pure-admin-theme-corporate` |
| Dark | `@keenmate/pure-admin-theme-dark` |
| Express | `@keenmate/pure-admin-theme-express` |
| Minimal | `@keenmate/pure-admin-theme-minimal` |

### Installing Themes

Theme zips are self-contained — compiled CSS in `dist/` references fonts via relative paths (`../assets/fonts/...`), so extracting preserves correct asset resolution with no path adjustments needed. Each theme includes compiled CSS, SCSS source (for customization), bundled fonts, and a `theme.json` manifest.

#### Option A: Manual download

Download theme zips from [pureadmin.io](https://pureadmin.io) and extract them into `priv/static/themes/`:

```
priv/static/themes/
├── themes.json
├── audi/
│   ├── theme.json
│   ├── dist/audi.css
│   ├── scss/audi.scss
│   └── assets/fonts/*.woff2
├── dark/
│   ├── dist/dark.css
│   └── ...
└── ...
```

#### Option B: Pure Admin CLI

Install the [`@keenmate/pureadmin`](https://www.npmjs.com/package/@keenmate/pureadmin) CLI and manage themes in your project:

```bash
npm install -g @keenmate/pureadmin
pureadmin themes audi dark express    # download and extract
pureadmin update                      # re-download only changed themes
```

The CLI tracks versions and checksums in `pure-admin.json` — only changed themes are re-downloaded.

#### Option C: Download during CI/CD build

Fetch themes automatically in your Dockerfile using the bundle API:

```dockerfile
ARG THEMES_URL=https://pureadmin.io/api/bundle?themes=audi,dark,express,corporate,minimal
RUN apt-get update && apt-get install -y --no-install-recommends curl unzip && rm -rf /var/lib/apt/lists/* \
  && mkdir -p priv/static/themes \
  && curl -fsSL -o /tmp/themes.zip "${THEMES_URL}" \
  && unzip -o /tmp/themes.zip -d priv/static/themes \
  && rm -f /tmp/themes.zip
```

Pass a comma-separated list of theme names to the `themes` query parameter. The API returns a single zip with all requested themes. See `demo/Dockerfile` for a complete example.

#### Theme cache invalidation

The demo app's `ThemePlug` caches downloaded themes to disk. Each theme's `theme.json` contains a `checksums.content_sha` field — a SHA-256 hash of the package contents. On access, the plug validates the cache in the background by sending a conditional request (`If-None-Match: <content_sha>`) to pureadmin.io. If the server returns 200 (theme updated), it re-downloads without blocking the current request. Freshness checks are throttled to once per 10 minutes per theme.

To force-clear the cache:

```bash
make themes-clear
```

## Requirements

- Elixir ~> 1.15
- Phoenix LiveView ~> 1.0
- `@keenmate/pure-admin-core` CSS (v2.2.0+)

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
mix setup         # Install deps + build assets
mix phx.server    # Visit http://localhost:4000
```

### Running the Demo with Podman

Using Make (recommended):

```bash
make podman-build     # Build the image
make podman-run       # Run the container (port 4000)
make podman-deploy    # Build + run in one step
make podman-push      # Push to registry.km8.es
make podman-logs      # Tail container logs
make podman-stop      # Stop the container
make podman-clean     # Remove container and image
```

Or manually:

```bash
podman build -f demo/Dockerfile -t keen-pure-admin-demo .
podman run -p 4000:4000 \
  -e SECRET_KEY_BASE=$(mix phx.gen.secret) \
  -e PHX_HOST=localhost \
  keen-pure-admin-demo
```

For production (`elixir.demo.pureadmin.io`):

```bash
SECRET_KEY_BASE=<your-secret> PHX_HOST=elixir.demo.pureadmin.io make podman-deploy
```

## License

MIT
