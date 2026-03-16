defmodule KPureAdmin.Components.Pager do
  @moduledoc """
  Pager and LoadMore components for Pure Admin.
  """
  use Phoenix.Component

  import KPureAdmin.Helpers

  @doc """
  Renders a pagination control.

  ## Examples

      <.pager page={@page} total_pages={@total_pages} on_previous="prev_page" on_next="next_page" />

      <.pager page={3} total_pages={10} on_previous="prev" on_next="next" on_first="first" on_last="last" />

      <.pager page={1} total_pages={10} align="end" info_text="Showing 1-25 of 250" />
  """
  attr(:page, :integer, default: 1)
  attr(:total_pages, :integer, default: 1)
  attr(:align, :string, default: nil, values: [nil, "start", "center", "end"])
  attr(:show_page_input, :boolean, default: true, doc: "Show page number input")
  attr(:show_info, :boolean, default: true, doc: "Show info section")
  attr(:info_text, :string, default: nil, doc: "Custom info text (overrides page X of Y)")
  attr(:on_previous, :string, default: "prev-page", doc: "Event for previous button")
  attr(:on_next, :string, default: "next-page", doc: "Event for next button")
  attr(:on_first, :string, default: nil, doc: "Event for first button (nil = hidden)")
  attr(:on_last, :string, default: nil, doc: "Event for last button (nil = hidden)")
  attr(:on_page_change, :string, default: nil, doc: "Event for page input change")
  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:controls, doc: "Custom controls (overrides default buttons)")
  slot(:info, doc: "Custom info content (overrides default info)")

  def pager(assigns) do
    ~H"""
    <div class={build_classes("pa-pager", [{"pa-pager--#{@align}", @align != nil}], @class)} {@rest}>
      <div class="pa-pager__container">
        <%= if @controls != [] do %>
          <%= render_slot(@controls) %>
        <% else %>
          <div class="pa-pager__controls">
            <button :if={@on_first} class="pa-btn pa-btn--sm pa-btn--secondary" disabled={@page <= 1} phx-click={@on_first}>
              &#171; First
            </button>
            <button class="pa-btn pa-btn--sm pa-btn--secondary" disabled={@page <= 1} phx-click={@on_previous}>
              &#8249; Previous
            </button>
            <button class="pa-btn pa-btn--sm pa-btn--secondary" disabled={@page >= @total_pages} phx-click={@on_next}>
              Next &#8250;
            </button>
            <button :if={@on_last} class="pa-btn pa-btn--sm pa-btn--secondary" disabled={@page >= @total_pages} phx-click={@on_last}>
              Last &#187;
            </button>
          </div>
        <% end %>

        <%= if @info != [] do %>
          <%= render_slot(@info) %>
        <% else %>
          <div :if={@show_info && @show_page_input && @info_text == nil} class="pa-pager__info">
            <span class="pa-pager__text">Page</span>
            <input
              type="number"
              class="pa-input pa-input--sm pa-pager__input"
              value={@page}
              min="1"
              max={@total_pages}
              phx-change={@on_page_change}
              name="page"
            />
            <span class="pa-pager__text">of <%= @total_pages %></span>
          </div>
          <span :if={@info_text} class="pa-pager__text"><%= @info_text %></span>
        <% end %>
      </div>
    </div>
    """
  end

  @doc """
  Renders a load more button.

  ## Examples

      <.load_more phx-click="load_more" count="25 of 250" />
      <.load_more is_loading phx-click="load_more">Loading...</.load_more>
      <.load_more align="start" phx-click="load_more">Show More Items</.load_more>
  """
  attr(:is_loading, :boolean, default: false)
  attr(:count, :string, default: nil, doc: "Count text, e.g. '25 of 250'")
  attr(:align, :string, default: nil, values: [nil, "start", "center", "end"])
  attr(:class, :string, default: nil)
  attr(:rest, :global, include: ~w(phx-click))
  slot(:inner_block)

  def load_more(assigns) do
    ~H"""
    <div class={build_classes("pa-load-more", [{"pa-load-more--#{@align}", @align != nil}], @class)}>
      <button class={build_classes("pa-load-more__button", [{"pa-load-more__button--loading", @is_loading}])} {@rest}>
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
