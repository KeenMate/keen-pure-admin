/**
 * PureAdminSidebarResize hook - Drag to resize sidebar.
 *
 * Saves the width to localStorage so it survives reloads. Restored widths
 * are parsed as an integer and clamped to [MIN, MAX] — a poisoned
 * localStorage entry (e.g. a long string, a CSS expression, a negative
 * number) can't slip through and produce a broken layout.
 */
const MIN_WIDTH = 180
const MAX_WIDTH = 500

export const PureAdminSidebarResize = {
  mounted() {
    const sidebar = this.el
    if (!sidebar.classList.contains("pa-layout__sidebar--resizable")) return

    let startX, startWidth

    const onMouseMove = (e) => {
      const diff = e.clientX - startX
      const newWidth = Math.min(Math.max(startWidth + diff, MIN_WIDTH), MAX_WIDTH)
      sidebar.style.width = `${newWidth}px`
    }

    const onMouseUp = () => {
      document.removeEventListener("mousemove", onMouseMove)
      document.removeEventListener("mouseup", onMouseUp)
      // Persist the width as a plain integer — no units or extra tokens.
      const parsed = parseInt(sidebar.style.width, 10)
      if (Number.isFinite(parsed)) {
        localStorage.setItem("pa-sidebar-width", String(parsed))
      }
    }

    sidebar.addEventListener("mousedown", (e) => {
      if (e.offsetX > sidebar.offsetWidth - 8) {
        startX = e.clientX
        startWidth = sidebar.offsetWidth
        document.addEventListener("mousemove", onMouseMove)
        document.addEventListener("mouseup", onMouseUp)
      }
    })

    // Restore saved width — integer-parse and clamp.
    const saved = parseInt(localStorage.getItem("pa-sidebar-width"), 10)
    if (Number.isFinite(saved)) {
      const clamped = Math.min(Math.max(saved, MIN_WIDTH), MAX_WIDTH)
      sidebar.style.width = `${clamped}px`
    }
  },
}
