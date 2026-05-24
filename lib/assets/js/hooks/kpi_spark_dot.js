/**
 * PureAdminKpiSparkDot - Replace an SVG sparkline's trailing <circle> with
 * a CSS-pixel-sized <span> dot.
 *
 * Why: the sparkline SVG uses `preserveAspectRatio="none"` so the polyline
 * stretches to fill arbitrary container widths. That same non-uniform
 * scaling deforms an SVG <circle> into an oval (different X/Y scale
 * factors). Render the trailing dot as a CSS span instead — sized in
 * pixels, so it stays circular regardless of chart aspect ratio.
 *
 * Mount on any sparkline SVG (`.pa-kpi-tile__spark` in Terminal grid; nested
 * SVGs inside `.pa-kpi-spark-row__chart` / `.pa-kpi-hero-main__chart` /
 * `.pa-kpi-bento-tile__chart` in the other showcases). On init, the hook:
 *   1. Reads `cx`/`cy` from the existing `<circle>` (and the SVG's
 *      viewBox) to compute the dot position as percentages.
 *   2. Wraps the SVG in a `.pa-kpi-spark-wrap` span (position: relative)
 *      so the dot can be absolutely positioned against it — UNLESS the SVG's
 *      existing parent is already a tight positioned anchor (positioned +
 *      height within 4px of the SVG itself, e.g. `.pa-kpi-hero-main__chart-svg`).
 *      An extra wrap would break the `height: 100%` chain on the SVG (the
 *      wrap has no explicit height), which combined with
 *      `preserveAspectRatio="none"` + `overflow: visible` lets the polygon
 *      escape its container and stretch across the viewport.
 *   3. Appends a `.pa-kpi-spark-dot` span at the percentage position.
 *   4. Removes the original SVG circle.
 *
 * Idempotent: if the parent is already `.pa-kpi-spark-wrap` (or any other
 * tight positioned anchor), the hook reuses it as the dot host.
 */

export const PureAdminKpiSparkDot = {
  mounted() {
    this._install()
  },

  updated() {
    // If LiveView patched the SVG (new points, new circle), re-run.
    if (this.el.querySelector('circle')) this._install()
  },

  _install() {
    const svg = this.el
    const circle = svg.querySelector('circle')
    if (!circle) return

    const cx = parseFloat(circle.getAttribute('cx'))
    const cy = parseFloat(circle.getAttribute('cy'))
    const vb = svg.viewBox.baseVal
    const xPct = ((cx - vb.x) / vb.width) * 100
    const yPct = ((cy - vb.y) / vb.height) * 100

    // Wrap the SVG in a position:relative span (or reuse an existing wrap)
    // so the dot can be absolutely anchored. Skip wrapping when the parent
    // is already a tight positioned anchor: positioned (non-static) AND
    // height within 4px of the SVG. That lets the SVG keep its `height: 100%`
    // resolving against an explicitly-sized parent — without that, a
    // `preserveAspectRatio="none"` SVG with `overflow: visible` will draw
    // its polygon past the container.
    let wrap = svg.parentElement
    if (!wrap) return
    if (!wrap.classList.contains('pa-kpi-spark-wrap')) {
      const pos = getComputedStyle(wrap).position
      const tightAnchor =
        pos !== 'static' && pos !== '' &&
        Math.abs(wrap.getBoundingClientRect().height - svg.getBoundingClientRect().height) < 4
      if (!tightAnchor) {
        const newWrap = document.createElement('span')
        newWrap.className = 'pa-kpi-spark-wrap'
        wrap.insertBefore(newWrap, svg)
        newWrap.appendChild(svg)
        wrap = newWrap
      }
    }

    // Remove any stale dot from a previous run (idempotency under updated()).
    const stale = wrap.querySelector('.pa-kpi-spark-dot')
    if (stale) stale.remove()

    const dot = document.createElement('span')
    dot.className = 'pa-kpi-spark-dot'
    dot.style.left = xPct + '%'
    dot.style.top = yPct + '%'
    wrap.appendChild(dot)

    circle.remove()
  },
}
