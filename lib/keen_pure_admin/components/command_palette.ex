defmodule PureAdmin.Components.CommandPalette do
  use Phoenix.Component
  import PureAdmin.Helpers

  @doc """
  Renders a command palette (Spotlight-style search overlay).

  The command palette is controlled by assigns from the parent LiveView.
  Use the `PureAdminCommandPalette` JS hook for keyboard shortcuts and navigation.

  ## Examples

      <.command_palette
        id="cmd-palette"
        is_open={@command_palette_open}
        query={@command_palette_query}
        results={@command_palette_results}
        context={@command_palette_context}
        placeholder="Search products, orders, users..."
        page={@command_palette_page}
        total_pages={@command_palette_total_pages}
        total_results={@command_palette_total_results}
      />
  """
  attr(:id, :string, default: "command-palette")
  attr(:is_open, :boolean, default: false)
  attr(:query, :string, default: "")
  attr(:results, :list, default: [], doc: "List of %{id, title, meta, icon, badge} maps")
  attr(:context, :string, default: nil, doc: "Current context label e.g. 'Searching in Products'")
  attr(:is_loading, :boolean, default: false)
  attr(:placeholder, :string, default: "Search products, orders, users... (try /p, /o, /u)")
  attr(:page, :integer, default: 1)
  attr(:total_pages, :integer, default: 1)
  attr(:total_results, :integer, default: 0)
  attr(:active_index, :integer, default: -1)

  attr(:empty_text, :string,
    default:
      "Type to search or use /p for products, /o for orders, /u for users, /i for invoices"
  )

  attr(:class, :string, default: nil)
  attr(:rest, :global)

  def command_palette(assigns) do
    ~H"""
    <div
      id={@id}
      class={
        build_classes(
          "pa-command-palette",
          [
            {"pa-command-palette--active", @is_open}
          ],
          @class
        )
      }
      phx-hook="PureAdminCommandPalette"
      {@rest}
    >
      <div class="pa-command-palette__backdrop"></div>
      <div class="pa-command-palette__container">
        <div class="pa-command-palette__search">
          <input
            type="text"
            class="pa-command-palette__input"
            id={"#{@id}-input"}
            value={@query}
            placeholder={@placeholder}
            autocomplete="off"
            spellcheck="false"
          />
          <div class={
            build_classes("pa-command-palette__context", [
              {"pa-command-palette__context--visible", @context != nil}
            ])
          }>
            <%= @context %>
          </div>
        </div>

        <div class={
          build_classes("pa-command-palette__results", [
            {"pa-command-palette__results--loading", @is_loading}
          ])
        }>
          <%= if @is_loading and @results == [] do %>
            <div class="pa-command-palette__loader">
              <div class="pa-spinner pa-spinner--sm pa-spinner--primary"></div>
              <span>Searching...</span>
            </div>
          <% else %>
            <%= if @results != [] do %>
              <%= for {item, index} <- Enum.with_index(@results) do %>
                <div
                  class={
                    build_classes("pa-command-palette__item", [
                      {"pa-command-palette__item--active", index == @active_index}
                    ])
                  }
                  phx-click="command_palette_select"
                  phx-value-index={index}
                >
                  <div :if={item[:icon]} class="pa-command-palette__item-icon"><%= item.icon %></div>
                  <div class="pa-command-palette__item-content">
                    <div class="pa-command-palette__item-title"><%= item.title %></div>
                    <div :if={item[:meta]} class="pa-command-palette__item-meta"><%= item.meta %></div>
                  </div>
                  <div :if={item[:badge]} class="pa-command-palette__item-badge">
                    <%= item.badge %>
                  </div>
                </div>
              <% end %>
              <div :if={@total_pages > 1} class="pa-command-palette__pagination">
                Page <%= @page %> of <%= @total_pages %> · <%= @total_results %> results
              </div>
            <% else %>
              <div class="pa-command-palette__empty"><%= @empty_text %></div>
            <% end %>
          <% end %>
        </div>

        <div class="pa-command-palette__footer">
          <div class="pa-command-palette__hint">
            <span class="pa-command-palette__key">↑↓</span>
            <span>Navigate</span>
          </div>
          <div class="pa-command-palette__hint">
            <span class="pa-command-palette__key">←→</span>
            <span>Pages</span>
          </div>
          <div class="pa-command-palette__hint">
            <span class="pa-command-palette__key">↵</span>
            <span>Select</span>
          </div>
          <div class="pa-command-palette__hint">
            <span class="pa-command-palette__key">Esc</span>
            <span>Close</span>
          </div>
        </div>
      </div>
    </div>
    """
  end
end
