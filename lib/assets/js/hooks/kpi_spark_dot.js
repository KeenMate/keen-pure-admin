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
 * Mount on the `.kpi-tile__spark` SVG itself. On init, the hook:
 *   1. Reads `cx`/`cy` from the existing `<circle>` (and the SVG's
 *      viewBox) to compute the dot position as percentages.
 *   2. Wraps the SVG in a `.kpi-tile__spark-wrap` span (position: relative)
 *      so the dot can be absolutely positioned against it.
 *   3. Appends a `.kpi-spark-dot` span at the percentage position.
 *   4. Removes the original SVG circle.
 *
 * Idempotent: if the parent is already `.kpi-tile__spark-wrap`, the hook
 * reuses it.
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
    // so the dot can be absolutely anchored.
    let wrap = svg.parentElement
    if (!wrap || !wrap.classList.contains('kpi-tile__spark-wrap')) {
      const newWrap = document.createElement('span')
      newWrap.className = 'kpi-tile__spark-wrap'
      svg.parentElement.insertBefore(newWrap, svg)
      newWrap.appendChild(svg)
      wrap = newWrap
    }

    // Remove any stale dot from a previous run (idempotency under updated()).
    const stale = wrap.querySelector('.kpi-spark-dot')
    if (stale) stale.remove()

    const dot = document.createElement('span')
    dot.className = 'kpi-spark-dot'
    dot.style.left = xPct + '%'
    dot.style.top = yPct + '%'
    wrap.appendChild(dot)

    circle.remove()
  },
}
