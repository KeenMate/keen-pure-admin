/**
 * PureAdminDetailPanel hook - Resizable divider via mouse drag.
 */
export const PureAdminDetailPanel = {
  mounted() {
    const handle = this.el.querySelector(".pa-detail-panel__handle")
    if (!handle) return

    let startX, startWidth

    const onMouseMove = (e) => {
      const diff = e.clientX - startX
      this.el.style.width = `${startWidth + diff}px`
    }

    const onMouseUp = () => {
      document.removeEventListener("mousemove", onMouseMove)
      document.removeEventListener("mouseup", onMouseUp)
    }

    handle.addEventListener("mousedown", (e) => {
      startX = e.clientX
      startWidth = this.el.offsetWidth
      document.addEventListener("mousemove", onMouseMove)
      document.addEventListener("mouseup", onMouseUp)
    })
  },
}
