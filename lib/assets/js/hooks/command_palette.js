/**
 * PureAdminCommandPalette hook - Ctrl+K shortcut and keyboard navigation.
 */
export const PureAdminCommandPalette = {
  mounted() {
    this.handleKeydown = (e) => {
      if ((e.ctrlKey || e.metaKey) && e.key === "k") {
        e.preventDefault()
        this.pushEvent("toggle-command-palette", {})
      }
    }
    document.addEventListener("keydown", this.handleKeydown)
  },

  destroyed() {
    document.removeEventListener("keydown", this.handleKeydown)
  },
}
