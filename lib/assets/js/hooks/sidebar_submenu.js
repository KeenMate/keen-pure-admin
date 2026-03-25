/**
 * PureAdminSidebarSubmenu hook - Persists submenu open/closed state in localStorage.
 *
 * The server renders `is_open` based on the current URL (active section always open).
 * This hook layers user-toggled state on top via localStorage, restoring manual
 * open/close choices across navigations.
 *
 * Logic: if the submenu contains the active page, it's always open (URL wins).
 * Otherwise, localStorage state is applied.
 *
 * FOAC prevention: The `fouc_prevention_script` injects a <style id="pa-submenu-preload">
 * tag before the sidebar HTML is parsed, replicating --open CSS for stored submenus.
 * This hook removes that style once real classes are in place.
 */

const STORAGE_KEY = "pa-sidebar-submenus"

function getStoredState() {
  try {
    return JSON.parse(localStorage.getItem(STORAGE_KEY)) || {}
  } catch {
    return {}
  }
}

function setStoredState(state) {
  localStorage.setItem(STORAGE_KEY, JSON.stringify(state))
}

export const PureAdminSidebarSubmenu = {
  mounted() {
    const li = this.el
    const submenuId = li.querySelector(".pa-sidebar__submenu")?.id
    if (!submenuId) return

    const hasActivePage = li.dataset.hasActivePage === "true"

    // Restore localStorage state only if this submenu doesn't contain the active page
    if (!hasActivePage) {
      const stored = getStoredState()
      if (submenuId in stored) {
        const isOpen = stored[submenuId]
        li.classList.toggle("pa-sidebar__item--open", isOpen)
        const submenu = li.querySelector(".pa-sidebar__submenu")
        if (submenu) {
          submenu.classList.toggle("pa-sidebar__submenu--open", isOpen)
        }
      }
    }

    // Remove the preload style now that real classes are applied
    const preload = document.getElementById("pa-submenu-preload")
    if (preload) preload.remove()

    // Watch for class changes on the <li> to detect when JS command toggles --open
    const observer = new MutationObserver(() => {
      const isOpen = li.classList.contains("pa-sidebar__item--open")
      const stored = getStoredState()
      if (stored[submenuId] !== isOpen) {
        stored[submenuId] = isOpen
        setStoredState(stored)
      }
    })

    observer.observe(li, { attributes: true, attributeFilter: ["class"] })
    this._observer = observer
  },

  destroyed() {
    if (this._observer) {
      this._observer.disconnect()
    }
  },
}
