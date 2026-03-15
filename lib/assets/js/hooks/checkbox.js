/**
 * PureAdminCheckbox - Manages indeterminate state for checkboxes.
 *
 * The HTML `indeterminate` property can only be set via JavaScript,
 * not via HTML attributes. This hook syncs the `data-indeterminate`
 * attribute to the input's `indeterminate` property.
 *
 * Usage: Add `phx-hook="PureAdminCheckbox"` and `data-indeterminate="true"`
 * to the checkbox wrapper element (the label.pa-checkbox).
 */
export const PureAdminCheckbox = {
  mounted() {
    this._sync()
  },

  updated() {
    this._sync()
  },

  _sync() {
    const input = this.el.querySelector('input[type="checkbox"]')
    if (input) {
      input.indeterminate = this.el.dataset.indeterminate === "true"
    }
  }
}
