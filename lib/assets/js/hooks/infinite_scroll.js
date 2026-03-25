/**
 * PureAdminInfiniteScroll hook — triggers a LiveView event when
 * a sentinel element scrolls into view.
 *
 * Data attributes:
 *   data-event="load_more"    — event name to push (default: "load_more")
 *   data-has-more="true"      — set to "false" to stop observing
 *   data-root-margin="200px"  — preload buffer distance (default: "200px")
 *   data-throttle="500"       — minimum ms between triggers (default: "500")
 */
export const PureAdminInfiniteScroll = {
  mounted() {
    this._lastTrigger = 0
    this._pending = false
    this._setupObserver()
  },

  updated() {
    // After DOM patch, check if has-more changed
    if (this.el.dataset.hasMore === "false") {
      this._disconnect()
    } else if (!this._observer) {
      this._setupObserver()
    }
    this._pending = false
  },

  destroyed() {
    this._disconnect()
  },

  _setupObserver() {
    const rootMargin = this.el.dataset.rootMargin || "200px"

    this._observer = new IntersectionObserver(
      ([entry]) => {
        if (entry.isIntersecting) {
          this._maybeTrigger()
        }
      },
      { rootMargin }
    )
    this._observer.observe(this.el)
  },

  _maybeTrigger() {
    if (this.el.dataset.hasMore === "false") return
    if (this._pending) return

    const throttle = parseInt(this.el.dataset.throttle || "500", 10)
    const now = Date.now()

    if (now - this._lastTrigger < throttle) return

    this._lastTrigger = now
    this._pending = true

    const event = this.el.dataset.event || "load_more"
    this.pushEvent(event, {})
  },

  _disconnect() {
    if (this._observer) {
      this._observer.disconnect()
      this._observer = null
    }
  },
}
