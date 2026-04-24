// If you want to use Phoenix channels, run `mix help phx.gen.channel`
// to get started and then uncomment the line below.
// import "./user_socket.js"

// You can include dependencies in two ways.
//
// The simplest option is to put them in assets/vendor and
// import them using relative paths:
//
//     import "../vendor/some-package.js"
//
// Alternatively, you can `npm install some-package --prefix assets` and import
// them using a path starting with the package name:
//
//     import "some-package"
//
// If you have dependencies that try to import CSS, esbuild will generate a separate `app.css` file.
// To load it, simply add a second `<link>` to your `root.html.heex` file.

// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import "phoenix_html"
// Establish Phoenix Socket and LiveView configuration.
import {Socket} from "phoenix"
import {LiveSocket} from "phoenix_live_view"
import {hooks as colocatedHooks} from "phoenix-colocated/demo"
import {PureAdminHooks, initModalDialogs, initPureAdminEvents} from "../../../lib/assets/js/keen_pure_admin"
import topbar from "../vendor/topbar"

const csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
const liveSocket = new LiveSocket("/live", Socket, {
  longPollFallbackMs: 2500,
  params: {_csrf_token: csrfToken},
  hooks: {...colocatedHooks, ...PureAdminHooks},
})

// Show progress bar on live navigation and form submits
topbar.config({barColors: {0: "#29d"}, shadowColor: "rgba(0, 0, 0, .3)"})
window.addEventListener("phx:page-loading-start", _info => topbar.show(300))
window.addEventListener("phx:page-loading-stop", _info => topbar.hide())

// Initialize PureAdmin programmatic dialogs (confirm/alert/prompt)
initModalDialogs()

// Wire PureAdmin delegated click handlers (popover, popconfirm, badge-group
// expand/collapse, tabs scroll, copy-to-clipboard). Replaces the inline
// onclick handlers previously embedded in component templates, so apps can
// run with strict CSP (`script-src 'self'`) — no `'unsafe-inline'` needed.
initPureAdminEvents()

console.log("[app.js] build:", new Date().toISOString(), "— reset-form listener attached")

// Server -> client: sync a form's inputs to the server's last render.
//
// LiveView intentionally preserves user-typed values across submits so that
// validation errors don't wipe input — which is why `form.reset()` alone
// isn't enough (it reverts to the stale `defaultValue` attribute, not the
// value the server just rendered). Trigger an explicit sync with:
//
//   push_event(socket, "reset-form", %{id: "my-form-id"})
//
// Each input's property is set directly from the server-rendered attribute,
// bypassing LiveView's input preservation so the clear actually lands.
window.addEventListener("phx:reset-form", ({detail}) => {
  console.group("[reset-form] event received", detail)
  const form = detail && detail.id && document.getElementById(detail.id)
  if (!form) {
    console.warn("[reset-form] no element with id:", detail && detail.id)
    console.groupEnd()
    return
  }
  console.log("[reset-form] form element:", form, "tag:", form.tagName)

  form.querySelectorAll("input, textarea").forEach(el => {
    const type = (el.type || "").toLowerCase()
    if (["submit", "reset", "button"].includes(type)) {
      console.log("[reset-form] skip button/submit:", el.name || "(unnamed)", type)
      return
    }
    const attrValue = el.getAttribute("value")
    const beforeProp = el.value
    if (type === "checkbox" || type === "radio") {
      const hasChecked = el.hasAttribute("checked")
      console.log(
        "[reset-form]", el.tagName.toLowerCase(), `(${type})`,
        "name=", el.name,
        "attr[checked]=", hasChecked,
        "before:", el.checked
      )
      el.checked = hasChecked
      console.log("[reset-form] -> after:", el.checked)
    } else {
      console.log(
        "[reset-form]", el.tagName.toLowerCase(), `(${type})`,
        "name=", el.name,
        "attr[value]=", JSON.stringify(attrValue),
        "before prop:", JSON.stringify(beforeProp)
      )
      el.value = attrValue || ""
      console.log("[reset-form] -> after prop:", JSON.stringify(el.value))
    }
  })

  form.querySelectorAll("select").forEach(sel => {
    const selected = sel.querySelector("option[selected]")
    const before = sel.value
    if (selected) {
      sel.value = selected.value
    } else {
      sel.selectedIndex = 0
    }
    console.log(
      "[reset-form] select",
      "name=", sel.name,
      "selected-attr-option=", selected && selected.value,
      "before:", JSON.stringify(before),
      "after:", JSON.stringify(sel.value)
    )
  })
  console.groupEnd()
})

// connect if there are any LiveViews on the page
liveSocket.connect()

// Signal page loader after first LiveView render (not just connect)
window.addEventListener("phx:page-loading-stop", function _firstRender() {
  if (window.__pageLoaderReady) window.__pageLoaderReady()
  window.removeEventListener("phx:page-loading-stop", _firstRender)
}, { once: true })

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket

// The lines below enable quality of life phoenix_live_reload
// development features:
//
//     1. stream server logs to the browser console
//     2. click on elements to jump to their definitions in your code editor
//
if (process.env.NODE_ENV === "development") {
  window.addEventListener("phx:live_reload:attached", ({detail: reloader}) => {
    // Enable server log streaming to client.
    // Disable with reloader.disableServerLogs()
    reloader.enableServerLogs()

    // Open configured PLUG_EDITOR at file:line of the clicked element's HEEx component
    //
    //   * click with "c" key pressed to open at caller location
    //   * click with "d" key pressed to open at function component definition location
    let keyDown
    window.addEventListener("keydown", e => keyDown = e.key)
    window.addEventListener("keyup", _e => keyDown = null)
    window.addEventListener("click", e => {
      if(keyDown === "c"){
        e.preventDefault()
        e.stopImmediatePropagation()
        reloader.openEditorAtCaller(e.target)
      } else if(keyDown === "d"){
        e.preventDefault()
        e.stopImmediatePropagation()
        reloader.openEditorAtDef(e.target)
      }
    }, true)

    window.liveReloader = reloader
  })
}

