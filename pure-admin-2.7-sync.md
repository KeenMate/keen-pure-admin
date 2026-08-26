# Pure Admin v2.6.0 + v2.7.0 + v2.7.1 + v2.8.0 Sync Plan

Tracks the work to bring `keen_pure_admin` from its current pure-admin v2.5.0
anchor (commit `1f9d818`) up to the framework's current HEAD. Four upstream
releases are covered:

- **v2.6.0** (2026-05-07) — KPI showcase suite, token consolidation, Tailwind
  role-colour palette, `pa-stat--square` redesign.
- **v2.7.0** (2026-05-10) — `pa-modal--banded`, `pa-gauge` rebuild,
  CSS-variable consolidation sweep, link tokens, sidebar/btn-split/timeline
  fixes.
- **v2.7.1** (2026-05-14) — KPI showcases promoted from inline demo styles
  into permanent `pa-kpi-*` core components (8 SCSS partials, all `kpi-*`
  classes renamed to `pa-kpi-*`, per-component cascade vars namespace-prefixed
  to `--pa-kpi-*`).
- **v2.8.0** (2026-05-28) — the formerly-`[Unreleased]` post-2.7.1 commits
  graduated to a stable release: generic terminal tab strip (replaces
  VALUE/Δ%/TREND view-mode toggle), `auto-fit` cell-min grids on gauges +
  editorial, layout-ratio modifiers on hero + bento, `--no-prev/-delta/-target`
  toggles on numeric strip, `--no-delta` on sparkline list — all of which
  our Phase 2 modules already cover. **Plus one architectural fix**: CSS
  variable defaults now emit at `:root` in the unthemed bundle
  (`dist/css/main.css`), closing a FOUC window where pages waiting for a
  theme stylesheet had `var(--pa-positive)` / `--pa-success-bg` / etc. resolve
  to invalid values (KPI sparklines / deltas rendered near-black via
  inherited text colour; web components fell back to hardcoded literals).
  The fix lives in upstream's `main.scss`, not `_core.scss` — `_core.scss`
  stays purely component CSS (consumed by BOTH the unthemed bundle AND
  themes via `@import`; emitting `:root` there would duplicate when a theme
  also emits its own). No wrapper change required; bump
  `@keenmate/pure-admin-core` to `^2.8.0` and consumers benefit
  automatically. Supersedes the 2.7.1-era partial fix that only emitted the
  5-step sentiment scale at `:root`.

Status legend: `[ ]` not started · `[~]` in progress · `[x]` done · `[-]`
intentionally skipped (with reason).

---

## Design principles for new KPI components

Two constraints set by the maintainer, applied to every new KPI wrapper:

1. **Pluggable chart rendering.** Each KPI component that contains a
   chart/sparkline/gauge visual must expose the chart region as a named slot
   (or a render callback) so consumers can plug in any renderer they already
   use — D3, ApexCharts, Vega-Lite, Chart.js, custom inline SVG, a LiveView
   hook, an Elixir-side `Contex` SVG, whatever. The framework's demo SVG
   markup is a reference, not a requirement; our components must not bake one
   chart library in.
2. **Labels are fully customisable.** Every textual label that the upstream
   demos hardcode (`VALUE` / `Δ%` / `TREND` toggle labels, `0 · tgt XYZ` scale
   captions, `vs last month` meta strings, status pill text like `WARN` /
   `GOOD` / `NEUTRAL`, `Mark all as read`, etc.) is an attr / slot. No
   English strings hardcoded in the component module. Default values may be
   provided for ergonomics but must be overridable end-to-end.

Both constraints inform the API shape, so they should be addressed in the
*first* KPI component built — pattern then carries to the rest.

---

## v2.6.0 work items

### Tokens (low-risk, mostly docs)

- [ ] **Document new canonical role tokens** in README's theming section:
  `--pa-success` / `--pa-warning` / `--pa-danger` / `--pa-info`. These are
  separate from existing `--pa-X-bg` (which are component-surface tokens) and
  now sit upstream of them via `--pa-btn-X-bg: var(--pa-X)`. Override one,
  cascade hits buttons + alerts + sentiment + KPI.
- [ ] **Document 5-step sentiment scale**: `--pa-very-positive` /
  `--pa-positive` / `--pa-neutral` / `--pa-negative` / `--pa-very-negative`.
  Clarify: sentiment is *direction of change* (ordinal); role colours are
  *urgency* (categorical). They coexist.
- [ ] **Document text-contrast tiers**: `--pa-text-strong` (85%) /
  `--pa-text-secondary` (70%) / `--pa-text-tertiary` (55%). Note that
  themes must emit these at every mode-switching scope (`:root`,
  `.pc-mode-light`, `.pc-mode-dark`) — the framework already does this, but
  any custom theme overriding the tiers needs the same pattern.
- [ ] **Document surface tints**: `--pa-surface-hover` (4%) /
  `--pa-surface-track` (12%).
- [ ] **Document chart trendline tokens**: `--pa-chart-trendline-height`
  (`3rem` default) / `--pa-chart-trendline-stroke` (`2.1`).
- [ ] **Document detail-popover chrome tokens**: `--pa-detail-bg` / `-text` /
  `-row-label` / `-title` / `-shadow` (Bloomberg-dark by default,
  theme-independent — override for theme-aware popovers).
- [ ] **Note the Tailwind palette shift** in README's upgrade notes:
  `$base-warning-color` `#ffc107 → #f97316` (yellow → orange) is the most
  visible visual change. Success and danger shifted but stay green/red. Themes
  ride the `!default` cascade.

### `pa-stat--square` rework (Visual breaking — existing component)

- [ ] **Update `PureAdmin.Components.Stat` square variant** to support the
  new inline number+symbol layout.
  - Inline number + symbol on the same baseline (drop the absolute-positioned
    watermark).
  - **Markup order is the visual order**: `<number><symbol>` for suffix units
    (`87%`, `23°C`), `<symbol><number>` for prefix currencies (`$847K`,
    `¥12.4M`). No flag/modifier needed.
  - Container queries (`cqi`) instead of `vw` — our markup just needs to
    render `__number` / `__symbol` / `__label` as siblings; the framework's
    SCSS handles sizing. Verify our wrapper doesn't force a fixed width that
    breaks container-query inline-size.
  - Update component docs / examples to show both `%` and `$` cases.

### KPI showcase suite (7 new components)

Each shipped as its own function-component module under
`lib/keen_pure_admin/components/kpi/`. Pattern set by the **first** built —
chart slot + label attrs — applies to all.

- [x] **Shared substrate** — `lib/keen_pure_admin/components/kpi.ex` +
  `kpi_detail.ex` + hooks in `lib/assets/js/hooks/`, registered in
  `components.ex` and `keen_pure_admin.js`. Re-anchored to v2.7.1
  `pa-kpi-*` class surface (Phase 1).
  - [x] `kpi_tile/1` — base tile on `pa-kpi-tile` (head · label · value ·
    prev row · chart slot · auto-built or raw detail · sentiment variants
    on value/delta · `variant` for sparkline direction · `is_standalone`).
    Status pill is `status_text` + `status_variant` (built-ins: `warn` /
    `good` / `neutral`); `:head` snippet overrides the whole head row.
    Auto-emits `phx-hook="PureAdminKpiTile"` when `detail_title_text` is
    set OR `:detail` slot is present.
  - [x] `kpi_detail/1` — popover element (`pa-kpi-detail` + `__title`) that
    accepts either a typed `rows` list (auto-built by `KpiDetail.build_auto_rows/1`
    from `:current` / `:previous` / `:delta_absolute` / `:delta_percent` /
    `:target` props on the host) OR a raw `:inner_block` override.
    Replaces the previous `kpi_tile_detail/1` slot scaffold.
  - [x] `PureAdmin.Components.KpiDetail` (kpi_detail.ex) — shared types +
    helpers (`build_auto_rows/1`, `delta_to_sentiment/1`,
    `sentiment_class/1`, `dasherize/1`) used by every KPI tile/row module.
    Mirrors `kpi-detail.ts` from svelte-pure-admin.
  - [x] `kpi_sparkline/1` — opt-in convenience for the simple
    polyline+trailing-dot pattern, on `pa-kpi-tile__spark`. Users who
    already have a chart library plug it into the `:chart` slot instead.
  - [x] `PureAdminKpiTile` JS hook — re-anchored to `.pa-kpi-detail`
    (was `.kpi-tile__detail`). Cursor-anchored Floating UI popover, moves
    detail to `<body>` on mount, restores on `destroyed`.
  - [x] `PureAdminKpiSparkDot` JS hook — re-anchored to
    `.pa-kpi-spark-wrap` + `.pa-kpi-spark-dot`. Idempotent on `updated()`.
- [x] **Terminal grid** — `PureAdmin.Components.KpiTerminal.kpi_terminal/1`
  (card wrapper) + `:pane` slot (each with `id`, `label_text`, optional
  `is_active`) for the generic tab strip. No tabs → children wrapped in a
  single `pa-kpi-terminal__grid--2col`. Tile primitive remains
  `PureAdmin.Components.Kpi.kpi_tile/1` (with `is_standalone`,
  `status_text` + `status_variant`, sparkline-direction `variant`). The
  VALUE/Δ%/TREND view-mode toggle was retired upstream in favour of the
  generic tab strip — `kpi_terminal/1` exposes a `:header_controls` slot
  for any custom toolbar a consumer wants instead. `PureAdminKpiTerminalTabs`
  JS hook drives client-side tab switching.
- [x] **Sparkline list** — `PureAdmin.Components.KpiSparklineList.kpi_sparkline_list/1`
  + `kpi_sparkline_row/1`. `is_no_delta` drops the rightmost column
  (`pa-kpi-spark-list--no-delta`); `is_chart_first` rotates the stacking
  90° at narrow widths. Row's chart cell is a `:chart` slot; the row
  itself hosts the popover.
- [x] **Comparison gauges** — `PureAdmin.Components.KpiGaugeList.kpi_gauge_list/1`
  + `kpi_gauge/1`. Default cell-min-driven `auto-fit` grid; switch via
  `grid_layout="2col"` or `"max_2".."max_6"`. `cell_min_width` overrides
  `--pa-kpi-gauge-cell-min`. `tick_position` / `tick_color` set the gauge
  tick knobs as inline CSS vars. Sentiment variants: `positive` / `warning`
  / `negative` / `neutral`.
- [x] **Hero + supporting** — `PureAdmin.Components.KpiHero.kpi_hero_list/1`
  + `kpi_hero_main/1` + `kpi_hero_side/1`. `hero_split="2_3"` or `"3_4"`
  shifts weight to the hero (default 1:1). Hero has `:meta` slot for the
  rich meta row (or set `delta_text` / `period_text` / `target_text` for
  the canonical pattern); `:chart` for the sparkline. Rail is a `:rail`
  slot.
- [x] **Bento** — `PureAdmin.Components.KpiBento.kpi_bento/1` + `kpi_bento_tile/1`.
  Default 6-tile hero-left layout; `bento_layout="hero_right"` mirrors;
  `bento_layout="5_tile"` is hero + 4 supporting. `row_height` overrides
  `--pa-kpi-bento-row-height`. Set `is_hero` on the first tile for the
  bigger value + chart sizes.
- [x] **Numeric strip** — `PureAdmin.Components.KpiStrip.kpi_strip/1` +
  `kpi_strip_row/1`. Composable `no_previous_value` / `no_delta_percent` /
  `no_target_bar` toggles. Header row auto-generated from visible columns;
  override individual labels via `header_labels` (map keyed by column atom)
  or suppress via `no_header` or replace fully via `:head` slot.
  `target_bar_percent` drives bar fill (capped at 100% visually);
  `target_percent_text` is the label below (may exceed 100).
- [x] **Editorial minimal** — `PureAdmin.Components.KpiEditorial.kpi_editorial/1`
  + `kpi_editorial_tile/1`. Cell-min-driven `auto-fit` grid by default;
  `is_2_columns` boolean shorthand or `grid_layout="max_N"` cap modifiers.
  `cell_min_width` overrides `--pa-kpi-edit-cell-min`. `target_text` is
  auto-rendered as `<em>tgt</em>{value}` in the meta row.

> ⚠️ **Note on snippet status.** None of the KPI showcases have graduated to
> `packages/core/snippets/` yet — they live in `demo/views/kpi-*.mustache`.
> Per the v2.6.0 changelog: "Will promote to `core-components/_kpi-*.scss`
> once the design language stabilises across additional KPI showcases."
> Treat these as 🆕 *new* rows in `component-audit.md` — built against demo
> views directly, re-audit when snippets land. Our component API may need to
> follow if upstream restructures during stabilisation.

---

## v2.7.0 work items

### `pa-modal--banded` (new modifier)

- [ ] **Extend `PureAdmin.Components.Modal`** to accept a `:banded` boolean
  attr that composes with the existing role variant (`:success | :warning |
  :danger | :info`). Markup: `<div class="pa-modal pa-modal--success pa-modal--banded">`.
- [ ] Document that banded buttons inside the modal's header/footer
  auto-invert (via `var(--pa-text-color-1)`) for cross-theme contrast — no
  consumer-side override needed.
- [ ] Add banded examples to demo for all four role variants.

### `pa-gauge` rebuild (Visual breaking — existing component)

- [ ] **Update `PureAdmin.Components.Gauge`** for the rebuilt ring layout.
  - Label moves out of the donut: render as a sibling row
    (`__min · __label · __max`) below the gauge, not inside `__inner`.
  - `__inner` now holds only the value text.
  - Expose `--pa-gauge-size` as a `:size` attr or style pass-through
    (default `12rem`).
  - Single-cascade colour: `--pa-gauge-fill` is now set by the role
    modifiers (`--success` / `--warning` / `--danger` / `--info`) and the
    base `::before` reads it. Markup unchanged — verify our wrapper still
    emits the same classes.
  - Note: text inside the donut doesn't auto-scale with `--pa-gauge-size`;
    document `font-size` on `.pa-gauge__value` for proportional resizing.
- [ ] Verify `.pa-gauge--zones` (multi-zone) still works through our wrapper
  — its `::before` is intentionally overridden, not affected by
  `--pa-gauge-fill`.

### Smaller component reworks

- [ ] **`pa-stat__icon--danger`** — add `:danger` to the icon-variant enum in
  `PureAdmin.Components.Stat` (was missing — original 3-variant list was
  inconsistent).
- [ ] **Stat hero deltas (`__change`)** — migrate from `:positive | :negative | :neutral` to the 5-step sentiment scale by adding `:very_positive | :very_negative`. Document neutral-colour shift (`--pa-text-color-2 → --pa-neutral`).
- [ ] **Sidebar submenu active text** — expose the new
  `--pa-sidebar-submenu-active-text` token in the theming docs. No wrapper
  change needed (CSS-only).
- [ ] **`pa-btn-split`** — verify our wrapper doesn't emit `overflow:hidden`
  on the container (the framework dropped it). Verify menu items inside
  `__menu` aren't getting flattened corners through our markup.
- [ ] **Timeline simple dots** — visual-only changes (border-radius `50% → 30%`,
  shadow opacity `0.3 → 0.5`). No wrapper change needed; flag in CHANGELOG.
- [ ] **`pa-fields--chips`** — add the new `:info` variant to the chip
  modifier enum.
- [ ] **`.pa-card--live-up` / `.pa-card--live-down`** — add as a
  live-data-direction variant on `PureAdmin.Components.Card`. Document this
  is *direction of latest tick*, not status.
- [ ] **`pa-btn--outline-secondary`** — no wrapper change. Just verify our
  demo / docs show it correctly now that it's visible on light themes.

### New global / link tokens

- [ ] **Document link tokens** (`--pa-link-color`, `--pa-link-color-hover`,
  `--pa-link-color-visited`) in the theming README. Note the global
  `:where(a)` rule means any custom component-level link styling continues
  to win without `:hover` / `:visited` overrides.

### CSS-variable consolidation sweep (no component changes — docs only)

The v2.7.0 sweep migrated ~180 SCSS-baked role-colour sites to runtime
`var()` tokens across statistics, data-viz, data-display, comparison,
timeline, file-selector, query-editor, lists, cards, logic-tree,
checkbox-lists, input-wrapper, composite-badge, tabs, alerts, callouts,
popconfirm, base, labels, notifications.

- [ ] **README note**: previously, overriding `--pa-success` / `-warning` /
  `-danger` / `-info` / `-accent` at runtime had no effect on those
  components — they baked at SCSS compile time. As of v2.7.0 the overrides
  cascade. No markup change for consumers, but theme authors can now
  override role colours once instead of editing each component's SCSS.

---

## Cross-cutting / housekeeping

- [ ] **Bump README anchors**:
  - Line 17 (`re-anchored to pure-admin v2.5.0`) → `v2.7.0`.
  - Line 624 (`@keenmate/pure-admin-core CSS (v2.3.6+)`) — decide minimum,
    likely bump to `v2.6.0+` (introduces the sentiment + tier tokens) or
    `v2.7.0+` (introduces banded modals, link tokens). KPI components will
    require v2.6.0+.
- [ ] **Refresh demo theme lockfile** — `demo/pureadmin.lock.json` still
  pins themes at `2.3.4`. Bump to current and re-fetch.
- [ ] **CHANGELOG entry** for the upcoming `keen_pure_admin` release —
  follow the structure of v1.3.0's entry. Two upstream releases absorbed:
  list new components, breaking-visual changes, new tokens.
- [ ] **`component-audit.md` updates**:
  - Update "Current framework HEAD" line `1f9d818 → 12b9d23`.
  - Add 7 🆕 rows for KPI components (note: no snippets yet, built against
    `demo/views/kpi-*.mustache`).
  - Mark `modal`, `gauge`, `stat`, `card`, `btn-split`, `fields-chips`
    rows ⏳ pending re-audit at HEAD `12b9d23`.
- [ ] **Demo additions** — add a `/kpi` section to the demo app mirroring
  the upstream demo's KPI submenu, one route per showcase, so the
  pluggable-chart-slot pattern can be exercised end-to-end with a real
  Phoenix LiveView setup.

---

## Open questions for the maintainer

- [ ] **Default chart renderer in demo?** The framework's demo uses inline
  SVG. Our demo can do the same, or pick a small Elixir-friendly default
  (Contex SVG?). Doesn't affect the component API — consumer plugs in what
  they want — but the demo needs *something* to render.
- [ ] **KPI label defaults: English or empty?** The toggle labels (`VALUE` /
  `Δ%` / `TREND`), pill states (`WARN` / `GOOD`), and scale captions (`tgt`,
  `0`) — default to English strings (ergonomic) or require consumers to
  pass them (no hidden English in i18n apps)? Recommend English defaults
  with `nil`-skips-rendering for opt-out.
- [ ] **Should the v2.6.0 stat-square rework + v2.7.0 work ship as one
  release or two?** Both contain Visual-breaking changes; bundling matches
  the upstream's own grouping (v1.3.0 absorbed v2.5.0 in one go).
