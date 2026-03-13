defmodule KPureAdmin.Components.Badge do
  @moduledoc """
  Badge, Label, CompositeBadge, and BadgeGroup components for Pure Admin.
  """
  use Phoenix.Component

  import KPureAdmin.Helpers

  # -- badge/1 --

  @doc """
  Renders a badge with Pure Admin BEM classes.

  ## Examples

      <.badge variant="success">Active</.badge>
      <.badge variant="warning" size="sm" is_pill>Pending</.badge>
  """
  attr(:variant, :string, default: "primary", doc: "Color variant")
  attr(:size, :string, default: nil, values: [nil, "xs", "sm", "lg", "xl"])
  attr(:is_pill, :boolean, default: false, doc: "Rounded pill shape")
  attr(:theme_color, :string, default: nil, doc: "Theme color 1-9")
  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:icon, doc: "Icon content inside pa-badge__icon")
  slot(:inner_block, required: true)

  def badge(assigns) do
    ~H"""
    <span class={badge_classes(assigns)} {@rest}>
      <span :for={icon <- @icon} class="pa-badge__icon"><%= render_slot(icon) %></span>
      <%= render_slot(@inner_block) %>
    </span>
    """
  end

  defp badge_classes(assigns) do
    build_classes(
      "pa-badge",
      [
        {"pa-badge--#{assigns.variant}", true},
        {"pa-badge--#{assigns.size}", assigns.size != nil},
        {"pa-badge--pill", assigns.is_pill},
        {"pa-bg-color-#{assigns.theme_color}", assigns.theme_color != nil}
      ],
      assigns.class
    )
  end

  # -- label/1 --

  @doc """
  Renders a lightweight label indicator.

  ## Examples

      <.label variant="success">Active</.label>
  """
  attr(:variant, :string, default: "primary")
  attr(:size, :string, default: nil, values: [nil, "sm", "lg"])
  attr(:is_outline, :boolean, default: false, doc: "Outline style")
  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def label(assigns) do
    ~H"""
    <span class={label_classes(assigns)} {@rest}>
      <%= render_slot(@inner_block) %>
    </span>
    """
  end

  defp label_classes(assigns) do
    variant_class =
      if assigns.is_outline,
        do: "pa-label--outline-#{assigns.variant}",
        else: "pa-label--#{assigns.variant}"

    build_classes(
      "pa-label",
      [
        {variant_class, true},
        {"pa-label--#{assigns.size}", assigns.size != nil}
      ],
      assigns.class
    )
  end

  # -- composite_badge/1 --

  @doc """
  Renders a three-part composite badge (icon + label + button/count).

  ## Examples

      <.composite_badge variant="primary" icon="🔔" label="Notifications" count="5" />
  """
  attr(:variant, :string, default: "primary")
  attr(:icon, :string, default: nil, doc: "Icon text or emoji")
  attr(:label, :string, required: true, doc: "Label text")
  attr(:count, :string, default: nil, doc: "Count/button text")
  attr(:class, :string, default: nil)
  attr(:rest, :global)

  def composite_badge(assigns) do
    ~H"""
    <div class={build_classes("pa-composite-badge", [{"pa-composite-badge--#{@variant}", true}], @class)} {@rest}>
      <span :if={@icon} class="pa-composite-badge__icon"><%= @icon %></span>
      <span class="pa-composite-badge__label"><%= @label %></span>
      <span :if={@count} class="pa-composite-badge__button"><%= @count %></span>
    </div>
    """
  end

  # -- badge_group/1 --

  @doc """
  Renders a container for multiple badges.

  ## Examples

      <.badge_group>
        <.badge variant="primary">Elixir</.badge>
        <.badge variant="info">Phoenix</.badge>
      </.badge_group>
  """
  attr(:is_show_all, :boolean, default: false, doc: "Show all badges (disable limit)")
  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def badge_group(assigns) do
    ~H"""
    <div
      class={build_classes("pa-badge-group", [{"pa-badge-group--show-all", @is_show_all}], @class)}
      {@rest}
    >
      <%= render_slot(@inner_block) %>
    </div>
    """
  end
end
