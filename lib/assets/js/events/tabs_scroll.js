/**
 * Horizontal tab scroll buttons.
 *
 * Components emit:
 *
 *   <button data-pa-tab-scroll="start">‹</button>
 *   <div class="pa-tabs__scroll-container">...</div>
 *   <button data-pa-tab-scroll="end">›</button>
 *
 * The delegator scrolls the sibling `.pa-tabs__scroll-container` by ±200px.
 */
const STEP = 200

export function initTabsScrollEvents() {
  document.addEventListener("click", (event) => {
    const btn = event.target.closest("[data-pa-tab-scroll]")
    if (!btn) return

    event.preventDefault()
    const direction = btn.dataset.paTabScroll
    const container = btn
      .closest(".pa-tabs")
      ?.querySelector(".pa-tabs__scroll-container")
    if (!container) return

    const delta = direction === "start" ? -STEP : STEP
    container.scrollBy({ left: delta, behavior: "smooth" })
  })
}
