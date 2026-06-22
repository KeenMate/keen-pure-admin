/**
 * PureAdminSplitter hook — Phoenix LiveView wrapper around the upstream
 * pure-admin-core splitter (`splitter_core.js`, ported verbatim from
 * `@keenmate/pure-admin-core@^2.9.0`).
 *
 * The core IIFE exposes `window.PaSplitter = { init, initAll }` and
 * auto-runs `initAll()` at DOMContentLoaded. Both init paths are
 * idempotent (`__paSplitterInit` flag on the element), so this hook's
 * `mounted()` call covers two cases the auto-init misses:
 *
 *   1. Splitters rendered after the initial page paint via a LiveView
 *      patch — the DOMContentLoaded fire already happened.
 *   2. Splitters whose attributes / pane count change at runtime and
 *      need a re-init (the upstream JS reads everything once at init,
 *      so the markup that gets initialized is the markup at that
 *      moment).
 *
 * Cleanup is best-effort. The upstream init doesn't expose a teardown
 * hook (its ResizeObserver / event listeners live as long as the DOM
 * subtree). When LiveView removes the splitter element, the browser GCs
 * the observers attached to it. Persistence has already flushed to
 * localStorage on every drag-end, so nothing's lost.
 *
 * Usage:
 *
 *     <.splitter id="demo" orientation="horizontal" style="height: 400px;">
 *       <:pane size="280px" min="200px" max="60%" is_minimizable>
 *         <!-- left content -->
 *       </:pane>
 *       <:pane>
 *         <!-- right content (fills remainder) -->
 *       </:pane>
 *     </.splitter>
 */
import "./splitter_core"

export const PureAdminSplitter = {
  mounted() {
    if (window.PaSplitter && typeof window.PaSplitter.init === "function") {
      window.PaSplitter.init(this.el)
    }
  },

  updated() {
    // LiveView patched the element — re-run init in case panes were
    // added / removed. Idempotent via `__paSplitterInit`, so this is a
    // no-op for unchanged markup; on a pane-count change the element
    // would arrive with a fresh DOM and the flag would be missing.
    if (window.PaSplitter && typeof window.PaSplitter.init === "function") {
      window.PaSplitter.init(this.el)
    }
  }
}
