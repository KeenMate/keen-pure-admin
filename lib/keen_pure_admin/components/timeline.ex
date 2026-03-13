defmodule KPureAdmin.Components.Timeline do
  @moduledoc """
  Timeline components for Pure Admin.

  Supports simple, alternating, and feed variants.
  """
  use Phoenix.Component

  import KPureAdmin.Helpers

  @doc """
  Renders a timeline container.

  ## Examples

      <.timeline>
        <.timeline_item variant="success" time_text="10:30 AM">
          Task completed successfully.
        </.timeline_item>
      </.timeline>

      <.timeline variant="alternating">
        ...
      </.timeline>
  """
  attr(:variant, :string, default: nil, values: [nil, "simple", "alternating", "feed"],
    doc: "Timeline variant")
  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def timeline(assigns) do
    ~H"""
    <ul
      class={build_classes("pa-timeline", [
        {"pa-timeline--#{@variant}", @variant != nil}
      ], @class)}
      {@rest}
    >
      <%= render_slot(@inner_block) %>
    </ul>
    """
  end

  @doc """
  Renders a timeline item.

  ## Examples

      <.timeline_item variant="success" time_text="10:30 AM">
        <:title>Event Title</:title>
        Event description here.
      </.timeline_item>

      <.timeline_item variant="info" is_filled time_text="2:00 PM">
        <:icon><i class="fa-solid fa-star"></i></:icon>
        Something happened.
      </.timeline_item>
  """
  attr(:variant, :string, default: nil,
    values: [nil, "primary", "secondary", "success", "danger", "warning", "info"])
  attr(:is_filled, :boolean, default: false, doc: "Filled marker instead of outline")
  attr(:is_date_header, :boolean, default: false, doc: "Date header item (for feed timeline)")
  attr(:time_text, :string, default: nil, doc: "Time/date text")
  attr(:icon_text, :string, default: nil, doc: "Icon text content (string)")
  attr(:avatar_url, :string, default: nil, doc: "Avatar image URL (feed timeline)")
  attr(:avatar_alt, :string, default: "User", doc: "Avatar alt text")
  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:icon, doc: "Custom icon content")
  slot(:title, doc: "Item title")
  slot(:meta, doc: "Metadata (date, time, etc.)")
  slot(:comment, doc: "Comment content (feed timeline)")
  slot(:inner_block, required: true)

  def timeline_item(assigns) do
    ~H"""
    <li class={timeline_item_classes(assigns)} {@rest}>
      <%= cond do %>
        <% @is_date_header -> %>
          <div :if={@icon_text || @icon != []} class="pa-timeline__date-icon">
            <%= if @icon != [] do %>
              <%= for icon <- @icon do %><%= render_slot(icon) %><% end %>
            <% else %>
              <%= @icon_text %>
            <% end %>
          </div>
          <div class="pa-timeline__date-label"><%= render_slot(@inner_block) %></div>

        <% @avatar_url != nil -> %>
          <div :if={@time_text} class="pa-timeline__time"><%= @time_text %></div>
          <div class="pa-timeline__content">
            <div class="pa-timeline__avatar">
              <img src={@avatar_url} alt={@avatar_alt} />
            </div>
            <%= render_slot(@inner_block) %>
            <div :if={@comment != []} class="pa-timeline__comment">
              <%= for comment <- @comment do %><%= render_slot(comment) %><% end %>
            </div>
          </div>

        <% true -> %>
          <div :if={@time_text} class="pa-timeline__time"><%= @time_text %></div>
          <div class="pa-timeline__marker">
            <%= if @icon != [] do %>
              <%= for icon <- @icon do %><%= render_slot(icon) %><% end %>
            <% else %>
              <%= @icon_text %>
            <% end %>
          </div>
          <div class="pa-timeline__content">
            <%= for title <- @title do %>
              <div class="pa-timeline__title"><%= render_slot(title) %></div>
            <% end %>
            <%= for meta <- @meta do %>
              <div class="pa-timeline__meta"><%= render_slot(meta) %></div>
            <% end %>
            <div class="pa-timeline__body">
              <%= render_slot(@inner_block) %>
            </div>
          </div>
      <% end %>
    </li>
    """
  end

  defp timeline_item_classes(assigns) do
    build_classes(
      "pa-timeline__item",
      [
        {"pa-timeline__item--#{assigns.variant}", assigns.variant != nil},
        {"pa-timeline__item--filled", assigns.is_filled},
        {"pa-timeline__item--date-header", assigns.is_date_header}
      ],
      assigns.class
    )
  end
end
