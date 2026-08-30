/**
 * PureAdminOverflow hook — Phoenix LiveView wrapper around the upstream
 * pure-admin-core progressive-collapse toolbar (`overflow_core.js`, ported
 * verbatim from `@keenmate/pure-admin-core@^2.9.0-rc06`).
 *
 * The core IIFE exposes `window.pureAdmin.components.overflow = { init, initAll, destroy }` and auto-runs
 * `initAll()` at DOMContentLoaded. `init(el)` is idempotent (via the
 * `__paOverflowInit` flag on the element), so this hook's `mounted()` covers
 * the two cases the DOMContentLoaded auto-init misses:
 *
 *   1. Overflow toolbars rendered after the initial page paint via a LiveView
 *      patch — the DOMContentLoaded fire already happened.
 *   2. Toolbars whose button set changes at runtime and need re-init (the
 *      upstream JS snapshots the child candidates once at init time; see the
 *      `updated()` caveat below).
 *
 * This hook is attached DIRECTLY to the `.pa-overflow` wrapper, so we pass
 * `this.el` straight to `init()` (unlike the card-actions / split flavours,
 * `initAll(this.el)` would NOT match because querySelectorAll doesn't return
 * the scope root itself).
 *
 * A `.pa-btn-split` child inside the toolbar must ALSO carry
 * `phx-hook="PureAdminSplitButton"` for its dropdown to open once collapsed —
 * this hook only reparents overflowing children into the `[⋮]` "more" menu as
 * the bar shrinks; it does not wire the split button's own toggle.
 *
 * `destroyed()` calls the keen-added `pureAdmin.components.overflow.destroy(this.el)` so
 * the ResizeObserver / MutationObserver are disconnected and the body-portal
 * "more" menu (which lives on `<body>`, NOT inside this.el, so it would
 * otherwise leak) is removed when LiveView drops the toolbar.
 *
 * Usage (see `KPureAdmin.Components.Button.overflow/1`):
 *
 *     <.overflow overflow_from="end">
 *       <.button variant="secondary">Save</.button>
 *       <.button variant="success" data-pa-actions-priority="10">Publish</.button>
 *       <.split_button label="Run" ...>
 *         <:item>Run with options…</:item>
 *       </.split_button>
 *     </.overflow>
 */
import "./overflow_core"

const overflow = () =>
  window.pureAdmin && window.pureAdmin.components && window.pureAdmin.components.overflow

function initOverflow(el) {
  const o = overflow()
  if (!o) return
  if (typeof o.init === "function") o.init(el)
  else if (typeof o.initAll === "function") o.initAll(el)
}

export const PureAdminOverflow = {
  mounted() {
    initOverflow(this.el)
  },

  updated() {
    // Idempotent via `__paOverflowInit`, so this is a no-op for unchanged
    // markup. On a fresh subtree (LiveView replaced the node) the flag is
    // missing and the toolbar re-initializes with the new candidate snapshot.
    initOverflow(this.el)
  },

  destroyed() {
    const o = overflow()
    if (o && typeof o.destroy === "function") o.destroy(this.el)
  }
}
