defmodule KPureAdmin.Components do
  @moduledoc """
  Bulk import macro for all KPureAdmin components.

  Use this module as a full replacement for Phoenix's generated `CoreComponents`:

      # In your app's html_helpers or where you had:
      # import MyAppWeb.CoreComponents
      use KPureAdmin.Components

  This imports all function components from every component module, giving you
  access to `button/1`, `badge/1`, `alert/1`, `card/1`, `modal/1`, `table/1`,
  `tabs/1`, `input/1`, `grid/1`, `layout/1`, and many more.
  """

  defmacro __using__(_opts) do
    quote do
      import KPureAdmin.Components.Alert
      import KPureAdmin.Components.Badge
      import KPureAdmin.Components.Button
      import KPureAdmin.Components.Callout
      import KPureAdmin.Components.Card
      import KPureAdmin.Components.CommandPalette
      import KPureAdmin.Components.CheckboxList
      import KPureAdmin.Components.Code
      import KPureAdmin.Components.DataDisplay
      import KPureAdmin.Components.DataViz
      import KPureAdmin.Components.Form
      import KPureAdmin.Components.Grid
      import KPureAdmin.Components.Layout
      import KPureAdmin.Components.List
      import KPureAdmin.Components.Loader
      import KPureAdmin.Components.Modal
      import KPureAdmin.Components.Navigation
      import KPureAdmin.Components.Pager
      import KPureAdmin.Components.Popconfirm
      import KPureAdmin.Components.Profile
      import KPureAdmin.Components.Stat
      import KPureAdmin.Components.Table
      import KPureAdmin.Components.Timeline
      import KPureAdmin.Components.SettingsPanel
      import KPureAdmin.Components.Toast
      import KPureAdmin.Components.Tooltip
      import KPureAdmin.Components.Typography
    end
  end
end
