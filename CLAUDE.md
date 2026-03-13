# keen_pure_admin

Phoenix LiveView component library wrapping the Pure Admin CSS framework (`@keenmate/pure-admin-core`) into function components and LiveComponents.

## Project Structure

- `lib/keen_pure_admin.ex` - Root module
- `lib/keen_pure_admin/components/` - Function components (one file per component group)
- `lib/keen_pure_admin/live/` - LiveComponents (stateful: CommandPalette, ToastLive, DialogService)
- `lib/keen_pure_admin/helpers.ex` - BEM class builder utilities
- `lib/keen_pure_admin/types.ex` - Shared type definitions
- `lib/keen_pure_admin/config.ex` - NimbleOptions configuration
- `lib/assets/js/` - JS hooks for Phoenix LiveView
- `test/` - Tests mirror lib/ structure

## Key Conventions

- Module prefix: `KPureAdmin`
- Component names are unprefixed (e.g., `button/1` not `pa_button/1`) - full CoreComponents replacement
- All CSS classes follow BEM: `pa-{block}`, `pa-{block}--{modifier}`, `pa-{block}__{element}`
- Use `build_classes/3` from `KPureAdmin.Helpers` for class building
- Function components for CSS-only and JS-command components
- LiveComponents only for server-state components
- Slots follow Phoenix conventions: `inner_block` for default, named slots for `:header`, `:footer`, etc.
- Props: `variant`, `size` (strings), `is_*` (booleans), `class` (extra CSS), `:rest` (global attrs)

## Reference Projects

- `../pure-admin/packages/core/snippets/` - HTML snippets with BEM classes
- `../svelte-pure-admin/packages/svelte-pure-admin/src/lib/` - Svelte component implementations
- `../keen-microsoft-graphapi/microsoft_graphapi/` - KeenMate Elixir package conventions

## Commands

- `mix deps.get` - Install dependencies
- `mix compile` - Compile
- `mix test` - Run tests
- `mix format` - Format code
- `mix quality` - Format check + credo + dialyzer
