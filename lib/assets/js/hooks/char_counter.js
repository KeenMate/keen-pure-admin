/**
 * PureAdminCharCounter - Character counter for textareas/inputs.
 *
 * Attach to a form-group element containing a textarea/input and a help text element.
 * Counts characters on every keystroke, updates counter text, and toggles error state.
 *
 * Data attributes:
 *   data-max-chars     - Maximum character count (required)
 *   data-msg           - Message template when under limit (default: "{count}/{max}")
 *   data-msg-over      - Message template when over limit (default: "{count}/{max}")
 *
 * Template placeholders: {count}, {max}
 *
 * The hook finds:
 *   - First <textarea> or <input> inside the element
 *   - First .pa-form-help inside the element
 *   - Toggles pa-form-group--error on the hook element
 *   - Toggles pa-textarea--error / pa-input--error on the input
 *   - Toggles pa-form-help--error on the help element
 */
export const PureAdminCharCounter = {
  mounted() {
    this._setup()
  },

  updated() {
    this._setup()
  },

  _setup() {
    const el = this.el
    const input = el.querySelector("textarea, input[type='text']")
    const help = el.querySelector(".pa-form-help")
    if (!input || !help) return

    const max = parseInt(el.dataset.maxChars, 10)
    if (isNaN(max)) return

    const msgTemplate = el.dataset.msg || "{count}/{max}"
    const msgOverTemplate = el.dataset.msgOver || msgTemplate
    const isTextarea = input.tagName === "TEXTAREA"
    const inputBaseClass = isTextarea ? "pa-textarea" : "pa-input"

    // Remove previous listener if any
    if (this._listener) input.removeEventListener("input", this._listener)

    const update = () => {
      const count = input.value.length
      const over = count > max
      const template = over ? msgOverTemplate : msgTemplate
      const text = template.replace(/\{count\}/g, count).replace(/\{max\}/g, max)

      help.textContent = text

      if (over) {
        el.classList.add("pa-form-group--error")
        input.classList.add(inputBaseClass + "--error")
        help.classList.add("pa-form-help--error")
      } else {
        el.classList.remove("pa-form-group--error")
        input.classList.remove(inputBaseClass + "--error")
        help.classList.remove("pa-form-help--error")
      }
    }

    this._listener = update
    input.addEventListener("input", update)
    update()
  },

  destroyed() {
    if (this._listener) {
      const input = this.el.querySelector("textarea, input[type='text']")
      if (input) input.removeEventListener("input", this._listener)
    }
  }
}
