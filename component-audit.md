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

**Current framework HEAD** (for reference when recording new audits): `d49531c` (v2.8.0)
(check `git -C ../pure-admin rev-parse --short HEAD` for the live value).
Last re-audit pass: 2026-05-30 — four upstream releases absorbed in one bump:
- **v2.6.0** (`05b416b`) — KPI showcase suite, framework token consolidation, Tailwind role palette, `pa-stat--square` redesign.
- **v2.7.0** (`12b9d23`) — `pa-modal--banded`, `pa-gauge` rebuild, CSS-variable consolidation sweep, link tokens, sidebar / btn-split / timeline / chip / live-card / outline-secondary fixes.
- **v2.7.1** (`2754d24`) — KPI showcases promoted from inline demo styles into permanent `pa-kpi-*` core components (8 SCSS partials).
- **v2.8.0** (`d49531c`) — CSS variable defaults at `:root` in unthemed bundle, generic terminal tab strip, `auto-fit` cell-min grids, layout-ratio modifiers, composable strip toggles.

Previous re-audit pass: 2026-04-25 — pure-admin v2.5.0 alert rework absorbed.

---

## Components mapped to audited snippets

| Component module | Snippet | Status | Verified on | pure-admin commit | Notes |
|---|---|---|---|---|---|
| `PureAdmin.Components.Alert` | `alerts.html` | ✅ | 2026-04-25 | `2ef8034` | Re-audited for v2.5.0. Drops the `pa-alert__content` wrapper when no `:icon` slot is supplied so structural children (`__heading`, `__list`, `__actions`, `<p>`, `<hr>`) land as direct flex children of `.pa-alert` and pick up the new `flex-basis: 100%` SCSS rules. New `heading_size` attr (`nil` \| `"lg"`) toggles the `pa-alert__heading--lg` modifier — the v2.5.0 unification puts the compact heading on the default and makes the punchy/deliberate-read look opt-in. New `is_multiline` attr emits `pa-alert--multiline` to switch back to `align-items: flex-start` for the icon + multi-line `__content` case. Dismiss button still uses HTML entity `&times;` (cosmetically identical to the snippet's literal `×`); `phx-click` dismiss handler is intentional LiveView divergence from snippet's inline `onclick`. Previously ✅ at `512ef3c` on 2026-04-24. |
| `PureAdmin.Components.Badge` (badge, label, composite_badge, badge_group) | `badges.html` | ✅ | 2026-04-24 | `517f6bf` | Clean. |
| `PureAdmin.Components.Button` (button, button_group, split_button) | `buttons.html` | ✅ | 2026-05-30 | `12b9d23` | Re-audited for v2.7.0 btn-split chevron-corner fix. Wrapper does NOT emit `overflow: hidden` on `.pa-btn-split` (the v2.7.0 fix relies on the container NOT clipping). No markup change required. Previously ✅ at `43a9a42` 2026-04-24. |
| `PureAdmin.Components.Callout` | `callouts.html` | ✅ | 2026-04-24 | `6ea28e8` | Fixed: `pa-callout__heading` wrapper element flipped from `<div>` to `<h4>` to match snippet's semantic heading pattern. |
| `PureAdmin.Components.Card` | `cards.html` | ✅ | 2026-05-30 | `12b9d23` | Re-audited for v2.7.0 `--live-up`/`--live-down`/`--live-neutral` sentiment migration. `live_state="up"`/`"down"`/`"neutral"` attr already exposes the modifier — upstream migrated the internal SCSS from `rgba(...)` to `color-mix()` over the 5-step sentiment scale, no API impact. Earlier `:tools` → `pa-card__actions` fix preserved. Previously ✅ at `4a67018` 2026-04-24. |
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
| `PureAdmin.Components.Timeline` | `timeline.html` | ⚠️ | 2026-05-30 | `12b9d23` | Re-audited for v2.7.0 visual tweaks (simple-dot border-radius 50% → 30%, shadow opacity 0.3 → 0.5). CSS-only changes, no wrapper update needed. Pre-existing gaps remain: alternating layout's `__date` vs `__time` logic is muddled and `pa-timeline--single-column` isn't exposed — deferred. Previously ⚠️ at `eaa5ad9` 2026-04-24. |
| `PureAdmin.Components.Toast` | `toasts.html` | ✅ | 2026-04-24 | `4056fa9` | Clean. Close button renders an inline SVG `×` glyph instead of the snippet's literal `✕` — intentional divergence for sharper rendering on high-DPI. |
| `PureAdmin.Components.Tooltip` (tooltip, popover) | `tooltips.html` | ✅ | 2026-04-24 | `b2d196b` | Fixed: popover header title now `<h4>` (was `<span class="pa-popover__title">`). Tooltip's `pa-tooltip--floating` default is intentional — paired with the global `[data-tooltip]` delegator in `hooks/tooltip.js` that creates portal tooltips on body; `is_inline=true` opts out for inline dotted-underline CSS tooltips. |
| `PureAdmin.Components.Typography` (heading, paragraph, divider, pa_link) | `typography.html` | ✅ | 2026-04-24 | `12f1281` | Clean. |
| `PureAdmin.Components.Modal` | `modals.html` | ✅ | 2026-05-30 | `12b9d23` | Re-audited for v2.7.0 banded modals. New `is_banded` boolean emits `pa-modal--banded` alongside `:variant` — `<.modal variant="success" is_banded>` produces a filled-header + filled-footer banded modal that reads against the band on any theme (framework's CSS auto-inverts inner buttons via `--pa-text-color-1`). Earlier close-button class fix preserved. Previously ✅ at `795856e` 2026-04-25. |
| `lib/assets/js/modal_dialogs.js` (programmatic `PureAdmin.confirm/alert/prompt`) | `modal-dialogs.html` | ✅ | 2026-04-25 | `e5eba00` | Clean — DOM produced matches `_modals.scss`; all options align (variant/size/position/closeOnBackdrop, scrollbar gutter, focus management). |
| `PureAdmin.Components.DataDisplay` (field, fields, field_group, desc_table, prop_card, banded, accent_grid, dot_leaders) | `data-display.html` | ✅ | 2026-05-30 | `12b9d23` | Re-audited for v2.7.0 fields-chips polish (chip spacing / focus styling tweaks — all CSS-only). `accent_grid__item` numeric `color="1..9"` extension preserved as a Phoenix divergence. Previously ✅ at `39cc6bd` 2026-04-25. |
| `PureAdmin.Components.Layout.notifications/1` + `notification_item/1` | `notifications.html` | ✅ | 2026-04-25 | `0d7bb15` | Clean. |
| `PureAdmin.Components.Stat` (default + hero + hero-compact + square) | `statistics.html` | ✅ | 2026-05-30 | `12b9d23` | Re-audited for v2.6.0 + v2.7.0. **v2.6.0 `pa-stat--square` redesign**: `__number` + `__symbol` siblings, baseline-aligned, `cqi` (container-query) font scaling. New `is_prefix_symbol` boolean flips DOM order to `<symbol><number>` for prefix currencies (`$847K`, `¥12.4M`); default false renders `<number><symbol>` for suffix units (`87%`, `23°C`). **v2.7.0 hero deltas**: `change_direction` extended to 5-step sentiment scale (`very_positive` / `positive` / `neutral` / `negative` / `very_negative`); neutral colour shifted from `--pa-text-color-2` to `--pa-neutral`. Stat icon `:danger` becomes valid as upstream `_statistics.scss` ships the modifier. Previously ✅ at `5de0ce8` 2026-04-25. |
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
| `PureAdmin.Components.DataViz` (progress, stacked_bar, data_bar, gauge) | `_data-viz.scss` | Re-audited 2026-05-30 against `12b9d23` for v2.7.0 `gauge/1` rebuild — label moved out of the donut hole (`__inner` now holds only value); label sits in a sibling row alongside `__min` / `__max`. New `:size` attr emits `--pa-gauge-size` inline (default upstream `12rem`). `_data-viz.scss` migrated to `--pa-surface-track` for gauge / ring / progress rails (consumes v2.8.0 `:root` defaults). Framework still says "snippet deferred". |
| `PureAdmin.Components.SettingsPanel` | `_settings-panel.scss` | Framework says "Demo-internal; no snippet needed" |
| `PureAdmin.Components.Kpi` (substrate: `kpi_tile/1`, `kpi_detail/1`, `kpi_sparkline/1`) | `_kpi-base.scss` (v2.7.1, `2754d24`) | New in 2026-05-30 against v2.7.1 promotion. `pa-kpi-tile`, `pa-kpi-detail`, `pa-kpi-spark` classes plus 5-step sentiment (`--very-positive` / `--positive` / `--neutral` / `--negative` / `--very-negative`) on `__value` and `__delta`. Detail popover auto-builds rows from typed props (Current / Previous / Δ absolute / Δ percent / Target) via shared `PureAdmin.Components.KpiDetail` helpers, or accepts raw markup via `:inner_block`. `is_standalone` toggles tiles outside a `pa-kpi-terminal__grid`. JS hook `PureAdminKpiTile` cursor-anchors the popover via Floating UI virtual reference. |
| `PureAdmin.Components.KpiDetail` (helpers — `build_auto_rows/1`, `delta_to_sentiment/1`, `sentiment_class/1`, `dasherize/1`) | `_kpi-base.scss` (v2.7.1, `2754d24`) | Shared by every tile / row component. Mirrors `kpi-detail.ts` from svelte-pure-admin 1:1. No DOM emission of its own. |
| `PureAdmin.Components.KpiTerminal` (`kpi_terminal/1` + tab strip) | `_kpi-terminal.scss` (v2.7.1, `2754d24`; tab generalised v2.8.0 `f0edd10`) | Card wrapper with generic `:pane` tab strip (each pane has `id`, `label_text`, optional `is_active`). No panes → children wrapped in a single `pa-kpi-terminal__grid--2col`. `:header_controls` slot for custom toolbars between title and LIVE pill. JS hook `PureAdminKpiTerminalTabs` wires the client-side tab switch (scoped per terminal). |
| `PureAdmin.Components.KpiSparklineList` (`kpi_sparkline_list/1` + `kpi_sparkline_row/1`) | `_kpi-sparkline-list.scss` (v2.7.1, `2754d24`; `--no-delta` v2.8.0 `11e2be5`) | `is_no_delta` drops the rightmost Δ% column; `is_chart_first` rotates the L→R order 90° at narrow widths. Track widths absorbed as SCSS variables in v2.8.0. |
| `PureAdmin.Components.KpiGaugeList` (`kpi_gauge_list/1` + `kpi_gauge/1`) | `_kpi-comparison-gauges.scss` (v2.7.1, `2754d24`; cell-min grid v2.8.0 `1425764`) | Default cell-min-driven `auto-fit` grid; switch via `grid_layout="2col"` or `"max_2".."max_6"` to cap columns. `cell_min_width` overrides `--pa-kpi-gauge-cell-min`. `tick_position` / `tick_color` knobs. |
| `PureAdmin.Components.KpiHero` (`kpi_hero_list/1` + `kpi_hero_main/1` + `kpi_hero_side/1`) | `_kpi-hero-supporting.scss` (v2.7.1, `2754d24`; `--hero-2-3`/`--hero-3-4` v2.8.0 `619defa`) | `hero_split="2_3"` / `"3_4"` shifts grid weight to the hero (default 1:1). Hero has `:meta` slot (or `delta_text` / `period_text` / `target_text` for the canonical pattern), `:chart` for the sparkline; rail tiles are `:rail` slot. |
| `PureAdmin.Components.KpiBento` (`kpi_bento/1` + `kpi_bento_tile/1`) | `_kpi-bento.scss` (v2.7.1, `2754d24`; `--hero-right`/`--5-tile` v2.8.0 `77f39ce`) | Default 6-tile hero-left layout; `bento_layout="hero_right"` mirrors; `bento_layout="5_tile"` is hero + 4 supporting. `row_height` overrides `--pa-kpi-bento-row-height`. Set `is_hero` on the first tile. |
| `PureAdmin.Components.KpiStrip` (`kpi_strip/1` + `kpi_strip_row/1`) | `_kpi-numeric-strip.scss` (v2.7.1, `2754d24`; composable toggles v2.8.0 `c30cf17`) | Composable `no_previous_value` / `no_delta_percent` / `no_target_bar` toggles (2-5 columns). Header row auto-generated from visible columns; override via `header_labels` (map) or suppress via `no_header` / replace via `:head` slot. `target_bar_percent` drives bar fill (capped at 100% visually); `target_percent_text` is the label (may exceed 100). |
| `PureAdmin.Components.KpiEditorial` (`kpi_editorial/1` + `kpi_editorial_tile/1`) | `_kpi-editorial-minimal.scss` (v2.7.1, `2754d24`; cell-min grid v2.8.0 `4a297d0`) | Cell-min-driven `auto-fit` grid by default; `is_2_columns` shorthand for `pa-kpi-edit__grid--2col`; `grid_layout="max_N"` caps at N columns. `target_text` auto-renders as `<em>tgt</em>{value}` in the meta row. |

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

_None — upstream's audit pass is complete as of `1f9d818` (2026-04-25, v2.5.0)._

---

## Recording a re-audit

When upstream publishes a new commit for an already-audited snippet, flip
the status back to ⏳ and work the row again. Keep the previous commit in
the Notes column so the diff is obvious:

```
| Alert | alerts.html | ⏳ | — | — | Re-audit queued — was ✅ at `512ef3c` 2026-04-24 |
```
