# keen_pure_admin — a server-rendered admin component library for Phoenix LiveView

Hi everyone 👋

We just want to share **[keen_pure_admin](https://hex.pm/packages/keen_pure_admin)**, a Phoenix LiveView component library that wraps the [Pure Admin](https://github.com/KeenMate/pure-admin) CSS framework into ~40 function components + LiveComponents. It's a **drop-in replacement for the generated `CoreComponents`** — you swap one `import` for `use PureAdmin.Components` and get `button/1`, `input/1`, `table/1`, `modal/1`, `flash/1`, plus cards, tabs, stats, KPI tiles, splitters, command palette, toasts, and more.

- **Demo:** https://elixir.demo.pureadmin.io
- **Themes & showcase:** https://pureadmin.io
- **Docs:** https://hexdocs.pm/keen_pure_admin

## Motivation

We build a lot of admin/back-office apps, and we were tired of two things: rebuilding the same navbar/sidebar/table/modal chrome in every project, and shipping a big client-side framework just to get a polished dashboard. Pure Admin already gave us a mature, themeable BEM CSS framework (multiple themes, light/dark, a settings panel, KPI widgets). What was missing was a **first-class Elixir binding** so we could write `<.card>` / `<.stat>` / `<.splitter>` in HEEx instead of hand-copying `class="pa-card__header..."` snippets and wiring the JS by hand. That's what this library is.

## How it works

It's deliberately boring in the best way: **components render plain BEM HTML on the server**. No VDOM, no client framework, no build-time component compiler. A `<.button variant="primary" size="lg">` just produces `<button class="pa-btn pa-btn--primary pa-btn--lg">`. Everything that *can* be CSS-only is CSS-only; server state (command palette, toast service, dialogs) lives in LiveComponents; and interactive widgets get a small JS hook.

Setup is: `use PureAdmin.Components`, register `PureAdminHooks` on your LiveSocket, drop in a theme CSS file, done. All strings are translatable through a runtime callback (Gettext, DB, ETS — your choice), and it ships **strict-CSP-clean** (no inline `onclick=`/`<script>`; behaviour is delegated events via `initPureAdminEvents()`), so you can run `script-src 'self'`.

## How it differs from live_svelte

`live_svelte` (which is great!) renders **Svelte components on the client** and bridges props/state across the LiveView socket — you're running a JS UI framework, and your components live in `.svelte` files. `keen_pure_admin` is the opposite philosophy: **the markup is HEEx, rendered server-side, and there is no UI framework on the client.** You author in Elixir, diffs flow through LiveView the normal way, and the only JS is a handful of thin behavioural hooks. If you want a reactive JS component model, reach for `live_svelte`. If you want "Phoenix all the way down" with a batteries-included admin design system, this is that.

(For the record, we do maintain a parallel Svelte binding of the same design system — so the Elixir and Svelte components are kept 1:1 on prop names, which keeps mental context-switching cheap for mixed teams.)

## Proxying & guarding — the interesting part

The tricky bit with an established CSS framework is that some widgets (splitter drag, multi-range filter, auto-collapsing toolbars, fit-to-box stats) ship with **vanilla JS that knows nothing about LiveView**. We handle that with two patterns:

- **Proxying.** We port the upstream widget JS *verbatim* as a `*_core.js` file (e.g. `splitter_core.js` is ~1300 lines copied straight from pure-admin, so upstream syncs are a plain file copy). The Phoenix hook is then a thin proxy that bridges the vanilla `window.PaSplitter.init(el)` API into LiveView's `mounted()` / `updated()` / `destroyed()` lifecycle. Upstream's init is idempotent, so re-running it on a LiveView patch is safe.
- **Guarding.** When a widget mutates its own DOM (the splitter writes `flex-basis`, the range-group reparents a floating panel to `<body>`), we mark that subtree with `phx-update="ignore"` so LiveView's diffing **doesn't clobber the JS-applied state**. Dynamic content flows in through nested `live_component`/`live_render` instead. We also guard the *inputs*: `safe_url/2` deny-lists `javascript:`/`data:`/`vbscript:` on every link-bearing component, and localStorage/CSS-length values are allow-listed before they're ever concatenated into markup.

## Performance work

A few things we did specifically to keep it fast and flicker-free:

- **No client framework runtime** to download, parse, or hydrate — you ship CSS + a few KB of hooks.
- **Theme changes recolor without re-rendering.** SVG sparklines and sentiment deltas inherit `currentColor`, so a light↔dark flip or theme swap recolors live via CSS. We also emit a `pa:theme-change` event so canvas-based charts (Chart.js/ECharts/D3) can re-sample colors in place instead of being rebuilt.
- **Page Context** — server-rendered JSON in a hidden input, read synchronously by JS. No API round-trip on load, and it's CSP-safe.
- **FOUC killed at the source** — the framework now emits neutral `--pa-*` variable defaults at `:root`, so nothing renders near-black during the window before the theme stylesheet resolves.
- **Cheap interactions** — drag handlers are `requestAnimationFrame`-throttled, fit/collapse widgets use `ResizeObserver`/`IntersectionObserver` rather than polling, and the categorized logger is **silent by default with zero overhead in production**.

We'd love feedback — especially from anyone weighing server-rendered vs. client-framework component libraries for admin UIs. Happy to answer questions here. 🙏
