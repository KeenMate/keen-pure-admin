/**
 * PureAdminToast hook - Auto-dismiss toasts with progress bar.
 */
export const PureAdminToast = {
  mounted() {
    const duration = parseInt(this.el.dataset.duration || "5000", 10)
    if (duration > 0) {
      this.timeout = setTimeout(() => {
        this.el.classList.add("pa-toast--dismissing")
        setTimeout(() => {
          this.pushEvent("dismiss-toast", { id: this.el.id })
        }, 300)
      }, duration)
    }
  },

  destroyed() {
    if (this.timeout) clearTimeout(this.timeout)
  },
}
