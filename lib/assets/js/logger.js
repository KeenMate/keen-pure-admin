/**
 * PureAdmin Logger — categorized, color-coded, silent by default.
 *
 * Follows the KeenMate logging convention (web-daterangepicker, web-multiselect):
 * - Category-based loggers with PA: prefix
 * - Color-coded output (debug=blue, info=green, warn=orange, error=red)
 * - Silent by default (zero overhead in production)
 * - Runtime enable/disable via window or exported API
 *
 * Usage in hooks:
 *   import { createLogger } from '../logger'
 *   const log = createLogger('SETTINGS')
 *   log.debug('Manifests loaded:', manifests)
 *
 * Browser console:
 *   PureAdmin.logging.enableLogging()
 *   PureAdmin.logging.setCategoryLevel('PA:SETTINGS', 'debug')
 *   PureAdmin.logging.getCategories()
 */

const COLORS = {
  debug: '#0ea5e9',
  info: '#10b981',
  warn: '#f59e0b',
  error: '#ef4444'
}

const LEVELS = { debug: 1, info: 2, warn: 3, error: 4, silent: 5 }

let globalLevel = (typeof localStorage !== 'undefined' && localStorage.getItem('pa-log-level')) || 'silent'
const categoryLevels = {}
const categories = new Set()

function shouldLog(category, level) {
  const catLevel = categoryLevels[category] || globalLevel
  return LEVELS[level] >= LEVELS[catLevel]
}

function timestamp() {
  const d = new Date()
  return d.toTimeString().slice(0, 8) + '.' + String(d.getMilliseconds()).padStart(3, '0')
}

function makeLogFn(category, level) {
  return (...args) => {
    if (!shouldLog(category, level)) return
    const color = COLORS[level] || '#999'
    const prefix = `%c[${timestamp()}] [${level.toUpperCase()}] [${category}]`
    const style = `color: ${color}; font-weight: bold;`
    console[level === 'debug' ? 'debug' : level](prefix, style, ...args)
  }
}

/**
 * Creates a categorized logger.
 * @param {string} name - Category name (e.g., 'SETTINGS', 'TOAST', 'FLASH')
 * @returns Logger object with debug/info/warn/error methods
 */
export function createLogger(name) {
  const category = `PA:${name}`
  categories.add(category)

  return {
    debug: makeLogFn(category, 'debug'),
    info: makeLogFn(category, 'info'),
    warn: makeLogFn(category, 'warn'),
    error: makeLogFn(category, 'error')
  }
}

/** Set global log level for all categories. */
export function setLogLevel(level) {
  if (LEVELS[level] !== undefined) globalLevel = level
}

/** Set log level for a specific category. */
export function setCategoryLevel(category, level) {
  if (LEVELS[level] !== undefined) categoryLevels[category] = level
}

/** Enable all logging (sets global level to 'debug'). Persists across page reloads. */
export function enableLogging() {
  globalLevel = 'debug'
  localStorage.setItem('pa-log-level', 'debug')
  console.info('%c[PureAdmin] Logging enabled (persistent)', 'color: #10b981; font-weight: bold;')
}

/** Disable all logging (sets global level to 'silent'). Clears persistence. */
export function disableLogging() {
  globalLevel = 'silent'
  localStorage.removeItem('pa-log-level')
}

/** Get list of registered categories. */
export function getCategories() {
  return [...categories]
}

// Expose on window for browser console access (KeenMate convention)
if (typeof window !== 'undefined') {
  window.PureAdmin = window.PureAdmin || {}
  window.PureAdmin.logging = {
    enableLogging,
    disableLogging,
    setLogLevel,
    setCategoryLevel,
    getCategories
  }

  // Register in window.components (KeenMate shared convention)
  window.components = window.components || {}
  window.components['keen-pure-admin'] = {
    version: () => '1.0.0-rc.1',
    config: {
      name: 'keen-pure-admin',
      version: '1.0.0-rc.1',
      author: 'KeenMate',
      license: 'MIT',
      repository: 'https://github.com/KeenMate/keen-pure-admin',
      homepage: 'https://pureadmin.io'
    },
    logging: window.PureAdmin.logging
  }
}
