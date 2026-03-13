defmodule KPureAdmin.Hooks do
  @moduledoc """
  Documents available JS hooks shipped with KPureAdmin.

  Users must import hooks in their `app.js`:

      ```javascript
      import { PureAdminHooks } from "../deps/keen_pure_admin/assets/js/keen_pure_admin"
      let liveSocket = new LiveSocket("/live", Socket, { hooks: { ...PureAdminHooks } })
      ```

  ## Available Hooks

  - `PureAdminTooltip` - Tooltip positioning via Floating UI
  - `PureAdminPopover` - Popover positioning and show/hide
  - `PureAdminToast` - Toast auto-dismiss and progress bar
  - `PureAdminCommandPalette` - Ctrl+K shortcut, keyboard navigation
  - `PureAdminDetailPanel` - Resizable divider drag
  - `PureAdminSidebarResize` - Sidebar drag-to-resize
  """
end
