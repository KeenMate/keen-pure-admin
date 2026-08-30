/**
 * PureAdminCardActionsOverflow hook — progressive collapse of `<.card>` action
 * buttons into a `[⋮]` "more" menu when the header actions row runs out of
 * space.
 *
 * As of the 2.9.0-rc06 sync this is a THIN wrapper over the shared
 * `overflow_core.js` (`pureAdmin.components.cardActionsOverflow`, same handle as
 * `pureAdmin.components.overflow`). Upstream promoted the original
 * `card-actions-overflow.js` into the generic `overflow.js` primitive, which
 * auto-inits on BOTH `.pa-overflow` and `.pa-card__actions--overflow` and is a
 * strict superset of the old card-only logic: it collapses a nested
 * `.pa-btn-split` as one atomic labeled group (the old standalone impl
 * flattened it and broke it), normalizes `.pa-btn__icon` so menu rows don't
 * zig-zag, and shares one dismissal registry + positioner with the split
 * button. Keeping a separate keen copy would mean re-porting all of that; the
 * wrapper below inherits it for free.
 *
 * `overflow_core.js`'s `init(el)` is idempotent via `__paOverflowInit`, so the
 * DOMContentLoaded auto-init and this hook's `mounted()` can't double-init the
 * same wrapper. `destroyed()` calls the keen-added `destroy(el)` so the
 * body-portal menu / observers are torn down when a card is removed by a diff
 * (upstream never tears down; see `overflow_core.js` header).
 *
 * Wire it by marking the actions wrapper with `pa-card__actions--overflow` +
 * `phx-hook="PureAdminCardActionsOverflow"` — `<.card actions_variant="overflow">`
 * does this automatically.
 *
 * Per-button knob:  data-pa-actions-priority="N"        higher stays longer (default 0)
 * Wrapper knobs:    data-pa-actions-overflow-from        "end" (default) / "start"
 *                   data-pa-overflow-trigger="ghost"     chromeless [⋮] look
 */
import "./overflow_core"

const cardOverflow = () =>
  window.pureAdmin &&
  window.pureAdmin.components &&
  (window.pureAdmin.components.cardActionsOverflow || window.pureAdmin.components.overflow)

function initCardOverflow(el) {
  const o = cardOverflow()
  if (!o) return
  if (typeof o.init === "function") o.init(el)
  else if (typeof o.initAll === "function") o.initAll(el)
}

export const PureAdminCardActionsOverflow = {
  mounted() {
    initCardOverflow(this.el)
  },

  updated() {
    initCardOverflow(this.el)
  },

  destroyed() {
    const o = cardOverflow()
    if (o && typeof o.destroy === "function") o.destroy(this.el)
  }
}
