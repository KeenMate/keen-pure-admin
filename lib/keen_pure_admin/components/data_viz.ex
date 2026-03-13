defmodule KPureAdmin.Components.DataViz do
  @moduledoc """
  Data visualization components for Pure Admin. (Phase 2)

  Includes Progress, ProgressRing, Gauge, DataBar, StackedBar, Sparkline,
  Heatmap, BarList and their sub-components.
  """
  use Phoenix.Component

  import KPureAdmin.Helpers

  @doc "Renders a progress bar."
  attr(:value, :integer, default: 0, doc: "Progress percentage (0-100)")
  attr(:variant, :string, default: "primary")
  attr(:size, :string, default: nil, values: [nil, "sm", "lg"])
  attr(:class, :string, default: nil)
  attr(:rest, :global)

  def progress(assigns) do
    ~H"""
    <div class={build_classes("pa-progress", [{"pa-progress--#{@size}", @size != nil}], @class)} {@rest}>
      <div
        class={"pa-progress__bar pa-progress__bar--#{@variant}"}
        style={"width: #{@value}%"}
        role="progressbar"
        aria-valuenow={@value}
        aria-valuemin="0"
        aria-valuemax="100"
      >
      </div>
    </div>
    """
  end
end
