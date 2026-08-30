/**
 * PureAdminStatFit hook — Phoenix LiveView wrapper around the upstream
 * pure-admin-core stat-fit behaviour (`pa_stat_fit_core.js`, ported verbatim
 * from `@keenmate/pure-admin-core@^2.9.0`).
 *
 * The core IIFE exposes `window.pureAdmin.components.statFit = { init, refresh }` and auto-runs
 * `init()` at DOMContentLoaded. `init(root)` is idempotent (a `__paStatFit`
 * flag on the tile), so this hook's `mounted()` call covers the cases the
 * auto-init misses:
 *
 *   1. Fit tiles rendered after the initial page paint via a LiveView patch —
 *      the DOMContentLoaded fire already happened.
 *   2. Fit tiles whose number / symbol text changes at runtime and need a
 *      re-fit (the JS reads text once when it computes the font-size, so a
 *      new value needs `refresh` to recompute).
 *
 * The hook is placed on the individual `.pa-stat--square[data-pa-stat-fit]`
 * tile (`this.el` is the tile), so `init(this.el)` scopes the query to that
 * element and `refresh(this.el)` re-fits just this tile on update.
 *
 * Cleanup is best-effort. The upstream init doesn't expose a teardown hook
 * (its ResizeObserver lives as long as the DOM subtree). When LiveView removes
 * the tile, the browser GCs the observer attached to it.
 *
 * Usage:
 *
 *     <.stat variant="square" color="info" is_fit
 *       number="847K" symbol_text="$" is_prefix_symbol
 *       label_text="Monthly Revenue"
 *       change_text="▲ 12.5% vs last month" change_direction="positive"
 *       context_text="Updated 2 min ago"
 *       style="height: 16rem;" />
 */
import "./pa_stat_fit_core"

const statFit = () =>
  window.pureAdmin && window.pureAdmin.components && window.pureAdmin.components.statFit

export const PureAdminStatFit = {
  mounted() {
    const s = statFit()
    if (s && typeof s.init === "function") s.init(this.el)
  },

  updated() {
    // LiveView patched the tile. `init` is a no-op if it's already wrapped
    // (idempotent via `__paStatFit`), but the number / symbol text may have
    // changed, so re-fit this tile to recompute the font-size.
    const s = statFit()
    if (s && typeof s.init === "function") s.init(this.el)
    if (s && typeof s.refresh === "function") s.refresh(this.el)
  }
}
