/**
 * PureAdminSplitButton hook - Split button dropdown via Floating UI.
 * Menu is moved to document.body to avoid overflow clipping.
 */
export const PureAdminSplitButton = {
  mounted() {
    const toggle = this.el.querySelector(".pa-btn-split__toggle")
    const menu = this.el.querySelector(".pa-btn-split__menu")
    if (!toggle || !menu) return

    this._toggle = toggle
    this._menu = menu
    this._cleanup = null
    this.el._splitButtonHook = this

    toggle.addEventListener("click", (e) => {
      e.stopPropagation()
      this._isOpen() ? this._close() : this._open()
    })

    // Close on click outside
    this._outsideClick = (e) => {
      if (this._isOpen() && !this.el.contains(e.target) && !menu.contains(e.target)) {
        this._close()
      }
    }
    document.addEventListener("click", this._outsideClick)

    // Close on Escape
    this._escHandler = (e) => {
      if (e.key === "Escape" && this._isOpen()) this._close()
    }
    document.addEventListener("keydown", this._escHandler)

    // Forward menu item clicks as LiveView events via hook
    // (menu is moved to document.body, so native phx-click won't work)
    menu.addEventListener("click", (e) => {
      // Check for inline action button click first (e.g. delete button beside item)
      const actionBtn = e.target.closest("[phx-click]")
      if (actionBtn && !actionBtn.classList.contains("pa-btn-split__item")) {
        const event = actionBtn.getAttribute("phx-click")
        const action = actionBtn.getAttribute("phx-value-action")
        if (event) {
          this.pushEvent(event, action ? { action } : {})
        }
        return
      }

      const item = e.target.closest(".pa-btn-split__item")
      if (!item) return

      const event = item.getAttribute("data-phx-click")
      const value = item.getAttribute("data-phx-value-action")
      if (event) {
        this.pushEvent(event, value ? { action: value } : {})
      }

      // Opt-out: an item (or an ancestor) marked [data-pa-keep-open] keeps the
      // menu open on click — e.g. it opens a popconfirm / sub-panel anchored to
      // the item that must stay visible. Mirrors upstream split-button.js.
      if (e.target.closest("[data-pa-keep-open]")) return
      this._close()
    })
  },

  destroyed() {
    if (this._outsideClick) document.removeEventListener("click", this._outsideClick)
    if (this._escHandler) document.removeEventListener("keydown", this._escHandler)
    this._close()
  },

  _isOpen() {
    return this.el.classList.contains("pa-btn-split--open")
  },

  _open() {
    // Close any other open split buttons first
    document.querySelectorAll(".pa-btn-split--open").forEach((el) => {
      if (el !== this.el && el._splitButtonHook) {
        el._splitButtonHook._close()
      }
    })

    const menu = this._menu
    const placement = this.el.dataset.placement || "bottom-end"

    this.el.classList.add("pa-btn-split--open")

    // Move to body to escape overflow containers
    menu._originalParent = this.el
    document.body.appendChild(menu)
    menu.classList.add("pa-btn-split__menu--open")

    if (window.FloatingUIDOM) {
      const FUI = window.FloatingUIDOM
      this._cleanup = FUI.autoUpdate(this.el, menu, () => {
        FUI.computePosition(this.el, menu, {
          placement,
          strategy: "fixed",
          middleware: [FUI.offset(4), FUI.flip(), FUI.shift({ padding: 8 })]
        }).then(({ x, y }) => {
          Object.assign(menu.style, {
            position: "fixed",
            left: `${x}px`,
            top: `${y}px`,
            minWidth: `${this.el.offsetWidth}px`
          })
        })
      })
    }
  },

  _close() {
    const menu = this._menu
    if (!menu) return

    if (this._cleanup) {
      this._cleanup()
      this._cleanup = null
    }

    this.el.classList.remove("pa-btn-split--open")
    menu.classList.remove("pa-btn-split__menu--open")

    // Move back to original parent
    if (menu._originalParent) {
      menu._originalParent.appendChild(menu)
      delete menu._originalParent
    }

    menu.style.position = ""
    menu.style.left = ""
    menu.style.top = ""
    menu.style.minWidth = ""
  }
}
