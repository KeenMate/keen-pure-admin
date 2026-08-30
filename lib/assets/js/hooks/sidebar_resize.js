/**
 * PureAdminSidebarResize — thin standalone wrapper around the vendored
 * `sidebar_resize_core.js` (`pureAdmin.components.sidebarResize`, ported verbatim
 * from `@keenmate/pure-admin-core@^2.9.0-rc11`).
 *
 * In the common case you do NOT need this hook: `PureAdminSidebar` already calls
 * `sidebarResize.init()` on mount/update (a LiveView element takes only one
 * phx-hook and the sidebar uses that one), and the core module also auto-inits
 * at DOMContentLoaded. This wrapper exists only as an escape hatch for attaching
 * resize on its own element.
 *
 * The core module activates on `.pc-layout__sidebar--resizable` and creates its
 * own `.pc-sidebar-resize` handle — do not server-render the handle. `init()`
 * takes no argument (it queries the resizable sidebar itself) and is idempotent.
 */
import "./sidebar_resize_core"

export const PureAdminSidebarResize = {
  mounted() {
    const r = window.pureAdmin && window.pureAdmin.components && window.pureAdmin.components.sidebarResize
    if (r && typeof r.init === "function") r.init()
  },

  updated() {
    const r = window.pureAdmin && window.pureAdmin.components && window.pureAdmin.components.sidebarResize
    if (r && typeof r.init === "function") r.init()
  }
}
