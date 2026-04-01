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
themes.json                          # manifest listing all bundled themes
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

Install the CLI globally and manage themes in your project:

```bash
npm install -g @keenmate/pureadmin

# Add themes to your project
pureadmin themes audi dark express

# Check for updates and re-download changed themes
pureadmin update
```

The CLI tracks theme versions and `content_sha` checksums in a `pure-admin.json` config file. Only changed themes are re-downloaded. Themes are extracted to `priv/static/themes/` by default.

### Option B: Manual download

Download theme zips from [pureadmin.io](https://pureadmin.io) and extract them into `priv/static/themes/`.

### Option C: Download in CI/CD (Dockerfile)

Fetch themes automatically during your Docker build using the bundle API. Pass a comma-separated list of theme names to the `themes` query parameter — the API returns a single zip with all requested themes:

```dockerfile
ARG THEMES_URL=https://pureadmin.io/api/bundle?themes=audi,dark,express,corporate,minimal
RUN apt-get update && apt-get install -y --no-install-recommends curl unzip && rm -rf /var/lib/apt/lists/* \
  && mkdir -p priv/static/themes \
  && curl -fsSL -o /tmp/themes.zip "${THEMES_URL}" \
  && unzip -o /tmp/themes.zip -d priv/static/themes \
  && rm -f /tmp/themes.zip
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
  <.fouc_prevention_script />
  {@inner_content}
</body>
```

CSS classes applied to `<body>`: `pa-mode-light` or `pa-mode-dark`.

## Theme CSS Variables

Override these CSS custom properties to customize the appearance:

### Core Colors

| Variable | Description |
|---|---|
| `--accent-color` | Primary accent for interactive elements |
| `--base-text-color` | Default body text |
| `--base-bg-color` | Page background |
| `--base-border-color` | Default borders |

### Semantic Colors

| Variable | Description |
|---|---|
| `--base-success-color` | Success/positive states |
| `--base-warning-color` | Warning/caution states |
| `--base-danger-color` | Danger/error states |
| `--base-info-color` | Informational states |

### Layout

| Variable | Description |
|---|---|
| `--pa-header-bg` | Navbar background |
| `--pa-sidebar-bg` | Sidebar background |
| `--pa-sidebar-width` | Sidebar width (default: 26rem) |

### Theme Slots

| Variable | Description |
|---|---|
| `--base-color-1` through `--base-color-9` | Custom color slots |

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
