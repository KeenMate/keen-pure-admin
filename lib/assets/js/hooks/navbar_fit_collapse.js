/**
 * PureAdminNavFitCollapse hook — Phoenix LiveView wrapper for the nav-collapse
 * path of the upstream pure-admin core Fit engine (`navbar_fit_core.js` — the one
 * degradation engine, ported verbatim from `@keenmate/pure-admin-core`; it
 * absorbed the former navbar-collapse.js).
 *
 * A `.pc-navmenu[data-pc-fit-nav]` is a fit container whose ITEMS degrade: as the
 * header narrows the lowest-priority `<li>`s (by `data-pc-fit-nav-priority`) fold
 * into a sink — `data-pc-fit-nav="sidebar"` rebuilds them as native
 * `.pc-sidebar__*` items under a section heading; `data-pc-fit-nav="menu"` folds
 * them into a generated "More ▾" dropdown — restoring as space returns.
 *
 * The core IIFE exposes `window.pureAdmin.components.fit.initNav(nav)` and
 * auto-runs `initAllNav()` at DOMContentLoaded. `initNav(nav)` is idempotent (via
 * the `__paFitNavInit` flag). Because LiveView mounts nodes after
 * DOMContentLoaded, the hook calls `initNav(this.el)` in `mounted()`. The hook
 * attaches to the `.pc-navmenu` element (set by
 * `PureAdmin.Components.Layout.nav_menu/1`).
 */
import "./navbar_fit_core"

const fit = () =>
  window.pureAdmin && window.pureAdmin.components && window.pureAdmin.components.fit

function initFitNav(el) {
  const f = fit()
  if (f && typeof f.initNav === "function") f.initNav(el)
}

export const PureAdminNavFitCollapse = {
  mounted() {
    initFitNav(this.el)
  },

  updated() {
    // Idempotent via `__paFitNavInit`; re-inits only if LiveView replaced the node.
    initFitNav(this.el)
  }
}
