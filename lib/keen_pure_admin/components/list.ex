defmodule KPureAdmin.Components.List do
  @moduledoc """
  List components for Pure Admin.

  Provides `list/1` for the container and `list_item/1` for individual items.
  ListItem supports structured content with avatar, title, subtitle, and meta.
  """
  use Phoenix.Component

  import KPureAdmin.Helpers

  @doc "Renders a styled list container."
  attr(:is_bordered, :boolean, default: false, doc: "Add borders between items")
  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def list(assigns) do
    ~H"""
    <div
      class={build_classes("pa-list", [{"pa-list--bordered", @is_bordered}], @class)}
      {@rest}
    >
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  @doc """
  Renders a list item with optional structured content.

  ## Examples

      <.list_item title_text="John Doe" subtitle_text="Developer" meta_text="Online" />

      <.list_item title_text="Jane Smith" subtitle_text="Designer">
        <:avatar><img src="/avatars/jane.jpg" /></:avatar>
      </.list_item>

      <.list_item>
        Custom content here
      </.list_item>
  """
  attr(:title_text, :string, default: nil, doc: "Title text")
  attr(:subtitle_text, :string, default: nil, doc: "Subtitle text")
  attr(:meta_text, :string, default: nil, doc: "Meta text (right side)")
  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:avatar, doc: "Avatar content")
  slot(:inner_block, doc: "Custom content (overrides title/subtitle/meta)")

  def list_item(assigns) do
    has_structured = assigns.title_text != nil || assigns.subtitle_text != nil || assigns.meta_text != nil

    assigns = assign(assigns, :has_structured, has_structured)

    ~H"""
    <div class={build_classes("pa-list__item", [], @class)} {@rest}>
      <div :if={@avatar != []} class="pa-list__avatar">
        <%= for avatar <- @avatar do %>
          <%= render_slot(avatar) %>
        <% end %>
      </div>
      <%= if @inner_block != [] && !@has_structured do %>
        <%= render_slot(@inner_block) %>
      <% else %>
        <div class="pa-list__content">
          <div :if={@title_text} class="pa-list__title"><%= @title_text %></div>
          <div :if={@subtitle_text} class="pa-list__subtitle"><%= @subtitle_text %></div>
        </div>
        <div :if={@meta_text} class="pa-list__meta"><%= @meta_text %></div>
        <%= if @inner_block != [] do %>
          <%= render_slot(@inner_block) %>
        <% end %>
      <% end %>
    </div>
    """
  end
end
