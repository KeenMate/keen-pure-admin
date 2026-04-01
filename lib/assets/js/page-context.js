/**
 * Page Context — reads server-rendered JSON from a hidden input.
 *
 * The server renders a hidden input with id="pa-page-context" containing
 * a JSON blob. JS reads it synchronously — no API fetch needed.
 *
 * Usage:
 *   import { getPageContext, getContextValue } from "keen_pure_admin"
 *
 *   const ctx = getPageContext()          // full context object
 *   const manifests = getContextValue("themeManifests")  // single key
 */

let _cache = null

/**
 * Returns the full page context object.
 * Cached after first read.
 */
export function getPageContext() {
  if (_cache !== null) return _cache
  const el = document.getElementById('pa-page-context')
  if (!el) { _cache = {}; return _cache }
  try {
    _cache = JSON.parse(el.value)
  } catch {
    _cache = {}
  }
  return _cache
}

/**
 * Returns a single value from the page context.
 */
export function getContextValue(key) {
  return getPageContext()[key]
}

/**
 * Clears the cache — useful after LiveView navigation when the
 * hidden input might be updated.
 */
export function clearContextCache() {
  _cache = null
}
