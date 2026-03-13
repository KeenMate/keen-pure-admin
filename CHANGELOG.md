# Changelog

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
- Profile panel with nav items and footer actions

## v0.1.0

- Initial release
- Phase 1: Foundation + 10 key components (button, badge, alert, card, table, modal, tabs, form, layout, grid)
- BEM class builder helpers
- JS hook scaffold
- `use KPureAdmin.Components` for bulk import
