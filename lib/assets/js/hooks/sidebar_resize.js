/**
 * PureAdminSidebarResize hook - Drag to resize sidebar.
 */
export const PureAdminSidebarResize = {
  mounted() {
    const sidebar = this.el
    if (!sidebar.classList.contains("pa-layout__sidebar--resizable")) return

    let startX, startWidth

    const onMouseMove = (e) => {
      const diff = e.clientX - startX
      const newWidth = Math.min(Math.max(startWidth + diff, 180), 500)
      sidebar.style.width = `${newWidth}px`
    }

    const onMouseUp = () => {
      document.removeEventListener("mousemove", onMouseMove)
      document.removeEventListener("mouseup", onMouseUp)
      localStorage.setItem("pa-sidebar-width", sidebar.style.width)
    }

    sidebar.addEventListener("mousedown", (e) => {
      if (e.offsetX > sidebar.offsetWidth - 8) {
        startX = e.clientX
        startWidth = sidebar.offsetWidth
        document.addEventListener("mousemove", onMouseMove)
        document.addEventListener("mouseup", onMouseUp)
      }
    })

    // Restore saved width
    const savedWidth = localStorage.getItem("pa-sidebar-width")
    if (savedWidth) {
      sidebar.style.width = savedWidth
    }
  },
}
