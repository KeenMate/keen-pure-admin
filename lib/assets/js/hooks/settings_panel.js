/**
 * PureAdminSettings hook - Settings panel for Pure Admin layout.
 *
 * Reads theme manifests from page context (hidden input) if available,
 * falls back to fetching from /api/themes/manifests.
 * All settings persist to localStorage and apply classes to <html>/<body>.
 */
import { getContextValue } from "../page-context"
import { createLogger } from "../logger"

const log = createLogger('SETTINGS')

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

const FONT_FAMILY_MAP = {
  'serif': 'Georgia, "Times New Roman", Times, serif',
  'mono': '"Courier New", Courier, monospace',
  'cuprum': '"Cuprum", Arial, sans-serif',
  'fira-sans-condensed': '"Fira Sans Condensed", Arial Narrow, Arial, sans-serif',
  'manrope': '"Manrope", Arial, sans-serif',
  'martel': '"Martel", Georgia, serif',
  'maven-pro': '"Maven Pro", Arial, sans-serif',
  'monda': '"Monda", Arial, sans-serif',
  'play': '"Play", Arial, sans-serif',
  'signika': '"Signika", Arial, sans-serif',
  'yanone-kaffeesatz': '"Yanone Kaffeesatz", Arial, sans-serif'
}

const GOOGLE_FONTS = {
  'cuprum': 'Cuprum:wght@400;500;700',
  'fira-sans-condensed': 'Fira+Sans+Condensed:wght@400;500;600;700',
  'manrope': 'Manrope:wght@400;500;600;700',
  'martel': 'Martel:wght@400;700',
  'maven-pro': 'Maven+Pro:wght@400;500;600;700',
  'monda': 'Monda:wght@400;700',
  'play': 'Play:wght@400;700',
  'signika': 'Signika:wght@400;500;600;700',
  'yanone-kaffeesatz': 'Yanone+Kaffeesatz:wght@400;500;600;700'
}

const DEFAULTS = {
  "theme": "",
  "theme-mode": "",
  "color-variant": "",
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

const loadedFonts = new Set()

export const PureAdminSettings = {
  mounted() {
    this._themeManifests = {}
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

    document.addEventListener("click", this._handleClickOutside)

    // Use data-default-theme if no theme stored in localStorage
    this._defaultTheme = this.el.dataset.defaultTheme || ""
    if (this._defaultTheme && !localStorage.getItem("theme")) {
      localStorage.setItem("theme", this._defaultTheme)
      log.debug("No theme in localStorage, applying default:", this._defaultTheme)
    }

    // Try page context first (synchronous, no fetch), fall back to API
    const contextManifests = getContextValue("themeManifests")
    if (contextManifests && Object.keys(contextManifests).length > 0) {
      log.debug("Using page context manifests:", Object.keys(contextManifests))
      this._themeManifests = contextManifests
      this._populateThemeSelector()
      this._loadSettings()
      this._applyAllSettings()
      this._bindControls()
    } else {
      // Fallback: fetch from API
      this._fetchManifests().then(() => {
        log.debug("Manifests loaded from API:", Object.keys(this._themeManifests))
        this._populateThemeSelector()
        this._loadSettings()
        this._applyAllSettings()
        this._bindControls()
      })
    }
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

  // -- Manifest fetching --

  async _fetchManifests() {
    try {
      const response = await fetch("/api/themes/manifests")
      if (response.ok) {
        this._themeManifests = await response.json()
      }
    } catch (err) {
      log.error("Failed to fetch theme manifests:", err)
    }
  },

  _getCurrentManifest() {
    const theme = this._getSetting("theme")
    const manifest = theme ? this._themeManifests[theme] : null
    log.debug("getCurrentManifest: theme =", theme, ", found =", !!manifest)
    return manifest
  },

  // -- Theme selector --

  _populateThemeSelector() {
    const sel = this.el.querySelector("[data-setting='theme']")
    if (!sel || Object.keys(this._themeManifests).length === 0) return

    sel.innerHTML = ""
    const sorted = Object.entries(this._themeManifests)
      .sort((a, b) => a[1].name.localeCompare(b[1].name))

    for (const [id, manifest] of sorted) {
      const opt = document.createElement("option")
      opt.value = id
      opt.textContent = manifest.name
      sel.appendChild(opt)
    }
  },

  // -- Color variants --

  _getVariants(manifest) {
    if (!manifest) return []
    if (Array.isArray(manifest.colorVariants)) {
      return manifest.colorVariants.filter(v => v.id !== undefined)
    }
    if (manifest.colorVariants && manifest.colorVariants.supported) {
      return manifest.colorVariants.supported
    }
    return []
  },

  _updateColorVariantSection(manifest) {
    const section = this.el.querySelector("[data-section='color-variant']")
    const sel = this.el.querySelector("[data-setting='color-variant']")
    if (!section || !sel) return

    const variants = this._getVariants(manifest)
    log.debug("updateColorVariantSection: variants =", variants.length, variants.map(v => v.id || "(default)"))
    if (variants.length <= 1) {
      section.style.display = "none"
      this._applyColorVariant("", manifest)
      return
    }

    section.style.display = ""
    sel.innerHTML = ""
    for (const v of variants) {
      const opt = document.createElement("option")
      opt.value = v.id
      opt.textContent = v.name
      if (v.description) opt.title = v.description
      sel.appendChild(opt)
    }
  },

  _applyColorVariant(variant, manifest) {
    const pattern = manifest?.variantCssClass || "pa-color-{variant}"
    const body = document.body
    const targetClass = variant ? pattern.replace("{variant}", variant) : null

    // Skip if already correct (avoid FOUC from remove+add cycle)
    if (targetClass && body.classList.contains(targetClass)) {
      localStorage.setItem("color-variant", variant)
      return
    }

    // Remove all variant classes
    for (const v of this._getVariants(manifest)) {
      if (v.id) body.classList.remove(pattern.replace("{variant}", v.id))
    }

    // Apply new
    if (variant) {
      body.classList.add(pattern.replace("{variant}", variant))
    }

    localStorage.setItem("color-variant", variant)
  },

  // -- Modes --

  _getModesForVariant(manifest, variantId) {
    if (!manifest) return []
    if (Array.isArray(manifest.colorVariants)) {
      const variant = manifest.colorVariants.find(v => (v.id || "") === (variantId || ""))
      if (variant && Array.isArray(variant.modes)) {
        return variant.modes
      }
    }
    if (manifest.modes && manifest.modes.supported) {
      return manifest.modes.supported.map(id => ({ id, name: id.charAt(0).toUpperCase() + id.slice(1) }))
    }
    return []
  },

  _getDefaultMode(manifest, variantId) {
    const modes = this._getModesForVariant(manifest, variantId)
    const def = modes.find(m => m.default)
    return def ? def.id : (modes[0]?.id || "dark")
  },

  _updateModeSection(manifest, variantId) {
    const section = this.el.querySelector("[data-section='theme-mode']")
    const sel = this.el.querySelector("[data-setting='theme-mode']")
    if (!section || !sel) return

    const modes = this._getModesForVariant(manifest, variantId)
    log.debug("updateModeSection: variantId =", variantId, ", modes =", modes.length, modes.map(m => m.id))
    if (modes.length <= 1) {
      section.style.display = "none"
      if (modes.length === 1) {
        this._applyThemeMode(modes[0].id)
      }
      return
    }

    section.style.display = ""
    sel.innerHTML = ""
    for (const m of modes) {
      const opt = document.createElement("option")
      opt.value = m.id
      opt.textContent = m.name
      sel.appendChild(opt)
    }
  },

  _applyThemeMode(mode) {
    const body = document.body
    const manifest = this._getCurrentManifest()
    const pattern = manifest?.modeCssClass || "pa-mode-{mode}"
    const targetClass = pattern.replace("{mode}", mode)

    // Skip remove+add if already correct (avoid FOUC)
    if (body.classList.contains(targetClass)) {
      body.dataset.theme = mode
      localStorage.setItem("theme-mode", mode)
      return
    }

    // Remove every mode class declared by the manifest's variants (and the
    // built-in light/dark for unmanifested themes). Keeps stray mode classes
    // from a previous theme out of the body.
    const allModes = new Set(["light", "dark"])
    if (manifest && Array.isArray(manifest.colorVariants)) {
      for (const v of manifest.colorVariants) {
        if (Array.isArray(v.modes)) {
          for (const m of v.modes) if (m.id) allModes.add(m.id)
        }
      }
    }
    for (const m of allModes) body.classList.remove(pattern.replace("{mode}", m))

    body.classList.add(targetClass)
    body.dataset.theme = mode
    localStorage.setItem("theme-mode", mode)

    this._setupAutoThemeListener(mode)
  },

  _resolveThemeMode(mode) {
    if (mode === "auto") {
      return window.matchMedia("(prefers-color-scheme: dark)").matches ? "dark" : "light"
    }
    return mode
  },

  _setupAutoThemeListener(mode) {
    if (this._mediaQuery) {
      this._mediaQuery.removeEventListener("change", this._handleOSThemeChange)
      this._mediaQuery = null
    }
    if (mode === "auto") {
      this._mediaQuery = window.matchMedia("(prefers-color-scheme: dark)")
      this._mediaQuery.addEventListener("change", this._handleOSThemeChange)
    }
  },

  // -- Theme CSS --

  // Resolve the stylesheet URL from the manifest's colorVariants[0].file when
  // available (handles both `css/{id}.css` registry layout and `dist/{id}.css`
  // local-build layout). Falls back to the registry default for themes with no
  // manifest or no declared file.
  _resolveThemeHref(themeId) {
    const manifest = this._themeManifests[themeId]
    const variants = Array.isArray(manifest?.colorVariants) ? manifest.colorVariants : []
    const file = variants.find(v => !v.id)?.file || variants[0]?.file
    const relative = file || `css/${themeId}.css`
    return `/themes/${themeId}/${relative}`
  },

  _applyThemeCSS(themeId) {
    if (!themeId) return

    let themeLink = document.getElementById("pa-theme-css")
    if (!themeLink) {
      themeLink = document.createElement("link")
      themeLink.id = "pa-theme-css"
      themeLink.rel = "stylesheet"
      document.head.appendChild(themeLink)
    }

    const newHref = this._resolveThemeHref(themeId)
    if (themeLink.getAttribute("href") !== newHref) {
      themeLink.href = newHref
    }
  },

  // -- Fonts --

  _themeBundlesFont(family) {
    const manifest = this._getCurrentManifest()
    if (!manifest || !manifest.fonts || !manifest.fonts.family) return false
    const themeFont = manifest.fonts.family.toLowerCase()
    const fontName = (FONT_FAMILY_MAP[family] || "").split(",")[0].replace(/"/g, "").trim().toLowerCase()
    return fontName && themeFont.startsWith(fontName)
  },

  _loadGoogleFont(family) {
    if (!GOOGLE_FONTS[family] || loadedFonts.has(family)) return
    const link = document.createElement("link")
    link.rel = "stylesheet"
    link.href = `https://fonts.googleapis.com/css2?family=${GOOGLE_FONTS[family]}&display=swap`
    document.head.appendChild(link)
    loadedFonts.add(family)
  },

  _applyFontFamily(family) {
    const body = document.body
    if (family !== "default" && FONT_FAMILY_MAP[family]) {
      if (this._themeBundlesFont(family)) {
        body.style.removeProperty("--base-font-family")
      } else {
        this._loadGoogleFont(family)
        body.style.setProperty("--base-font-family", FONT_FAMILY_MAP[family])
      }
    } else {
      body.style.removeProperty("--base-font-family")
    }
    localStorage.setItem("font-family", family)
  },

  _updateFontFamilyDefault() {
    const sel = this.el.querySelector("[data-setting='font-family']")
    if (!sel) return
    const defaultOpt = sel.querySelector('option[value="default"]')
    if (!defaultOpt) return

    const manifest = this._getCurrentManifest()
    const themeFont = manifest?.fonts?.family?.split(",")[0]?.trim()
    defaultOpt.textContent = themeFont ? `Theme Default (${themeFont})` : "Theme Default"
  },

  // -- Load & apply all --

  _loadSettings() {
    // Sync non-manifest controls with stored values
    this.el.querySelectorAll("[data-setting]").forEach((control) => {
      const key = control.dataset.setting
      // Skip dynamically populated selects
      if (["theme", "theme-mode", "color-variant"].includes(key)) return

      const value = this._getSetting(key)
      if (control.type === "checkbox") {
        control.checked = value === "true"
      } else {
        control.value = value
      }
    })
  },

  _applyAllSettings() {
    const body = document.body
    const html = document.documentElement
    const manifest = this._getCurrentManifest()

    // Theme CSS
    const theme = this._getSetting("theme")
    if (theme) {
      this._applyThemeCSS(theme)
      const themeSel = this.el.querySelector("[data-setting='theme']")
      if (themeSel) themeSel.value = theme
    }

    // Color variants
    this._updateColorVariantSection(manifest)
    const variants = this._getVariants(manifest)
    let currentVariant = ""
    if (variants.length > 1) {
      const stored = localStorage.getItem("color-variant") || ""
      const validIds = variants.map(v => v.id)
      currentVariant = validIds.includes(stored) ? stored : (variants[0]?.id || "")
      log.debug("applyAllSettings: stored variant =", JSON.stringify(stored), ", validIds =", validIds, ", resolved =", JSON.stringify(currentVariant))
      const variantSel = this.el.querySelector("[data-setting='color-variant']")
      if (variantSel) variantSel.value = currentVariant
      this._applyColorVariant(currentVariant, manifest)
    }

    // Modes (depends on variant)
    this._updateModeSection(manifest, currentVariant)
    const modes = this._getModesForVariant(manifest, currentVariant)
    if (modes.length > 1) {
      const savedMode = localStorage.getItem("theme-mode") || this._getDefaultMode(manifest, currentVariant)
      const resolved = this._resolveThemeMode(savedMode)
      this._applyThemeMode(resolved)
      const modeSel = this.el.querySelector("[data-setting='theme-mode']")
      if (modeSel) modeSel.value = savedMode
    } else if (modes.length === 1) {
      this._applyThemeMode(modes[0].id)
    } else {
      // No manifest — fall back to localStorage
      const mode = this._getSetting("theme-mode") || "light"
      const resolved = this._resolveThemeMode(mode)
      this._applyThemeMode(resolved)
    }

    // Font family default label
    this._updateFontFamilyDefault()

    // Font family
    const fontFamily = this._getSetting("font-family")
    this._applyFontFamily(fontFamily)

    // RTL
    if (this._getSetting("rtl-mode") === "true") {
      html.setAttribute("dir", "rtl")
    } else {
      html.setAttribute("dir", "ltr")
    }

    // Font size — allowlist-check before applying so a poisoned localStorage
    // entry can't inject an arbitrary class name.
    html.classList.remove(...FONT_SIZE_CLASSES)
    const fontSize = this._getSetting("font-size")
    if (fontSize && fontSize !== "default") {
      const candidate = `font-size-${fontSize}`
      if (FONT_SIZE_CLASSES.includes(candidate)) html.classList.add(candidate)
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

    // Container width — allowlist-check to block arbitrary class names
    // that could flow in from a poisoned localStorage entry.
    body.classList.remove(...CONTAINER_WIDTH_CLASSES)
    const containerWidth = this._getSetting("container-width")
    if (containerWidth && containerWidth !== "fluid") {
      const candidate = `pa-container-${containerWidth}`
      if (CONTAINER_WIDTH_CLASSES.includes(candidate)) body.classList.add(candidate)
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

  _bindControls() {
    // Toggle button
    const toggle = this.el.querySelector(".pa-settings-panel__toggle")
    if (toggle) {
      toggle.addEventListener("click", (e) => {
        e.stopPropagation()
        this.el.classList.toggle("pa-settings-panel--open")
      })
    }

    // Theme change
    const themeSel = this.el.querySelector("[data-setting='theme']")
    if (themeSel) {
      themeSel.addEventListener("change", () => {
        const theme = themeSel.value
        localStorage.setItem("theme", theme)
        this._applyThemeCSS(theme)

        const manifest = this._themeManifests[theme]
        this._updateColorVariantSection(manifest)
        this._updateModeSection(manifest, "")
        this._updateFontFamilyDefault()

        // Apply default mode for new theme
        const defaultMode = this._getDefaultMode(manifest, "")
        this._applyThemeMode(defaultMode)
        const modeSel = this.el.querySelector("[data-setting='theme-mode']")
        if (modeSel) modeSel.value = defaultMode

        // Reset color variant
        localStorage.setItem("color-variant", "")
      })
    }

    // Color variant change
    const variantSel = this.el.querySelector("[data-setting='color-variant']")
    if (variantSel) {
      variantSel.addEventListener("change", () => {
        const variant = variantSel.value
        const manifest = this._getCurrentManifest()
        this._applyColorVariant(variant, manifest)
        this._updateModeSection(manifest, variant)

        // Apply default mode for new variant
        const defaultMode = this._getDefaultMode(manifest, variant)
        this._applyThemeMode(defaultMode)
        const modeSel = this.el.querySelector("[data-setting='theme-mode']")
        if (modeSel) modeSel.value = defaultMode
      })
    }

    // Mode change
    const modeSel = this.el.querySelector("[data-setting='theme-mode']")
    if (modeSel) {
      modeSel.addEventListener("change", () => {
        const mode = this._resolveThemeMode(modeSel.value)
        this._applyThemeMode(mode)
      })
    }

    // All other data-setting controls (font-size, font-family, checkboxes, selects)
    this.el.querySelectorAll("[data-setting]").forEach((control) => {
      const key = control.dataset.setting
      if (["theme", "theme-mode", "color-variant"].includes(key)) return

      control.addEventListener("change", () => {
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
}
