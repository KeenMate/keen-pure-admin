# Changelog

## v1.1.0 — 2026-04-23

### Added

- **`:field` attr on form components** — `input/1`, `textarea/1`, `select/1`, `checkbox/1`, `radio/1`, and `form_group/1` now accept `field={@form[:x]}` for one-line Phoenix form binding. Derives `name`, `id`, `value` (or `checked`), and error state from the `Phoenix.HTML.FormField` struct; explicit attrs still win. `used_input?/1` is respected so unsubmitted fields don't show stale errors.
- **Auto-rendered field errors** — when `field=` is set and the field has errors, `input`/`textarea`/`select` automatically render a `form_help` below themselves in the error variant. Opt out with `show_errors={false}`. `form_group` flips to `validation="error"` in the same condition.
- **`PureAdmin.Components.Form.translate_error/1`** — default `%{key}`-interpolating error formatter, overridable via `config :keen_pure_admin, :error_formatter` (MFA tuple or 1-arity function) for Gettext-aware apps.
- **`PureAdmin.DateTime`** — new top-level helper with `format/2` (styles: `:short_date`, `:long_date`, `:full_date`, `:time`, `:long_time`, `:short_date_time`, `:long_date_time`, `:relative`, or any raw strftime pattern) and `relative/2` (buckets time diffs into `now` / seconds / minutes / hours / yesterday / days / weeks / months / years, past and future; accepts `now:` for deterministic tests). Accepts `Date`, `NaiveDateTime`, and `DateTime`. Month names, weekday names, and relative phrases all flow through `PureAdmin.Translations.t/2`.
- **Translation keys** — 47 new keys under `pureAdmin.datetime.*` (connectors, relative phrases past/future, 12 month names, 7 weekday names).
- **`push_flash/5` gained `replace: true`** — wipes any existing alerts in the container before rendering the new one, so status messages don't stack.
- **`PureAdmin.Components.Flash.clear_flash/2`** — dedicated "clear without pushing" helper.
- **`PureAdminFlash` hook** — honors both the `replace` payload flag and a new `pa:flash-clear` event.

### Fixed

- Getting Started page — resolved an outdented-heredoc compiler warning by moving a code block into a module attribute.

---

## v1.0.0 — 2026-04-11

First stable release. Phoenix LiveView component library wrapping Pure Admin CSS framework into 35+ function components, 14 JS hooks, and 3 LiveComponents.

### Highlights

- **Drop-in CoreComponents replacement** — `use PureAdmin.Components` replaces the Phoenix-generated `CoreComponents` module
- **`PureAdmin.Config`** — centralized app configuration (`:app_name`, `:app_logo`, `:app_version`, `:copyright`, `:font_class`). Components like `navbar_brand/1` and `footer/1` read from it automatically
- **`package.json`** — enables `import "keen_pure_admin"` in esbuild for hex dependents
- **`pureadmin create` template** — scaffold a full Phoenix LiveView app with PureAdmin layout via the [PureAdmin CLI](https://www.npmjs.com/package/@keenmate/pureadmin)

### What's included

- 35+ function components: layout, navbar, sidebar, buttons, badges, cards, tables, modals, forms, tabs, tooltips, toasts, flash, pagers, loaders, timeline, code, stats, and more
- 14 JS hooks: sidebar toggle/resize/submenu persistence, settings panel, profile panel, command palette, toast/flash, tooltip/popover (Floating UI), split button, char counter, checkbox, infinite scroll
- 3 LiveComponents: CommandPalette, ToastLive, DialogService
- Full BEM class support with `build_classes/3` helper
- i18n via runtime translation callback (~60 keys)
- Page context system (server → JS, CSP-safe)
- Persistent logging (`PureAdmin.logging.enableLogging()` survives page reloads)

### Installation

```elixir
{:keen_pure_admin, "~> 1.0"}
```

See the [README](README.md) for full setup guide or use the PureAdmin CLI:

```bash
npx @keenmate/pureadmin create my-app --template phoenix-liveview
```

Compatible with `@keenmate/pure-admin-core` v2.3.6 and Phoenix LiveView ~> 1.0.

---

## v1.0.0-rc.2 — 2026-04-03

### Added

- **`PureAdmin.Config`** — application-level configuration system. Set `:app_name`, `:app_logo`, `:app_version`, `:copyright`, `:font_class` in `config.exs` and components read from it automatically
- **`navbar_brand/1`** — falls back to config `:app_name` and `:app_logo` when no inner content provided
- **`footer/1`** — falls back to config `:copyright` (start slot) and `:app_version` (end slot) when no slots provided
- **`PureAdmin.Config.root_html_attrs/0`** — returns `%{class: font_class}` for the `<html>` element, supports `pa-font-responsive` and granular `pa-font-base-{9-12}` / `pa-font-mobile-{9-12}` classes from pure-admin-core v2.3.6
- **Getting Started page** — new demo page with installation, setup timeline, responsive font sizing, available themes, and component overview (mirrors Svelte demo structure)

### Changed

- **Root layout** — removed separate `pure-admin.css` link; theme CSS already includes the core framework
- **Dockerfile** — switched theme download from broken `curl` + zip API to `npx @keenmate/pureadmin themes --dir` CLI, added CSS copy step for `app.css`

### Bug Fixes

- **Sidebar** — fix mobile toggle not working: `toggle_sidebar()` was hardcoded to dispatch to `#sidebar`, now accepts configurable target ID via `navbar_burger` `target` attr
- **Logger** — `enableLogging()` now persists across page reloads via localStorage
- **Sidebar** — optimize resize handler to only act on breakpoint crossings
- **Docker build** — fix 404 for CSS assets (`pure-admin.css`, `audi.css`) — app CSS was never copied to `priv/static` and theme bundle API returned empty zip

## v1.0.0-rc.1 — 2026-04-01

### Flash Messages

- **`PureAdmin.Components.Flash`** — new module with two approaches:
  - **Standard flash** — `flash/1` and `flash_group/1` as drop-in replacements for CoreComponents, styled with `pa-alert` BEM classes. Works with Phoenix's built-in `put_flash/3`
  - **Independent flash containers** — `flash_container/1` + `push_flash/5` for multiple independent flash groups on the same page. Each container receives messages independently via a JS hook
- **`PureAdminFlash`** JS hook — client-side rendering of flash alerts. Supports markdown body (**bold**, *italic*, `[links](url)`, lists, `---` horizontal rules), action buttons with `pushEvent` callbacks, auto-dismiss, and dismissible close button
- **Markdown body** — flash message text supports basic markdown rendered as proper `pa-alert__content` HTML
- **Action buttons** — flash messages can include action buttons that push events back to the LiveView or dismiss the flash

### Toast Updates (pure-admin 2.3.0)

- **Toast action buttons** — `push_toast/5` accepts `:actions` option with `%{label, event, params, variant, dismiss}` maps. JS hook renders `pa-toast__actions` with `pa-btn--xs` buttons inside `pa-toast__content`. Clicking an action fires `pushEvent` back to the server, then auto-dismisses
- **Toast progress bar** — `:progress` option renders `pa-toast__progress` bar that animates from 100% to 0% over the duration. `:progress_color` option overrides the bar color via inline style
- **Filled toasts via push_toast** — `:filled` option renders `pa-toast--filled-{variant}` class
- **`max_width`** — custom max-width per toast (e.g. `max_width: "50rem"`)
- **Width ratchet** — container `min-width` tracks the widest toast shown, resets when container is empty
- **Click-to-dismiss** — toasts without actions are click-to-dismiss (cursor: pointer). Toasts with actions require close button or action click

### Command Palette v2

- **Multi-step commands** (`/prefix`) — register commands with `steps`, each with `prompt`, `placeholder`, and optional `free_text`. Steps progress sequentially with selections displayed as locked tokens. Commands complete via `handle_info({:command_complete, cmd_id, selections})`
- **Search contexts** (`:prefix`) — register scoped search contexts with `shortcut` and `aliases`. Typing `:p laptop` searches products for "laptop"
- **Global search** — typing without a prefix searches across all data
- **6 modes** — `idle`, `command_list`, `command_step`, `context_list`, `context_search`, `global_search` with full state machine transitions
- **Step filtering** — typing in a command step filters the step options in real-time
- **Step back** — Backspace at position 0 or Escape goes to previous step (or back to command/context list)
- **`cp:` event protocol** — namespaced events (`cp:toggle`, `cp:input`, `cp:select`, `cp:step_back`, etc.) replacing `command_palette_` prefix
- **`cp:reset_input` push_event** — force-clears browser input on mode transitions (LiveView doesn't patch focused inputs)
- **Debounced search** — 150ms debounce for context and global search, instant for command/context list filtering
- **Mode-aware keyboard** — Escape goes back in step/context modes instead of closing. Footer hints update per mode
- **Two display styles** — `display="inline"` (default, Svelte-style: full sentence in input with command badge) and `display="tokens"` (original: colored token spans above a clean input). Switchable at runtime

### Command Palette (pure-admin 2.3.3 / 2.3.4)


- **`pa-command-palette__input-wrapper`** — new wrapper around input + context label for correct positioning
- **`pa-command-palette__token-prompt`** — step prompt text between token badges (replaces `__token--prompt`)
- **Standard `pa-badge`** — item badges now use `pa-badge` instead of custom `pa-command-palette__item-badge`
- **Token badges** — step tokens in tokens mode use `pa-badge pa-badge--primary` for command name, plain `pa-badge` for values
- **Tokens `&:empty` hiding** — tokens div hides automatically when empty via CSS
- **Home screen** — idle state shows categorized list of commands (with Alt+key hotkey badges) and search contexts, all clickable
- **Hotkeys** — `Alt+D` Deploy, `Alt+A` Assign, `Alt+G` Go to Page, `Alt+T` Switch Theme. Work globally and inside the palette
- **Global search includes commands/contexts** — typing "deploy" finds the Deploy command alongside data results. Selecting a command/context enters that mode
- **Form codes** — `/go` page options have numeric codes (e.g., `24` for Alerts). `filter_options` matches on label, description, and exact code
- **`pa-command-palette__home`** — home screen container with `__home-section` separators and `__home-heading` labels
- **`pa-command-palette__shortcut`** — flex container for multi-key hotkey badge groups

### Translations (i18n)

- **`PureAdmin.Translations`** — new module with runtime translation callback system. Ships with ~60 English defaults under `pureAdmin.*` flat keys. Apps override via config: `config :keen_pure_admin, translate: &MyApp.translate/2`
- **`t(key, params)`** — main translation function with `%{param}` interpolation. Falls back to English when callback returns nil or isn't configured
- **`interpolate(string, params)`** — exported helper for app callbacks
- **All components updated** — hardcoded English strings replaced with `t()` calls across command palette, pager, popconfirm, modal, alert, toast, flash, settings panel (~60 keys)

### Components (pure-admin 2.3.1 / 2.3.2)

- **`split_button/1`** — chevron icon now points up (`fa-chevron-up`) for `top-*` placements, down for `bottom-*`
- **`split_button/1` primary icon** — new `icon` attr for Font Awesome icon on the primary button (e.g. `icon="fas fa-download"`)
- **`split_button/1` item icons** — `:item` slot now accepts `icon` attr (e.g. `icon="fas fa-file"`) rendering as `pa-btn-split__item-icon`
- **`split_button/1` inline action buttons** — `:item` slot accepts `action_icon`, `action_event`, `action_value`, `action_variant` attrs for inline action buttons beside menu items (e.g. delete/remove). The JS hook forwards clicks via `pushEvent` since the menu is moved to `document.body`
- **`button/1` label wrapping** — button text is wrapped in `<span class="pa-btn__label">` when an icon is present, enabling proper centering with `align="center"`
- **`split_button/1` menu structure** — uses `pa-btn-split__menu-inner` wrapper and `pa-btn-split__item-row` BEM elements (replaces inline styles), matching pure-admin 2.3.2 two-container pattern
- **`input_group/1`** — `:button` slot now documented to use `class="pa-input-group__button"` on the button element

### Demo

- **Phoenix / LiveView** sidebar section — new section for framework-specific features (matches Svelte demo's "Svelte" section)
- **CoreComponents Migration** page — migration table showing replaced vs manual functions, setup timeline
- **Flash Messages** page — independent containers demo, variant showcase, markdown + action buttons demo, standard `@flash` compatibility
- **Toasts** page — added progress bar demos (standard + filled), action toast demos (Undo, Retry, Update, Filled + Actions), theme color toasts with filled subsection
- **Buttons** page — split buttons card moved after Responsive Direction to match pure-admin layout 1:1, consolidated into single card with subsections (Sizes, Upward Placement, Custom Icons)

### Theme Cache Invalidation

- **`ThemePlug` auto-refresh** — cached themes are validated against pureadmin.io using `content_sha` from the theme's `checksums` field. On first access after startup, the plug sends a conditional request (`If-None-Match`) to the API in the background. If the server returns 200 (sha mismatch), the theme is re-downloaded without blocking the current request. 304 means the cache is fresh. Freshness checks are throttled to once per 10 minutes per theme
- **`make themes-clear`** — new Makefile target to force-clear the theme cache, triggering fresh downloads on next access

### Documentation

- **Prerequisites** section added to README and getting-started guide (`mix phx.new --no-tailwind`)
- **Main site** link added to README ([pureadmin.io](https://pureadmin.io))
- **Theme installation** guide — actual zip structure from pureadmin.io API, self-contained relative paths. Three installation options: Pure Admin CLI (`@keenmate/pureadmin`), manual download, CI/CD Dockerfile
- **Creating custom themes** — new section in theming docs referencing the CLI's `init`, `build`, `pack`, `publish` workflow
- **Theme customization via SCSS** — variable overrides, custom fonts, baseline correction, complete example
- **`make help`** — all Makefile targets now have `## description` comments

Compatible with `@keenmate/pure-admin-core` v2.3.5.

## v1.0.0-rc.1 (initial)

First release candidate. Consolidates all v0.x development into a stable API.

### Highlights

- **35+ function components** covering the full Pure Admin CSS framework: layout, navigation, forms, tables, data display, modals, toasts, and more
- **13 JS hooks** for interactive features: settings panel, tooltips, popovers, split buttons, sidebar persistence, command palette, character counters, and more
- **Drop-in `CoreComponents` replacement** -- `use PureAdmin.Components` gives you everything
- **Full BEM class support** with `build_classes/3` helper
- **RTL support** for tooltips and popovers
- **Podman/Docker support** for the demo app
- **Live demo** at [elixir.demo.pureadmin.io](https://elixir.demo.pureadmin.io)

### Settings Panel

- **Dynamic theme manifests** — settings panel JS now fetches `/api/themes/manifests` and dynamically populates theme selector (sorted alphabetically), replacing hardcoded `themes` prop
- **Color variants** — new `data-section="color-variant"` section, shown/hidden based on theme manifest. Applies `pa-color-{variant}` CSS class to body. Supports per-variant mode lists
- **Mode per variant** — mode selector updates when color variant changes, auto-hides if only one mode available, auto-applies single mode
- **Font detection from manifest** — "Theme Default" option shows bundled font name (e.g., "Theme Default (Fira Sans Condensed)"), skips Google Fonts download if theme already bundles the font
- **Removed `themes` attr** from `settings_panel/1` — themes are now loaded dynamically, only `default_theme` attr remains

### On-Demand Theme Downloads

- **ThemePlug** — new Plug that serves `/themes/:name.css` with on-demand downloading from pureadmin.io. When a theme CSS is requested that isn't bundled at build time, it downloads from `pureadmin.io/api/themes/:name/download`, extracts CSS and `theme.json` manifest from the zip, and caches to disk
- **`/api/themes/manifests`** — returns all available theme manifests as JSON (from both build-time `priv/static/themes/` and on-demand cache)
- **`/api/themes/:name/manifest`** — returns a single theme's manifest
- **Negative cache** — failed downloads are cached for 10 minutes (ETS-based)
- **Slug validation** — theme names must match `^[a-z0-9-]+$`
- **Pure Erlang** — uses `:httpc` and `:zip` for downloads, no external tools needed in runtime image
- **`?theme=cobalt2`** — query param sets localStorage and swaps CSS link before paint, triggering on-demand download if theme not bundled

### Dockerfile & Deployment

- **Dockerfile** (`demo/Dockerfile`) — multi-stage build with `elixir:1.18-slim` builder and `debian:trixie-slim` runtime. Downloads theme bundles from pureadmin.io at build time (CSS + manifests). Configurable via `THEMES_URL` build arg
- **Makefile** — added `podman-build`, `podman-run`, `podman-stop`, `podman-restart`, `podman-logs`, `podman-clean`, `podman-deploy`, `podman-push` targets matching pure-admin conventions. Registry: `registry.km8.es`
- **.dockerignore** — excludes `_build/`, `deps/`, `node_modules/`, `.git/`
- **`force_ssl`** — now opt-in via `FORCE_SSL=true` build-time env var (was always-on, breaking local container testing)

### New Hooks

- **`PureAdminInfiniteScroll`** — IntersectionObserver-based infinite scroll hook. Fires a LiveView event when a sentinel element scrolls into view. Configurable via `data-event`, `data-has-more`, `data-throttle`, `data-root-margin`. Throttled to prevent rapid-fire triggers.

### Components

- **`list_item/1`** — added `:meta` slot for rich meta content (badges, icons) alongside existing `meta_text` string attr
- **`timeline/1`** — fixed alternating variant to use `<div>` container and correct BEM classes (`pa-timeline__date` + `pa-timeline__icon` instead of `pa-timeline__time` + `pa-timeline__marker`). Added `align` attr (`"start"`, `"end"`) and `is_keep_layout` for alternating layout control — replaces raw `class="pa-timeline--start"` usage
- **`timeline_item/1`** — auto-detects layout from props: block/alternating pattern when `icon_text` or `:icon` is provided, simple pattern otherwise
- **`card/1`** — added `is_bordered` attr for bordered card styling — replaces raw `class="pa-card--bordered"` usage
- **`button_group/1`** — added `responsive` attr (`"sm-vertical"`, `"md-horizontal"`, etc.) for responsive direction changes at breakpoints — replaces raw `class="pa-btn-group--md-vertical"` usage
- **`grid/1`** — added `align="stretch"` to allowed values
- **`column/1`** — added `is_no_padding`, `is_grow`, `is_shrink` props for flex layout control
- **`values:` validation** — added compile-time value validation to all `variant`, `color`, `theme_color`, and `level` attrs across alert, badge, label, composite_badge, button, popconfirm, data_display, form, table, and typography components. Typos like `variant="outine-danger"` or `color="10"` now produce compile warnings
- **pure-admin 2.2.0 support** — updated CSS to v2.2.0. Added `theme_color` attr to `button/1`, `callout/1`, and `toast/1` for theme color slots 1-9. Added `is_filled` attr to `toast/1` for full-color background toasts. Alert `theme_color` now uses proper `pa-alert--color-{N}` / `pa-alert--outline-color-{N}` classes (was `pa-bg-color-{N}`)

### Demo

- **45 demo pages** covering all Pure Admin CSS components (up from 34)
- **Dashboard** — rewritten to match pure-admin reference 1:1: 4 hero stat KPIs, 6 square stats with color variants, revenue trend SVG placeholder, traffic sources table, timeline activity feed, recent orders with badges, top products, system status with badge meta, quick actions
- **Timeline pages** — split into 4 pages matching pure-admin: Simple (color-coded, filled bullets), Block (alternating with layout modifiers: start/end/keep-layout), Feed (avatars, comments, date headers, load more, infinite scroll), Advanced
- **Design pages** — new section: Colors (semantic + theme slots), Theme Variables (45 CSS custom properties), CSS Helpers (visibility, borders, overflow, cursor), Layouts (structure, navbar, sidebar, container width)
- **New pages** — Components Overview (index with 27 component cards), Notifications (interactive list with filtering), Sizing & Layout (width/spacing/display utilities), Virtual Scroll (infinite scroll demo with `PureAdminInfiniteScroll` hook, virtual scroll planned)
- **Raw HTML consolidation** — converted remaining raw `pa-` HTML across 10+ demo pages to use components
- **Root layout** — theme CSS loaded via `<link id="pa-theme-css">` with inline script that reads `?theme=` from URL and swaps href before paint
- **Footer** — updated version to v1.0.0-rc.1

### README

- Added Hex/GitHub/path installation options
- Added full setup guide (CSS, Floating UI, Font Awesome, FOUC, toasts)
- Added Podman build/run/deploy instructions with `make` targets
- Updated component and hook tables

Compatible with `@keenmate/pure-admin-core` v2.2.0.

---

## v0.3.4

### New Components
- **comparison**: New `comparison_table/1`, `comparison_row/1`, `comparison_section/1`, `comparison_value/1` — comparison table components for two-column and three-column data diff patterns (version control, merge conflicts). `:cell` slot with `is_changed`, `is_solid`, `is_conflict` modifiers. `comparison_value/1` includes copy-to-clipboard button with visual feedback (icon swap)

### Layout
- **sidebar_submenu**: Fix accordion behavior — opening one submenu no longer closes all others. Each submenu now uses scoped `toggle_submenu/1` with `{:closest, ".pa-sidebar__item"}` and ID-targeted `<ul>`
- **sidebar_submenu**: Add `id` attr for stable submenu identification, `phx-hook="PureAdminSidebarSubmenu"` for localStorage persistence of open/closed state across navigations
- **sidebar_submenu**: Add FOAC prevention — `fouc_prevention_script` injects `<style>` tag from localStorage before sidebar HTML renders, eliminating flash of collapsed submenus
- **split_button**: Close other open split buttons when opening a new one
- **split_button**: Add `on_click` and `action` attrs to `:item` slot for LiveView event handling via hook `pushEvent`

### JS
- **clipboard**: Global `kpa:clipboard-copy` event listener — copy to clipboard via `JS.dispatch`, with visual icon feedback (clipboard → checkmark → revert). Works anywhere, no per-page setup needed
- **PureAdminSidebarSubmenu** (new hook): Persists sidebar submenu open/closed state to localStorage. Restores state on mount, URL-active submenus always win over localStorage. Uses MutationObserver to detect JS command class changes
- **PureAdminSplitButton**: Fix multiple open menus — opening a split button now closes any other open one

### Demo
- Add Comparison Tables demo (`/tables/comparison`) — two-column, three-column, solid background variants using `table_card`
- Restructure routes to hierarchical paths (`/components/buttons`, `/tables/standard`, etc.) — enables `String.starts_with?` for sidebar submenu `is_open` derivation from URL
- Add global toast service — `<.toast_container>` in app layout, PubSub-based `handle_info` hook in `on_mount` for cross-page toast delivery
- Add Split Buttons demo section to buttons page with primary actions, dropdown items, sizes, and toast feedback
- Background task toasts now use PubSub broadcast instead of direct `send/2`, so toasts arrive on whichever page is active

## v0.3.3

### Components (pure-admin 2.1.0 sync)
- **button**: Add `split_button/1` — split button with primary action + dropdown toggle via `PureAdminSplitButton` JS hook. `:item` slot with `is_danger` modifier, `placement` attr for Floating UI positioning, `on_click` for primary action
- **tooltip**: Add `is_keyword` modifier — dotted underline + help cursor for inline term explanations (`pa-tooltip--keyword`)

### Demo
- Add Table Multi-Select demo with cross-filter selection, summary bar, expandable details, bulk actions
- Update pure-admin CSS to v2.1.0

## v0.3.2

### Components
- **table**: Add `table_card/1` — card wrapper with header/footer, color variants (primary/success/warning/danger), theme colors (1-9), `is_scrollable`, `is_plain`
- **table**: Add `:foot` slot for `<tfoot>` support (colspan, totals rows)
- **table**: Add `align` attr on `:col` slot (start/center/end) for per-column text alignment
- **table**: Add `is_responsive_grid` modifier for CSS Grid responsive collapse
- **table**: Render `:action` column first (leftmost) to match pure-admin reference
- **table_container**: Add `is_panel` mode with `title_text`, `:header`, `:actions` slots
- **table_container/table_card**: Use `<h3>` for titles to match pure-admin CSS selectors (colored header text)
- **pager**: Fix layout to match pure-admin: controls-left | info-center | controls-right (was all-controls then info)
- **pager**: Add `icon_first`, `icon_previous`, `icon_next`, `icon_last` attrs for custom icon sets
- **pager**: Change info format to `/ N pages` (was `Page ... of N`)
- **data_display**: Add `is_value_end` and `is_value_center` modifiers to `banded/1` and `desc_table/1`
- **form**: Add `input_wrapper/1` — wraps input/select with optional clear (×) button (`pa-input-wrapper` + `pa-input-wrapper__clear`), `has_clear`, `on_clear` attrs
- **filter_card**: New `filter_card/1` component — expandable filter card with `:filters`, `:advanced_filters`, `:actions` slots, toggle/clear/refresh/apply buttons, `is_expanded`, `is_loading`, `is_disabled` states, matching Svelte `FilterCard`

### Demo
- Split tables into three pages: Standard Tables, Table Sizing, Responsive
- Rewrite Standard Tables demo to match pure-admin reference 1:1 (same data, sections, structure)
- Rewrite Table Sizing demo to match pure-admin reference 1:1 (same data, card structure with inline code headers, text action buttons with correct sizes per variant)
- Rewrite Responsive Tables demo to match pure-admin reference 1:1 (How It Works grid, basic/product/orders tables with actions and badges, CSS Grid Custom Layouts with data-grid/data-span, HTML Implementation with grid advanced section, SCSS variables reference, Testing Tips, LiveView code examples)
- Add Table Filters demo matching pure-admin reference (basic search filter, expandable filters with advanced section toggle, inline horizontal filters, active filter tags with composite badges)
- Remove invented `pa-page-title`/`pa-page-subtitle` CSS classes from all demo pages — use plain `<p>` like the reference
- Clean up `demo.css` — remove unused chart/activity/status classes

## v0.3.1

### New Components
- `popconfirm/1` — small confirmation dialogs anchored to trigger buttons via Floating UI, with `message`, `placement` (top/bottom/start/end, RTL-aware), `icon_variant` (danger/warning/info), `is_compact`, `confirm_event`/`confirm_value` for LiveView integration, click-outside-to-close, move-to-body positioning

### RTL Support
- `tooltip/1` — position values renamed: `right` → `end`, `left` → `start` (RTL-aware via `document.dir`)
- `popover/1` — placement values renamed: `right` → `end`, `left` → `start` (RTL-aware via `document.dir`)
- Tooltip JS hook — added `resolveLogicalPlacement()` that maps `start`/`end` to physical `left`/`right` based on document direction

### Components
- `badge/1` — replaced `width` attr (`pa-badge--w-Nx` classes) with `max_width` attr using `maxwr-N text-truncate` utility classes
- `modal/1` — fixed popover alignment classes (`pa-popover--center`, `pa-popover--end`) to be copied to content element when moved to `document.body`
- Tooltip JS — fixed theme color variants not applied to floating tooltips (regex only matched first class, which was always `floating`)

### JS
- `modal_dialogs.js` — new ES module wrapping pure-admin's programmatic dialog API (`PureAdmin.confirm/alert/prompt/custom`), exported via `initModalDialogs()`

### Demo
- **Modal Dialogs page** — new page with confirm/alert/prompt demos, position options, sequential dialogs, LiveView server integration, API reference tables
- **Modals page** — rewritten to match pure-admin reference (grouped layout, settings modal, richer modal content)
- **Tooltips page** — updated to use `start`/`end` position naming
- **Badges page** — updated fixed-width section to use `max_width` utility approach, renamed "Left-Side Ellipsis" to "Start-Side Ellipsis"
- **Popconfirm page** — new page with basic popconfirms (delete/archive/reset with icon variants), compact variant, table row delete confirmations with LiveView integration
- **Command Palette page** — new page with Spotlight-style search overlay, Ctrl+K shortcut, context switching (/p, /o, /u, /i), keyboard navigation, pagination, LiveView server-side search
- **Data Display page** — new page with pa-fields layouts: stacked, multi-column grid (cols-2/3/4), field groups, horizontal, table-style bordered, striped, compact, inline, row, relaxed, filled, color-coded borders
- **Data Display 2 page** — new page with advanced patterns: Ant Design descriptions table (1/2/fixed columns), dot leaders (invoice style), property cards, banded rows
- **Data Visualization page** — new page with CSS-only visualizations: progress bars (sizes/colors/striped/animated/rounded), stacked bars with legends, progress rings, dashboard gauges, data bars in tables, activity heatmaps, sparkline bars
- **Detail Panel page** — new page with inline split-view and overlay modes, table row selection, field-group detail content
- Fixed all compile warnings across demo (nested `if` parentheses, `dynamic_tag` name deprecation, undefined attributes, missing slots)

## v0.3.0

Compatible with `@keenmate/pure-admin-core` v2.0.2.

### Components
- `section/1` — added `title_text` attr that renders an `<h3 class="pa-section-title">` heading
- `code/1` — fixed to render plain `<code>` without `pa-code` class, matching Svelte reference
- `card/1` — added `:subtitle` slot (rich HTML counterpart to `subtitle_text`)
- `card/1` — fixed `subtitle_text` to render with `pa-text pa-text--secondary` class matching Svelte reference
- `card/1` — fixed title rendering: plain `<h3>` without wrapper div when no icon is present, matching Svelte reference
- `card/1` — fixed non-inline tabs to render outside header as sibling (matching reference DOM structure)
- `card/1` — fixed inline tabs to render after title (not before), matching reference order
- `form_label/1` — added `is_required` attr that renders asterisk indicator
- `checkbox/1` — added `:label_content` slot, `is_indeterminate` (via PureAdminCheckbox hook), `is_x_mark`
- `checkbox_box/1` — added `is_indeterminate` support
- `tabs/1` — scrollable overflow now renders proper scroll buttons and scroll container
- `tab_item/1` — added deterministic `id` and `:not()` exclusion to prevent 2px flash on tab switch
- `switch_tab/3` — scoped tab/panel switching via `tabs_id` + content container id to prevent cross-group interference
- `label/1` — fixed outline to use `pa-label--outline` class (not `pa-label--outline-{variant}`), matching Svelte reference; added `xs`/`xl` size support
- `badge_group/1` — added `limit`, `total`, `is_expanded`, `on_toggle`, `more_text`, `collapse_text` attrs for expand/collapse with two modes: server-side (fires LiveView event for lazy loading) and client-side (CSS-based hiding with JS class toggle, survives LiveView DOM patching)
- `badge/1` — added `width` attr (`pa-badge--w-{size}` BEM class) and `is_ellipsis_start` for left-side truncation
- `composite_badge/1` — added `is_interactive`, `on_label_click`, `on_button_click`, `label_variant`, `button_variant`, `button_text`, `:icon_content` slot for full interactive support with separate label/button click events
- `checkbox_box/1` — new low-level checkbox (input + box) for tables and composite components
- `checkbox_list/1` — new container with variant (compact/bordered/striped) and layout (inline/grid/2col/3col)
- `checkbox_list_item/1` — new item with label, description, state (disabled/locked), and `:actions` slot
- `basic_list/1` — new component for styled `<ul>` with spacing, icon, bordered, striped, inline, unstyled variants
- `ordered_list/1` — new component for styled `<ol>` with numeric, roman, alpha styles
- `definition_list/1` — new component for styled `<dl>` with standard and inline layouts

### JS Hooks
- `PureAdminCharCounter` — new hook for textarea/input character counting with configurable max, translatable message templates via `data-msg`/`data-msg-over` with `{count}`/`{max}` placeholders
- `PureAdminCheckbox` — new hook for syncing `indeterminate` property from `data-indeterminate` attribute (required for tri-state checkboxes)

### Components (enhanced)
- `tooltip/1` — new CSS-only tooltip wrapper with position, variant, multiline, help cursor support
- `popover/1` — new click-triggered popover with title, placement, size, alignment, custom trigger slot
- `pager/1` — enhanced with page input, first/last buttons, configurable events, custom info text, `:controls` and `:info` slots
- `load_more/1` — enhanced with `phx-click` support via `:global` attrs
- `loader_center/1` — new centered loader container (flexbox centering)
- `loader_overlay/1` — enhanced to accept custom content via slot (not just default spinner)
- `toast/1` — added `title_text`, `message_text`, `is_visible`, `on_close`, `:icon` slot, close button with SVG icon
- `toast_container/1` — updated positions to use logical names (top-end, top-center, top-start, bottom-end, bottom-center, bottom-start)

### Demo
- **Cards page** — complete rewrite matching Svelte pure-admin reference (14 sections: same-height, basic, header three-part layout, colored, theme colors, bordered, ghost, underlined headers, statistics, statistics with trends, interactive, advanced features, data display, CSS classes reference)
- **Grid page** — complete rewrite matching Svelte pure-admin reference (overview, basic usage, percentage columns, fraction columns, responsive grid, offsets, row alignment, no gutter, visibility utilities, nested grids, quick reference, code examples)
- **Buttons page** — complete rewrite matching Svelte pure-admin reference (variants, sizes, outline, states, block, button groups with gap sizes, vertical alignment, responsive direction, text truncation, icon buttons, icon-only, fixed width, text alignment, ripple effects, loading states, usage guide, CSS classes reference)
- **Inputs page** — new page matching Svelte pure-admin reference (text inputs with states/sizes/validation/theme colors, input groups with prepend/append/buttons/toggle mode, input types, select dropdowns, textareas, checkboxes & radios with sizes, width variations, CSS classes reference)
- **Validations page** — new page matching Svelte pure-admin reference (10 validation patterns: inline field errors, summary block, combined summary+inline, border+icon only, right-side indicators, helper text transforms, toast notifications, validation timing strategies, multi-field/cross-field, progressive multi-step, CSS classes reference)
- **Tabs page** — complete rewrite matching Svelte pure-admin reference (card header tabs, standalone, icons, fixed width, pills, vertical, boxed, sizes, badges, centered, full width, border-top, icon-only horizontal/vertical, standalone page-level, standalone vertical, bordered horizontal/vertical, long titles with wrap/collapse/scrollable, inline tabs in header)
- **Validations page** — interactive demos: char counter with JS hook, validation timing strategies (real-time/blur/submit), cross-field validation (password match, date range)
- **Badges page** — complete rewrite matching Svelte pure-admin reference (badge sizes reference table, basic badges, pill badges, badges with icons, label sizes reference, labels with outline, badge groups with expand/collapse, fixed-width badges with tooltips, left-side ellipsis, composite badges with mixed colors and interactive click handlers, usage examples)
- **Lists page** — complete rewrite matching Svelte pure-admin reference (basic unordered lists with spacing variants, ordered lists with numeric/roman/alpha, definition lists with standard/inline, icon lists with success/danger/info/warning, bordered/striped, inline/unstyled, complex lists with avatars, implementation guide)
- **Checkbox Lists page** — new page matching Svelte reference (tri-state checkboxes, select-all pattern, disabled states, checkbox lists with descriptions, item states, list variants, task list with actions, inline/grid/multi-column layouts, interactive table with row selection and select-all)
- **Alerts page** — rewrite matching Svelte reference (basic alerts with strong labels, text icon alerts, dismissible alerts, rich content with heading/list/actions, outline alerts, compact alerts in responsive grid)
- **Callouts page** — rewrite matching Svelte reference (basic callouts, headings, icons, lists, sizes, code, links, grid layout, callout vs alert comparison)
- **Loaders page** — rewrite matching Svelte reference (spinner sizes/colors, inline spinners, centered loaders, loaders with text, card loading states, loader types, button loading states)
- **Pagers page** — new page (basic pager, first/last buttons, alignment variants, custom info text, load more with loading state, pager in card footer, CSS classes reference)
- **Tooltips page** — new page matching Svelte reference (positions, color variants, theme colors, button tooltips, icon-only tooltips, multiline, inline text, popovers with sizes/alignment/positions)
- **Toasts page** — new page matching Svelte reference (6 position demos, 5 variant buttons, persistent toasts, action toasts, multiple stacking toasts, long-running background task demo with server push, architecture docs)
- **Sidebar** — reorganized to match Svelte pure-admin layout (Components submenu with Grid, separate Tables and Timeline submenus, Forms as top-level item)

## v0.2.0

### Navbar subcomponents
- `navbar_brand/1` — brand/logo section with optional `logo` image
- `navbar_nav/1` — navigation link group (`position="start"` or `"end"`)
- `navbar_nav_item/1` — nav link with optional `has_dropdown` and `:dropdown` slot
- `navbar_dropdown/1` — CSS-driven dropdown menu (supports `is_level2` for nesting)
- `navbar_title/1` — page title in center section
- `navbar_search/1` — search widget with keyboard shortcut hint
- `navbar_profile_btn/1` — profile button with name and `:icon` slot

### Notifications
- `notifications/1` — bell button with badge count and dropdown panel
- `notification_item/1` — individual notification with variant, title, text, time slots

### Profile panel (enhanced)
- `profile_panel/1` — full slide-out panel with overlay, avatar, name/email/role, `:nav`, `:tabs`, `:footer_` slots
- `profile_nav_item/1` — navigation item within profile panel
- `toggle_profile_panel/1`, `close_profile_panel/1` — JS commands
- `PureAdminProfilePanel` JS hook — tab switching, favorites, click-outside-to-close

### Settings panel
- `settings_panel/1` — floating settings panel (theme mode, layout width, sidebar, fonts, etc.)
- `fouc_prevention_script/0` — inline script preventing flash of unstyled content
- `PureAdminSettings` JS hook — client-side localStorage-based settings management

### Layout
- Added `id` attr to `layout/1`
- `toggle_notifications/1` JS command

### Demo
- Navbar uses three-section layout (start/center/end) matching pure-admin reference
- Components dropdown with nested "More ›" submenu
- Notifications bell with sample items
- Profile panel with tabs (Profile/Favorites), nav items, and footer actions

## v0.1.0

- Initial release
- Phase 1: Foundation + 10 key components (button, badge, alert, card, table, modal, tabs, form, layout, grid)
- BEM class builder helpers
- JS hook scaffold
- `use PureAdmin.Components` for bulk import
