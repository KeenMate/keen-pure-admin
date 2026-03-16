/**
 * KPureAdmin - Phoenix LiveView hooks for Pure Admin components.
 *
 * Usage in app.js:
 *
 *   import { PureAdminHooks } from "../deps/keen_pure_admin/assets/js/keen_pure_admin"
 *   let liveSocket = new LiveSocket("/live", Socket, { hooks: { ...PureAdminHooks } })
 */

import { PureAdminTooltip } from "./hooks/tooltip"
import { PureAdminPopover } from "./hooks/popover"
import { PureAdminToast } from "./hooks/toast"
import { PureAdminCommandPalette } from "./hooks/command_palette"
import { PureAdminDetailPanel } from "./hooks/detail_panel"
import { PureAdminSidebarResize } from "./hooks/sidebar_resize"
import { PureAdminSettings } from "./hooks/settings_panel"
import { PureAdminProfilePanel } from "./hooks/profile_panel"
import { PureAdminCharCounter } from "./hooks/char_counter"
import { PureAdminCheckbox } from "./hooks/checkbox"
import { initModalDialogs } from "./modal_dialogs"

export const PureAdminHooks = {
  PureAdminTooltip,
  PureAdminPopover,
  PureAdminToast,
  PureAdminCommandPalette,
  PureAdminDetailPanel,
  PureAdminSidebarResize,
  PureAdminSettings,
  PureAdminProfilePanel,
  PureAdminCharCounter,
  PureAdminCheckbox,
}

export {
  PureAdminTooltip,
  PureAdminPopover,
  PureAdminToast,
  PureAdminCommandPalette,
  PureAdminDetailPanel,
  PureAdminSidebarResize,
  PureAdminSettings,
  PureAdminProfilePanel,
  PureAdminCharCounter,
  PureAdminCheckbox,
  initModalDialogs,
}
