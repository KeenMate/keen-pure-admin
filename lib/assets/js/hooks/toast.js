/**
 * PureAdminToast - Toast notification system.
 *
 * Attach to a toast container element. The server triggers toasts via push_event,
 * and the client handles rendering, auto-dismiss, and close button — no server
 * round-trips for display/dismiss.
 *
 * Server usage (in LiveView):
 *
 *   # Show a toast
 *   push_event(socket, "toast", %{
 *     variant: "success",
 *     title: "Saved!",
 *     message: "Your changes have been saved.",
 *     duration: 5000,       # 0 = persistent (manual dismiss)
 *     position: "top-end"   # optional, defaults to container's position
 *   })
 *
 * Template:
 *
 *   <.toast_container id="toasts" position="top-end" phx-hook="PureAdminToast" />
 *
 * Multiple containers can exist for different positions. Each container only
 * shows toasts matching its position (from data-position attr).
 */
export const PureAdminToast = {
  mounted() {
    this._toastId = 0
    this._position = this.el.dataset.position || 'top-end'

    this.handleEvent("toast", (toast) => {
      const position = toast.position || 'top-end'
      if (position !== this._position) return

      this._showToast(toast)
    })

    // Also support adding toasts from other hooks/JS via custom event
    this.el.addEventListener("pa:toast", (e) => {
      this._showToast(e.detail)
    })
  },

  _showToast(toast) {
    const id = `pa-toast-${this._position}-${this._toastId++}`
    const variant = toast.variant || 'info'
    const title = toast.title || ''
    const message = toast.message || ''
    const duration = toast.duration !== undefined ? toast.duration : 5000

    const el = document.createElement('div')
    el.id = id
    el.className = `pa-toast pa-toast--${variant} pa-toast--show`
    el.innerHTML = `
      <div class="pa-toast__content">
        ${title ? `<div class="pa-toast__title">${this._escapeHtml(title)}</div>` : ''}
        ${message ? `<div class="pa-toast__message">${this._escapeHtml(message)}</div>` : ''}
      </div>
      <button class="pa-toast__close" aria-label="Close">
        <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M18 6 6 18"/><path d="m6 6 12 12"/></svg>
      </button>
    `

    // Close button
    el.querySelector('.pa-toast__close').addEventListener('click', () => {
      this._dismissToast(el)
    })

    this.el.appendChild(el)

    // Auto-dismiss
    if (duration > 0) {
      setTimeout(() => this._dismissToast(el), duration)
    }
  },

  _dismissToast(el) {
    if (!el || !el.parentNode) return
    el.classList.remove('pa-toast--show')
    el.classList.add('pa-toast--dismissing')
    setTimeout(() => {
      if (el.parentNode) el.parentNode.removeChild(el)
    }, 300)
  },

  _escapeHtml(text) {
    const div = document.createElement('div')
    div.textContent = text
    return div.innerHTML
  }
}
