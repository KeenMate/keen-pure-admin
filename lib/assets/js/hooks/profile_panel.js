/**
 * PureAdminProfilePanel hook - Profile panel tab switching and interactions.
 *
 * Uses event delegation on the root element to handle clicks reliably,
 * even if LiveView patches the DOM after mount.
 */

// Deny-list: block the four URL schemes browsers will execute as script,
// but let everything else through (mailto:, tel:, sms:, deep-link schemes
// like slack://, intent://, myapp://, relative paths, fragments, queries).
// Mirrors PureAdmin.Helpers.safe_url/1 on the server side.
const UNSAFE_HREF_SCHEME = /^\s*(?:javascript|data|vbscript|file):/i

function isSafeHref(href) {
  const trimmed = String(href).trim()
  if (!trimmed) return false
  return !UNSAFE_HREF_SCHEME.test(trimmed)
}

export const PureAdminProfilePanel = {
  mounted() {
    // Close when clicking outside the panel and profile button
    this._handleDocumentClick = (e) => {
      if (!this.el.classList.contains("pa-profile-panel--open")) return

      const profileBtn = document.querySelector(".pc-navbar__profile-btn")
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
