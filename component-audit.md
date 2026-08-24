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

**Current framework HEAD** (for reference when recording new audits): `fe0cfdc` (v2.9.0-rc15)
(check `git -C ../pure-admin rev-parse --short HEAD` for the live value).

**Re-audit pass: 2026-08-23 — full sweep vs v2.9.0-rc15 (`fe0cfdc`).** Method: live
demo on :18700 + `.ex` source diffed against `snippets/*.html` AND the built
`dist/css/main.css` (the snippet is the markup contract; built CSS confirms
SCSS-styled modifiers — but note a class can be blessed in the snippet without its
own CSS rule, e.g. `pa-range__thumb--max`). **Fixed:** Card subtitle→`pa-card__meta`;
Badge (core gap — added `pa-badge--color-{1..9}` to core + switched wrapper);
Timeline invented `__title`/`__meta`→`<h3>`/`<p>` + `--single-column`; Stat
`--hero--compact` double-dash→`--hero-compact`; Typography `pa-heading`→bare `<h_n>`
+ `pa-paragraph`→`pa-text`; Code opt-in copy button; command-palette `pa-spinner--sm`
dropped; dropped dead attrs (list `is_bordered`, tab `width/height`, form `is_inline`,
table `is_hover/is_borderless`, sidebar `is_sticky`). **Verified clean:** KPI suite
(all 9), DataViz, SettingsPanel, Splitter, Flash, Comparison, Grid, Popconfirm,
Callout, Loader, Tooltip, Filter-card, Toast, Profile, Table-card, Range-group.
**Resolved cross-repo:** Layout sidebar `--resizable` (core blessed it as the single
activation marker); copy-hint i18n (keen already uses core's `::after`, gets
`--pa-copy-hint-text`/`--pa-copied-text` free at core ≥ rc16). **Not yet built:**
`pa-search-results` wrapper (new core component, deferred). Framework HEAD bumped
`d49531c` → `fe0cfdc`.

Previous re-audit pass: 2026-05-30 — four upstream releases absorbed in one bump:
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
| `PureAdmin.Components.Badge` (badge, label, composite_badge, badge_group) | `badges.html` | ✅ | 2026-08-23 | `fe0cfdc` | **Closed the `theme_color` core gap** (also flagged in svelte-pure-admin's badge audit). `theme_color` mapped to the generic `pa-bg-color-N` utility, which only sets the background → a theme-slot badge could render dark-text-on-dark. Root cause was a **core gap**: `_badges.scss` had no `pa-badge--color-N` pair (unlike alert/button/card). Added the filled `pa-badge--color-{1..9}` loop to core `badges/_badge-base.scss` (`--pa-color-N` bg + contrasting `--pa-color-N-text`, mirroring the alert pattern; badges are filled-only so no `--outline-color-N`), rebuilt core, and switched the wrapper to `pa-badge--color-N`. Now consistent with keen's own `alert.ex`/`button.ex`. **Requires core ≥ 2.9.0-rc15 (this commit) + theme rebuild.** svelte-pure-admin's wrapper should make the same switch (its audit left it as-is pending this core fix). Previously ✅ at `517f6bf` 2026-04-24. |
| `PureAdmin.Components.Button` (button, button_group, split_button) | `buttons.html` | ✅ | 2026-05-30 | `12b9d23` | Re-audited for v2.7.0 btn-split chevron-corner fix. Wrapper does NOT emit `overflow: hidden` on `.pa-btn-split` (the v2.7.0 fix relies on the container NOT clipping). No markup change required. **STRUCTURAL DOM-diff pass (2026-08-23, `/audit` live dump vs `buttons.html`):** every shape is **byte-identical** to canonical — basic/variant/outline/size/block, `pa-btn__icon` (start+end), `pa-btn--icon-only`, loading (`pa-btn--loading` + `pa-btn__spinner` + `disabled`), align-center (`pa-btn--align-center` + `pa-btn__label`), `href`→`<a class="pa-btn">`, `button_group`, and **split_button** (`pa-btn-split` > primary `pa-btn` + `pa-btn-split__toggle` with `pa-btn-split__chevron` + `__menu` > `__menu-inner` > `__item(--danger)`). All classes verified present in core CSS. keen adds `type="button"` + `disabled`-on-loading (a11y wins over canonical). Earlier flagged `pa-btn-split--auto-absorb`/`pa-keep-open`/`pa-overflow-trigger` are FALSE POSITIVES (docstring + `data-pa-*` attrs, not classes). Nits (benign, not fixed): split primary icon carries inline `style="font-size:1.25rem"`; icon-only buttons need `title`/`aria-label` for an accessible name (usage reminder). Previously ✅ at `43a9a42` 2026-04-24. |
| `PureAdmin.Components.Callout` | `callouts.html` | ✅ | 2026-04-24 | `6ea28e8` | Fixed: `pa-callout__heading` wrapper element flipped from `<div>` to `<h4>` to match snippet's semantic heading pattern. |
| `PureAdmin.Components.Card` | `cards.html` | ✅ | 2026-08-23 | `fe0cfdc` | Re-audited against v2.9.0-rc15 (card-header canonicalization rc05 + footer/overflow rc06). Canonical title (`.pa-card__title` > `.pa-card__title-text` + optional `.pa-card__title-icon`), `.pa-card__description`, footer `.pa-card__actions`, `:tools` → `.pa-card__actions`, and `:meta` → `.pa-card__meta` all already on-contract. **Fixed one latent drift:** `subtitle`/`subtitle_text` emitted the generic `pa-text pa-text--secondary` utility (off-contract; core defines no `.pa-card__subtitle`) — now emits the canonical `<span class="pa-card__meta">`, matching the `:meta` slot and svelte-pure-admin's identical card fix. Latent because no demo route exercised the prop. Previously ✅ at `12b9d23` 2026-05-30 (v2.7.0). |
| `PureAdmin.Components.CheckboxList` | `checkbox-lists.html` | ✅ | 2026-04-24 | `e2bb951` | Clean. |
| `PureAdmin.Components.Code` (code, code_block) | `code.html` | ✅ | 2026-08-23 | `fe0cfdc` | Re-audited against v2.9.0-rc15 — **old note was stale.** Language naming is correct (`pa-code--{lang}`, NOT `pa-code-block--{lang}`), and the headered structure matches the snippet: `pa-code-block` → `__header` > `__title` → `__body` > `<pre class="pa-code">`. **Added the canonical copy button** (per user decision): new opt-in `copy_text` attr renders `<button class="pa-btn pa-btn--xs pa-btn--secondary"><span class="pa-btn__icon"><i class="fa-solid fa-copy"></i></span> Copy</button>` in `__header`, wired to keen's global `[data-pa-copy]` clipboard delegator via `data-copy-value` (also triggers the headered form so copy works without a filename; copy source is explicit because a LiveView wrapper can't read slot text server-side). Only remaining gap: **syntax-token classes** (`pa-code-keyword`/`-string`/…) aren't emitted — expected, they come from a highlighter, not the structural wrapper. Previously ⚠️ at `cd2e51b` 2026-04-24. |
| `PureAdmin.Components.CommandPalette` + `PureAdmin.Live.CommandPalette` | `command-palette.html` | ✅ | 2026-08-23 | `fe0cfdc` | Re-audited against v2.9.0-rc15. CSS classes align; `size` already emits the new `--sm/--lg/--xl` resize presets. Multi-step command/mode/pagination state machine is an intentional LiveView extension. **Fixed one invented size:** the loader spinner used `pa-spinner--sm`, which doesn't exist (core spinner sizes are `--xs` + semantic colours; the canonical palette loader in `command-palette.html` uses `pa-spinner pa-spinner--primary` with NO size). Dropped `--sm`. Previously ✅ at `a9b4fe3` 2026-04-24. |
| `PureAdmin.Components.Comparison` | `comparison.html` | ✅ | 2026-04-24 | _current_ (`e4f1cd6` anchor) | Clean. |
| `PureAdmin.Components.Form` (input, textarea, select, checkbox, radio, form_group, form_label, form_help, input_group, simple_form, input_wrapper) | `forms.html` | ✅ | 2026-08-23 | `fe0cfdc` | Re-audited against v2.9.0-rc15. Structure on-contract (`pa-form`, `pa-form-group(--horizontal/--error/--success/--warning/--required)`, `pa-form-label(--required)`, `pa-form-help(--variant/--color-N)`, `pa-form-actions`). `:field`/`translate_error`/auto-error-rendering are LiveView extensions. **Fixed one dead-class attr:** `simple_form`'s `is_inline` emitted `pa-form--inline`, which has no core CSS — dropped. **STRUCTURAL DOM-diff pass (2026-08-23, `/audit` route → live dump vs `forms.html`):** input/sizes, textarea, select, validation (both `pa-form-group--{state}` wrapper AND control-level `pa-input--{state}`), form-help, **checkbox** (`label.pa-checkbox > input + __box + __label`) and **radio** (`label.pa-radio > input + text`, correctly no box/label spans), and input-group prepend/append all verified **byte-identical** to canonical. **Fixed:** exposed `size` on `radio` (`pa-radio--{xs,sm,lg,xl}`) and `input_group` (`pa-input-group--{size}`) — core supports both, keen didn't; input-group button-addon docstring now shows the required `pa-input-group__button` class (the demo already used it correctly, so it was never a keen defect — only the `:button` slot can't auto-inject it, so it's consumer-supplied). Benign/justified: `form_group` emits `<label class="pa-form-label">` rather than the snippet's bare `<label>` — core only auto-styles labels under `.pa-form .pa-form-group` (`_form-layout.scss:47`), so `pa-form-label` keeps a standalone form_group's label styled (robustness, not drift). **⚠️ RECORDED FOR FUTURE (a11y, not fixed):** the `form_group label="X"` shorthand emits a label with no `for`, and `input/textarea/select` default to no `id`, so the label isn't programmatically associated with its control. Can't auto-`id`-from-`name` safely (radio groups share `name` → duplicate ids). Recommend consumers use the explicit `<.form_label for={id}>` + `<.input id={id}>` pattern (already shown in `form_group`'s own docstring), or add opt-in id-linkage to the shorthand. Previously ✅ at `272f141` 2026-04-24. |
| `PureAdmin.Components.Grid` (grid, column) | `grid.html` | ✅ | 2026-04-24 | `0bd9f16` | Clean. |
| `PureAdmin.Components.Layout` (layout, navbar*, sidebar*, footer, etc.) | `layout.html` | ✅ | 2026-08-23 | `fe0cfdc` | Re-audited against v2.9.0-rc15. rc14 navbar rename fully ported (`pa-navbar__*`, `pa-app-header`, `pa-page-header`, `pa-navmenu__*`); `pa-layout__sidebar--icon-collapse` real; sticky driven by body-level `pa-layout--sticky` (JS/localStorage). **RESOLVED — the sidebar `--resizable`/`--sticky` finding:** core resolved its own snippet self-contradiction (separate session) by **blessing `.pa-layout__sidebar--resizable` as the single documented activation marker** — matching what core's shipped `sidebar-resize.js` + demo already do. So keen's `pa-layout__sidebar--resizable` was correct all along (keen mirrors core's working driver) — **kept, no change.** `pa-layout__sidebar--sticky` was genuinely dead (never in core JS or SCSS) — **dropped the class + the orphaned `is_sticky` attr.** Minor remainder: a `@doc` example teaches nonexistent `pa-navbar__icon-btn` (real header controls use `pa-navbar__profile-btn`/`pa-btn`) — doc-only. Previously ✅ (stale) at `9762492` 2026-04-24. |
| `PureAdmin.Components.List` (basic_list, ordered_list, definition_list, list, list_item) | `lists.html` | ✅ | 2026-08-23 | `fe0cfdc` | Re-audited against v2.9.0-rc15. `basic_list` (`pa-list-basic--bordered`), `ordered_list`, `definition_list`, and the interactive `list_item` (`pa-list__avatar`/`__title`/`__subtitle`/`__meta`) all on-contract. **Fixed dead-class attr:** `list/1`'s `is_bordered` emitted `pa-list--bordered`, which does not exist in core — the interactive `.pa-list` block ships NO bordered modifier (only `.pa-list-basic--bordered` does, on `basic_list/1`). The attr was non-functional and has been **dropped** (per user decision). `basic_list`'s real `is_bordered` → `pa-list-basic--bordered` is untouched. **STRUCTURAL DOM-diff pass (2026-08-23, `/audit` live dump vs `lists.html`):** basic_list (`<ul class="pa-list-basic"><li>`) byte-identical. **Fixed a nesting divergence in `list_item`:** `pa-list__meta` was rendered as an item-level **sibling** of `pa-list__content` (making it a third flex child, pushed right), but canonical nests `__meta` **inside** `__content`, stacked under title/subtitle (every `lists.html` example + the reference list `__content (flex:1)` > `__title`/`__subtitle`/`__meta`). Moved both `meta_text` and the `:meta` slot inside `__content`; `inner_block` stays item-level for custom extensions. Verified via `render_component`. NOTE: this changes the rendered layout of list items that use `meta_text` (meta now stacks instead of right-aligning) — matches the framework contract. Previously ✅ at `894b0dd` 2026-04-24. |
| `PureAdmin.Components.Loader` | `loaders.html` | ✅ | 2026-04-24 | `6a4682d` | Fixed: spinner `size` attr narrowed to `[nil, "xs"]` to match the only sizes SCSS actually ships (pure-admin AUDIT also flags this gap). Demo page updated to show default + xs only. |
| `PureAdmin.Components.Navigation` (tabs covered here; navbar bits overlap layout.html) | `tabs.html` + `layout.html` | ✅ | 2026-08-23 | `fe0cfdc` | Re-audited against v2.9.0-rc15. Tab container/item/panel/scroll structure (`pa-tabs`, `__container`, `__item(--active)`, `__panel(--active)`, `__scroll-btn--start/--end`, `__scroll-container`) all on-contract; scroll buttons correctly use `data-pa-tab-scroll` data attrs. **Fixed-size tabs — REWORKED to the shipped core contract (2026-08-23):** core resolved the fixed-size-tab design as **`pa-tabs--wrap-labels`** on the container + the generic rem utilities **`minwr-N`/`maxwr-N`/`minhr-N`** on items, and explicitly retired `pa-tabs__item--w-{N}x`/`--h-{N}x` (which never had CSS). keen followed: **dropped `tab_item`'s dead `width`/`height` attrs** (fixed size is now `class="minwr-6"`, square icon tab `class="minwr-3 minhr-3"`), **added `is_wrap_labels` to `tabs`** (→ `pa-tabs--wrap-labels`, pair with `maxwr-*`), and converted all ~15 demo call sites + the info alert off the dead scale onto the utilities, plus a new wrap-labels showcase. Verified via `render_component`. **STRUCTURAL DOM-diff pass (2026-08-23, `/audit` live dump vs `tabs.html`):** the tab tree is **byte-identical** to canonical — `<div class="pa-tabs"><button class="pa-tabs__item(--active)">…</button></div>` + `<div class="pa-tabs__content"><div class="pa-tabs__panel(--active)" id>…</div></div>` (keen adds benign `id` + `data-tab-target` hooks). No structural drift. Previously ✅ at `35f5f16` + `9762492` 2026-04-24. |
| `PureAdmin.Components.Popconfirm` | `popconfirm.html` | ✅ | 2026-04-24 | `d8e7f7c` | Fixed: emit initial `pa-popconfirm--{placement}` class on server render; `events/popconfirm.js` now strips logical `start|end` (was `left|right`) on class rewrite, and maps Floating UI's physical placement back to logical via `physicalToLogical()`. **Re-audit 2026-08-23 (`fe0cfdc`):** popconfirm body (`pa-popconfirm(--placement/--compact)`, `__actions`/`__arrow`/`__content`/`__icon(--danger/-warning/-info)`/`__message`) all on-contract. **STRUCTURAL DOM-diff pass (2026-08-23):** the `.pa-popconfirm` popup is **byte-identical** to canonical (`pa-popconfirm(--{placement}/--compact)` > `__arrow` + `__content` > `__message(pa-popconfirm__icon pa-popconfirm__icon--{danger,warning,info})` > `<p>` + `__actions` > two `pa-btn`s). **Fixed:** removed the off-contract `pa-popconfirm-wrapper` class from the trigger anchor div — not a core class (core's trigger is a bare sibling), and the JS anchors via `data-pa-popconfirm-trigger` not the class. Kept the wrapper *div* (with its inline `display:inline-block;position:relative` + data-attr) since keen can't attach the trigger data-attr to arbitrary slot content. Verified via `render_component`. |
| `PureAdmin.Components.Profile` | `profile.html` | ⚠️ | 2026-08-23 | `fe0cfdc` | Re-audited against v2.9.0-rc15. CSS classes align; close button already uses the masked-icon primitive `<span class="pa-icon pa-icon--x">` (rc15 icon-primitive sweep already absorbed — the prior `<i class="fa-xmark">` note is stale). Remaining ⚠️ (feature-level, flagged not fixed): the favourites subsystem (`pa-profile-panel__favorite-item`, `__favorite-icon`, `__favorite-label`, `__favorite-remove`, `__favorites-add`) is still not exposed as components — apps render that markup by hand. When it is componentised, its remove affordance must also use `pa-icon--x` (core converted the favourite-remove X in the rc15 sweep). Previously ⚠️ at `2b70e27` 2026-04-24. |
| `PureAdmin.Components.Table` (table, table_responsive, table_container, table_card) | `tables.html` | ✅ | 2026-08-23 | `fe0cfdc` | Re-audited against v2.9.0-rc15. `pa-table--striped`/`--bordered`/`--responsive`/`--responsive-grid`/size + `pa-table-card__description` (rc11) all on-contract. **Fixed two dead-class attrs:** `is_hover` → `pa-table--hover` and `is_borderless` → `pa-table--borderless`, neither of which exists in core. Row hover is ON by default (`.pa-table tbody tr:hover`), and the default table is already borderless (`--bordered` is the opt-in) — both attrs were no-ops. Dropped (only a docstring example used `is_hover`). Previously ✅ at `e34ca85` 2026-04-24. |
| `PureAdmin.Components.Pager` (pager, load_more) | `tables.html` (covers `_pagers.scss` too) | ✅ | 2026-04-24 | `e34ca85` | Clean. Icon attrs converted to slots + Unicode defaults for the security audit; covered by v1.3.0 breaking change note. |
| `PureAdmin.Components.Timeline` | `timeline.html` | ⚠️ | 2026-08-23 | `fe0cfdc` | Re-audited against v2.9.0-rc15. **Fixed invented classes:** the simple-layout branch emitted `pa-timeline__title` + `pa-timeline__meta`, neither of which exists in core SCSS (0 hits) — the recurring "plausible-but-nonexistent element" pattern. Core's canonical in-content title is a bare `<h3>` (alternating snippet), which keen's own icon/block branch already emitted; the simple branch now matches (`:title` → `<h3>`, `:meta` → `<p>`). `:meta` had zero real usage anywhere in the repo. **Exposed** the missing `pa-timeline--single-column` modifier (`is_single_column`). 11 tests green. **Still ⚠️ (deferred, judgment call):** the alternating branch's `__date` vs `__time` selection is muddled and needs a deeper rework against the `--start`/`--end`/`--feed` variant matrix — flag before touching. Previously ⚠️ at `12b9d23` 2026-05-30. |
| `PureAdmin.Components.Toast` | `toasts.html` | ✅ | 2026-08-23 | `fe0cfdc` | Re-audited against v2.9.0-rc15. Close button already uses the masked-icon primitive `<span class="pa-icon pa-icon--x">` (the blessed close glyph as of rc15's icon-primitive sweep) — on-contract. (Prior note claiming an inline SVG `×` was stale; the wrapper had since moved to `pa-icon--x`.) Structure otherwise clean. Previously ✅ at `4056fa9` 2026-04-24. |
| `PureAdmin.Components.Tooltip` (tooltip, popover) | `tooltips.html` | ✅ | 2026-04-24 | `b2d196b` | Fixed: popover header title now `<h4>` (was `<span class="pa-popover__title">`). Tooltip's `pa-tooltip--floating` default is intentional — paired with the global `[data-tooltip]` delegator in `hooks/tooltip.js` that creates portal tooltips on body; `is_inline=true` opts out for inline dotted-underline CSS tooltips. **STRUCTURAL DOM-diff pass (2026-08-23, `/audit` live dump vs `tooltips.html`):** popover is **byte-identical** to canonical (`pa-popover(--{sm,lg,center,end})` > `__trigger` + `__content` > `__header`[`<h4>` + `__close` `pa-icon--x`] + `__body` — all real classes). Tooltip trigger `pa-tooltip(--floating/--{variant}/--help/--keyword/--multiline)` all real; `--floating` confirmed intentional (JS suppresses the CSS pseudo-tooltip). **Fixed one dead class:** `position="top"` emitted `pa-tooltip--top`, which doesn't exist in core (top is the default = no modifier) — now emits nothing for top. Verified via `render_component`. Minor completeness gap (recorded, not fixed): tooltip doesn't expose the `pa-tooltip--color-{1..9}` scale (only semantic `variant`). |
| `PureAdmin.Components.Typography` (heading, paragraph, divider, pa_link) | `typography.html` | ✅ | 2026-08-23 | `fe0cfdc` | Re-audited against v2.9.0-rc15. **Fixed two invented classes:** `heading/1` emitted `pa-heading` and `paragraph/1` emitted `pa-paragraph`, neither of which exists in core (0 in built CSS). Core headings are **bare** `<h1>`..`<h6>` (no class); the canonical paragraph is `<p class="pa-text">`. Now `heading/1` emits an unclassed tag (callers add utilities via `class`) and `paragraph/1` emits `pa-text` — matching keen's own `text/1`, which already used `pa-text`. Previously ✅ (stale) at `12f1281` 2026-04-24. |
| `PureAdmin.Components.Modal` | `modals.html` | ✅ | 2026-05-30 | `12b9d23` | Re-audited for v2.7.0 banded modals. New `is_banded` boolean emits `pa-modal--banded` alongside `:variant` — `<.modal variant="success" is_banded>` produces a filled-header + filled-footer banded modal that reads against the band on any theme (framework's CSS auto-inverts inner buttons via `--pa-text-color-1`). Earlier close-button class fix preserved. **Re-audit 2026-08-23 (`fe0cfdc`):** close button already uses `pa-icon--x` ✓; `--banded`/`--show`/`--top`/semantic variants/`__body--scrollable` all real. One minor note: `is_static` emits `pa-modal--static`, which has no core CSS — the static behavior (no ESC/backdrop close) is fully handled in Elixir via `!@is_static` guards, so the class is a harmless dead state-marker (no JS keys off it). Left as-is; drop it if a state hook isn't wanted. **STRUCTURAL DOM-diff pass (2026-08-23, `/audit` live dump vs `modals.html`):** the tree is **byte-identical** to canonical — `pa-modal(--show)` > `__backdrop` + `__container(--{sm,lg,xl,xxl,fw})` > `__header`[`__title` + close `pa-btn pa-btn--sm pa-btn--icon-only pa-btn--{secondary|light}` > `pa-icon--x`] + `__body(--scrollable)` + `__footer`; close correctly derives `--light` for coloured/banded headers, `--secondary` otherwise (matches the svelte fix). **Fixed two invented classes** found via the dump: (1) `header_classes` emitted `pa-modal__header--{variant}`, which does NOT exist in core (0 hits; snippet says *"No pa-modal__header--*"*) — core colours the header via the root `.pa-modal--{variant}` descendant rule. Dropped it; `header_variant` now falls back into the root class (`variant \|\| header_variant`), so a `header_variant`-only modal actually colours now (previously it emitted ONLY the dead header class and rendered uncoloured). (2) `size="md"` emitted `pa-modal__container--md`, which doesn't exist ("md" IS the default medium = bare `__container`) — now emits no modifier. Verified via `render_component`. Previously ✅ at `795856e` 2026-04-25. |
| `lib/assets/js/modal_dialogs.js` (programmatic `PureAdmin.confirm/alert/prompt`) | `modal-dialogs.html` | ✅ | 2026-04-25 | `e5eba00` | Clean — DOM produced matches `_modals.scss`; all options align (variant/size/position/closeOnBackdrop, scrollbar gutter, focus management). |
| `PureAdmin.Components.DataDisplay` (field, fields, field_group, desc_table, prop_card, banded, accent_grid, dot_leaders) | `data-display.html` | ✅ | 2026-05-30 | `12b9d23` | Re-audited for v2.7.0 fields-chips polish (chip spacing / focus styling tweaks — all CSS-only). `accent_grid__item` numeric `color="1..9"` extension preserved as a Phoenix divergence. **Re-audit 2026-08-23 (`fe0cfdc`):** copy-to-clipboard is **on-contract** — keen uses core's real `pa-field--copy-hover` + `pa-field__copy` + `data-pa-copy`/`data-pa-copy-on-click` and relies on core's `::after` for the hint text (NO invented `pa-field__copy-hint` element — keen avoided the trap svelte-pure-admin fell into). Core's new copy-hint i18n (`--pa-copy-hint-text` / `--pa-copied-text` on the `::after`, committed `2db3c3d`) means keen gets translatable hints **for free** once it bumps to core ≥ rc16 — a root provider can set the two vars once and every copy affordance translates. No keen markup change. Previously ✅ at `39cc6bd` 2026-04-25. |
| `PureAdmin.Components.Layout.notifications/1` + `notification_item/1` | `notifications.html` | ✅ | 2026-04-25 | `0d7bb15` | Clean. |
| `PureAdmin.Components.Stat` (default + hero + hero-compact + square) | `statistics.html` | ✅ | 2026-05-30 | `12b9d23` | Re-audited for v2.6.0 + v2.7.0. **v2.6.0 `pa-stat--square` redesign**: `__number` + `__symbol` siblings, baseline-aligned, `cqi` (container-query) font scaling. New `is_prefix_symbol` boolean flips DOM order to `<symbol><number>` for prefix currencies (`$847K`, `¥12.4M`); default false renders `<number><symbol>` for suffix units (`87%`, `23°C`). **v2.7.0 hero deltas**: `change_direction` extended to 5-step sentiment scale (`very_positive` / `positive` / `neutral` / `negative` / `very_negative`); neutral colour shifted from `--pa-text-color-2` to `--pa-neutral`. Stat icon `:danger` becomes valid as upstream `_statistics.scss` ships the modifier. **Re-audit 2026-08-23 (`fe0cfdc`): fixed a class bug** — the `"hero-compact"` variant emitted `pa-stat--hero pa-stat--hero--compact`, where `--hero--compact` is an invalid double-dash class matching nothing (so compact tiles silently fell back to plain `--hero`). Core's canonical modifier is the single-dash standalone `pa-stat--hero-compact`; now emitted correctly. No test had covered it. Previously ✅ at `5de0ce8` 2026-04-25. |
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
| `PureAdmin.Components.Flash` | Phoenix flash-message wrapper; no framework equivalent — it piggy-backs on `.pa-alert`, which is covered by `alerts.html`. **Re-audited 2026-08-23 (`fe0cfdc`): ✅ on-contract.** `flash/1` renders a canonical `pa-alert` (`--{variant}`/`--dismissible`, `__icon`/`__content`/`__heading`/`__close` + `pa-icon--x`), and the `PureAdminFlash` JS hook (`flash.js`) injects the same canonical alert markup (incl. `__actions`/`__list`). `flash_container/1`'s `pa-flash-container` is keen-namespaced infra (empty hook-target div; the hook targets `data-container-id`, not the class) — not core drift, since flash has no core contract. |

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

---

## Sidebar coverage — remaining non-component pages (2026-08-23, `fe0cfdc`)

Closing the sidebar sweep. These pages don't map to a core component snippet:

- **Icons (`icon`/`faicon`/`heroicon`, `/phoenix/icons`) — N/A (no drift).** These
  are icon-provider adapters, not pure-admin markup: `faicon` → `<i class="fa-{variant} fa-{name}">`,
  `heroicon` → inline `<svg>`, `icon` dispatches (`hero-*` → heroicon, else FA `<i>`).
  The only core icon *contract* is the masked `pa-icon`/`pa-icon--x` primitive, already
  used correctly in every close/remove affordance (verified). Nothing to diff.
- **Virtual scroll (`/virtual-scroll/demo`) — feature gap, no drift.** Core ships a
  CSS-only `pa-virtual-table` (windowed table). keen does NOT componentise it and uses
  **infinite scroll** instead (`phx-hook="PureAdminInfiniteScroll"` + `data-*` on a regular
  table) — a different, LiveView-idiomatic pattern with ZERO `pa-*` structural classes, so
  no invented-class risk. Gap: apps wanting the `pa-virtual-table` CSS render it by hand.
- **Phoenix CoreComponents (`/phoenix/core-components`) — nothing new.** Re-showcases
  already-audited components (card / callout / badge / …).
- **Sizing demos (`/components/sizing`, `/tables/sizing`) — FIXED.** The width table listed
  `wr-12/14/16/24/32/48`, which are **off** core's actual `wr-*` scale (1-10, then 15/20/25/…/50
  in 5-rem steps) — those rows showcased non-existent utilities. Replaced with real scale
  values (`wr-15/20/25/30/35/40/45/50`). All 23 sizing-demo utilities now verified present
  in core CSS.

**Sidebar sweep is now complete** — every component page has had at least a class-sweep;
the 8 highest-traffic (forms, modal, tooltip, popconfirm, tabs, lists, buttons, +cards) also
got the full structural live-DOM diff.

---

## Data-viz, Settings, Flash + KPI suite (2026-08-24, `fe0cfdc`)

### DataViz (`data_viz.ex`) — FIXED
Core styles semantic variants only; **`primary` is the default fill** (base
`.pa-progress__fill { background: var(--pa-accent) }`) with no `--primary` rule.
keen offered `variant="primary"` on `progress` / `progress_ring` / `gauge` /
`sparkline` / `stacked_segment` / `data_bar`, emitting a **dead `--primary`
class** each time. Fixed: suppress the modifier when `variant == "primary"`
(kept in `values:` as the documented default alias — same precedent as tooltip
`--top` / modal `size="md"`). Also:
- **heatmap** offered `warning`/`info` variants that core never styles
  (core heatmap = `success` + `danger` cell ramps + `--compact` only) → dropped
  `warning`/`info` from `values:`, exposed the real `is_compact` → `pa-heatmap--compact`.
- **data_bar** now exposes core's real `pa-data-bar--negative` (was missing).
Regression test: `test/keen_pure_admin/components/data_viz_test.exs` (7 tests).

### Settings panel (`settings_panel.ex`) — CLEAN
Every emitted class (`pa-settings-panel__toggle/content/title/section/label/
select/checkbox-group/checkbox/hint`, `pa-btn--block`) exists in core. No drift.

### Flash (`flash.ex`) — FIXED (minor)
`flash/1` uses core `pa-alert` + `pa-icon--x` (audited, correct). Dropped the
off-contract **`pa-flash-container`** class from `flash_container/1` — it has
zero core CSS and zero JS references (the hook uses `data-container-id` +
`phx-hook`), a `pa-`-prefixed marker implying a core contract that doesn't exist
(same pattern as the popconfirm-wrapper drop). The div + its functional attrs
stay; only the phantom class is gone.

### KPI suite — 8/9 CLEAN, 1 FIXED
Parallel structural audit of all 9 keen KPI files vs their `_kpi-*.scss`
counterparts + built CSS (every interpolated modifier resolved against
`values:` lists / Elixir maps):
- **CLEAN:** `kpi.ex`, `kpi_detail.ex`, `kpi_bento.ex`, `kpi_terminal.ex`,
  `kpi_editorial.ex`, `kpi_gauge_list.ex`, `kpi_hero.ex`, `kpi_sparkline_list.ex`.
  Every emitted class maps to a real core rule; modifiers gated on non-nil so no
  dead-default leaks; sparkline correctly uses TWO ramps (row `--up-strong…` vs
  delta `--very-positive…`).
- **`kpi_strip.ex` — FIXED (real bug).** `head_cell_classes/1` dasherized the
  full column atom → emitted `pa-kpi-strip__head--previous-value/-delta-percent/
  -target-bar` + nonexistent `--metric`/`--now`. Core blesses only the SHORT
  forms `--prev`/`--delta`/`--target` (which the `--no-prev`/`--no-delta`/
  `--no-target` hide rules target) + `--num`. Five invented no-op classes that
  also silently broke the header-hide rules. Fixed via a `@head_modifiers`
  atom→short-name map; `metric`/`now` head cells now carry no modifier (matches
  core). Regression test: `test/keen_pure_admin/components/kpi_strip_test.exs`.

Low-priority MISSING-FEATURE notes (not drift): bento/hero `__chart-svg` inner
wrapper is the slot author's responsibility (keen emits only `__chart`);
editorial footer `<strong>` emphasis not surfaced. Full keen suite green
(164 tests + 16 doctests).
