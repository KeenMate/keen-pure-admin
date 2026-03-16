/**
 * PureAdminTooltip - Creates floating tooltips on document.body.
 *
 * Tooltips are created outside the component tree so they aren't
 * clipped by overflow:hidden on parent containers.
 *
 * Usage: Add `phx-hook="PureAdminTooltip"` to elements with
 * `data-tooltip` and optional `data-tooltip-position` (top|right|bottom|left).
 *
 * Also initializes tooltips for all [data-tooltip] elements on the page
 * (even without phx-hook) via a global delegated listener.
 */

const OFFSET = 8

function createFloatingTooltip(trigger, text, position) {
  const el = document.createElement('div')
  el.className = 'pa-tooltip-floating'
  el.textContent = text
  el.style.position = 'absolute'
  el.style.zIndex = '9000'
  el.style.visibility = 'hidden'
  el.style.pointerEvents = 'none'
  document.body.appendChild(el)

  // Position relative to trigger
  const rect = trigger.getBoundingClientRect()
  const tipRect = el.getBoundingClientRect()
  const scrollX = window.scrollX
  const scrollY = window.scrollY

  let top, left

  switch (position) {
    case 'bottom':
      top = rect.bottom + OFFSET + scrollY
      left = rect.left + (rect.width - tipRect.width) / 2 + scrollX
      break
    case 'left':
      top = rect.top + (rect.height - tipRect.height) / 2 + scrollY
      left = rect.left - tipRect.width - OFFSET + scrollX
      break
    case 'right':
      top = rect.top + (rect.height - tipRect.height) / 2 + scrollY
      left = rect.right + OFFSET + scrollX
      break
    default: // top
      top = rect.top - tipRect.height - OFFSET + scrollY
      left = rect.left + (rect.width - tipRect.width) / 2 + scrollX
      break
  }

  // Keep within viewport
  const maxLeft = window.innerWidth + scrollX - tipRect.width - 5
  left = Math.max(scrollX + 5, Math.min(left, maxLeft))

  el.style.top = top + 'px'
  el.style.left = left + 'px'
  el.style.visibility = 'visible'

  return el
}

function removeFloatingTooltip(el) {
  if (el && el.parentNode) {
    el.parentNode.removeChild(el)
  }
}

// Hook for LiveView elements
export const PureAdminTooltip = {
  mounted() {
    this._setupTooltip()
  },

  updated() {
    this._setupTooltip()
  },

  _setupTooltip() {
    const text = this.el.dataset.tooltip
    if (!text) return

    const position = this.el.dataset.tooltipPosition || this.el.dataset.position || 'top'

    // Remove old listeners
    if (this._enter) this.el.removeEventListener('mouseenter', this._enter)
    if (this._leave) this.el.removeEventListener('mouseleave', this._leave)

    let floatingEl = null

    this._enter = () => {
      floatingEl = createFloatingTooltip(this.el, text, position)
    }
    this._leave = () => {
      removeFloatingTooltip(floatingEl)
      floatingEl = null
    }

    this.el.addEventListener('mouseenter', this._enter)
    this.el.addEventListener('mouseleave', this._leave)
  },

  destroyed() {
    if (this._enter) this.el.removeEventListener('mouseenter', this._enter)
    if (this._leave) this.el.removeEventListener('mouseleave', this._leave)
  }
}

// Global delegated listener for all [data-tooltip] elements (no hook needed)
if (typeof document !== 'undefined') {
  let activeTooltip = null
  let activeTrigger = null

  document.addEventListener('mouseover', function (e) {
    const trigger = e.target.closest('[data-tooltip]')

    // If we moved to a different trigger (or no trigger), clean up old one
    if (activeTrigger && activeTrigger !== trigger) {
      removeFloatingTooltip(activeTooltip)
      activeTooltip = null
      activeTrigger = null
    }

    if (!trigger || trigger.dataset.tooltipInit === 'hook') return
    if (trigger === activeTrigger) return // already showing

    const text = trigger.dataset.tooltip
    if (!text) return

    // Determine position from classes or data attribute
    let position = 'top'
    if (trigger.classList.contains('pa-tooltip--bottom')) position = 'bottom'
    else if (trigger.classList.contains('pa-tooltip--left')) position = 'left'
    else if (trigger.classList.contains('pa-tooltip--right')) position = 'right'
    if (trigger.dataset.tooltipPosition) position = trigger.dataset.tooltipPosition

    activeTooltip = createFloatingTooltip(trigger, text, position)
    activeTrigger = trigger

    // Apply variant
    const variantMatch = trigger.className.match(/pa-tooltip--(\w[\w-]*)/)
    if (variantMatch && !['bottom', 'left', 'right', 'top', 'multiline', 'help', 'floating'].includes(variantMatch[1])) {
      activeTooltip.classList.add('pa-tooltip--' + variantMatch[1])
    }
    if (trigger.classList.contains('pa-tooltip--multiline')) {
      activeTooltip.classList.add('pa-tooltip--multiline')
    }
  })

  document.addEventListener('mouseout', function (e) {
    if (!activeTrigger) return
    const related = e.relatedTarget
    // Only hide if we actually left the trigger (not moving to a child)
    if (related && activeTrigger.contains(related)) return
    if (related && related.closest && related.closest('[data-tooltip]') === activeTrigger) return

    removeFloatingTooltip(activeTooltip)
    activeTooltip = null
    activeTrigger = null
  })
}
