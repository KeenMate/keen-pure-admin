/**
 * PureAdminTooltip hook - Tooltip positioning.
 *
 * Usage:
 *   <span id="tip-1" phx-hook="PureAdminTooltip" data-position="top">
 *     Hover me
 *     <span class="pa-tooltip" style="display:none">Tooltip content</span>
 *   </span>
 */
export const PureAdminTooltip = {
  mounted() {
    const tooltip = this.el.querySelector(".pa-tooltip")
    if (!tooltip) return

    this.el.addEventListener("mouseenter", () => {
      tooltip.style.display = ""
    })

    this.el.addEventListener("mouseleave", () => {
      tooltip.style.display = "none"
    })
  },
}
