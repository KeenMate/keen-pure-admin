/**
 * PureAdminPopover hook - Popover show/hide on click.
 */
export const PureAdminPopover = {
  mounted() {
    const popover = this.el.querySelector(".pa-popover")
    if (!popover) return

    this.el.addEventListener("click", (e) => {
      e.stopPropagation()
      popover.classList.toggle("pa-popover--show")
    })

    document.addEventListener("click", () => {
      popover.classList.remove("pa-popover--show")
    })
  },
}
