# JS Hooks

PureAdmin ships 13 JavaScript hooks for interactive features. Import them all via `PureAdminHooks` or individually.

## Setup

```javascript
import { PureAdminHooks } from "keen_pure_admin"

let liveSocket = new LiveSocket("/live", Socket, {
  hooks: { ...PureAdminHooks }
})
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

### PureAdminCommandPalette

Command palette with keyboard navigation (arrow keys, Enter, Escape), search filtering, context switching, and pagination.

Used by: `<.command_palette />`

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

Split button dropdown via Floating UI. Manages open/close state, closes other open split buttons, and handles `pushEvent` for menu item clicks.

Used by: `<.split_button />`

### PureAdminSidebarSubmenu

Persists sidebar submenu open/closed state to `localStorage`. Restores state on mount, URL-active submenus always win over stored state. Uses `MutationObserver` to detect JS command class changes.

Used by: `<.sidebar_submenu />`

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

## Modal Dialogs (non-hook)

Programmatic dialogs are initialized separately:

```javascript
import { initModalDialogs } from "keen_pure_admin"

initModalDialogs()
```

This enables `PureAdmin.confirm()`, `PureAdmin.alert()`, and `PureAdmin.prompt()` globally.
