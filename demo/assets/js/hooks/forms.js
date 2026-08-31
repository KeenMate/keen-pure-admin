/**
 * Demo hooks for the Forms page (`/forms`).
 *
 * DEMO-ONLY glue. LiveView owns the DOM, so the pure-admin demo's inline
 * `<script>` measurement + tri-state cycler are reproduced here as hooks:
 *
 *   - MeasureFormSizes — measures the rendered input/button heights per row of
 *     the "Input Sizes Reference" table and writes them into the height cells.
 *   - FormsTristate    — click-cycles a checkbox unchecked → checked →
 *     indeterminate (the pure-admin `data-pa-tristate` behaviour; keen's core
 *     ships only the static-indeterminate `PureAdminCheckbox` hook).
 */

// ── MeasureFormSizes ──────────────────────────────────────────────────────────
// Attach to the sizes-reference `<table>`. For each body row, reads the actual
// offsetHeight of the `[data-measure="input"]` / `[data-measure="button"]`
// controls and writes "<n>px" into the row's `.height-input` / `.height-button`
// cells. Re-runs on every LiveView patch so the numbers stay correct.
export const MeasureFormSizes = {
  mounted() {
    this._measure()
  },
  updated() {
    this._measure()
  },
  _measure() {
    this.el.querySelectorAll("tbody tr").forEach((row) => {
      const input = row.querySelector('[data-measure="input"]')
      const button = row.querySelector('[data-measure="button"]')
      const inputCell = row.querySelector(".height-input")
      const buttonCell = row.querySelector(".height-button")
      if (input && inputCell) inputCell.textContent = input.offsetHeight + "px"
      if (button && buttonCell) buttonCell.textContent = button.offsetHeight + "px"
    })
  }
}

// ── FormsTristate ─────────────────────────────────────────────────────────────
// Attach to a `.pa-checkbox` label. Click cycles the inner checkbox through
// unchecked → checked → indeterminate (mirrors pure-admin's `data-pa-tristate`).
export const FormsTristate = {
  mounted() {
    this.input = this.el.querySelector('input[type="checkbox"]')
    this._onClick = (e) => {
      if (!this.input) return
      e.preventDefault()
      if (this.input.indeterminate) {
        this.input.indeterminate = false
        this.input.checked = false
      } else if (this.input.checked) {
        this.input.checked = false
        this.input.indeterminate = true
      } else {
        this.input.checked = true
      }
    }
    this.el.addEventListener("click", this._onClick)
  },
  destroyed() {
    if (this._onClick) this.el.removeEventListener("click", this._onClick)
  }
}
