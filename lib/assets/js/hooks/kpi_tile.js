/**
 * PureAdminKpiTile - Cursor-anchored hover detail popover for KPI tiles.
 *
 * Mounted on any `pa-kpi-*` host element (tile, row, gauge, etc.) that
 * contains a `.pa-kpi-detail` child. On mount, moves the detail element to
 * <body> so ancestor overflow:hidden / transform / clip-path can't clip it.
 * On mouseenter/mousemove updates the popover position via Floating UI
 * anchored to a virtual reference element at the cursor coordinates.
 *
 * Floating UI must be loaded globally as `window.FloatingUIDOM`.
 *
 * Why a virtual reference element instead of anchoring to the tile? In
 * vertical-stack layouts (a 25% column with 3 tiles), every tile's
 * "above-it" geometry sits in an identical-looking gap above the next
 * tile, which reads as "popover is always at the same spot." Anchoring to
 * the cursor keeps the popover visually tied to where the user is
 * pointing.
 *
 * Other details:
 * - `position: fixed` + `strategy: 'fixed'` because cursor coords are
 *   viewport-relative (clientX/clientY).
 * - `pointer-events: none` (set in CSS on `.pa-kpi-detail`) so the cursor
 *   passes through and tile mouseleave fires reliably.
 * - `flip()` + `shift({ padding: 8 })` middleware keeps the popover
 *   on-screen near edges.
 */

const OFFSET = 14

export const PureAdminKpiTile = {
  mounted() {
    this.detail = this.el.querySelector(':scope > .pa-kpi-detail')
      || this.el.querySelector('.pa-kpi-detail')
    if (!this.detail) return
    if (!window.FloatingUIDOM) return

    // Move detail to <body> so it escapes ancestor overflow/clip contexts.
    // Track the original parent so destroyed() can put it back (defensive —
    // LiveView patches that replace the parent would otherwise lose track).
    this.originalParent = this.detail.parentNode
    document.body.appendChild(this.detail)

    this.cursorX = 0
    this.cursorY = 0

    const virtualEl = {
      getBoundingClientRect: () => ({
        width: 0,
        height: 0,
        x: this.cursorX,
        y: this.cursorY,
        top: this.cursorY,
        left: this.cursorX,
        right: this.cursorX,
        bottom: this.cursorY,
      }),
    }

    const { computePosition, flip, shift, offset } = window.FloatingUIDOM

    this.reposition = () => {
      computePosition(virtualEl, this.detail, {
        strategy: 'fixed',
        placement: 'top-start',
        middleware: [offset(OFFSET), flip(), shift({ padding: 8 })],
      }).then(({ x, y }) => {
        this.detail.style.left = `${x}px`
        this.detail.style.top = `${y}px`
      })
    }

    this._enter = (e) => {
      this.cursorX = e.clientX
      this.cursorY = e.clientY
      this.detail.setAttribute('data-show', '')
      this.reposition()
    }
    this._move = (e) => {
      this.cursorX = e.clientX
      this.cursorY = e.clientY
      this.reposition()
    }
    this._leave = () => {
      this.detail.removeAttribute('data-show')
    }

    this.el.addEventListener('mouseenter', this._enter)
    this.el.addEventListener('mousemove', this._move)
    this.el.addEventListener('mouseleave', this._leave)
  },

  destroyed() {
    if (!this.detail) return
    if (this._enter) this.el.removeEventListener('mouseenter', this._enter)
    if (this._move) this.el.removeEventListener('mousemove', this._move)
    if (this._leave) this.el.removeEventListener('mouseleave', this._leave)

    // Pull the detail element back out of <body>; if its original parent has
    // been removed from the DOM (full LiveView re-render), just drop it.
    if (this.detail.parentNode === document.body) {
      if (this.originalParent && this.originalParent.isConnected) {
        this.originalParent.appendChild(this.detail)
      } else {
        this.detail.remove()
      }
    }
  },
}
