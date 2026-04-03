/**
 * PureAdminSidebar — Sidebar toggle with mobile/desktop awareness.
 *
 * Handles:
 * - Desktop: toggles sidebar-hidden on body (full hide or icon-collapse)
 * - Mobile (<=768px): toggles sidebar-visible on body (overlay modal)
 * - Burger button active state synced with sidebar visibility
 * - Window resize: resets mobile/desktop state at 768px breakpoint
 * - localStorage persistence for desktop state
 *
 * Attach to the sidebar element:
 *   <.sidebar id="sidebar" />
 *
 * The burger button calls: phx-click={toggle_sidebar()}
 * which dispatches "pa:toggle_sidebar" to this hook's element.
 */
import { createLogger } from "../logger"

const log = createLogger('SIDEBAR')
const MOBILE_BREAKPOINT = 768

export const PureAdminSidebar = {
  mounted() {
    this._body = document.body
    this._burger = document.querySelector('.burger-menu')

    // Listen for toggle events from the burger button (via JS.dispatch)
    this.el.addEventListener("pa:toggle_sidebar", () => {
      this._toggle()
    })

    // Window resize: reset state at breakpoint
    this._lastMobile = this._isMobile()
    this._resizeHandler = () => this._onResize()
    window.addEventListener('resize', this._resizeHandler)

    // Set initial state
    this._syncInitialState()

    log.debug('mounted, mobile:', this._isMobile())
  },

  destroyed() {
    window.removeEventListener('resize', this._resizeHandler)
  },

  _isMobile() {
    return window.innerWidth <= MOBILE_BREAKPOINT
  },

  _toggle() {
    const isMobile = this._isMobile()
    const behavior = localStorage.getItem('sidebar-behavior') || 'hide'

    if (isMobile) {
      // Mobile: toggle sidebar-visible (overlay)
      this._body.classList.toggle('sidebar-visible')
      if (this._burger) this._burger.classList.toggle('active')
      log.debug('mobile toggle, visible:', this._body.classList.contains('sidebar-visible'))
    } else {
      // Desktop: toggle sidebar-hidden
      const isHidden = this._body.classList.contains('sidebar-hidden')

      if (isHidden) {
        this._body.classList.remove('sidebar-hidden')
        if (this._burger) this._burger.classList.add('active')
      } else {
        this._body.classList.add('sidebar-hidden')
        if (this._burger) this._burger.classList.remove('active')
      }

      localStorage.setItem('sidebar-hidden', this._body.classList.contains('sidebar-hidden').toString())
      log.debug('desktop toggle, hidden:', this._body.classList.contains('sidebar-hidden'), 'behavior:', behavior)
    }
  },

  _onResize() {
    const isMobile = this._isMobile()

    // Only act on breakpoint crossings
    if (isMobile === this._lastMobile) return
    this._lastMobile = isMobile

    if (isMobile) {
      // Entering mobile: remove desktop state, reset burger
      this._body.classList.remove('sidebar-hidden')
      this._body.classList.remove('sidebar-visible')
      if (this._burger) this._burger.classList.remove('active')
    } else {
      // Entering desktop: remove mobile state, restore from localStorage
      this._body.classList.remove('sidebar-visible')
      const sidebarHidden = localStorage.getItem('sidebar-hidden') === 'true'

      if (sidebarHidden) {
        this._body.classList.add('sidebar-hidden')
        if (this._burger) this._burger.classList.remove('active')
      } else {
        this._body.classList.remove('sidebar-hidden')
        if (this._burger) this._burger.classList.add('active')
      }
    }
  },

  _syncInitialState() {
    const isMobile = this._isMobile()

    if (isMobile) {
      // Mobile: sidebar hidden by default, burger shows hamburger
      this._body.classList.remove('sidebar-hidden')
      this._body.classList.remove('sidebar-visible')
      if (this._burger) this._burger.classList.remove('active')
    }
    // Desktop state is already handled by FOUC prevention script
  }
}
