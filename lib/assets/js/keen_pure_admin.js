/**
 * PureAdmin - Phoenix LiveView hooks for Pure Admin components.
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
import { PureAdminSplitButton } from "./hooks/split_button"
import { PureAdminSidebarSubmenu } from "./hooks/sidebar_submenu"
import { PureAdminFlash } from "./hooks/flash"
import { PureAdminInfiniteScroll } from "./hooks/infinite_scroll"
import { initModalDialogs } from "./modal_dialogs"

// Global event listeners for component JS commands
window.addEventListener("kpa:clipboard-copy", (e) => {
  if (!e.detail || !e.detail.text) return
  navigator.clipboard.writeText(e.detail.text)

  // Visual feedback: swap clipboard icon to checkmark
  const btn = e.target.closest(".pa-comparison-table__copy")
  if (!btn) return
  const icon = btn.querySelector("i")
  if (!icon) return
  icon.classList.remove("fa-clipboard")
  icon.classList.add("fa-check")
  setTimeout(() => {
    icon.classList.remove("fa-check")
    icon.classList.add("fa-clipboard")
  }, 1000)
})

export const PureAdminHooks = {
  PureAdminFlash,
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
  PureAdminSplitButton,
  PureAdminSidebarSubmenu,
  PureAdminInfiniteScroll,
}

export {
  PureAdminFlash,
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
  PureAdminSplitButton,
  PureAdminSidebarSubmenu,
  PureAdminInfiniteScroll,
  initModalDialogs,
}
