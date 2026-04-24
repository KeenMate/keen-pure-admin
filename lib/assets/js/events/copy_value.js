/**
 * Copy-to-clipboard delegator.
 *
 * Two interaction patterns:
 *
 *   1. Copy button (icon button next to a value):
 *        <span data-copy-value="...">...</span>
 *        <button data-pa-copy>...icon...</button>
 *      The button copies the nearest previous sibling (or ancestor's)
 *      `[data-copy-value]` content.
 *
 *   2. Click-to-copy value:
 *        <span data-pa-copy-on-click data-copy-value="...">...</span>
 *      Clicking the span itself copies its own `data-copy-value`.
 *
 * Visual feedback: swaps the button's `<i>` class from `.fa-copy` to
 * `.fa-check` for 1.5s, or flashes a `.pa-field__value--copied` class
 * on the click-to-copy span.
 */
const FLASH_MS = 1500

export function initCopyValueEvents() {
  document.addEventListener("click", (event) => {
    const btn = event.target.closest("[data-pa-copy]")
    if (btn) {
      event.preventDefault()
      const text = findCopyText(btn)
      if (text != null) copy(text).then(() => flashButton(btn))
      return
    }

    const clickValue = event.target.closest("[data-pa-copy-on-click]")
    if (clickValue) {
      event.preventDefault()
      const text = clickValue.dataset.copyValue ?? clickValue.textContent
      if (text != null) copy(text).then(() => flashValue(clickValue))
    }
  })
}

// Resolve the text a copy button should copy. Preference order:
//   1. explicit `data-copy-value` on the button
//   2. nearest previous sibling with `[data-copy-value]`
//   3. nearest ancestor with `[data-copy-value]`
//   4. previous sibling's textContent
function findCopyText(btn) {
  if (btn.dataset.copyValue != null) return btn.dataset.copyValue

  let sibling = btn.previousElementSibling
  while (sibling) {
    if (sibling.dataset && sibling.dataset.copyValue != null) {
      return sibling.dataset.copyValue
    }
    sibling = sibling.previousElementSibling
  }

  const ancestor = btn.parentElement?.closest("[data-copy-value]")
  if (ancestor) return ancestor.dataset.copyValue

  if (btn.previousElementSibling) return btn.previousElementSibling.textContent

  return null
}

function copy(text) {
  if (navigator.clipboard && navigator.clipboard.writeText) {
    return navigator.clipboard.writeText(text)
  }
  // Fallback for non-secure contexts (no HTTPS, no clipboard API).
  return new Promise((resolve) => {
    const ta = document.createElement("textarea")
    ta.value = text
    ta.style.position = "fixed"
    ta.style.opacity = "0"
    document.body.appendChild(ta)
    ta.select()
    try {
      document.execCommand("copy")
    } catch (_) {
      /* give up silently */
    }
    document.body.removeChild(ta)
    resolve()
  })
}

function flashButton(btn) {
  const icon = btn.querySelector("i")
  if (!icon) return
  icon.classList.remove("fa-copy")
  icon.classList.add("fa-check")
  setTimeout(() => {
    icon.classList.remove("fa-check")
    icon.classList.add("fa-copy")
  }, FLASH_MS)
}

function flashValue(el) {
  el.classList.add("pa-field__value--copied")
  setTimeout(() => el.classList.remove("pa-field__value--copied"), FLASH_MS)
}
