/**
 * PureAdminKpiChart - Chart.js drop-in for the KPI showcase chart slot.
 *
 * Demo-only helper. Mirrors pure-admin's `demo/js/kpi-chartjs-examples.js`
 * but rewired as a per-canvas LiveView hook so chart instances are tied to
 * the canvas's mount/destroy lifecycle (not a global DOMContentLoaded
 * scan).
 *
 * Mount on `<canvas data-kpi-chart>`. The hook reads the canvas's resolved
 * `color` (the KPI sentiment cascade sets `color: var(--pa-positive)`
 * etc. on the chart wrapper) and renders a Chart.js bar or line chart in
 * that colour. Re-renders on the `pa:theme-change` window event.
 *
 * Data attributes on the canvas:
 *   data-kpi-chart            marker — required
 *   data-kpi-type="bar"       "bar" (default) | "line" | "stacked-bar" | "doughnut"
 *   data-kpi-points="[...]"   single series: JSON array of numbers, e.g. "[4, 7, 6, 9]"
 *                             multi-series: array of arrays, e.g. "[[4,7,6],[3,5,8]]"
 *                             (required for stacked-bar; first series only for line / bar)
 *   data-kpi-fill="area"      "area" (default) or "line" (line type only)
 *   data-kpi-aspect="8"       width:height ratio (default 8)
 *   data-kpi-labels='["W1"]'  optional x-axis labels (mostly cosmetic — axes are hidden)
 *
 * Requires Chart.js loaded globally as `window.Chart`. No-op without it.
 */

// Opacities for cascade-coloured multi-series charts. Layered above
// currentColor at decreasing strength so each series reads distinctly while
// still inheriting the host's sentiment / theme cascade.
const SERIES_OPACITY = [0.95, 0.65, 0.42, 0.25, 0.15]

function resolveRgb(canvas) {
  const computed = getComputedStyle(canvas).color
  const m = computed.match(/(\d+(?:\.\d+)?)/g)
  if (!m || m.length < 3) return [59, 130, 246] // #3b82f6 fallback
  return [+m[0], +m[1], +m[2]]
}

function rgba(rgb, a) {
  return `rgba(${rgb[0]}, ${rgb[1]}, ${rgb[2]}, ${a})`
}

function readPoints(canvas) {
  try {
    const parsed = JSON.parse(canvas.dataset.kpiPoints || "[]")
    if (Array.isArray(parsed) && parsed.length) {
      // Flatten array-of-arrays to the first series for single-series chart types.
      return Array.isArray(parsed[0]) ? parsed[0] : parsed
    }
  } catch (_) { /* fall through */ }
  return [4, 7, 6, 9, 8, 11, 10, 13, 12, 15, 14, 17]
}

function readSeries(canvas) {
  try {
    const parsed = JSON.parse(canvas.dataset.kpiPoints || "[]")
    if (Array.isArray(parsed) && parsed.length) {
      return Array.isArray(parsed[0]) ? parsed : [parsed]
    }
  } catch (_) { /* fall through */ }
  return [[4, 7, 6, 9], [3, 5, 4, 6], [2, 3, 5, 4]]
}

function readLabels(canvas, length) {
  try {
    const parsed = JSON.parse(canvas.dataset.kpiLabels || "null")
    if (Array.isArray(parsed)) return parsed
  } catch (_) { /* fall through */ }
  return Array.from({ length }, (_, i) => i)
}

function baseOptions(aspect, yScale) {
  yScale.display = false
  return {
    responsive: true,
    maintainAspectRatio: true,
    aspectRatio: aspect,
    animation: false,
    layout: { padding: 4 },
    plugins: {
      legend: { display: false },
      tooltip: { enabled: false },
    },
    scales: {
      x: { display: false, grid: { display: false } },
      y: yScale,
    },
    elements: {
      line: { borderCapStyle: "round", borderJoinStyle: "round" },
    },
  }
}

function barConfig(points, rgb, aspect) {
  const last = points.length - 1
  const lo = Math.min(...points)
  const hi = Math.max(...points)
  const pad = (hi - lo) * 0.35 || hi * 0.1 || 1
  return {
    type: "bar",
    data: {
      labels: points.map((_, i) => i),
      datasets: [{
        data: points,
        backgroundColor: points.map((_, i) => i === last ? rgba(rgb, 0.95) : rgba(rgb, 0.42)),
        borderWidth: 0,
        borderRadius: 2,
        categoryPercentage: 0.82,
        barPercentage: 0.92,
      }],
    },
    options: baseOptions(aspect, { min: lo - pad }),
  }
}

function stackedBarConfig(series, rgb, aspect, labels) {
  return {
    type: "bar",
    data: {
      labels,
      datasets: series.map((data, i) => ({
        data,
        backgroundColor: rgba(rgb, SERIES_OPACITY[i % SERIES_OPACITY.length]),
        borderWidth: 0,
        borderRadius: 2,
        categoryPercentage: 0.82,
        barPercentage: 0.92,
        stack: "main",
      })),
    },
    options: {
      responsive: true,
      maintainAspectRatio: true,
      aspectRatio: aspect,
      animation: false,
      layout: { padding: 4 },
      plugins: { legend: { display: false }, tooltip: { enabled: false } },
      scales: {
        x: { display: false, grid: { display: false }, stacked: true },
        y: { display: false, stacked: true, beginAtZero: true },
      },
    },
  }
}

function doughnutConfig(points, rgb, aspect) {
  return {
    type: "doughnut",
    data: {
      labels: points.map((_, i) => i),
      datasets: [{
        data: points,
        backgroundColor: points.map((_, i) => rgba(rgb, SERIES_OPACITY[i % SERIES_OPACITY.length])),
        borderWidth: 0,
        spacing: 2,
      }],
    },
    options: {
      responsive: true,
      maintainAspectRatio: true,
      aspectRatio: aspect,
      animation: false,
      cutout: "62%",
      layout: { padding: 4 },
      plugins: { legend: { display: false }, tooltip: { enabled: false } },
    },
  }
}

function lineConfig(points, rgb, aspect, isArea) {
  const last = points.length - 1
  return {
    type: "line",
    data: {
      labels: points.map((_, i) => i),
      datasets: [{
        data: points,
        borderColor: rgba(rgb, 1),
        backgroundColor: isArea ? rgba(rgb, 0.15) : "transparent",
        fill: isArea,
        borderWidth: 2,
        tension: 0.35,
        pointRadius: points.map((_, i) => i === last ? 3 : 0),
        pointBackgroundColor: rgba(rgb, 1),
        pointBorderColor: rgba(rgb, 1),
      }],
    },
    options: baseOptions(aspect, { grace: "15%" }),
  }
}

export const PureAdminKpiChart = {
  mounted() {
    if (typeof window.Chart === "undefined") return
    this._build()
    this._themeHandler = () => this._recolor()
    window.addEventListener("pa:theme-change", this._themeHandler)
  },

  destroyed() {
    if (this._themeHandler) window.removeEventListener("pa:theme-change", this._themeHandler)
    if (this._chart) {
      this._chart.destroy()
      this._chart = null
    }
  },

  _build() {
    const canvas = this.el
    const type = canvas.dataset.kpiType || "bar"
    const aspect = parseFloat(canvas.dataset.kpiAspect) || 8
    const rgb = resolveRgb(canvas)
    const isArea = (canvas.dataset.kpiFill || "area") === "area"

    let config
    if (type === "line") {
      config = lineConfig(readPoints(canvas), rgb, aspect, isArea)
    } else if (type === "stacked-bar") {
      const series = readSeries(canvas)
      const labels = readLabels(canvas, series[0].length)
      config = stackedBarConfig(series, rgb, aspect, labels)
    } else if (type === "doughnut") {
      config = doughnutConfig(readPoints(canvas), rgb, aspect)
    } else {
      config = barConfig(readPoints(canvas), rgb, aspect)
    }

    this._chart = new window.Chart(canvas, config)
    this._type = type
  },

  _recolor() {
    if (!this._chart) return
    const rgb = resolveRgb(this.el)
    const datasets = this._chart.data.datasets

    if (this._type === "line") {
      const ds = datasets[0]
      const isArea = ds.fill === true
      ds.borderColor = rgba(rgb, 1)
      ds.backgroundColor = isArea ? rgba(rgb, 0.15) : "transparent"
      ds.pointBackgroundColor = rgba(rgb, 1)
      ds.pointBorderColor = rgba(rgb, 1)
    } else if (this._type === "stacked-bar") {
      datasets.forEach((ds, i) => {
        ds.backgroundColor = rgba(rgb, SERIES_OPACITY[i % SERIES_OPACITY.length])
      })
    } else if (this._type === "doughnut") {
      const ds = datasets[0]
      ds.backgroundColor = ds.data.map((_, i) => rgba(rgb, SERIES_OPACITY[i % SERIES_OPACITY.length]))
    } else {
      const ds = datasets[0]
      const last = ds.data.length - 1
      ds.backgroundColor = ds.data.map((_, i) => i === last ? rgba(rgb, 0.95) : rgba(rgb, 0.42))
    }

    this._chart.update()
  },
}
