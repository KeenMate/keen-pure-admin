defmodule PureAdmin.Components.Loader do
  @moduledoc """
  Loader and spinner components for Pure Admin.

  Provides `spinner/1` for rotating spinners and `loader/1` for animated loaders
  with multiple types (dots, bars, pulse, ring, wave).
  """
  use Phoenix.Component

  import PureAdmin.Helpers

  @doc """
  Renders a spinner.

  ## Examples

      <.spinner />
      <.spinner size="lg" variant="primary" />
  """
  attr(:size, :string, default: nil, values: [nil, "xs", "sm", "md", "lg", "xl", "2xl"])
  attr(:variant, :string, default: nil,
    values: [nil, "primary", "secondary", "success", "danger", "warning", "info"],
    doc: "Spinner color variant")
  attr(:class, :string, default: nil)
  attr(:rest, :global)

  def spinner(assigns) do
    ~H"""
    <div
      class={build_classes("pa-spinner", [
        {"pa-spinner--#{@size}", @size != nil},
        {"pa-spinner--#{@variant}", @variant != nil}
      ], @class)}
      {@rest}
    ></div>
    """
  end

  @doc """
  Renders an animated loader.

  ## Types

  - `"dots"` (default): Three bouncing dots
  - `"bars"` / `"wave"`: Five animated bars
  - `"pulse"`: Pulsing circle
  - `"ring"`: Spinning ring

  ## Examples

      <.loader />
      <.loader type="bars" color="primary" />
      <.loader type="pulse" size="lg" />
  """
  attr(:type, :string, default: "dots", values: ["dots", "bars", "pulse", "ring", "wave"],
    doc: "Loader animation type")
  attr(:size, :string, default: nil, values: [nil, "lg"], doc: "Loader size")
  attr(:color, :string, default: nil,
    values: [nil, "primary", "secondary", "success", "danger", "warning", "info"],
    doc: "Loader color")
  attr(:class, :string, default: nil)
  attr(:rest, :global)

  def loader(assigns) do
    ~H"""
    <div class={loader_classes(assigns)} {@rest}>
      <%= cond do %>
        <% @type == "dots" -> %>
          <span></span><span></span><span></span>
        <% @type in ["bars", "wave"] -> %>
          <span></span><span></span><span></span><span></span><span></span>
        <% true -> %>
      <% end %>
    </div>
    """
  end

  @doc "Renders a centered loader container (flexbox centering)."
  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def loader_center(assigns) do
    ~H"""
    <div class={build_classes("pa-loader-center", [], @class)} {@rest}>
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  @doc "Renders a centered loader overlay with backdrop."
  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:inner_block)

  def loader_overlay(assigns) do
    ~H"""
    <div class={build_classes("pa-loader-overlay", [], @class)} {@rest}>
      <%= if @inner_block != [] do %>
        <%= render_slot(@inner_block) %>
      <% else %>
        <.spinner />
      <% end %>
    </div>
    """
  end

  defp loader_classes(assigns) do
    build_classes(
      "pa-loader-#{assigns.type}",
      [
        {"pa-loader-#{assigns.type}--#{assigns.size}", assigns.size != nil},
        {"pa-loader-#{assigns.type}--#{assigns.color}", assigns.color != nil}
      ],
      assigns.class
    )
  end
end
