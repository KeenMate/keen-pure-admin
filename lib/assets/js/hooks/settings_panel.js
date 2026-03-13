/**
 * PureAdminSettings hook - Settings panel for Pure Admin layout.
 *
 * Manages theme mode, layout width, sidebar, display, font options.
 * All settings persist to localStorage and apply classes to <html>/<body>.
 * No server-side events needed — purely client-side.
 */

const FONT_FAMILY_CLASSES = [
  "font-family-serif",
  "font-family-mono",
  "font-family-cuprum",
  "font-family-fira-sans-condensed",
  "font-family-manrope",
  "font-family-martel",
  "font-family-maven-pro",
  "font-family-monda",
  "font-family-play",
  "font-family-signika",
  "font-family-yanone-kaffeesatz",
]

const FONT_SIZE_CLASSES = [
  "font-size-small",
  "font-size-default",
  "font-size-large",
  "font-size-xlarge",
]

const CONTAINER_WIDTH_CLASSES = [
  "pa-container-sm",
  "pa-container-md",
  "pa-container-lg",
  "pa-container-xl",
  "pa-container-2xl",
]

const DEFAULTS = {
  "theme": "",
  "theme-mode": "light",
  "font-size": "default",
  "font-family": "default",
  "sidebar-hidden": "false",
  "sidebar-behavior": "hide",
  "sidebar-resizable": "false",
  "compact-mode": "false",
  "rtl-mode": "false",
  "profile-no-avatar": "false",
  "profile-icon-only-tabs": "false",
  "container-width": "fluid",
  "sidebar-mode": "",
}

export const PureAdminSettings = {
  mounted() {
    this._mediaQuery = null
    this._handleOSThemeChange = (e) => {
      if (this._getSetting("theme-mode") === "auto") {
        this._applyThemeMode(e.matches ? "dark" : "light")
      }
    }
    this._handleClickOutside = (e) => {
      if (!this.el.contains(e.target) && this.el.classList.contains("pa-settings-panel--open")) {
        this.el.classList.remove("pa-settings-panel--open")
      }
    }

    this._loadSettings()
    this._applyAllSettings()
    this._bindControls()

    document.addEventListener("click", this._handleClickOutside)
  },

  destroyed() {
    document.removeEventListener("click", this._handleClickOutside)
    if (this._mediaQuery) {
      this._mediaQuery.removeEventListener("change", this._handleOSThemeChange)
      this._mediaQuery = null
    }
  },

  _getSetting(key) {
    return localStorage.getItem(key) || DEFAULTS[key]
  },

  _loadSettings() {
    // Sync UI controls with stored values
    this.el.querySelectorAll("[data-setting]").forEach((control) => {
      const key = control.dataset.setting
      const value = this._getSetting(key)

      if (control.type === "checkbox") {
        // profile-no-avatar is stored as "true" when avatar is hidden
        control.checked = value === "true"
      } else {
        control.value = value
      }
    })
  },

  _bindControls() {
    // Toggle button
    const toggle = this.el.querySelector(".pa-settings-panel__toggle")
    if (toggle) {
      toggle.addEventListener("click", (e) => {
        e.stopPropagation()
        this.el.classList.toggle("pa-settings-panel--open")
      })
    }

    // Settings controls
    this.el.querySelectorAll("[data-setting]").forEach((control) => {
      control.addEventListener("change", () => {
        const key = control.dataset.setting
        const value = control.type === "checkbox" ? control.checked.toString() : control.value
        localStorage.setItem(key, value)
        this._applyAllSettings()
      })
    })

    // Reset button
    const resetBtn = this.el.querySelector("[data-reset]")
    if (resetBtn) {
      resetBtn.addEventListener("click", () => {
        Object.keys(DEFAULTS).forEach((key) => localStorage.removeItem(key))
        this._loadSettings()
        this._applyAllSettings()
      })
    }
  },

  _applyAllSettings() {
    const body = document.body
    const html = document.documentElement

    // Theme CSS (dynamic link tag)
    this._applyThemeCSS()

    // Theme mode (light/dark/auto)
    const mode = this._getSetting("theme-mode")
    const resolved = this._resolveThemeMode(mode)
    this._applyThemeMode(resolved)
    this._setupAutoThemeListener(mode)

    // RTL mode
    if (this._getSetting("rtl-mode") === "true") {
      html.setAttribute("dir", "rtl")
    } else {
      html.setAttribute("dir", "ltr")
    }

    // Font size
    html.classList.remove(...FONT_SIZE_CLASSES)
    const fontSize = this._getSetting("font-size")
    if (fontSize !== "default") {
      html.classList.add(`font-size-${fontSize}`)
    }

    // Font family
    body.classList.remove(...FONT_FAMILY_CLASSES)
    const fontFamily = this._getSetting("font-family")
    if (fontFamily !== "default") {
      body.classList.add(`font-family-${fontFamily}`)
    }

    // Sidebar collapsed
    if (this._getSetting("sidebar-hidden") === "true") {
      body.classList.add("sidebar-hidden")
    } else {
      body.classList.remove("sidebar-hidden")
    }

    // Sidebar behavior
    const sidebar = document.querySelector(".pa-layout__sidebar")
    if (sidebar) {
      sidebar.classList.remove("pa-layout__sidebar--icon-collapse")
      if (this._getSetting("sidebar-behavior") === "icon-collapse") {
        sidebar.classList.add("pa-layout__sidebar--icon-collapse")
      }

      // Sidebar resizable
      if (this._getSetting("sidebar-resizable") === "true") {
        sidebar.classList.add("pa-layout__sidebar--resizable")
      } else {
        sidebar.classList.remove("pa-layout__sidebar--resizable")
      }
    }

    // Compact mode
    if (this._getSetting("compact-mode") === "true") {
      body.classList.add("compact-mode")
    } else {
      body.classList.remove("compact-mode")
    }

    // Container width
    body.classList.remove(...CONTAINER_WIDTH_CLASSES)
    const containerWidth = this._getSetting("container-width")
    if (containerWidth && containerWidth !== "fluid") {
      body.classList.add(`pa-container-${containerWidth}`)
    }

    // Sidebar mode (sticky)
    if (this._getSetting("sidebar-mode") === "sticky") {
      body.classList.add("pa-layout--sticky")
    } else {
      body.classList.remove("pa-layout--sticky")
    }

    // Profile panel - avatar
    const profileHeader = document.querySelector(".pa-profile-panel__header")
    if (profileHeader) {
      if (this._getSetting("profile-no-avatar") === "true") {
        profileHeader.classList.add("pa-profile-panel__header--no-avatar")
      } else {
        profileHeader.classList.remove("pa-profile-panel__header--no-avatar")
      }
    }

    // Profile panel - icon-only tabs
    const profileTabs = document.querySelector(".pa-profile-panel__tabs")
    if (profileTabs) {
      if (this._getSetting("profile-icon-only-tabs") === "true") {
        profileTabs.classList.add("pa-profile-panel__tabs--icon-only")
      } else {
        profileTabs.classList.remove("pa-profile-panel__tabs--icon-only")
      }
    }
  },

  _applyThemeCSS() {
    const themeId = this._getSetting("theme")
    if (!themeId) return

    // Read theme options from data attribute on the hook element
    const themesData = this.el.dataset.themes
    if (!themesData) return

    let themes
    try {
      themes = JSON.parse(themesData)
    } catch {
      return
    }

    const selected = themes.find((t) => t.id === themeId)
    if (!selected) return

    let themeLink = document.getElementById("pa-theme-css")
    if (!themeLink) {
      themeLink = document.createElement("link")
      themeLink.id = "pa-theme-css"
      themeLink.rel = "stylesheet"
      document.head.appendChild(themeLink)
    }
    if (themeLink.href !== selected.css_path) {
      themeLink.href = selected.css_path
    }
  },

  _resolveThemeMode(mode) {
    if (mode === "auto") {
      return window.matchMedia("(prefers-color-scheme: dark)").matches ? "dark" : "light"
    }
    return mode
  },

  _applyThemeMode(resolved) {
    document.body.classList.remove("pa-mode-light", "pa-mode-dark")
    document.body.classList.add(`pa-mode-${resolved}`)
  },

  _setupAutoThemeListener(mode) {
    // Clean up previous listener
    if (this._mediaQuery) {
      this._mediaQuery.removeEventListener("change", this._handleOSThemeChange)
      this._mediaQuery = null
    }

    // Set up new listener if in auto mode
    if (mode === "auto") {
      this._mediaQuery = window.matchMedia("(prefers-color-scheme: dark)")
      this._mediaQuery.addEventListener("change", this._handleOSThemeChange)
    }
  },
}
