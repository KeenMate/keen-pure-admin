/**
 * PureAdminKpiTerminalTabs - Click-driven tab strip for the KPI Terminal grid.
 *
 * Mirrors `initTerminalTabs()` from `@keenmate/pure-admin-core` 2.7.1's
 * `demo/js/kpi-showcases.js`. Mounted on the `.pa-kpi-terminal` card.
 * Toggles `.is-active` on the clicked `.pa-kpi-terminal__tab` and its
 * matching `.pa-kpi-terminal__pane[data-tab="…"]`, scoped to this terminal
 * only (nested terminals stay isolated).
 *
 * Each terminal owns its own active tab; consumers can either let this
 * hook drive state purely client-side, or omit the hook and manage active
 * pane via LiveView assigns + `phx-click` on the tab buttons.
 */

export const PureAdminKpiTerminalTabs = {
  mounted() {
    this._wire()
  },

  updated() {
    this._wire()
  },

  _wire() {
    const tabs = this._scoped(".pa-kpi-terminal__tab")
    const panes = this._scoped(".pa-kpi-terminal__pane")
    if (!tabs.length) return

    if (!this._handler) {
      this._handler = (event) => {
        const tab = event.target.closest(".pa-kpi-terminal__tab")
        if (!tab) return
        if (tab.closest(".pa-kpi-terminal") !== this.el) return

        const slug = tab.dataset.tab
        for (const t of tabs) {
          const active = t === tab
          t.classList.toggle("is-active", active)
          t.setAttribute("aria-selected", active ? "true" : "false")
        }
        for (const p of panes) {
          p.classList.toggle("is-active", p.dataset.tab === slug)
        }
      }
      this.el.addEventListener("click", this._handler)
    }
  },

  destroyed() {
    if (this._handler) this.el.removeEventListener("click", this._handler)
  },

  /* Collect descendants matching selector, excluding any inside a nested
     .pa-kpi-terminal (so nested terminals don't cross-fire). */
  _scoped(selector) {
    return Array.from(this.el.querySelectorAll(selector)).filter(
      (el) => el.closest(".pa-kpi-terminal") === this.el
    )
  },
}
