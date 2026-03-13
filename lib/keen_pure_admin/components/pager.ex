defmodule KPureAdmin.Components.Pager do
  @moduledoc """
  Pager and LoadMore components for Pure Admin. (Phase 2)
  """
  use Phoenix.Component

  import KPureAdmin.Helpers

  @doc "Renders a pagination control."
  attr(:page, :integer, default: 1)
  attr(:total_pages, :integer, default: 1)
  attr(:align, :string, default: nil, values: [nil, "start", "end"])
  attr(:class, :string, default: nil)
  attr(:rest, :global)

  def pager(assigns) do
    ~H"""
    <div class={build_classes("pa-pager", [{"pa-pager--#{@align}", @align != nil}], @class)} {@rest}>
      <div class="pa-pager__container">
        <div class="pa-pager__controls">
          <button class="pa-btn pa-btn--sm pa-btn--secondary" disabled={@page <= 1} phx-click="prev-page">
            &#8249; Previous
          </button>
          <button class="pa-btn pa-btn--sm pa-btn--secondary" disabled={@page >= @total_pages} phx-click="next-page">
            Next &#8250;
          </button>
        </div>
        <div class="pa-pager__info">
          <span class="pa-pager__text">Page <%= @page %> of <%= @total_pages %></span>
        </div>
      </div>
    </div>
    """
  end

  @doc "Renders a load more button."
  attr(:is_loading, :boolean, default: false)
  attr(:count, :string, default: nil)
  attr(:align, :string, default: nil, values: [nil, "start", "end"])
  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:inner_block)

  def load_more(assigns) do
    ~H"""
    <div class={build_classes("pa-load-more", [{"pa-load-more--#{@align}", @align != nil}], @class)} {@rest}>
      <button class={build_classes("pa-load-more__button", [{"pa-load-more__button--loading", @is_loading}])}>
        <span :if={@is_loading} class="pa-load-more__spinner"></span>
        <span class="pa-load-more__text">
          <%= if @inner_block != [], do: render_slot(@inner_block), else: "Load More" %>
        </span>
        <span :if={@count} class="pa-load-more__count">(<%= @count %>)</span>
      </button>
    </div>
    """
  end
end
