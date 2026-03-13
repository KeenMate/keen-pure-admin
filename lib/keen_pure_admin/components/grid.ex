defmodule KPureAdmin.Components.Grid do
  @moduledoc """
  Grid system components for Pure Admin.

  Provides `grid/1` (row) and `column/1` wrapping the `pa-row` and `pa-col-*` classes.
  """
  use Phoenix.Component

  import KPureAdmin.Helpers

  @doc """
  Renders a grid row container.

  ## Examples

      <.grid>
        <.column size="50" md="1-3">Content</.column>
        <.column size="50" md="2-3">Content</.column>
      </.grid>

      <.grid is_same_height is_no_gutter>
        <.column size="1-3">Card 1</.column>
        <.column size="1-3">Card 2</.column>
        <.column size="1-3">Card 3</.column>
      </.grid>
  """
  attr(:is_no_gutter, :boolean, default: false)
  attr(:is_same_height, :boolean, default: false)
  attr(:align, :string, default: nil, values: [nil, "center", "end", "between", "around"])
  attr(:valign, :string, default: nil, values: [nil, "top", "middle", "bottom"])
  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def grid(assigns) do
    ~H"""
    <div class={row_classes(assigns)} {@rest}>
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  defp row_classes(assigns) do
    build_classes(
      "pa-row",
      [
        {"pa-row--no-gutter", assigns.is_no_gutter},
        {"pa-row--same-height", assigns.is_same_height},
        {"pa-row--#{assigns.align}", assigns.align != nil},
        {"pa-row--#{assigns.valign}", assigns.valign != nil}
      ],
      assigns.class
    )
  end

  @doc """
  Renders a grid column.

  Column sizes use Pure Admin's naming: percentage (5-100 in 5% increments)
  or fractions (1-2, 1-3, 2-3, 1-4, 3-4, etc.).

  ## Examples

      <.column size="100" md="50" lg="1-3">Responsive column</.column>
      <.column size="1-2" offset="25">Offset column</.column>
  """
  attr(:size, :string, default: nil, doc: "Base column size (e.g. '50', '1-3', '100')")
  attr(:sm, :string, default: nil, doc: "Size at sm breakpoint (>=576px)")
  attr(:md, :string, default: nil, doc: "Size at md breakpoint (>=768px)")
  attr(:lg, :string, default: nil, doc: "Size at lg breakpoint (>=992px)")
  attr(:xl, :string, default: nil, doc: "Size at xl breakpoint (>=1200px)")
  attr(:offset, :string, default: nil, doc: "Offset from left (e.g. '25', '35')")
  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def column(assigns) do
    ~H"""
    <div class={col_classes(assigns)} {@rest}>
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  defp col_classes(assigns) do
    classes =
      [
        assigns.size && "pa-col-#{assigns.size}",
        assigns.sm && "pa-col-sm-#{assigns.sm}",
        assigns.md && "pa-col-md-#{assigns.md}",
        assigns.lg && "pa-col-lg-#{assigns.lg}",
        assigns.xl && "pa-col-xl-#{assigns.xl}",
        assigns.offset && "pa-offset-#{assigns.offset}",
        assigns.class
      ]
      |> Enum.reject(&is_nil/1)
      |> Enum.join(" ")

    if classes == "", do: "pa-col", else: classes
  end
end
