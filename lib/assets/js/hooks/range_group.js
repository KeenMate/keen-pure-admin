/**
 * PureAdminRangeGroup hook — Phoenix LiveView wrapper around the upstream
 * pure-admin-core range group (`range_group_core.js`, ported verbatim from
 * `@keenmate/pure-admin-core@^2.9.0`).
 *
 * The core IIFE exposes `window.PaRangeGroup = { init }` and auto-runs
 * `init()` (over the whole document) at DOMContentLoaded. `init(scope?)`
 * finds every `[data-range-group]` *inside* `scope` and builds it; building
 * is idempotent per root (guarded by `root._rangeGroup`). Because
 * `querySelectorAll` does not match the scope element itself, and this hook
 * is mounted ON the `.pa-range-group` root, we scope the init call to the
 * element's parent so the root is discovered.
 *
 * `mounted()` / `updated()` cover the two cases the DOMContentLoaded
 * auto-init misses:
 *
 *   1. Range groups rendered after the initial page paint via a LiveView
 *      patch — the DOMContentLoaded fire already happened.
 *   2. Groups whose rows change at runtime and need a re-init.
 *
 * The interactive DOM (thumbs, tick marks, floating panel) is entirely
 * JS-managed and the panel reparents to <body> while open, so the root
 * carries `phx-update="ignore"` (see `range_group.ex`) — LiveView must not
 * try to reconcile the JS-built subtree. `updated()` still fires for
 * attribute-only patches on the root and re-inits idempotently.
 *
 * Usage:
 *
 *     <.range_group id="people-filters">
 *       <:range key="age" label="Age" min={18} max={80}
 *               value_min={25} value_max={60} />
 *       <:range key="salary" label="Salary" min={0} max={200_000} step={5000}
 *               value_min={40_000} value_max={200_000} prefix="$" is_thousands />
 *       <:range key="children" label="Children" min={0} max={8}
 *               mode="single" bound="gte" value={2} />
 *     </.range_group>
 */
import "./range_group_core"

function initGroup(el) {
  if (window.PaRangeGroup && typeof window.PaRangeGroup.init === "function") {
    // Scope to the parent so the [data-range-group] root itself is matched.
    window.PaRangeGroup.init(el.parentNode || el)
  }
}

export const PureAdminRangeGroup = {
  mounted() {
    initGroup(this.el)
  },

  updated() {
    // Idempotent via the `root._rangeGroup` guard — a no-op for an
    // already-built root; on a fresh root (patched-in markup) it builds.
    initGroup(this.el)
  }
}
