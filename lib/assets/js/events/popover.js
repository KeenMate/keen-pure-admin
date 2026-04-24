/**
 * Popover — click-triggered floating panel with header + body.
 *
 * Ported from the inline `<script>` block that used to live in the
 * `popover/1` component template (lib/keen_pure_admin/components/tooltip.ex).
 * Single document-level click listener handles every `<.popover>` on the
 * page via `data-pa-popover-*` attributes:
 *
 *   <div class="pa-popover" data-placement="bottom">
 *     <button data-pa-popover-trigger>...</button>
 *     <div class="pa-popover__content">
 *       ...
 *       <button data-pa-popover-close>×</button>
 *     </div>
 *   </div>
 *
 * Uses Floating UI when present for collision-aware placement; falls back
 * to manual positioning otherwise.
 *
 * Note: this is NOT the same as `PureAdminPopover` LiveView hook (which
 * previously did a simple class toggle but was never actually wired into
 * the component markup). The new delegator is the single source of truth.
 */
const OFFSET = 10

export function initPopoverEvents() {
  document.addEventListener("click", onClick)
}

function onClick(event) {
  const trigger = event.target.closest("[data-pa-popover-trigger]")
  if (trigger) {
    event.preventDefault()
    event.stopPropagation()
    toggleFromTrigger(trigger)
    return
  }

  const closeBtn = event.target.closest("[data-pa-popover-close]")
  if (closeBtn) {
    event.preventDefault()
    const content = closeBtn.closest(".pa-popover__content")
    if (content) close(content)
    return
  }

  // Click outside any popover — close all open ones.
  if (!event.target.closest(".pa-popover, .pa-popover__content")) {
    document.querySelectorAll(".pa-popover__content[data-show]").forEach(close)
  }
}

function toggleFromTrigger(trigger) {
  // The trigger's sibling is the `.pa-popover__content`.
  const content = trigger.nextElementSibling
  if (!content || !content.classList.contains("pa-popover__content")) return

  const isOpen = content.hasAttribute("data-show")

  // Close all others first.
  document
    .querySelectorAll(".pa-popover__content[data-show]")
    .forEach((el) => {
      if (el !== content) close(el)
    })

  if (isOpen) {
    close(content)
  } else {
    open(trigger, content)
  }
}

function open(trigger, content) {
  // Portal to body so ancestor transforms/overflow don't clip the popover.
  if (content.parentNode !== document.body) {
    const popover = content.parentNode
    content._originalParent = popover
    content._originalNext = content.nextElementSibling
    popover.classList.forEach((cls) => {
      if (cls.startsWith("pa-popover--") && cls !== "pa-popover--sm" && cls !== "pa-popover--lg") {
        content.classList.add(cls)
      }
    })
    document.body.appendChild(content)
  }

  content.setAttribute("data-show", "")
  position(trigger, content)
}

function close(content) {
  content.removeAttribute("data-show")
  content.style.position = ""
  content.style.top = ""
  content.style.left = ""

  if (content._cleanupAutoUpdate) {
    content._cleanupAutoUpdate()
    content._cleanupAutoUpdate = null
  }

  if (content._originalParent) {
    if (content._originalNext) {
      content._originalParent.insertBefore(content, content._originalNext)
    } else {
      content._originalParent.appendChild(content)
    }
    content._originalParent = null
    content._originalNext = null
  }
}

function position(trigger, content) {
  const placement = resolvePlacement(content.dataset.placement || "bottom")
  content.style.position = "fixed"
  content.style.zIndex = "9000"

  if (window.FloatingUIDOM) {
    const FUI = window.FloatingUIDOM
    const update = () => {
      FUI.computePosition(trigger, content, {
        placement,
        strategy: "fixed",
        middleware: [FUI.offset(OFFSET), FUI.flip(), FUI.shift({ padding: 5 })],
      }).then((result) => {
        content.style.left = `${result.x}px`
        content.style.top = `${result.y}px`
      })
    }
    update()
    if (FUI.autoUpdate) {
      content._cleanupAutoUpdate = FUI.autoUpdate(trigger, content, update)
    }
  } else {
    manualPosition(trigger, content, placement)
  }
}

function resolvePlacement(placement) {
  const rtl = document.documentElement.dir === "rtl"
  if (placement === "start") return rtl ? "right" : "left"
  if (placement === "end") return rtl ? "left" : "right"
  return placement
}

function manualPosition(trigger, content, placement) {
  requestAnimationFrame(() => {
    const tr = trigger.getBoundingClientRect()
    const cr = content.getBoundingClientRect()
    let top, left

    switch (placement) {
      case "top":
        top = tr.top - cr.height - OFFSET
        left = tr.left + tr.width / 2 - cr.width / 2
        break
      case "right":
        top = tr.top + tr.height / 2 - cr.height / 2
        left = tr.right + OFFSET
        break
      case "left":
        top = tr.top + tr.height / 2 - cr.height / 2
        left = tr.left - cr.width - OFFSET
        break
      default:
        top = tr.bottom + OFFSET
        left = tr.left + tr.width / 2 - cr.width / 2
    }

    left = Math.max(5, Math.min(left, window.innerWidth - cr.width - 5))
    top = Math.max(5, Math.min(top, window.innerHeight - cr.height - 5))
    content.style.top = `${top}px`
    content.style.left = `${left}px`
  })
}
