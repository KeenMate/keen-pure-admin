/**
 * PureAdminNavFit hook — Phoenix LiveView wrapper around the upstream pure-admin
 * core navbar-fit engine (`navbar_fit_core.js` — the container-generic fit engine, ported verbatim from
 * `@keenmate/pure-admin-core@^2.9.0-rc17`).
 *
 * navbar-fit is priority-driven header degradation: when the header row can't
 * fit all its content, slots carrying `data-pc-fit` (hide | steps | sidebar)
 * degrade one at a time, LOWEST `data-pc-fit-priority` first, until the row
 * fits; when space returns everything restores (reset-then-degrade, so no
 * hysteresis). It also owns nav-item collapse (the former navbar-collapse.js):
 * it pre-folds every fit-managed nav (`relayoutAllNav()`) before it measures.
 *
 * The core IIFE exposes `window.pureAdmin.components.navFit = { init, initAll,
 * relayoutAll }` and auto-runs `initAll()` at DOMContentLoaded. `init(container)`
 * is idempotent (via the `__paFitInit` flag) and a no-op when the container
 * holds no `[data-pc-fit]` slot, so it's safe to call unconditionally.
 *
 * The hook attaches to the fit CONTAINER — `.pc-navbar__inner` (set by
 * `PureAdmin.Components.Layout.navbar/1`) — and passes `this.el` straight to
 * `init()`. No `destroyed()` teardown: the navbar lives in the app shell layout
 * and mounts once per session (LiveView navigation keeps it), and the engine's
 * only side effect is a ResizeObserver GC'd with the container — so there's no
 * per-page leak to clean up, unlike the reparenting navbar-collapse.
 */
import "./navbar_fit_core"

const navFit = () =>
  window.pureAdmin && window.pureAdmin.components && window.pureAdmin.components.navFit

function initNavFit(el) {
  const f = navFit()
  if (f && typeof f.init === "function") f.init(el)
}

export const PureAdminNavFit = {
  mounted() {
    initNavFit(this.el)
  },

  updated() {
    // Idempotent via `__paFitInit`; re-inits only if LiveView replaced the node.
    initNavFit(this.el)
  }
}
