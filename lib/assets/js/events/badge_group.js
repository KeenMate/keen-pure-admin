/**
 * Badge-group expand/collapse.
 *
 * Replaces the inline `onclick="this.parentElement.classList.add(...)"`
 * previously used in `PureAdmin.Components.Badge.badge_group/1` when
 * `use_js` is true. Components emit:
 *
 *   <span data-pa-badge-group-expand>More</span>
 *   <span data-pa-badge-group-collapse>Less</span>
 *
 * The delegator finds the nearest `.pa-badge-group` ancestor and toggles
 * the `pa-badge-group--expanded` class — identical behavior, no inline JS.
 */
export function initBadgeGroupEvents() {
  document.addEventListener("click", (event) => {
    const expand = event.target.closest("[data-pa-badge-group-expand]")
    if (expand) {
      event.preventDefault()
      const group = expand.closest(".pa-badge-group")
      if (group) group.classList.add("pa-badge-group--expanded")
      return
    }

    const collapse = event.target.closest("[data-pa-badge-group-collapse]")
    if (collapse) {
      event.preventDefault()
      const group = collapse.closest(".pa-badge-group")
      if (group) group.classList.remove("pa-badge-group--expanded")
    }
  })
}
