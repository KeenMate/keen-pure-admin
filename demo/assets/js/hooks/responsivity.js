/**
 * Demo hooks for the Responsivity pages (`/responsivity`, `/components/fit-to-size`).
 *
 * These are DEMO-ONLY glue — the framework engines (fit.js, container-breakpoint.js)
 * ship vendored in keen and are reused here via their public APIs. The hooks below
 * only drive the demo scaffolding: the width sliders, the two Chart.js sparklines,
 * the custom card tab switching, and the Container-Breakpoint "build a chart on
 * demand + log every flip" example. The fit engine itself is wired with the shared
 * `PureAdminNavFit` hook (it inits fit on any `[data-pc-fit-auto]` / `[data-pc-fit]`
 * container, not just the navbar).
 */

// ── StageWidth ──────────────────────────────────────────────────────────────
// Attach to a `<input type="range">`. Drives a "stage" element's max-width from
// the slider value, and mirrors the value into an `<output>`. Replaces the demo's
// old inline `oninput=` handlers (LiveView owns the DOM, so we use a hook).
//   data-stage  = id of the element whose max-width the slider controls
//   data-output = id of the <output> to write "<value>px" into (optional)
export const StageWidth = {
  mounted() {
    this.stage = document.getElementById(this.el.dataset.stage)
    this.output = this.el.dataset.output ? document.getElementById(this.el.dataset.output) : null
    this._apply = () => {
      const w = this.el.value
      if (this.stage) this.stage.style.maxWidth = w + "px"
      if (this.output) this.output.textContent = w + "px"
    }
    this.el.addEventListener("input", this._apply)
    this._apply()
  },
  destroyed() {
    if (this._apply) this.el.removeEventListener("input", this._apply)
  }
}

// ── FitSparkline ────────────────────────────────────────────────────────────
// Attach to a `<canvas>`. Renders a small Chart.js line sparkline in the theme
// accent colour. Used by Fit-to-Size example 2 (chart ↔ KPI container query).
//   data-points = JSON array of numbers
function accentColor() {
  return (getComputedStyle(document.documentElement).getPropertyValue("--pc-accent") || "#3b82f6").trim()
}

function sparklineConfig(points) {
  return {
    type: "line",
    data: {
      labels: points.map((_, i) => i),
      datasets: [{
        data: points,
        borderColor: accentColor(),
        backgroundColor: "rgba(59, 130, 246, 0.12)",
        fill: true, tension: 0.4, pointRadius: 0, borderWidth: 2
      }]
    },
    options: {
      responsive: true, maintainAspectRatio: false,
      plugins: { legend: { display: false }, tooltip: { enabled: false } },
      scales: { x: { display: false }, y: { display: false } }
    }
  }
}

export const FitSparkline = {
  mounted() {
    if (typeof window.Chart === "undefined") return
    let points
    try { points = JSON.parse(this.el.dataset.points || "[]") } catch (_) { points = [] }
    if (!points.length) points = [612, 640, 606, 701, 760, 803, 847]
    this._chart = new window.Chart(this.el, sparklineConfig(points))
  },
  destroyed() {
    if (this._chart) { this._chart.destroy(); this._chart = null }
  }
}

// ── CardTabs ────────────────────────────────────────────────────────────────
// Attach to a product card. Wires click-to-switch on `.pa-tabs__item` buttons
// scoped to this card, toggling both the active tab and the matching panel.
// The container query / engine hides the tab strip wholesale in the wide (grid)
// mode where every panel is shown, so this only matters in the tabbed modes.
//   data-panel-class = the panel BEM base (e.g. "prod__panel"); active class is
//                      "<base>--active"
export const CardTabs = {
  mounted() {
    const base = this.el.dataset.panelClass
    this._onClick = (e) => {
      const btn = e.target.closest(".pa-tabs__item")
      if (!btn || !this.el.contains(btn)) return
      const panel = btn.getAttribute("data-panel")
      this.el.querySelectorAll(".pa-tabs__item").forEach((t) =>
        t.classList.toggle("pa-tabs__item--active", t === btn))
      this.el.querySelectorAll("." + base).forEach((p) =>
        p.classList.toggle(base + "--active", p.getAttribute("data-panel") === panel))
    }
    this.el.addEventListener("click", this._onClick)
  },
  destroyed() {
    if (this._onClick) this.el.removeEventListener("click", this._onClick)
  }
}

// ── FitToSizeEx4 ────────────────────────────────────────────────────────────
// Attach to the engine-driven product card (Fit-to-Size example 4). Drives the
// Container Breakpoint engine via its `observe(el, opts, cb)` API — which toggles
// `.d-none` on `[data-pc-show]` pieces and reflects `[data-mode]` — and uses the
// per-flip callback to BUILD the hero revenue Chart.js instance only in `grid`
// mode and DESTROY it otherwise (mount on demand), logging every flip. Also owns
// this card's tab switching (same behaviour as CardTabs) since a node can carry
// only one phx-hook.
//   data-breakpoints = JSON thresholds, e.g. {"icons":0,"tabs":34,"grid":64}
//   data-chart       = id of the <canvas> for the hero chart
//   data-log         = id of the log container
//   data-panel-class = panel BEM base (e.g. "prodx__panel")
function cbApi() {
  const pa = window.pureAdmin && window.pureAdmin.components && window.pureAdmin.components.containerBreakpoint
  if (pa) return pa
  return window.pureCss && window.pureCss.components && window.pureCss.components.containerBreakpoint
}

export const FitToSizeEx4 = {
  mounted() {
    const card = this.el
    const logEl = document.getElementById(card.dataset.log)
    const base = card.dataset.panelClass
    let chart = null
    let builds = 0

    const log = (msg) => {
      if (!logEl) return
      const line = document.createElement("div")
      line.textContent = msg
      logEl.insertBefore(line, logEl.firstChild)
    }

    const buildChart = () => {
      const canvas = document.getElementById(card.dataset.chart)
      if (!canvas || !window.Chart) return null
      return new window.Chart(canvas, sparklineConfig([612, 640, 606, 701, 760, 803, 847]))
    }

    // Tab switching, scoped to this card (see CardTabs).
    this._onClick = (e) => {
      const btn = e.target.closest(".pa-tabs__item")
      if (!btn || !card.contains(btn)) return
      const panel = btn.getAttribute("data-panel")
      card.querySelectorAll(".pa-tabs__item").forEach((t) =>
        t.classList.toggle("pa-tabs__item--active", t === btn))
      card.querySelectorAll("." + base).forEach((p) =>
        p.classList.toggle(base + "--active", p.getAttribute("data-panel") === panel))
    }
    card.addEventListener("click", this._onClick)

    log("waiting — the revenue Chart.js instance is NOT built until the card reaches grid mode (~640px)")

    const api = cbApi()
    if (!api || typeof api.observe !== "function") return

    let steps
    try { steps = JSON.parse(card.dataset.breakpoints || "{}") } catch (_) { steps = { icons: 0, tabs: 34, grid: 64 } }

    this._destroyChart = () => { if (chart) { chart.destroy(); chart = null } }

    this._handle = api.observe(
      card,
      { steps: steps, unit: "rem", attribute: "data-mode", initial: "tabs", hiddenClass: "d-none" },
      (mode, _prev, detail) => {
        const w = Math.round(detail.width)
        log("mode → " + mode + " (card " + w + "px)")
        if (mode === "grid") {
          if (!chart) {
            chart = buildChart()
            if (chart) { builds++; log("  ▶ built revenue chart instance #" + builds) }
          }
        } else if (chart) {
          chart.destroy()
          chart = null
          log("  ✕ destroyed chart (not grid mode)")
        }
      }
    )
  },
  destroyed() {
    if (this._onClick) this.el.removeEventListener("click", this._onClick)
    if (this._handle && typeof this._handle.destroy === "function") this._handle.destroy()
    if (this._destroyChart) this._destroyChart()
  }
}
