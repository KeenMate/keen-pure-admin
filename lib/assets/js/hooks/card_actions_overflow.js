/**
 * PureAdminCardActionsOverflow hook — progressive collapse of
 * `<.card>` action buttons into a "..." menu when the row runs out
 * of space.
 *
 * Mark the actions wrapper with `pa-card__actions--overflow` and
 * `phx-hook="PureAdminCardActionsOverflow"`. The hook measures the
 * wrapper on mount and on every ResizeObserver tick, moving items
 * one at a time into a body-portal menu (reuses `pa-btn-split__menu`)
 * until `scrollWidth <= clientWidth`.
 *
 * Per-button knobs:
 *   data-pa-actions-priority="N"          higher stays longer (default 0)
 *
 * Wrapper knobs:
 *   data-pa-actions-overflow-from="end"   (default) rightmost drops first
 *   data-pa-actions-overflow-from="start"           leftmost drops first
 *
 * The from-attr can be flipped at runtime — a MutationObserver picks
 * it up and re-runs the drop walk.
 *
 * Ported from `pure-admin-core/src/js/card-actions-overflow.js`
 * (2.9.0-rc02) into LiveView hook lifecycle.
 */
export const PureAdminCardActionsOverflow = {
  mounted() {
    const root = this.el
    if (!root.classList.contains("pa-card__actions--overflow")) return

    const items = Array.from(root.children).filter((el) => el.nodeType === 1)
    if (items.length === 0) return

    const ordered = items.map((el, idx) => {
      const p = parseInt(el.getAttribute("data-pa-actions-priority"), 10)
      return { el, priority: isNaN(p) ? 0 : p, domIndex: idx }
    })

    let dropOrder = []
    const buildDropOrder = () => {
      const dropFromStart = root.getAttribute("data-pa-actions-overflow-from") === "start"
      dropOrder = ordered.slice().sort((a, b) => {
        if (a.priority !== b.priority) return a.priority - b.priority
        return dropFromStart ? a.domIndex - b.domIndex : b.domIndex - a.domIndex
      })
    }
    buildDropOrder()

    // Trigger button — the "..." affordance, appended to the wrapper.
    const trigger = document.createElement("button")
    trigger.type = "button"
    trigger.className = "pa-btn pa-btn--xs pa-btn--ghost pa-card__actions-overflow-trigger"
    trigger.setAttribute("aria-label", "More actions")
    trigger.setAttribute("aria-haspopup", "menu")
    trigger.setAttribute("aria-expanded", "false")
    trigger.innerHTML = '<i class="fa-solid fa-ellipsis-vertical" aria-hidden="true"></i>'
    trigger.style.display = "none"
    root.appendChild(trigger)

    // Menu lives on <body> so card `overflow: hidden` can't clip it.
    // Reuses pa-btn-split__menu — same styling as the split-button menu.
    const menu = document.createElement("div")
    menu.className = "pa-btn-split__menu"
    menu.setAttribute("role", "menu")
    document.body.appendChild(menu)
    const menuInner = document.createElement("div")
    menuInner.className = "pa-btn-split__menu-inner"
    menu.appendChild(menuInner)

    const moveToMenu = (el) => {
      if (el.__paOverflowOrigClass == null) el.__paOverflowOrigClass = el.className
      el.className = "pa-btn-split__item"
      menuInner.appendChild(el)
    }

    const moveToRoot = (el) => {
      if (el.__paOverflowOrigClass != null) el.className = el.__paOverflowOrigClass
      root.insertBefore(el, trigger)
    }

    const relayout = () => {
      // Step 1 — restore every item into the wrapper in DOM order.
      ordered.slice().sort((a, b) => a.domIndex - b.domIndex).forEach((item) => {
        moveToRoot(item.el)
      })
      trigger.style.display = "none"

      // Step 2 — if everything fits, we're done.
      if (root.scrollWidth <= root.clientWidth) {
        if (menu.classList.contains("pa-btn-split__menu--open")) closeMenu()
        return
      }

      // Step 3 — walk drop order, push items into the menu until it fits.
      trigger.style.display = ""
      for (let i = 0; i < dropOrder.length; i++) {
        if (root.scrollWidth <= root.clientWidth) break
        moveToMenu(dropOrder[i].el)
      }
    }

    // ── Menu open/close + positioning ──────────────────────────────────────
    let stopAutoUpdate = null
    const FUI = window.FloatingUIDOM || null

    const positionFallback = () => {
      const rect = trigger.getBoundingClientRect()
      menu.style.position = "fixed"
      menu.style.top = `${rect.bottom + 4}px`
      menu.style.right = `${window.innerWidth - rect.right}px`
      menu.style.left = "auto"
    }

    const openMenu = () => {
      if (menuInner.children.length === 0) return
      menu.classList.add("pa-btn-split__menu--open")
      trigger.setAttribute("aria-expanded", "true")

      if (FUI && FUI.computePosition && FUI.autoUpdate) {
        stopAutoUpdate = FUI.autoUpdate(trigger, menu, () => {
          if (trigger.offsetParent === null) return closeMenu()
          const rect = trigger.getBoundingClientRect()
          if (rect.width === 0 && rect.height === 0) return closeMenu()
          FUI.computePosition(trigger, menu, {
            placement: "bottom-end",
            strategy: "fixed",
            middleware: [FUI.offset(4), FUI.flip(), FUI.shift({ padding: 8 })]
          }).then((pos) => {
            Object.assign(menu.style, {
              position: "fixed",
              left: `${pos.x}px`,
              top: `${pos.y}px`,
              right: "auto"
            })
          })
        })
      } else {
        positionFallback()
        window.addEventListener("scroll", positionFallback, true)
        window.addEventListener("resize", positionFallback)
      }

      setTimeout(() => document.addEventListener("mousedown", onDocClick), 0)
    }

    const closeMenu = () => {
      menu.classList.remove("pa-btn-split__menu--open")
      trigger.setAttribute("aria-expanded", "false")
      if (stopAutoUpdate) {
        stopAutoUpdate()
        stopAutoUpdate = null
      }
      window.removeEventListener("scroll", positionFallback, true)
      window.removeEventListener("resize", positionFallback)
      document.removeEventListener("mousedown", onDocClick)
    }

    const onDocClick = (e) => {
      if (menu.contains(e.target) || trigger.contains(e.target)) return
      closeMenu()
    }

    const onTriggerClick = (e) => {
      e.stopPropagation()
      if (menu.classList.contains("pa-btn-split__menu--open")) closeMenu()
      else openMenu()
    }
    trigger.addEventListener("click", onTriggerClick)

    const onMenuClick = (e) => {
      if (!e.target.closest(".pa-btn-split__item")) return
      setTimeout(closeMenu, 0)
    }
    menu.addEventListener("click", onMenuClick)

    // First paint — wait for layout, then relayout.
    requestAnimationFrame(relayout)

    let ro = null
    if (typeof ResizeObserver !== "undefined") {
      ro = new ResizeObserver(() => {
        if (menu.classList.contains("pa-btn-split__menu--open")) closeMenu()
        relayout()
      })
      ro.observe(root)
      // Also watch the parent: when items are in the menu the wrapper sizes
      // to its (smaller) content and won't fire on parent grows.
      if (root.parentNode) ro.observe(root.parentNode)
    }

    let mo = null
    if (typeof MutationObserver !== "undefined") {
      mo = new MutationObserver(() => {
        buildDropOrder()
        relayout()
      })
      mo.observe(root, { attributes: true, attributeFilter: ["data-pa-actions-overflow-from"] })
    }

    // Stash for destroyed() teardown.
    this._paOverflow = {
      trigger,
      menu,
      menuInner,
      ordered,
      ro,
      mo,
      closeMenu,
      onTriggerClick,
      onMenuClick
    }
  },

  destroyed() {
    const state = this._paOverflow
    if (!state) return

    state.closeMenu()
    if (state.ro) state.ro.disconnect()
    if (state.mo) state.mo.disconnect()
    state.trigger.removeEventListener("click", state.onTriggerClick)
    state.menu.removeEventListener("click", state.onMenuClick)

    // Pull items out of the menu so they don't leak when the menu node
    // is removed from <body>.
    state.ordered.forEach(({ el }) => {
      if (el.__paOverflowOrigClass != null) {
        el.className = el.__paOverflowOrigClass
        delete el.__paOverflowOrigClass
      }
    })

    if (state.menu.parentNode) state.menu.parentNode.removeChild(state.menu)
    if (state.trigger.parentNode) state.trigger.parentNode.removeChild(state.trigger)
  }
}
