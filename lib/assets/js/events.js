/**
 * PureAdmin delegated events.
 *
 * Single document-level click listener per behavior, dispatched via `data-pa-*`
 * attributes emitted by the components. No inline `onclick=` handlers; all
 * behavior is registered in this module so apps can ship with strict CSP
 * (`script-src 'self'`) — no `'unsafe-inline'` needed for component behavior.
 *
 * Call `initPureAdminEvents()` once from your `app.js`:
 *
 *     import { initPureAdminEvents } from "../deps/keen_pure_admin/assets/js/keen_pure_admin"
 *     initPureAdminEvents()
 *
 * Idempotent — safe to call multiple times.
 */

import { initPopconfirmEvents } from "./events/popconfirm"
import { initPopoverEvents } from "./events/popover"
import { initBadgeGroupEvents } from "./events/badge_group"
import { initTabsScrollEvents } from "./events/tabs_scroll"
import { initCopyValueEvents } from "./events/copy_value"

let initialized = false

/**
 * Wires all delegated listeners once. Subsequent calls are no-ops.
 */
export function initPureAdminEvents() {
  if (initialized) return
  initialized = true

  initPopconfirmEvents()
  initPopoverEvents()
  initBadgeGroupEvents()
  initTabsScrollEvents()
  initCopyValueEvents()
}
