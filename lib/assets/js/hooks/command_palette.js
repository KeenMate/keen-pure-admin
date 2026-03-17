/**
 * PureAdminCommandPalette hook - Ctrl+K shortcut and keyboard navigation.
 */
export const PureAdminCommandPalette = {
  mounted() {
    this.input = this.el.querySelector('.pa-command-palette__input')
    this.backdrop = this.el.querySelector('.pa-command-palette__backdrop')

    // Global Ctrl+K / Cmd+K
    this._globalKeydown = (e) => {
      if ((e.ctrlKey || e.metaKey) && e.key === 'k') {
        e.preventDefault()
        this.pushEvent('command_palette_toggle', {})
      }
    }
    document.addEventListener('keydown', this._globalKeydown)

    // Input handler
    if (this.input) {
      this._inputHandler = (e) => {
        this.pushEvent('command_palette_search', { query: e.target.value })
      }
      this.input.addEventListener('input', this._inputHandler)

      this._keydownHandler = (e) => {
        switch (e.key) {
          case 'Escape':
            e.preventDefault()
            this.pushEvent('command_palette_close', {})
            break
          case 'ArrowUp':
            e.preventDefault()
            this.pushEvent('command_palette_navigate', { direction: 'up' })
            break
          case 'ArrowDown':
            e.preventDefault()
            this.pushEvent('command_palette_navigate', { direction: 'down' })
            break
          case 'ArrowLeft':
            if (this.input.selectionStart === 0) {
              e.preventDefault()
              this.pushEvent('command_palette_page', { direction: 'prev' })
            }
            break
          case 'ArrowRight':
            if (this.input.selectionStart === this.input.value.length) {
              e.preventDefault()
              this.pushEvent('command_palette_page', { direction: 'next' })
            }
            break
          case 'Enter':
            e.preventDefault()
            this.pushEvent('command_palette_select', {})
            break
        }
      }
      this.input.addEventListener('keydown', this._keydownHandler)
    }

    // Backdrop click
    if (this.backdrop) {
      this._backdropClick = () => {
        this.pushEvent('command_palette_close', {})
      }
      this.backdrop.addEventListener('click', this._backdropClick)
    }

    this._focusIfOpen()
  },

  updated() {
    this._focusIfOpen()
    this._scrollActiveIntoView()
  },

  _focusIfOpen() {
    if (this.el.classList.contains('pa-command-palette--active') && this.input) {
      // Small delay to ensure DOM is ready
      setTimeout(() => this.input.focus(), 50)
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
  }
}
