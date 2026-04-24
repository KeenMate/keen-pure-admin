/**
 * Popconfirm — anchored confirmation dialog.
 *
 * Ported from the inline `<script>` block that used to live in the
 * `popconfirm/1` component template. Single document-level click listener
 * handles every `<.popconfirm>` on the page via `data-pa-popconfirm-*`
 * attributes:
 *
 *   <div data-pa-popconfirm-trigger="my-id">...trigger...</div>
 *   <div id="my-id" data-pa-popconfirm class="pa-popconfirm" data-placement="bottom">
 *     ...
 *     <button data-pa-popconfirm-close="my-id">Cancel</button>
 *     <button data-pa-popconfirm-close="my-id" phx-click="...">Confirm</button>
 *   </div>
 *
 * Uses Floating UI if present (loaded via CDN alongside the app) for
 * collision-aware placement. Falls back to manual positioning otherwise.
 */
const OFFSET = 8
const SHIFT_PADDING = 10

let currentPopconfirm = null

export function initPopconfirmEvents() {
  document.addEventListener("click", onClick)
}

function onClick(event) {
  const trigger = event.target.closest("[data-pa-popconfirm-trigger]")
  if (trigger) {
    event.stopPropagation()
    toggle(trigger)
    return
  }

  const closeBtn = event.target.closest("[data-pa-popconfirm-close]")
  if (closeBtn) {
    // Don't preventDefault — phx-click on the confirm button still needs to fire.
    const id = closeBtn.dataset.paPopconfirmClose
    const el = document.getElementById(id)
    if (el) close(el)
    return
  }

  // Click outside — close the currently open one.
  if (
    currentPopconfirm &&
    !currentPopconfirm.contains(event.target) &&
    !event.target.closest("[data-pa-popconfirm-trigger]")
  ) {
    close(currentPopconfirm)
  }
}

function toggle(trigger) {
  const id = trigger.dataset.paPopconfirmTrigger
  const popconfirm = document.getElementById(id)
  if (!popconfirm) return

  if (currentPopconfirm && currentPopconfirm !== popconfirm) {
    close(currentPopconfirm)
  }

  if (popconfirm.classList.contains("is-open")) {
    close(popconfirm)
    return
  }

  open(trigger, popconfirm)
}

function open(trigger, popconfirm) {
  // Portal to body so transforms/overflow on ancestors don't clip it.
  if (popconfirm.parentNode !== document.body) {
    popconfirm._originalParent = popconfirm.parentNode
    popconfirm._originalNext = popconfirm.nextElementSibling
    document.body.appendChild(popconfirm)
  }
  popconfirm.classList.add("is-open")
  position(trigger, popconfirm)
  currentPopconfirm = popconfirm
}

function close(popconfirm) {
  popconfirm.classList.remove("is-open")
  popconfirm.style.position = ""
  popconfirm.style.top = ""
  popconfirm.style.left = ""

  if (popconfirm._cleanupAutoUpdate) {
    popconfirm._cleanupAutoUpdate()
    popconfirm._cleanupAutoUpdate = null
  }

  if (popconfirm._originalParent) {
    if (popconfirm._originalNext) {
      popconfirm._originalParent.insertBefore(popconfirm, popconfirm._originalNext)
    } else {
      popconfirm._originalParent.appendChild(popconfirm)
    }
    popconfirm._originalParent = null
    popconfirm._originalNext = null
  }

  if (currentPopconfirm === popconfirm) currentPopconfirm = null
}

function position(trigger, popconfirm) {
  const placement = resolvePlacement(popconfirm.dataset.placement || "bottom")
  popconfirm.style.position = "fixed"
  popconfirm.style.zIndex = "9000"

  if (window.FloatingUIDOM) {
    const FUI = window.FloatingUIDOM
    const update = () => {
      FUI.computePosition(trigger, popconfirm, {
        placement,
        strategy: "fixed",
        middleware: [FUI.offset(OFFSET), FUI.flip(), FUI.shift({ padding: SHIFT_PADDING })],
      }).then((result) => {
        popconfirm.style.left = `${result.x}px`
        popconfirm.style.top = `${result.y}px`
        popconfirm.className = popconfirm.className
          .replace(/pa-popconfirm--(top|bottom|left|right)/g, "")
          .trim() + ` pa-popconfirm--${result.placement}`
      })
    }
    update()
    if (FUI.autoUpdate) {
      popconfirm._cleanupAutoUpdate = FUI.autoUpdate(trigger, popconfirm, update)
    }
  } else {
    manualPosition(trigger, popconfirm, placement)
  }
}

function resolvePlacement(placement) {
  const rtl = document.documentElement.dir === "rtl"
  if (placement === "start") return rtl ? "right" : "left"
  if (placement === "end") return rtl ? "left" : "right"
  return placement
}

function manualPosition(trigger, popconfirm, placement) {
  requestAnimationFrame(() => {
    const tr = trigger.getBoundingClientRect()
    const pr = popconfirm.getBoundingClientRect()
    let top, left

    switch (placement) {
      case "top":
        top = tr.top - pr.height - OFFSET
        left = tr.left + tr.width / 2 - pr.width / 2
        break
      case "right":
        top = tr.top + tr.height / 2 - pr.height / 2
        left = tr.right + OFFSET
        break
      case "left":
        top = tr.top + tr.height / 2 - pr.height / 2
        left = tr.left - pr.width - OFFSET
        break
      default:
        top = tr.bottom + OFFSET
        left = tr.left + tr.width / 2 - pr.width / 2
    }

    left = Math.max(5, Math.min(left, window.innerWidth - pr.width - 5))
    top = Math.max(5, Math.min(top, window.innerHeight - pr.height - 5))
    popconfirm.style.top = `${top}px`
    popconfirm.style.left = `${left}px`
  })
}
