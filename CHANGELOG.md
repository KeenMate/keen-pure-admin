# Changelog

## v0.3.0

### Components
- `section/1` — added `title_text` attr that renders an `<h3 class="pa-section-title">` heading
- `code/1` — fixed to render plain `<code>` without `pa-code` class, matching Svelte reference
- `card/1` — added `:subtitle` slot (rich HTML counterpart to `subtitle_text`)
- `card/1` — fixed `subtitle_text` to render with `pa-text pa-text--secondary` class matching Svelte reference
- `card/1` — fixed title rendering: plain `<h3>` without wrapper div when no icon is present, matching Svelte reference
- `card/1` — fixed non-inline tabs to render outside header as sibling (matching reference DOM structure)
- `card/1` — fixed inline tabs to render after title (not before), matching reference order
- `form_label/1` — added `is_required` attr that renders asterisk indicator
- `checkbox/1` — added `:label_content` slot (rich HTML counterpart to `label` attr)
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
- `use KPureAdmin.Components` for bulk import
