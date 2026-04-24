/**
 * PureAdminProfilePanel hook - Profile panel tab switching and interactions.
 *
 * Uses event delegation on the root element to handle clicks reliably,
 * even if LiveView patches the DOM after mount.
 */

// Allows http/https/mailto/tel absolute URLs plus relative paths ("/",
// "./", "../", "?", "#"). Rejects javascript:, data:, vbscript:, file:,
// and anything else that could execute or redirect unexpectedly.
const SAFE_HREF_SCHEME = /^(?:https?:|mailto:|tel:)/i
const UNSAFE_HREF_SCHEME = /^\s*(?:javascript|data|vbscript|file):/i

function isSafeHref(href) {
  const trimmed = String(href).trim()
  if (!trimmed) return false
  if (UNSAFE_HREF_SCHEME.test(trimmed)) return false
  // Absolute URL with allowed scheme.
  if (SAFE_HREF_SCHEME.test(trimmed)) return true
  // Relative path, hash, or query — no scheme means browser resolves
  // against the current origin, which is safe.
  return !/^[a-z][a-z0-9+.-]*:/i.test(trimmed)
}

export const PureAdminProfilePanel = {
  mounted() {
    // Close when clicking outside the panel and profile button
    this._handleDocumentClick = (e) => {
      if (!this.el.classList.contains("pa-profile-panel--open")) return

      const profileBtn = document.querySelector(".pa-header__profile-btn")
      if (
        !this.el.querySelector(".pa-profile-panel__content").contains(e.target) &&
        (!profileBtn || !profileBtn.contains(e.target))
      ) {
        this.el.classList.remove("pa-profile-panel--open")
      }
    }
    document.addEventListener("click", this._handleDocumentClick)

    // Panel internal clicks
    this.el.addEventListener("click", (e) => {
      // Overlay click closes panel
      if (e.target.closest(".pa-profile-panel__overlay")) {
        this.el.classList.remove("pa-profile-panel--open")
        return
      }

      // Close button
      if (e.target.closest(".pa-profile-panel__close")) {
        this.el.classList.remove("pa-profile-panel--open")
        return
      }

      // Tab switching
      const tab = e.target.closest("[data-profile-tab]")
      if (tab) {
        const tabId = tab.dataset.profileTab

        this.el.querySelectorAll("[data-profile-tab]").forEach((t) => {
          t.classList.toggle("pa-tabs__item--active", t.dataset.profileTab === tabId)
        })

        this.el.querySelectorAll("[data-profile-panel]").forEach((p) => {
          p.classList.toggle("pa-tabs__panel--active", p.dataset.profilePanel === tabId)
        })
        return
      }

      // Favorite remove
      const removeBtn = e.target.closest(".pa-profile-panel__favorite-remove")
      if (removeBtn) {
        e.stopPropagation()
        removeBtn.closest("li").remove()
        return
      }

      // Favorite item navigation — scheme-check rejects javascript:/data:/vbscript:
      // so a poisoned `data-href` can't trigger XSS. Only http/https/mailto/tel
      // and same-origin relative paths are allowed through.
      const favoriteItem = e.target.closest(".pa-profile-panel__favorite-item")
      if (favoriteItem) {
        const href = favoriteItem.dataset.href
        if (href && isSafeHref(href)) window.location.href = href
      }
    })
  },

  destroyed() {
    document.removeEventListener("click", this._handleDocumentClick)
  },
}
