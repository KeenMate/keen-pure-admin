/**
 * NavbarSearchDemo — the inline navbar search (search position "A") wired to a
 * small demo dataset, with a live results dropdown independent of the Ctrl+K
 * command palette.
 *
 * DEMO behaviour only: keen ships the markup + CSS (`.pc-navbar-search--field`
 * + `.pa-search-autocomplete` via `navbar_search_field/1`); a real app wires the
 * results to its own API/router (e.g. `phx-keyup="search"` + a `:results` slot).
 * Here we filter a static list client-side, mirroring pure-admin's
 * `demo/js/navbar-search.js` but as a LiveView hook so its listeners are tied to
 * the input's mount/destroy lifecycle.
 *
 * Attach to the INPUT (rest is forwarded there by `navbar_search_field/1`):
 *   <.navbar_search_field id="navbarSearchInline" phx-hook="NavbarSearchDemo" ... />
 */

// Demo dataset — pages, products, people, orders. A real app would query a
// backend; the shape (name + type + icon [+ href]) is all the popup needs.
const DATA = [
  { name: "Dashboard", type: "Page", icon: "📊", href: "/" },
  { name: "Getting Started", type: "Page", icon: "🚀", href: "/getting-started" },
  { name: "Command Palette", type: "Page", icon: "⌨️", href: "/components/command-palette" },
  { name: "Tables", type: "Page", icon: "📋", href: "/tables/standard" },
  { name: "Alerts", type: "Page", icon: "🔔", href: "/components/alerts" },
  { name: "Fit to Size", type: "Page", icon: "↔️", href: "/components/fit-to-size" },
  { name: "MacBook Pro 16\"", type: "Product", icon: "💻", href: "#" },
  { name: "iPhone 15 Pro", type: "Product", icon: "📱", href: "#" },
  { name: "AirPods Pro", type: "Product", icon: "🎧", href: "#" },
  { name: "Apple Watch Ultra", type: "Product", icon: "⌚", href: "#" },
  { name: "John Doe", type: "User", icon: "👤", href: "#" },
  { name: "Jane Smith", type: "User", icon: "👤", href: "#" },
  { name: "Order #1001", type: "Order", icon: "📦", href: "#" },
  { name: "Invoice #INV-501", type: "Invoice", icon: "📄", href: "#" },
]

function highlight(text, query) {
  const q = query.trim()
  if (!q) return text
  const re = new RegExp("(" + q.replace(/[.*+?^${}()|[\]\\]/g, "\\$&") + ")", "ig")
  return text.replace(re, "<mark>$1</mark>")
}

export const NavbarSearchDemo = {
  mounted() {
    const input = this.el
    const field = input.closest(".pc-navbar-search--field")
    const results = field && field.querySelector(".pa-search-autocomplete")
    if (!results) return

    this._matches = []
    this._activeIndex = -1
    this._timer = null

    const debounceDelay =
      (window.pureAdmin && window.pureAdmin.config && window.pureAdmin.config.typingDebounceDelay) || 300

    const open = () => { results.hidden = false }
    const close = () => { results.hidden = true; this._activeIndex = -1 }

    const filter = (query) => {
      const q = query.trim().toLowerCase()
      if (!q) return []
      return DATA.filter((d) => d.name.toLowerCase().includes(q)).slice(0, 8)
    }

    const render = (query) => {
      if (this._matches.length === 0) {
        results.innerHTML = '<div class="pa-search-autocomplete__empty">No results found</div>'
        open()
        return
      }
      results.innerHTML = this._matches
        .map((d, i) => (
          '<div class="pa-search-autocomplete__item' + (i === this._activeIndex ? " pa-search-autocomplete__item--active" : "") + '" data-index="' + i + '">' +
            '<span class="pa-search-autocomplete__item-icon" aria-hidden="true">' + d.icon + "</span>" +
            '<span class="pa-search-autocomplete__item-name">' + highlight(d.name, query) + "</span>" +
            '<span class="pa-search-autocomplete__item-type">' + d.type + "</span>" +
          "</div>"
        ))
        .join("")
      open()
      results.querySelectorAll(".pa-search-autocomplete__item").forEach((el) => {
        el.addEventListener("mousedown", (e) => {
          e.preventDefault() // keep focus in the input
          select(parseInt(el.dataset.index, 10))
        })
      })
    }

    const select = (index) => {
      const item = this._matches[index]
      if (!item) return
      close()
      if (item.href && item.href !== "#") {
        window.location.href = item.href
      } else {
        input.value = item.name
      }
    }

    const search = () => {
      const query = input.value
      this._matches = filter(query)
      this._activeIndex = this._matches.length > 0 ? 0 : -1
      if (!query.trim()) { close(); return }
      render(query)
    }

    this._onInput = () => {
      if (this._timer) clearTimeout(this._timer)
      this._timer = setTimeout(search, debounceDelay)
    }
    this._onFocus = () => {
      if (input.value.trim() && this._matches.length) open()
    }
    this._onKeydown = (e) => {
      if (results.hidden) return
      switch (e.key) {
        case "ArrowDown":
          e.preventDefault()
          this._activeIndex = Math.min(this._activeIndex + 1, this._matches.length - 1)
          render(input.value)
          break
        case "ArrowUp":
          e.preventDefault()
          this._activeIndex = Math.max(this._activeIndex - 1, 0)
          render(input.value)
          break
        case "Enter":
          e.preventDefault()
          if (this._activeIndex >= 0) select(this._activeIndex)
          break
        case "Escape":
          e.preventDefault()
          close()
          break
      }
    }
    // Close when clicks land outside the field.
    this._onDocClick = (e) => {
      if (field && !field.contains(e.target)) close()
    }

    input.addEventListener("input", this._onInput)
    input.addEventListener("focus", this._onFocus)
    input.addEventListener("keydown", this._onKeydown)
    document.addEventListener("click", this._onDocClick)
  },

  destroyed() {
    if (this._timer) clearTimeout(this._timer)
    if (this._onInput) this.el.removeEventListener("input", this._onInput)
    if (this._onFocus) this.el.removeEventListener("focus", this._onFocus)
    if (this._onKeydown) this.el.removeEventListener("keydown", this._onKeydown)
    if (this._onDocClick) document.removeEventListener("click", this._onDocClick)
  },
}
