/**
 * PureAdminNavDropdown hook — Phoenix LiveView wrapper around the upstream
 * pure-admin-core touch support for navbar dropdowns (`navbar_dropdown_core.js`,
 * ported verbatim from `@keenmate/pure-admin-core@^2.9.0-rc11`).
 *
 * The core IIFE exposes `window.pureAdmin.components.navDropdown = { closeAll, init }`, attaches
 * its own document-level `click` / `keydown` delegation listeners, and auto-runs
 * `init()` at DOMContentLoaded. On `(hover: none)` devices it implements
 * first-tap-opens / second-tap-navigates for `.pc-navmenu__item--has-dropdown`
 * parents (hover-capable input keeps native CSS hover + navigation).
 *
 * Because the behaviour is delegated at the document level, simply importing the
 * core module is enough to make touch dropdowns work app-wide — a per-element
 * hook is OPTIONAL. This hook exists only to re-seed the `aria-haspopup` /
 * `aria-expanded` attributes on parents inside a nav rendered/patched after the
 * initial DOMContentLoaded fire (`init(this.el)` is scoped to the element). No
 * `destroyed()` is needed: the listeners are global and shared, not per-element.
 *
 * Attach to the same `.pc-navmenu` element as the nav markup, or omit it
 * entirely and rely on the auto-init + delegation.
 */
import "./navbar_dropdown_core"

const navDropdown = () =>
  window.pureAdmin && window.pureAdmin.components && window.pureAdmin.components.navDropdown

export const PureAdminNavDropdown = {
  mounted() {
    const d = navDropdown()
    if (d && typeof d.init === "function") d.init(this.el)
  },

  updated() {
    const d = navDropdown()
    if (d && typeof d.init === "function") d.init(this.el)
  }
}
