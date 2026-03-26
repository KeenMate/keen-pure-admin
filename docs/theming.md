# Theming

KPureAdmin supports the Pure Admin theme system with dynamic theme switching, color variants, and light/dark modes.

## Available Themes

| Theme | Package |
|---|---|
| Default | `@keenmate/pure-admin-core` |
| Audi | `@keenmate/pure-admin-theme-audi` |
| Corporate | `@keenmate/pure-admin-theme-corporate` |
| Dark | `@keenmate/pure-admin-theme-dark` |
| Express | `@keenmate/pure-admin-theme-express` |
| Minimal | `@keenmate/pure-admin-theme-minimal` |

Browse all themes at [pureadmin.io](https://pureadmin.io).

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
