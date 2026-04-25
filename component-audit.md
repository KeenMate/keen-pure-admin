# Component Audit Log

Tracks which PureAdmin LiveView components have been cross-checked against
their `@keenmate/pure-admin-core` HTML snippets. Mirrors the process used
by `../pure-admin/packages/core/snippets/AUDIT.md` on the framework side.

**Why this file exists.** The CSS framework (Pure Admin) is the source of
truth for BEM class names, modifier classes, and markup structure. Our
Elixir components wrap that markup. When the framework shifts — a modifier
renamed, an element restructured, a new variant added — our wrappers need
to follow. This log answers *has anyone verified this component still
matches the current snippet*, and if so, against which framework commit.

**Process.**

1. Pick a component row marked ⏳ pending.
2. Open the paired snippet in `../pure-admin/packages/core/snippets/`.
3. Open `../pure-admin/packages/core/snippets/AUDIT.md` and note the
   commit hash of the last framework-side audit for that snippet.
4. Compare class names, modifier classes, BEM elements, slot structure,
   and attribute expectations against the snippet.
5. Fix drift in-place; or, if the snippet looks wrong and our
   implementation is correct, raise it with maintainers and note the
   discrepancy in the row's "Notes" column.
6. Mark the row ✅ audited with today's date and the pure-admin commit
   hash you verified against. Subsequent re-audits are only needed when
   a newer pure-admin commit lands for that snippet.
7. One component per commit.

**Legend.**

- ✅ audited — component reviewed and brought in line with the snippet as of the listed framework commit
- ⏳ pending — not yet touched in this pass
- 🆕 new — snippet doesn't exist yet; component was built against SCSS directly
- ⚠️ disputed — we believe our implementation is correct and the snippet is wrong; see Notes

**Current framework HEAD** (for reference when recording new audits): `cf75736`
(check `git -C ../pure-admin rev-parse --short HEAD` for the live value).
Last re-audit pass: 2026-04-25 — picked up 11 newly-audited snippets that had been pending or missing on 2026-04-24.

---

## Components mapped to audited snippets

| Component module | Snippet | Status | Verified on | pure-admin commit | Notes |
|---|---|---|---|---|---|
| `PureAdmin.Components.Alert` | `alerts.html` | ✅ | 2026-04-24 | `512ef3c` | Minor: dismiss button uses HTML entity `&times;` vs snippet's literal `×` — cosmetically identical. `phx-click` dismiss handler is intentional LiveView divergence from snippet's inline `onclick`. |
| `PureAdmin.Components.Badge` (badge, label, composite_badge, badge_group) | `badges.html` | ✅ | 2026-04-24 | `517f6bf` | Clean. |
| `PureAdmin.Components.Button` (button, button_group, split_button) | `buttons.html` | ✅ | 2026-04-24 | `43a9a42` | Clean. |
| `PureAdmin.Components.Callout` | `callouts.html` | ✅ | 2026-04-24 | `6ea28e8` | Fixed: `pa-callout__heading` wrapper element flipped from `<div>` to `<h4>` to match snippet's semantic heading pattern. |
| `PureAdmin.Components.Card` | `cards.html` | ✅ | 2026-04-24 | `4a67018` | Fixed: `:tools` slot now emits `pa-card__actions` (was `pa-card__tools`; snippet has no such class). Slot name kept for API stability. Follow-up: card tabs don't yet implement `pa-card__tab-content`/`--active` — tracked below. |
| `PureAdmin.Components.CheckboxList` | `checkbox-lists.html` | ✅ | 2026-04-24 | `e2bb951` | Clean. |
| `PureAdmin.Components.Code` (code, code_block) | `code.html` | ⚠️ | 2026-04-24 | `cd2e51b` | Phase-2 stub — class naming diverges (`pa-code-block--{lang}` vs snippet's `pa-code--{lang}`), header structure (`pa-code-block__title`, `pa-btn` for copy) not yet modeled, syntax-token classes (`pa-code-keyword`, `pa-code-string`, …) not exposed. Deferred to a v1.4 rewrite. |
| `PureAdmin.Components.CommandPalette` + `PureAdmin.Live.CommandPalette` | `command-palette.html` | ✅ | 2026-04-24 | `a9b4fe3` | CSS classes align with snippet. Component adds a multi-step command / mode / pagination state machine on top — intentional LiveView extension, not drift. |
| `PureAdmin.Components.Comparison` | `comparison.html` | ✅ | 2026-04-24 | _current_ (`e4f1cd6` anchor) | Clean. |
| `PureAdmin.Components.Form` (input, textarea, select, checkbox, radio, form_group, form_label, form_help, input_group, simple_form, input_wrapper) | `forms.html` | ✅ | 2026-04-24 | `272f141` | Clean. `:field` / `translate_error` / auto-error-rendering are LiveView extensions on top of the snippet surface. |
| `PureAdmin.Components.Grid` (grid, column) | `grid.html` | ✅ | 2026-04-24 | `0bd9f16` | Clean. |
| `PureAdmin.Components.Layout` (layout, navbar*, sidebar*, footer, etc.) | `layout.html` | ✅ | 2026-04-24 | `9762492` | Clean. `.burger-menu .active` toggle lives in the settings-panel hook rather than in the layout component, which is intentional. |
| `PureAdmin.Components.List` (basic_list, ordered_list, definition_list, list, list_item) | `lists.html` | ✅ | 2026-04-24 | `894b0dd` | Clean. |
| `PureAdmin.Components.Loader` | `loaders.html` | ✅ | 2026-04-24 | `6a4682d` | Fixed: spinner `size` attr narrowed to `[nil, "xs"]` to match the only sizes SCSS actually ships (pure-admin AUDIT also flags this gap). Demo page updated to show default + xs only. |
| `PureAdmin.Components.Navigation` (tabs covered here; navbar bits overlap layout.html) | `tabs.html` + `layout.html` | ✅ | 2026-04-24 | `35f5f16` + `9762492` | Clean. |
| `PureAdmin.Components.Popconfirm` | `popconfirm.html` | ✅ | 2026-04-24 | `d8e7f7c` | Fixed: emit initial `pa-popconfirm--{placement}` class on server render; `events/popconfirm.js` now strips logical `start|end` (was `left|right`) on class rewrite, and maps Floating UI's physical placement back to logical via `physicalToLogical()` |
| `PureAdmin.Components.Profile` | `profile.html` | ⚠️ | 2026-04-24 | `2b70e27` | CSS classes align. Follow-up: favourites subsystem (`pa-profile-panel__favorite-item`, `__favorite-icon`, `__favorite-label`, `__favorite-remove`, `__favorites-add`) is not yet exposed as components — apps have to render the markup by hand. Close button uses `<i class="fa-xmark">` vs snippet's literal `✕` (intentional; consistent with our Font Awesome conventions). |
| `PureAdmin.Components.Table` (table, table_responsive, table_container, table_card) | `tables.html` | ✅ | 2026-04-24 | `e34ca85` | Clean. |
| `PureAdmin.Components.Pager` (pager, load_more) | `tables.html` (covers `_pagers.scss` too) | ✅ | 2026-04-24 | `e34ca85` | Clean. Icon attrs converted to slots + Unicode defaults for the security audit; covered by v1.3.0 breaking change note. |
| `PureAdmin.Components.Timeline` | `timeline.html` | ⚠️ | 2026-04-24 | `eaa5ad9` | Simple/feed layouts clean. Alternating layout's `__date` vs `__time` logic is muddled and `pa-timeline--single-column` isn't exposed. Needs a focused pass — deferred to v1.4. |
| `PureAdmin.Components.Toast` | `toasts.html` | ✅ | 2026-04-24 | `4056fa9` | Clean. Close button renders an inline SVG `×` glyph instead of the snippet's literal `✕` — intentional divergence for sharper rendering on high-DPI. |
| `PureAdmin.Components.Tooltip` (tooltip, popover) | `tooltips.html` | ✅ | 2026-04-24 | `b2d196b` | Fixed: popover header title now `<h4>` (was `<span class="pa-popover__title">`). Tooltip's `pa-tooltip--floating` default is intentional — paired with the global `[data-tooltip]` delegator in `hooks/tooltip.js` that creates portal tooltips on body; `is_inline=true` opts out for inline dotted-underline CSS tooltips. |
| `PureAdmin.Components.Typography` (heading, paragraph, divider, pa_link) | `typography.html` | ✅ | 2026-04-24 | `12f1281` | Clean. |
| `PureAdmin.Components.Modal` | `modals.html` | ✅ | 2026-04-25 | `795856e` | Fixed: header close button now `pa-btn--secondary` for default modal and `pa-btn--light` for themed modals (was always `pa-btn--primary`); class is `pa-btn pa-btn--sm pa-btn--icon-only pa-btn--{secondary,light}` per snippet. |
| `lib/assets/js/modal_dialogs.js` (programmatic `PureAdmin.confirm/alert/prompt`) | `modal-dialogs.html` | ✅ | 2026-04-25 | `e5eba00` | Clean — DOM produced matches `_modals.scss`; all options align (variant/size/position/closeOnBackdrop, scrollbar gutter, focus management). |
| `PureAdmin.Components.DataDisplay` (field, fields, field_group, desc_table, prop_card, banded, accent_grid, dot_leaders) | `data-display.html` | ✅ | 2026-04-25 | `39cc6bd` | Clean. `accent_grid__item` has both `color="1..9"` (numeric) and `variant="primary|success|…"` — numeric is a Phoenix extension beyond the snippet, kept as-is. |
| `PureAdmin.Components.Layout.notifications/1` + `notification_item/1` | `notifications.html` | ✅ | 2026-04-25 | `0d7bb15` | Clean. |
| `PureAdmin.Components.Stat` (default + hero + hero-compact + square) | `statistics.html` | ✅ | 2026-04-25 | `5de0ce8` | Clean. |
| `PureAdmin.Components.FilterCard` | `filter-card.html` | ✅ | 2026-04-25 | `b65ec2b` | Clean. |
| `lib/assets/js/hooks/detail_panel.js` (resize hook only) | `detail-panel.html` | ✅ | 2026-04-25 | `c1dc6ff` | Fixed: handle selector now `.pa-detail-panel-resize` (was `.pa-detail-panel__handle`); width written to `--pa-local-detail-panel-width` on `<html>` (was inline `style.width` on the panel); body gets `pa-detail-panel-resizing` during drag, handle gets `pa-detail-panel-resize--active`; RTL drag direction inverted; min-width clamped to 200 px. Open/close state-management for the three display modes (inline split-view / card overlay / fixed overlay) is the consumer's responsibility — no Elixir wrapper for the panel container yet (gap noted below). |

---

## Components with no current snippet (framework gap)

These exist in our library because Pure Admin has SCSS for them, but the
framework repo hasn't produced a snippet yet — they were built against
the SCSS source + demo pages directly. Re-audit once the framework ships
a snippet.

| Component module | SCSS source | Notes |
|---|---|---|
| `PureAdmin.Components.DataViz` (progress, stacked_bar, data_bar, etc.) | `_data-viz.scss` | Framework says "D3-driven — snippet would be thin; defer" |
| `PureAdmin.Components.SettingsPanel` | `_settings-panel.scss` | Framework says "Demo-internal; no snippet needed" |

### Library gaps (snippet exists, no Elixir wrapper)

| Component | Snippet | Notes |
|---|---|---|
| `pa-detail-view` / `pa-detail-panel` (container, three display modes) | `detail-panel.html` | We ship the resize JS hook (`PureAdminDetailPanel`) but no Elixir wrapper for the inline split-view, card overlay, or fixed/mobile overlay container markup. Apps render the markup by hand and just attach the hook. Worth componentising in a later release. |

---

## Components not backed by a framework snippet

LiveView-specific additions that don't exist on the framework side. These
are audited against our own conventions and integration tests only.

| Component module | Notes |
|---|---|
| `PureAdmin.Components.Flash` | Phoenix flash-message wrapper; no framework equivalent — it piggy-backs on `.pa-alert`, which is covered by `alerts.html`. |

---

## Components whose snippet audit is pending upstream

_None — upstream's audit pass is complete as of `cf75736` (2026-04-25)._

---

## Recording a re-audit

When upstream publishes a new commit for an already-audited snippet, flip
the status back to ⏳ and work the row again. Keep the previous commit in
the Notes column so the diff is obvious:

```
| Alert | alerts.html | ⏳ | — | — | Re-audit queued — was ✅ at `512ef3c` 2026-04-24 |
```
