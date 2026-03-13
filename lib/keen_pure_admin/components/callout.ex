defmodule KPureAdmin.Components.Callout do
  @moduledoc """
  Callout components for Pure Admin.

  When an icon slot is provided, content is wrapped in `pa-callout__content` div
  for proper layout alongside the icon.
  """
  use Phoenix.Component

  import KPureAdmin.Helpers

  @doc """
  Renders a callout box.

  ## Examples

      <.callout variant="info">Important note here.</.callout>

      <.callout variant="warning" heading_text="Warning">
        Be careful with this operation.
      </.callout>

      <.callout variant="info" size="sm">
        <:icon><i class="fa-solid fa-info-circle"></i></:icon>
        This is a compact callout with an icon.
      </.callout>
  """
  attr(:variant, :string, default: "info",
    values: ["primary", "secondary", "info", "success", "warning", "danger"])
  attr(:size, :string, default: nil, values: [nil, "sm", "lg"], doc: "Callout size")
  attr(:heading_text, :string, default: nil, doc: "Callout heading text (shorthand for :title slot)")
  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:icon, doc: "Icon element (wraps content in pa-callout__content)")
  slot(:title, doc: "Optional callout title (overrides heading_text)")
  slot(:inner_block, required: true)

  def callout(assigns) do
    ~H"""
    <div class={callout_classes(assigns)} {@rest}>
      <%= if @icon != [] do %>
        <span class="pa-callout__icon">
          <%= for icon <- @icon do %>
            <%= render_slot(icon) %>
          <% end %>
        </span>
        <div class="pa-callout__content">
          <%= if @title != [] do %>
            <div :for={title <- @title} class="pa-callout__heading"><%= render_slot(title) %></div>
          <% else %>
            <div :if={@heading_text} class="pa-callout__heading"><%= @heading_text %></div>
          <% end %>
          <%= render_slot(@inner_block) %>
        </div>
      <% else %>
        <%= if @title != [] do %>
          <div :for={title <- @title} class="pa-callout__heading"><%= render_slot(title) %></div>
        <% else %>
          <div :if={@heading_text} class="pa-callout__heading"><%= @heading_text %></div>
        <% end %>
        <div class="pa-callout__content">
          <%= render_slot(@inner_block) %>
        </div>
      <% end %>
    </div>
    """
  end

  defp callout_classes(assigns) do
    build_classes(
      "pa-callout",
      [
        {"pa-callout--#{assigns.variant}", true},
        {"pa-callout--#{assigns.size}", assigns.size != nil}
      ],
      assigns.class
    )
  end
end
