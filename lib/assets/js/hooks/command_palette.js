/**
 * PureAdminCommandPalette v2 — Multi-step commands + scoped search.
 *
 * Keyboard shortcuts:
 *   Ctrl+K / Cmd+K  — Toggle palette
 *   ↑↓              — Navigate items
 *   ←→              — Pages (in search modes)
 *   Enter / Tab      — Select item or submit free text
 *   Escape           — Back (in step/context) or close
 *   Backspace at 0   — Back to previous step
 *
 * Event protocol (hook → LiveView):
 *   cp:toggle, cp:close, cp:input, cp:navigate, cp:page, cp:select, cp:step_back
 *
 * Reads data-mode from the component root to determine keyboard behavior.
 */
import { createLogger } from "../logger"

const log = createLogger('CMD_PALETTE')

export const PureAdminCommandPalette = {
  mounted() {
    this.input = this.el.querySelector('.pa-command-palette__input')
    this.backdrop = this.el.querySelector('.pa-command-palette__backdrop')
    this._debounceTimer = null
    this._lastQuery = ''
    log.debug('mounted, input:', !!this.input)

    // Global Ctrl+K / Cmd+K and Alt+key hotkeys
    this._globalKeydown = (e) => {
      if ((e.ctrlKey || e.metaKey) && e.key === 'k') {
        e.preventDefault()
        log.debug('Ctrl+K pressed')
        this.pushEvent('cp:toggle', {})
        return
      }

      // Alt+key hotkeys — open palette with specific command
      if (e.altKey && !e.ctrlKey && !e.metaKey && e.key !== 'Alt') {
        log.debug('Alt+' + e.key + ' pressed')
        this.pushEvent('cp:hotkey', { key: e.key.toLowerCase() })
        e.preventDefault()
      }
    }
    document.addEventListener('keydown', this._globalKeydown)

    // Input handler with debounce for search modes
    if (this.input) {
      this._inputHandler = (e) => {
        const query = e.target.value
        const mode = this._getMode()

        // Debounce search modes, instant for command/context list filtering
        if (mode === 'context_search' || mode === 'global_search') {
          clearTimeout(this._debounceTimer)
          this._debounceTimer = setTimeout(() => {
            this.pushEvent('cp:input', { query })
          }, 150)
        } else {
          this.pushEvent('cp:input', { query })
        }
      }
      this.input.addEventListener('input', this._inputHandler)

      this._keydownHandler = (e) => {
        const mode = this._getMode()

        // Alt+key hotkeys inside the palette
        if (e.altKey && !e.ctrlKey && !e.metaKey && e.key !== 'Alt') {
          e.preventDefault()
          this.pushEvent('cp:hotkey', { key: e.key.toLowerCase() })
          return
        }

        switch (e.key) {
          case 'Escape':
            e.preventDefault()
            // In step/context modes, go back instead of closing
            if (mode === 'command_step' || mode === 'context_search') {
              this.pushEvent('cp:step_back', {})
            } else {
              this.pushEvent('cp:close', {})
            }
            break

          case 'ArrowUp':
            e.preventDefault()
            this.pushEvent('cp:navigate', { direction: 'up' })
            break

          case 'ArrowDown':
            e.preventDefault()
            this.pushEvent('cp:navigate', { direction: 'down' })
            break

          case 'ArrowLeft':
            if (this.input.selectionStart === 0 && (mode === 'context_search' || mode === 'global_search')) {
              e.preventDefault()
              this.pushEvent('cp:page', { direction: 'prev' })
            }
            break

          case 'ArrowRight':
            if (this.input.selectionStart === this.input.value.length && (mode === 'context_search' || mode === 'global_search')) {
              e.preventDefault()
              this.pushEvent('cp:page', { direction: 'next' })
            }
            break

          case 'Backspace':
            if (mode === 'command_step' || mode === 'context_search') {
              const display = this.el.dataset.display || 'inline'
              if (display === 'inline') {
                // In inline mode, prevent deleting into the locked prefix
                // The locked prefix length is tracked via data attribute
                const lockedLen = parseInt(this.el.dataset.lockedLength || '0', 10)
                if (this.input.selectionStart <= lockedLen && this.input.selectionEnd <= lockedLen) {
                  e.preventDefault()
                  this.pushEvent('cp:step_back', {})
                } else if (this.input.selectionStart <= lockedLen) {
                  e.preventDefault()
                }
              } else {
                // Token mode: backspace at position 0 → go back
                if (this.input.selectionStart === 0 && this.input.selectionEnd === 0) {
                  e.preventDefault()
                  this.pushEvent('cp:step_back', {})
                }
              }
            }
            break

          case 'Enter':
          case 'Tab':
            e.preventDefault()
            this.pushEvent('cp:select', { index: -1 })
            break
        }
      }
      this.input.addEventListener('keydown', this._keydownHandler)
    }

    // Backdrop click
    if (this.backdrop) {
      this._backdropClick = () => {
        this.pushEvent('cp:close', {})
      }
      this.backdrop.addEventListener('click', this._backdropClick)
    }

    // Listen for focus events from LiveView
    this.handleEvent('cp:focus', () => {
      this._focusInput()
    })

    // Listen for input reset (when entering a new step/mode)
    this.handleEvent('cp:reset_input', ({ value }) => {
      if (this.input) {
        this.input.value = value || ''
        this._focusInput()
      }
    })

    this._focusIfOpen()
  },

  updated() {
    this._focusIfOpen()
    this._scrollActiveIntoView()
  },

  _getMode() {
    return this.el.dataset.mode || 'idle'
  },

  _focusInput() {
    if (this.input) {
      setTimeout(() => {
        this.input.focus()
        // Place cursor at end
        this.input.selectionStart = this.input.value.length
        this.input.selectionEnd = this.input.value.length
      }, 50)
    }
  },

  _focusIfOpen() {
    if (this.el.classList.contains('pa-command-palette--active')) {
      this._focusInput()
    }
  },

  _scrollActiveIntoView() {
    const active = this.el.querySelector('.pa-command-palette__item--active')
    if (active) {
      active.scrollIntoView({ block: 'nearest' })
    }
  },

  destroyed() {
    document.removeEventListener('keydown', this._globalKeydown)
    clearTimeout(this._debounceTimer)
  }
}
