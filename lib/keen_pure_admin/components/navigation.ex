defmodule PureAdmin.Components.Navigation do
  @moduledoc """
  Tab and navigation components for Pure Admin.

  Provides standalone tabs (`tabs/1`, `tab_item/1`, `tab_panel/1`) and
  card tabs, with JS-command-based tab switching.
  """
  use Phoenix.Component

  alias Phoenix.LiveView.JS
  import PureAdmin.Helpers

  @doc """
  Renders a tab bar container.

  ## Examples

      <.tabs id="my-tabs">
        <.tab_item target="panel-1" is_active>Overview</.tab_item>
        <.tab_item target="panel-2">Details</.tab_item>
      </.tabs>
      <.tabs_content>
        <.tab_panel id="panel-1" is_active>Overview content</.tab_panel>
        <.tab_panel id="panel-2">Details content</.tab_panel>
      </.tabs_content>
  """
  attr(:id, :string, default: nil)
  attr(:style, :string, default: nil, values: [nil, "pills", "boxed", "border-top", "vertical"],
    doc: "Tab style variant")
  attr(:is_border_top, :boolean, default: false,
    doc: "Border on top instead of bottom (shorthand for style='border-top')")
  attr(:size, :string, default: nil, values: [nil, "sm", "lg"])
  attr(:align, :string, default: nil, values: [nil, "centered", "full"])
  attr(:overflow, :string, default: nil, values: [nil, "nowrap", "scrollable", "collapse"])
  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def tabs(assigns) do
    ~H"""
    <div id={@id} class={tabs_classes(assigns)} data-tabs-scroll={if @overflow == "scrollable", do: ""} {@rest}>
      <%= if @overflow == "scrollable" do %>
        <button class="pa-tabs__scroll-btn pa-tabs__scroll-btn--start" onclick="this.nextElementSibling.scrollBy({left: -200, behavior: 'smooth'})">
          <i class="fa-solid fa-chevron-left"></i>
        </button>
        <div class="pa-tabs__scroll-container">
          <%= render_slot(@inner_block) %>
        </div>
        <button class="pa-tabs__scroll-btn pa-tabs__scroll-btn--end" onclick="this.previousElementSibling.scrollBy({left: 200, behavior: 'smooth'})">
          <i class="fa-solid fa-chevron-right"></i>
        </button>
      <% else %>
        <%= render_slot(@inner_block) %>
      <% end %>
    </div>
    """
  end

  defp tabs_classes(assigns) do
    effective_style = if assigns.is_border_top && assigns.style == nil, do: "border-top", else: assigns.style

    build_classes(
      "pa-tabs",
      [
        {"pa-tabs--#{effective_style}", effective_style != nil},
        {"pa-tabs--#{assigns.size}", assigns.size != nil},
        {"pa-tabs--#{assigns.align}", assigns.align != nil},
        {"pa-tabs--#{assigns.overflow}", assigns.overflow != nil}
      ],
      assigns.class
    )
  end

  @doc """
  Renders an individual tab item/button.

  ## Examples

      <.tab_item target="panel-1" is_active>Home</.tab_item>

      <.tab_item target="panel-2">
        <:icon><i class="fa-solid fa-gear"></i></:icon>
        Settings
      </.tab_item>
  """
  attr(:target, :string, required: true, doc: "ID of the target tab panel")
  attr(:tabs_id, :string, default: nil, doc: "ID of the parent tabs container (for JS switching)")
  attr(:is_active, :boolean, default: false)
  attr(:width, :string, default: nil,
    values: [nil, "1x", "2x", "3x", "4x", "5x", "6x", "7x", "8x", "9x", "10x"],
    doc: "Fixed width")
  attr(:height, :string, default: nil,
    values: [nil, "1x", "2x", "3x", "4x", "5x", "6x", "7x", "8x", "9x", "10x"],
    doc: "Fixed height")
  attr(:class, :string, default: nil)
  attr(:rest, :global, include: ~w(disabled))
  slot(:icon, doc: "Icon content (rendered before text)")
  slot(:inner_block, required: true)

  def tab_item(assigns) do
    tab_item_id = "tab-btn-#{assigns.target}"
    assigns = assign(assigns, :tab_item_id, tab_item_id)

    ~H"""
    <button
      id={@tab_item_id}
      class={tab_item_classes(assigns)}
      phx-click={switch_tab(@target, @tabs_id, @tab_item_id)}
      data-tab-target={@target}
      {@rest}
    >
      <%= for icon <- @icon do %>
        <%= render_slot(icon) %>
      <% end %>
      <%= render_slot(@inner_block) %>
    </button>
    """
  end

  defp tab_item_classes(assigns) do
    build_classes(
      "pa-tabs__item",
      [
        {"pa-tabs__item--active", assigns.is_active},
        {"pa-tabs__item--w-#{assigns.width}", assigns.width != nil},
        {"pa-tabs__item--h-#{assigns.height}", assigns.height != nil}
      ],
      assigns.class
    )
  end

  @doc """
  Renders a tab content container.
  """
  attr(:id, :string, default: nil, doc: "Content container ID (use {tabs_id}-content for scoped switching)")
  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def tabs_content(assigns) do
    ~H"""
    <div id={@id} class={build_classes("pa-tabs__content", [], @class)} {@rest}>
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  @doc """
  Renders a tab panel (content for a single tab).

  ## Examples

      <.tab_panel id="panel-1" is_active>Content here</.tab_panel>
  """
  attr(:id, :string, required: true)
  attr(:is_active, :boolean, default: false)
  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def tab_panel(assigns) do
    ~H"""
    <div
      id={@id}
      class={build_classes("pa-tabs__panel", [{"pa-tabs__panel--active", @is_active}], @class)}
      {@rest}
    >
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  @doc """
  Renders a vertical tabs layout wrapper.
  """
  attr(:is_bordered, :boolean, default: false)
  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def tabs_vertical_layout(assigns) do
    ~H"""
    <div
      class={build_classes("pa-tabs__vertical-layout", [{"pa-tabs__vertical-layout--bordered", @is_bordered}], @class)}
      {@rest}
    >
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  @doc """
  Renders a bordered tabs container wrapper.
  """
  attr(:is_bordered, :boolean, default: false)
  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def tabs_container(assigns) do
    ~H"""
    <div
      class={build_classes("pa-tabs__container", [{"pa-tabs__container--bordered", @is_bordered}], @class)}
      {@rest}
    >
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  @doc """
  Returns a JS command that switches tab panels.

  Deactivates all sibling tabs and panels, then activates the target.
  """
  @spec switch_tab(String.t(), String.t() | nil, String.t() | nil) :: JS.t()
  def switch_tab(target_panel_id, tabs_id \\ nil, tab_item_id \\ nil) do
    tab_scope = if tabs_id, do: "##{tabs_id} .pa-tabs__item", else: ".pa-tabs__item"
    tab_scope = if tab_item_id, do: "#{tab_scope}:not(##{tab_item_id})", else: tab_scope
    # Scope panels to a content container with id derived from tabs id
    panel_scope = if tabs_id, do: "##{tabs_id}-content .pa-tabs__panel", else: ".pa-tabs__panel"

    %JS{}
    |> JS.add_class("pa-tabs__item--active")
    |> JS.remove_class("pa-tabs__item--active", to: tab_scope)
    |> JS.add_class("pa-tabs__panel--active", to: "##{target_panel_id}")
    |> JS.remove_class("pa-tabs__panel--active", to: "#{panel_scope}:not(##{target_panel_id})")
  end
end
