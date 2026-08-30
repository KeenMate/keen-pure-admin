/**
 * PureAdminContainerBreakpoint hook — Phoenix LiveView wrapper around the upstream
 * pure-admin core Container Breakpoint engine (`container_breakpoint_core.js`,
 * ported verbatim from `@keenmate/pure-admin-core@^2.9.0-rc17`).
 *
 * The engine is the JS counterpart to a CSS `@container` query: it watches the
 * element's content-box inline size and maps it to a NAMED mode from declared
 * width thresholds, reflecting the mode into `[data-mode]` (so CSS can key off
 * it) and toggling the shared `.d-none` on `[data-pc-show]` descendants — and it
 * fires a `pc:breakpoint` CustomEvent only when the mode flips.
 *
 * Wire it declaratively on the fit container:
 *
 *   <div id="product-card"
 *        phx-hook="PureAdminContainerBreakpoint"
 *        data-pc-breakpoints='{"icons":0,"tabs":34,"grid":64}'
 *        data-pc-breakpoint-initial="tabs">
 *     <div data-pc-show="grid">…rich…</div>       <!-- .d-none unless mode = grid -->
 *     <div data-pc-show="tabs icons">…compact…</div>
 *   </div>
 *
 * Server-side conditional rendering (mount-on-demand): add
 * `data-pc-breakpoint-event="mode_changed"` and the hook pushes that event to the
 * LiveView on every flip — so `handle_event("mode_changed", %{"mode" => m}, ...)`
 * can assign the mode and render only the branch for it (never building the
 * off-screen one). Without the attribute the hook stays purely client-side
 * (CSS `[data-mode]` + `.d-none`), pushing nothing.
 *
 * The core IIFE exposes `window.pureAdmin.components.containerBreakpoint =
 * { observe, init, initAll, relayoutAll }` and auto-runs `initAll()` at
 * DOMContentLoaded; `init(el)` reads `data-pc-breakpoints` off the element and is
 * idempotent (guarded by `el.__paCbHandle`). Because LiveView mounts nodes after
 * DOMContentLoaded, the hook calls `init(this.el)` in `mounted()`.
 */
import "./container_breakpoint_core"

const cb = () =>
  window.pureAdmin && window.pureAdmin.components && window.pureAdmin.components.containerBreakpoint

function initCb(el) {
  const api = cb()
  if (api && typeof api.init === "function") api.init(el)
}

export const PureAdminContainerBreakpoint = {
  mounted() {
    initCb(this.el)
    // Forward mode flips to the server only when opted in, so pure client-side
    // (CSS/data-mode) usage doesn't emit unhandled LiveView events.
    this._pushName = this.el.getAttribute("data-pc-breakpoint-event")
    if (this._pushName) {
      this._onBp = (e) => this.pushEvent(this._pushName, { mode: e.detail.mode, prev: e.detail.prev })
      this.el.addEventListener("pc:breakpoint", this._onBp)
    }
  },

  updated() {
    // Idempotent via `__paCbHandle`; re-reads thresholds only if LiveView
    // replaced the node.
    initCb(this.el)
  },

  destroyed() {
    if (this._onBp) this.el.removeEventListener("pc:breakpoint", this._onBp)
    const handle = this.el.__paCbHandle
    if (handle && typeof handle.destroy === "function") handle.destroy()
  }
}
