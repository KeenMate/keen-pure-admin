defmodule PureAdmin.Components.Stat do
  @moduledoc """
  Stat and metric display components for Pure Admin.

  Supports multiple variants: default (with optional icon), hero, hero-compact, and square.
  """
  use Phoenix.Component

  import PureAdmin.Helpers

  @doc """
  Renders a stat display.

  ## Variants

  - default: Simple number + label (optionally with icon)
  - `"hero"`: Large prominent stat with change indicator
  - `"hero-compact"`: Compact hero variant
  - `"square"`: Colored square stat with optional symbol

  ## Examples

      <.stat number="1,234" label_text="Total Users" />

      <.stat variant="hero" number="$12,345" label_text="Revenue"
        change_text="+12.5%" change_direction="positive" />

      <.stat variant="square" color="primary" number="42" label_text="Tasks" />

      <.stat number="99.9%" label_text="Uptime" icon_variant="success">
        <:icon><i class="fa-solid fa-check-circle"></i></:icon>
      </.stat>
  """
  attr(:variant, :string, default: nil, values: [nil, "hero", "hero-compact", "square"], doc: "Stat display variant")

  attr(:color, :string,
    default: nil,
    values: [nil, "primary", "secondary", "success", "info", "warning", "danger"],
    doc: "Color for square variant"
  )

  attr(:icon_variant, :string,
    default: "primary",
    values: ["primary", "secondary", "success", "info", "warning", "danger"],
    doc: "Icon color variant"
  )

  attr(:number, :string, default: nil, doc: "Value to display")
  attr(:label_text, :string, default: nil, doc: "Label text")
  attr(:change_text, :string, default: nil, doc: "Change text (e.g. '+12.5%') for hero variant")

  attr(:change_direction, :string,
    default: nil,
    values: [nil, "positive", "negative", "neutral"],
    doc: "Change direction (determines color)"
  )

  attr(:symbol_text, :string, default: nil, doc: "Symbol text for square variant")
  # Legacy aliases
  attr(:value, :string, default: nil, doc: "Legacy alias for number")
  attr(:label, :string, default: nil, doc: "Legacy alias for label_text")
  attr(:trend, :string, default: nil, doc: "Legacy alias for change_text")
  attr(:trend_direction, :string, default: nil, doc: "Legacy alias for change_direction (up/down)")
  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:icon, doc: "Icon content")
  slot(:inner_block, doc: "Custom layout content (overrides default rendering)")

  def stat(assigns) do
    # Resolve legacy aliases
    number = assigns.number || assigns.value
    label_text = assigns.label_text || assigns.label
    change_text = assigns.change_text || assigns.trend

    change_direction =
      assigns.change_direction ||
        case assigns.trend_direction do
          "up" -> "positive"
          "down" -> "negative"
          other -> other
        end

    assigns =
      assigns
      |> assign(:resolved_number, number)
      |> assign(:resolved_label, label_text)
      |> assign(:resolved_change, change_text)
      |> assign(:resolved_direction, change_direction)

    ~H"""
    <div class={stat_classes(assigns)} {@rest}>
      <%!-- Custom content via inner_block --%>
      <%= if @inner_block != [] do %>
        <%= render_slot(@inner_block) %>
      <% else %>
        <%= cond do %>
          <% @variant in ["hero", "hero-compact"] -> %>
            <div class="pa-stat__label"><%= @resolved_label %></div>
            <div class="pa-stat__value"><%= @resolved_number %></div>
            <div :if={@resolved_change} class={change_classes(@resolved_direction)}>
              <%= @resolved_change %>
            </div>

          <% @variant == "square" -> %>
            <div class="pa-stat__number"><%= @resolved_number %></div>
            <div :if={@symbol_text} class="pa-stat__symbol"><%= @symbol_text %></div>
            <div class="pa-stat__label"><%= @resolved_label %></div>

          <% @icon != [] -> %>
            <div class={"pa-stat__icon pa-stat__icon--#{@icon_variant}"}>
              <%= for icon <- @icon do %>
                <%= render_slot(icon) %>
              <% end %>
            </div>
            <div class="pa-stat__content">
              <div class="pa-stat__number"><%= @resolved_number %></div>
              <div class="pa-stat__label"><%= @resolved_label %></div>
            </div>

          <% true -> %>
            <div class="pa-stat__number"><%= @resolved_number %></div>
            <div class="pa-stat__label"><%= @resolved_label %></div>
            <div :if={@resolved_change} class={change_classes(@resolved_direction)}>
              <%= @resolved_change %>
            </div>
        <% end %>
      <% end %>
    </div>
    """
  end

  defp stat_classes(assigns) do
    variant_class =
      case assigns.variant do
        "hero" -> "pa-stat--hero"
        "hero-compact" -> "pa-stat--hero pa-stat--hero--compact"
        "square" -> "pa-stat--square"
        _ -> nil
      end

    build_classes(
      "pa-stat",
      [
        {variant_class, variant_class != nil},
        {"pa-stat--#{assigns.color}", assigns.color != nil}
      ],
      assigns.class
    )
  end

  defp change_classes(direction) do
    build_classes("pa-stat__change", [
      {"pa-stat__change--#{direction}", direction != nil}
    ])
  end
end
