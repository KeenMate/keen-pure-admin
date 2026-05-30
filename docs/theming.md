# Theming

PureAdmin supports the Pure Admin theme system with dynamic theme switching, color variants, and light/dark modes.

## Available Themes

| Theme | Package |
|---|---|
| Default | `@keenmate/pure-admin-core` |
| Audi | `@keenmate/pure-admin-theme-audi` |
| Corporate | `@keenmate/pure-admin-theme-corporate` |
| Dark | `@keenmate/pure-admin-theme-dark` |
| Express | `@keenmate/pure-admin-theme-express` |
| Minimal | `@keenmate/pure-admin-theme-minimal` |

Browse and preview all themes at [pureadmin.io](https://pureadmin.io).

## Installing Themes

Theme zips are self-contained — the compiled CSS in `dist/` references fonts via relative paths (`../assets/fonts/...`), so extracting a zip preserves correct asset resolution without any path adjustments.

Each theme zip contains:

```
audi/
├── theme.json                       # metadata: colors, variants, modes, fonts, checksums
├── dist/
│   └── audi.css                     # compiled CSS (ready to use)
├── scss/
│   └── audi.scss                    # SCSS source (for customization, see below)
├── assets/
│   └── fonts/
│       ├── *.woff2                  # bundled font files
│       └── ...
└── README.md
```

Place extracted themes under `priv/static/themes/` so Phoenix can serve them:

### Option A: Pure Admin CLI (recommended)

Pure Admin uses a three-file config modeled on `package.json` / `package-lock.json`:

| File | Role | Tracked? |
|---|---|---|
| `pureadmin.json` | declarations only — which themes the project uses | yes (hand-edited) |
| `pureadmin.lock.json` | resolved versions, content shas, fetch timestamps | yes (tool-managed) |
| `.pureadmin.json` | per-developer overrides (local paths, dev API keys) | no (gitignored) |

Create `pureadmin.json` at your project root with the themes you ship:

```json
{
  "themesDir": "priv/static/themes",
  "themes": {
    "audi": {},
    "dark": {},
    "express": {}
  }
}
```

Then resolve and download with the CLI:

```bash
# Local dev: install + write/refresh the lockfile
npx @keenmate/pureadmin themes install

# Bump every theme to the latest registry version (writes the lock)
npx @keenmate/pureadmin themes update

# CI / Docker: strict reproduce from the lockfile, fail on drift, never write
npx @keenmate/pureadmin themes ci
```

`themes install` is the everyday "make this project work" verb — fresh clones run it once. `themes ci` is the strict CI verb that reproduces the lockfile exactly. Add `priv/static/themes/` and `.pureadmin.json` to `.gitignore`.

The CLI auto-detects your `@keenmate/pure-admin-core` version (probes `package.json` and `assets/package.json`) and resolves theme versions compatible with it.

### Option B: Manual download

Download theme zips from [pureadmin.io](https://pureadmin.io) and extract them into `priv/static/themes/`. Each zip extracts to `<id>/css/<id>.css` plus assets and a `theme.json` manifest.

### Option C: Download in CI/CD (Dockerfile)

Run `themes ci` during your Docker build. Copy the two config files first so the CLI knows what to fetch, then run the install:

```dockerfile
COPY pureadmin.json pureadmin.lock.json ./
RUN apt-get update && apt-get install -y --no-install-recommends nodejs npm && rm -rf /var/lib/apt/lists/* \
  && npx @keenmate/pureadmin themes ci
```

> **Tip:** Run the theme download step *before* `mix assets.deploy` so that `phx.digest` fingerprints the theme files along with the rest of your static assets.

See the `Dockerfile` in the repo root for a complete working example.

## Customizing Themes via SCSS

If you install themes via npm (`@keenmate/pure-admin-theme-*`), you can import their SCSS source into your project stylesheet and override variables before the import. All theme variables use `!default`, so your values take precedence:

### Basic variable override

```scss
// assets/css/app.scss

// Override variables before importing the theme
$base-accent-color: #0066cc;
$card-border-radius: 8px;

// Import the theme — your overrides win
@import '@keenmate/pure-admin-theme-audi/src/scss/audi';
```

### Custom font

Every theme bundles its own font (e.g., Audi bundles Fira Sans Condensed). To use a different font, override `$base-font-family` and declare your `@font-face` before the theme import:

```scss
// assets/css/app.scss

// 1. Set your font family (overrides the theme's bundled font)
$base-font-family: 'Monda', Arial, sans-serif;

// 2. Declare @font-face with your font files
@font-face {
  font-family: 'Monda';
  font-weight: 400;
  font-display: swap;
  src: url('./fonts/monda-400.woff2') format('woff2');
}

@font-face {
  font-family: 'Monda';
  font-weight: 700;
  font-display: swap;
  src: url('./fonts/monda-700.woff2') format('woff2');
}

// 3. Import the theme
@import '@keenmate/pure-admin-theme-audi/src/scss/audi';
```

> **Tip:** Bundle font files locally in your project rather than loading from a CDN. The theme's bundled font is local and renders first — a remote font arriving later causes a visible flash (FOUT).

### Font baseline correction

Different fonts have different vertical metrics. When you swap fonts, text may appear higher or lower within buttons, card headers, and other aligned components. Use `ascent-override` and `descent-override` in `@font-face` to correct this:

```scss
@font-face {
  font-family: 'Monda';
  font-weight: 400;
  font-display: swap;
  src: url('./fonts/monda-400.woff2') format('woff2');
  ascent-override: 110%;    // push glyphs up within the line box
  descent-override: 20%;    // reduce space below the baseline
}
```

| Descriptor | Effect | Typical range |
|---|---|---|
| `ascent-override` | Controls where glyphs sit vertically. Higher % = text moves up. | 85% – 120% |
| `descent-override` | Controls space below the baseline. Lower % = less descender space. | 10% – 40% |
| `size-adjust` | Scales the font without changing font-size. Affects width and height. | 90% – 115% |

Use the [Font Tuning Tool](https://demo.pureadmin.io/tools/font-test) to find the right values for your font.

### Complete example

Audi theme with Monda font, baseline-corrected:

```scss
// assets/css/app.scss

$base-font-family: 'Monda', Arial, sans-serif;

@font-face {
  font-family: 'Monda';
  font-weight: 400;
  font-display: swap;
  src: url('./fonts/monda-400.woff2') format('woff2');
  ascent-override: 110%;
  descent-override: 20%;
}

@font-face {
  font-family: 'Monda';
  font-weight: 700;
  font-display: swap;
  src: url('./fonts/monda-700.woff2') format('woff2');
  ascent-override: 110%;
  descent-override: 20%;
}

// Import theme — uses Monda everywhere instead of Fira Sans Condensed
@import '@keenmate/pure-admin-theme-audi/src/scss/audi';
```

> The theme's original `@font-face` declarations (e.g., Fira Sans Condensed) remain in the compiled CSS but are never used since nothing references that font family name. This adds a few KB of unused CSS but has no runtime impact.

For more details see the [Theme Customization guide on pureadmin.io](https://pureadmin.io/docs/theme-customization).

## Creating Custom Themes

Use the Pure Admin CLI to scaffold and publish your own themes:

```bash
npm install -g @keenmate/pureadmin

# Scaffold a new theme project
pureadmin init my-theme "My Theme"

# Edit src/scss/my-theme.scss, then build and preview
pureadmin build

# Package with integrity checksums
pureadmin pack

# Publish to pureadmin.io (requires API key)
pureadmin publish --api-key YOUR_KEY
```

The CLI handles SCSS compilation, font bundling, SHA-256 checksums, and ZIP packaging. Published themes are immediately available via the API and CLI for other projects.

See the [Creating Themes guide on pureadmin.io](https://pureadmin.io/docs/creating-themes) for full documentation.

## Theme Color Slots (1-9)

Every theme defines 9 custom color slots. These are used by components via the `theme_color` attribute:

```heex
<.alert theme_color="3">Custom branded alert</.alert>
<.button theme_color="5">Custom button</.button>
<.callout theme_color="1">Custom callout</.callout>
```

Components supporting `theme_color`: `alert/1`, `button/1`, `callout/1`, `toast/1`, `card/1`, `table_card/1`, `input/1`, `select/1`, `textarea/1`.

## Light / Dark Mode

Mode is managed client-side via the settings panel. The `fouc_prevention_script` applies the stored mode before paint to prevent flashing:

```heex
<body>
  <.fouc_prevention_script default_mode="auto" />
  {@inner_content}
</body>
```

`default_mode` controls the first-visit mode (before any user selection is stored). Accepts `"light"`, `"dark"`, or `"auto"` (follows OS `prefers-color-scheme`). Defaults to `"light"`.

CSS classes applied to `<body>`: `pa-mode-light` or `pa-mode-dark` (`auto` resolves to one of these at runtime).

## Theme CSS Variables

Pure Admin exposes ~195 CSS custom properties split into two layers:

- **`--base-*`** (~71 vars) — web-component-style design tokens. Stable, semantic, override-friendly. See [`CSS-VARIABLES.md`](https://github.com/KeenMate/pure-admin/blob/main/packages/core/CSS-VARIABLES.md) in `@keenmate/pure-admin-core` for the full reference.
- **`--pa-*`** (~124 vars) — framework component tokens. Derived from the `--base-*` layer; most of them aren't intended to be overridden directly, but are useful for ad-hoc styling.

> **As of `@keenmate/pure-admin-core` v2.8.0**, the unthemed bundle (`dist/css/main.css`) emits a complete neutral default for every `--pa-*` token at `:root`. This means the framework renders with reasonable defaults *before* a theme stylesheet loads, eliminating the FOUC window where sparklines / sentiment indicators rendered near-black. Themes still emit their own `:root` block on top.

### Canonical role tokens (v2.8.0)

The four "what's the user trying to communicate" tokens. Use these instead of hard-coding red/green/yellow/blue:

| Variable | Purpose |
|---|---|
| `--pa-success` | Success / confirmation |
| `--pa-warning` | Warning / caution |
| `--pa-danger` | Danger / error |
| `--pa-info` | Informational |

Each role also has a `*-bg` / `*-bg-hover` / `*-bg-light` / `*-bg-subtle` / `*-border` / `*-text` / `*-text-light` family for component-level styling (e.g. `--pa-success-bg-light` for alert backgrounds).

### 5-step sentiment scale (v2.6.0, refined in v2.8.0)

For data visualization where "positive vs. negative" is the axis (KPI deltas, trend arrows, comparison gauges):

| Variable | Purpose |
|---|---|
| `--pa-very-positive` | Strong positive (e.g. ↑↑ in KPIs) |
| `--pa-positive` | Positive — aliases `--pa-success` |
| `--pa-neutral` | No change / baseline |
| `--pa-negative` | Negative — aliases `--pa-danger` |
| `--pa-very-negative` | Strong negative (e.g. ↓↓) |

Used by `Stat`'s 5-step `change_direction` attr (`very_positive` / `positive` / `neutral` / `negative` / `very_negative`) and across the KPI component family.

### Text contrast tiers (v2.8.0)

Three semantic text colours derived from `--pa-text-color-1` via `color-mix()`:

| Variable | Purpose |
|---|---|
| `--pa-text-strong` | High-contrast text (85%) — section headings, key values |
| `--pa-text-secondary` | Secondary text (70%) — supporting copy, captions |
| `--pa-text-tertiary` | Tertiary text (55%) — labels, hints, timestamps |

These work on both light and dark modes without needing per-mode overrides — the base colour flips, the mixing percentage stays the same.

### Surface tints (v2.8.0)

For hover backdrops and "track" backgrounds in progress / gauge components:

| Variable | Purpose |
|---|---|
| `--pa-surface-hover` | Hover backdrop (4% of `--pa-text-color-1` over transparent) |
| `--pa-surface-track` | Track/rail background for gauges, progress bars (12%) |

### Link tokens (v2.7.0)

| Variable | Purpose |
|---|---|
| `--pa-link-color` | Default link colour (aliases `--pa-accent`) |
| `--pa-link-color-hover` | Hovered link |
| `--pa-link-color-visited` | Visited link |

### Chart trendline tokens (v2.7.0)

For inline SVG sparklines and trend indicators:

| Variable | Purpose |
|---|---|
| `--pa-chart-trendline-height` | Default trendline container height (3rem) |
| `--pa-chart-trendline-stroke` | SVG `user-space` stroke width (2.1) |

### Detail popover chrome (v2.7.1)

The dark-themed hover detail popover used by every KPI tile / row:

| Variable | Purpose |
|---|---|
| `--pa-detail-bg` | Popover background |
| `--pa-detail-text` | Popover text |
| `--pa-detail-shadow` | Popover drop-shadow |

### Gauge size (v2.7.0)

| Variable | Purpose |
|---|---|
| `--pa-gauge-size` | Half-donut gauge diameter (default 12rem). Override per-instance via the `:size` attr on `gauge/1`. |

### KPI namespaced tokens (v2.7.1)

Per-component cascade variables under `--pa-kpi-*` — e.g. `--pa-kpi-bar-color` (sentiment-tinted bars in comparison gauges), `--pa-kpi-edit-cell-min` (`auto-fit` cell minimum for editorial grids), `--pa-kpi-gauge-cell-min`, `--pa-kpi-bento-row-height`. Most are set via component attrs (`cell_min_width`, `row_height`) rather than via global theme overrides.

### Layout

| Variable | Description |
|---|---|
| `--pa-header-bg` | Navbar background |
| `--pa-sidebar-bg` | Sidebar background |
| `--pa-sidebar-width` | Sidebar width (default: 26rem) |

### Theme color slots

| Variable | Description |
|---|---|
| `--pa-color-1` through `--pa-color-9` | Custom branded colour slots — see [Theme Color Slots](#theme-color-slots-1-9) above |

## Settings Panel

Add the settings panel to your layout for runtime theme/layout customization:

```heex
<.settings_panel default_theme="audi" />
```

The panel fetches available themes from `/api/themes/manifests` and populates the selector dynamically. All settings persist to `localStorage`:

- Theme selection
- Color variant (per theme)
- Light/dark mode
- Layout width (fluid, sm, md, lg, xl, 2xl)
- Sidebar behavior (hide, icon-collapse, resizable, sticky)
- Font size and family
- Compact mode, RTL mode

## Dynamic Theme Switching

Use `?theme=name` query parameter to switch themes:

```
https://your-app.com/?theme=dark
https://your-app.com/?theme=cobalt2
```

The inline script in the root layout reads the query param, stores it in `localStorage`, and swaps the theme CSS link before paint.
