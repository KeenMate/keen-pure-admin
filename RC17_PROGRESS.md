# rc17 wrapper rollout — progress / handoff (2026-08-28)

Status of porting **@keenmate/pure-admin-core v2.9.0-rc17** into the two wrappers.
Core rc17 is **published** to npm (tag `rc`) and tagged `v2.9.0-rc17` in the
pure-admin repo. rc17 headline: the new **Container Breakpoint engine**
(`container-breakpoint.js`) + fit-engine additions (`data-pa-fit-auto`,
`data-pa-fit-ignore`, `config.fit.defaultPriority`, container-generic) + the
**`navbar-fit.js` → `fit.js`** rename.

---

## ✅ Svelte (`../svelte-pure-admin`) — DONE, committed, pushed

Commit `b70cda8` on `prod` (pushed). Lib bumped to **1.9.0-rc04**, core dep → `^2.9.0-rc17`.

- **`ContainerBreakpoint.svelte`** (`packages/svelte-pure-admin/src/lib/layout/`) —
  reactive wrapper over the engine. Props: `steps` (Record<string,number>), `unit`
  ('rem'|'px'), `hysteresis`, `initial`, `hiddenClass`, `tag`, `class`, `onchange`.
  Exposes `{ mode }` via a snippet param → `{#if mode === '…'}` mounts only the
  shown branch. Uses `attribute:false` (Svelte owns `data-mode`), engine still
  toggles `.d-none` on `data-pa-show` children.
- **`FitContainer.svelte`** — arms `data-pa-fit-auto` + boots the container-generic
  fit engine; `defaultPriority` prop; children opt out with `data-pa-fit-ignore`.
- **`internal/core-js.ts`** — added `'container-breakpoint'` loader case.
- **`global.d.ts`** — added `pureAdmin.components.containerBreakpoint` + `.fit`
  types and `config.fit` / `config.containerBreakpoint`.
- **`index.ts`** — exported both components.
- **`FitSlot.svelte` / `FitStep.svelte`** — doc comments updated navbar-fit.js → fit.js.
- **Docs**: new `/container-breakpoint` route (`docs/src/routes/container-breakpoint/`:
  `+page.svelte`, `+page.ts`, `MountLog.svelte`) + sidebar entry "Responsive Fit"
  in `docs/src/routes/+layout.svelte`. `docs/package.json` dep → rc17.
- **CHANGELOG.md** (repo root) — `## [1.9.0-rc04]` section.

**Verified**: `svelte-check` 0 errors (2 benign `state_referenced_locally` warnings,
same class SidebarItem already ships). Playwright on the docs dev server confirmed
mount-on-demand: `wide → ▶ mounted: Revenue chart`, `narrow → ✕ destroyed`, re-widen
→ re-mounted. Multi-level card: `grid`/`tabs`/`icons` `[data-mode]` all correct.

> ⚠️ **"fix svelte first"** — user wants to revisit something on the Svelte side
> before finishing keen (likely something they saw testing the docs on mobile).
> Resume by asking what needs fixing / re-run the docs dev server
> (`cd docs && npm run dev`, it picks a free port ~5176) and Playwright the
> `/container-breakpoint` page.

---

## ⚠️ keen (`.` — Elixir/Phoenix LiveView) — IMPLEMENTED + VERIFIED, **NOT committed**

Everything works, but **do not `git add -A`**: the keen tree is mid **rc14 navbar
restructure** (uncommitted WIP). My rc17 edits are interleaved with that WIP in
shared files, and the whole navbar/core-hooks set is **untracked** (`git ls-files`
= 0 for `navbar_fit_core.js`, `navbar_fit.js`, `pure_admin_core.js`,
`navbar_collapse_core.js`, …). Staging shared files would sweep the unfinished
navbar/search rework into an rc17 commit.

### My rc17 files (keen)

**New (mine):**
- `lib/assets/js/hooks/container_breakpoint_core.js` — vendored verbatim from core
  `container-breakpoint.js` (rc17).
- `lib/assets/js/hooks/container_breakpoint.js` — the `PureAdminContainerBreakpoint`
  LiveView hook. Declarative (`data-pa-breakpoints`); pushes `pa:breakpoint` to the
  server only when `data-pa-breakpoint-event="…"` is set (else pure client-side).
- `demo/lib/demo_web/live/container_breakpoint_live.ex` — demo page.

**Edited (⚠️ entangled or on untracked WIP files):**
- `lib/assets/js/hooks/navbar_fit_core.js` — re-vendored ← core `fit.js` rc17
  (brings auto/ignore/default-priority/container-generic + `fit` name/`navFit`
  alias). *(was the stale rc12 copy; untracked)*
- `lib/assets/js/hooks/navbar_fit.js` — doc comment rc12 → rc17. *(untracked)*
- `lib/assets/js/hooks/pure_admin_core.js` — **additive** insert of `cfg.fit` +
  `cfg.containerBreakpoint` config defaults (before `})(pa.config);`). *(untracked)*
- `lib/assets/js/keen_pure_admin.js` — import + register `PureAdminContainerBreakpoint`
  (in `PureAdminHooks` obj + re-export). *(tracked, but +30 lines = ~27 are your WIP)*
- `demo/lib/demo_web/router.ex` — `+ live("/components/container-breakpoint", …)`.
  **CLEAN — only my line; isolatable.**
- `demo/lib/demo_web/components/layouts/app.html.heex` — one `<.sidebar_item …>` line
  at the very bottom. **Rest of the diff is your rc14 navbar WIP.**
- `CHANGELOG.md` — 3 bullets under `## [Unreleased]` `### Added` (Container
  Breakpoint hook, fit re-port, sync-extended-to-rc17). *(file also has your WIP)*
- `package.json` — dep `^2.9.0-rc16` → `^2.9.0-rc17`.

### Verification (keen)
- `mix compile` clean (LiveView + `<.heading>`/`<.paragraph>`/`<.callout>` OK).
- esbuild bundle of `keen_pure_admin.js` clean (~210kb); engine + hook present.
- **Live** on `mix phx.server` (`127.0.0.1:18700`), Playwright `/components/container-breakpoint`:
  `set=460→comfy`, `set=760→wide` (pkg+supplier shown), `set=300→compact` (both
  hidden); `data-mode` + `.d-none` correct; `pureAdmin.components.containerBreakpoint.observe`
  present; no console errors.

### To land keen (pick one)
1. **(recommended)** You fold my rc17 files into your in-flight keen navbar commit —
   same uncommitted surface.
2. I `git add` only the isolatable files (`router.ex` + the 3 new
   `container_breakpoint*` files) — but that commit is non-functional alone (hook
   unregistered without `keen_pure_admin.js`).
3. I `git add -p` the specific mine-only hunks across shared files → one coherent
   rc17 commit without your WIP (riskier).

---

## ADDENDUM — fit ↔ navbar-collapse consolidation (Option A), keen part

Core merged `navbar-collapse.js` into the one Fit engine (`fit.js`, attribute
`data-pa-fit-nav`); the old file is deleted upstream. keen was flipped to match —
**implemented + verified, NOT committed** (same entangled tree).

keen changes (mine, this pass):
- **Re-vendored** `lib/assets/js/hooks/navbar_fit_core.js` ← core `fit.js` (now
  carries the nav engine: `initNav` / `initAllNav` / `relayoutAllNav`, sinks
  `nav-sidebar` / `nav-menu`).
- **New** `lib/assets/js/hooks/navbar_fit_collapse.js` — `PureAdminNavFitCollapse`
  hook, `mounted()`→`fit.initNav(this.el)`.
- **Deleted** `lib/assets/js/hooks/navbar_collapse.js` + `navbar_collapse_core.js`
  (were untracked).
- `lib/assets/js/keen_pure_admin.js` — import + register
  `PureAdminNavFitCollapse` (was `PureAdminNavCollapse`).
- `lib/keen_pure_admin/components/layout.ex` — `nav_menu` emits `data-pa-fit-nav*`
  + `phx-hook="PureAdminNavFitCollapse"`; `nav_item` emits
  `data-pa-fit-nav-priority` / `data-pa-fit-nav` (icon attr unchanged); docs updated.
- `lib/assets/js/hooks/navbar_fit.js` — doc comment refreshed.

Verified: `mix compile` clean; `esbuild --bundle keen_pure_admin.js` clean
(NavFitCollapse + initNav present, zero navbar_collapse refs). NOT runtime-tested
on :18700 this pass. Fold these into the same keen WIP commit as the rest.

---

## Resume checklist
- [x] Svelte side fixed (mobile drawer bugs A/B committed) + nav-collapse flipped to fit (committed).
- [ ] Decide keen landing strategy (above) and commit/push keen — now also includes the nav-collapse consolidation files listed in the addendum.
- [ ] Publish core >rc17 (adds `fit.initNav`) + bump the svelte docs / keen dep, so the wrappers' nav-collapse resolves at runtime from npm.
- [ ] Optional: README "What's New" for svelte lib if publishing rc04.
- [ ] Kill any stray dev servers (docs vite, phoenix 18700) — vite stopped; demo :3000 (pure-admin) left running.
