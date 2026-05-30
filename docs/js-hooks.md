# JS Hooks

PureAdmin ships 18 JavaScript hooks for interactive features. Import them all via `PureAdminHooks` or individually.

Most component behaviour is delivered via these hooks plus a delegated-events module — call `initPureAdminEvents()` once at startup to wire the delegated handlers (popconfirm, popover, copy-to-clipboard, tabs scroll, badge-group expand/collapse). Together they let apps ship with strict CSP (`script-src 'self'`) without `'unsafe-inline'`.

## Setup

```javascript
import { PureAdminHooks, initPureAdminEvents } from "keen_pure_admin"

let liveSocket = new LiveSocket("/live", Socket, {
  hooks: { ...PureAdminHooks }
})

// Wire delegated click handlers. Idempotent; safe to call once at startup.
initPureAdminEvents()
```

## Available Hooks

### PureAdminSettings

Settings panel for theme mode, layout width, sidebar, fonts. Fetches theme manifests from `/api/themes/manifests` and dynamically populates the theme selector. All settings persist to `localStorage`.

Used by: `<.settings_panel />`

### PureAdminProfilePanel

Profile panel with tab switching, favorites management, and click-outside-to-close.

Used by: `<.profile_panel />`

### PureAdminTooltip

CSS-only tooltip positioning using Floating UI. Handles placement, auto-flip, and theme color variants.

Used by: `<.tooltip />` (when using floating/JS positioning)

### PureAdminPopover

Click-triggered popover with title, placement, size, and alignment. Uses Floating UI for positioning, moves content to `document.body` to avoid clipping.

Used by: `<.popover />`

### PureAdminToast

Toast auto-dismiss with configurable duration. Handles show/hide transitions and progress bar animation. Renders toasts client-side from `push_event` data.

Used by: `<.toast_container is_hook />`

### PureAdminFlash

Independent inline flash message containers. Multiple containers on the same page receive messages independently via `push_flash/5`. Renders `pa-alert` elements client-side. Supports markdown body (**bold**, *italic*, `[links](url)`, lists, `---` horizontal rules), action buttons with server callbacks, and auto-dismiss.

Used by: `<.flash_container />`

**Usage:**

```heex
<.flash_container id="my-form" />
```

```elixir
# Simple flash
socket |> push_flash("my-form", "success", "Saved!")

# With markdown body and action buttons
socket |> push_flash("my-form", "warning", """
Are you sure you want to delete **Invoice #1234**?

This action cannot be undone.
""",
  title: "Confirm Deletion",
  actions: [
    %{label: "Delete", event: "delete-record", params: %{id: 1234}, variant: "danger"},
    %{label: "Cancel", dismiss: true, variant: "secondary"}
  ])
```

**Options:**

| Option | Default | Description |
|---|---|---|
| `:title` | `nil` | Heading above the message |
| `:duration` | `0` | Auto-dismiss in ms (0 = persistent) |
| `:dismissible` | `true` | Show close button |
| `:actions` | `[]` | Action button maps (see above) |

### PureAdminCommandPalette

Spotlight-style command palette with three modes:

- **Commands** (`/prefix`) — multi-step action wizards with step progression
- **Search contexts** (`:prefix`) — scoped entity search
- **Global search** (no prefix) — search across everything

Keyboard: Ctrl+K toggle, ↑↓ navigate, Enter/Tab select, Escape/Backspace-at-0 step back. Debounced search input (150ms) for search modes, instant for command/context list filtering.

Used by: `<.command_palette />`

**Event protocol (hook → LiveView):**

| Event | Payload | When |
|---|---|---|
| `cp:toggle` | `{}` | Ctrl+K |
| `cp:close` | `{}` | Escape at top level, backdrop click |
| `cp:input` | `{query}` | Input changed |
| `cp:navigate` | `{direction}` | Arrow up/down |
| `cp:page` | `{direction}` | Arrow left/right (search modes) |
| `cp:select` | `{index}` | Enter, Tab, or click |
| `cp:step_back` | `{}` | Backspace at pos 0, Escape in step/context mode |

**LiveView → hook (push_event):**

| Event | Payload | Purpose |
|---|---|---|
| `cp:focus` | `{}` | Focus input |
| `cp:reset_input` | `{value}` | Force-set input value on mode transition |

**Registering commands:**

```elixir
commands = [
  %{
    id: "deploy",
    shortcut: "/deploy",
    aliases: ["/d"],
    name: "Deploy to Environment",
    description: "Deploy a branch to an environment",
    icon: "🚀",
    steps: [
      %{id: "environment", prompt: " in ", placeholder: "Select environment..."},
      %{id: "branch", prompt: " branch ", placeholder: "Type branch...", free_text: true}
    ]
  }
]
```

**Registering search contexts:**

```elixir
contexts = [
  %{id: "products", shortcut: ":products", aliases: [":p"], name: "Products", icon: "📦"}
]
```

**Handling command completion:**

```elixir
def handle_info({:command_complete, "deploy", selections}, socket) do
  env = Enum.find(selections, & &1.step_id == "environment")
  # Do something with selections...
  {:noreply, socket}
end
```

**Display styles:**

Two visual modes for command step progression:

- `display="inline"` (default) — Svelte-style. Input shows the full accumulated sentence (e.g., `/assign iPad Air to`). A command badge appears on the right. The locked prefix can't be deleted.
- `display="tokens"` — Token-style. Previous selections render as colored spans above a clean input. Each step starts with an empty input.

```heex
<.command_palette display="inline" ... />
<.command_palette display="tokens" ... />
```

### PureAdminDetailPanel

Detail panel toggle for inline split-view and overlay modes.

Used by: Detail panel patterns (see detail panel demo)

### PureAdminSidebarResize

Drag-to-resize sidebar with mouse/touch events. Stores width in `localStorage`.

Used by: `<.sidebar />` with `is_resizable` setting

### PureAdminCharCounter

Character counter for textarea/input fields. Configurable max length with translatable message templates via `data-msg`/`data-msg-over` with `{count}`/`{max}` placeholders.

Used by: `<.input type="textarea" />` with `maxlength` and char counter

### PureAdminCheckbox

Syncs the `indeterminate` property from `data-indeterminate` attribute. Required for tri-state checkboxes since HTML doesn't have an `indeterminate` attribute.

Used by: `<.checkbox is_indeterminate />`

### PureAdminSplitButton

Split button dropdown via Floating UI. Manages open/close state, closes other open split buttons, and handles `pushEvent` for menu item clicks and inline action buttons. Since the menu is moved to `document.body` for positioning, native `phx-click` doesn't work — the hook forwards clicks via `pushEvent`.

Used by: `<.split_button />`

### PureAdminSidebarSubmenu

Persists sidebar submenu open/closed state to `localStorage`. Restores state on mount, URL-active submenus always win over stored state. Uses `MutationObserver` to detect JS command class changes.

Used by: `<.sidebar_submenu />`

### PureAdminSidebar

Mobile-aware sidebar toggle. Desktop toggles `sidebar-hidden` on `<body>` (full hide or icon-collapse); mobile (≤768px) toggles `sidebar-visible` for the overlay modal pattern. Burger button active state stays synced with sidebar visibility. Persists desktop state to `localStorage`.

Used by: `<.sidebar id="sidebar" />` (paired with `<.navbar_burger />`)

### PureAdminKpiTile

Cursor-anchored hover detail popover for KPI tiles and rows. Uses Floating UI's virtual reference element so the popover follows the cursor; moves `.pa-kpi-detail` to `<body>` on mount to escape `overflow: hidden` ancestors. Auto-engaged whenever a tile or row has detail content.

Used by: `kpi_tile/1`, `kpi_sparkline_row/1`, `kpi_gauge/1`, `kpi_hero_main/1`, `kpi_hero_side/1`, `kpi_bento_tile/1`, `kpi_strip_row/1`, `kpi_editorial_tile/1` — automatically attached when `:detail` or `detail_title_text` is supplied.

### PureAdminKpiSparkDot

Converts the trailing `<circle>` on inline KPI sparkline SVGs into a CSS `.pa-kpi-spark-dot` span. Necessary because the sparkline `<svg>` uses `preserveAspectRatio="none"` for shape-fill — without this, circles render as squashed ellipses on wide tiles.

Used by: `kpi_sparkline/1` (and any consumer-supplied sparkline SVGs in the KPI `:chart` slot).

### PureAdminKpiTerminalTabs

Client-side tab strip wiring for the KPI Terminal card. Toggles `.is-active` on the clicked `.pa-kpi-terminal__tab` and its corresponding `.pa-kpi-terminal__pane`. Scoped per terminal so nested terminals stay isolated.

Used by: `kpi_terminal/1` when one or more `:pane` slots are supplied.

### PureAdminInfiniteScroll

IntersectionObserver-based infinite scroll. Fires a LiveView event when a sentinel element scrolls into view. Configurable throttle and preload buffer.

**Data attributes:**

| Attribute | Default | Description |
|---|---|---|
| `data-event` | `"load_more"` | LiveView event to push |
| `data-has-more` | `"true"` | Set to `"false"` to stop |
| `data-throttle` | `"500"` | Min ms between triggers |
| `data-root-margin` | `"200px"` | Preload buffer distance |

**Usage:**

```heex
<div
  id="scroll-sentinel"
  phx-hook="PureAdminInfiniteScroll"
  data-event="load_more"
  data-has-more={to_string(@has_more)}
>
  <.loader :if={@loading} />
</div>
```

## Page Context

Server-rendered JSON available to JS synchronously via a hidden input. Avoids API fetches on page load.

```javascript
import { getPageContext, getContextValue } from "keen_pure_admin"

const ctx = getPageContext()                    // full context
const manifests = getContextValue("themeManifests")  // single key
```

The settings panel reads `themeManifests` from the context automatically. Apps register providers:

```elixir
config :keen_pure_admin,
  page_context_providers: [&MyApp.PageContext.theme_manifests/1]
```

Render in root layout: `<.page_context />`

## Logging

Categorized, color-coded, silent by default. Enable at runtime:

```javascript
// Browser console
PureAdmin.logging.enableLogging()          // all → debug
PureAdmin.logging.setCategoryLevel('PA:SETTINGS', 'debug')  // one category
PureAdmin.logging.getCategories()          // list all

// KeenMate convention
window.components['keen-pure-admin'].logging.enableLogging()
```

Categories: `PA:SETTINGS`, `PA:CMD_PALETTE` (more added as hooks are instrumented).

Use in custom hooks:

```javascript
import { createLogger } from "keen_pure_admin"
const log = createLogger('MY_HOOK')
log.debug('mounted')
```

## Modal Dialogs (non-hook)

Programmatic dialogs are initialized separately:

```javascript
import { initModalDialogs } from "keen_pure_admin"

initModalDialogs()
```

This enables `PureAdmin.confirm()`, `PureAdmin.alert()`, and `PureAdmin.prompt()` globally.
