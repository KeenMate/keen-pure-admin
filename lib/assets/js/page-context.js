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
 * Cached after first read. Always returns a plain object:
 *
 * - missing hidden input   → `{}`
 * - invalid JSON           → `{}` (warning logged)
 * - non-object JSON value  → `{}` (warning logged)
 *
 * This lets callers do `getPageContext().someKey` without a defensive
 * `typeof`/null-check at every site and makes sure a malformed server
 * payload can't e.g. become an array whose `.length` collides with a
 * downstream expectation.
 */
export function getPageContext() {
  if (_cache !== null) return _cache
  const el = document.getElementById('pa-page-context')
  if (!el) { _cache = {}; return _cache }

  let parsed
  try {
    parsed = JSON.parse(el.value)
  } catch (err) {
    console.warn('[PureAdmin] #pa-page-context: JSON parse failed, falling back to {}', err)
    _cache = {}
    return _cache
  }

  // Accept only plain objects. Arrays, numbers, strings, null — all invalid.
  if (parsed === null || typeof parsed !== 'object' || Array.isArray(parsed)) {
    console.warn('[PureAdmin] #pa-page-context: expected JSON object, got', parsed)
    _cache = {}
    return _cache
  }

  _cache = parsed
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
