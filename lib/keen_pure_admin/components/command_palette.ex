defmodule PureAdmin.Components.CommandPalette do
  @moduledoc """
  Command palette component with multi-step commands and scoped search.

  Supports three modes:

  - **Commands** (`/prefix`) — multi-step action wizards with step progression
  - **Search contexts** (`:prefix`) — scoped entity search
  - **Global search** (no prefix) — search across everything

  ## Usage

      <.command_palette
        id="cmd-palette"
        is_open={@cp_open}
        mode={@cp_mode}
        query={@cp_query}
        results={@cp_results}
        commands={@cp_commands}
        contexts={@cp_contexts}
        active_index={@cp_active_index}
        current_command={@cp_current_command}
        current_step={@cp_current_step}
        current_step_index={@cp_step_index}
        total_steps={@cp_total_steps}
        selections={@cp_selections}
        preview={@cp_preview}
        current_context={@cp_current_context}
        is_loading={@cp_loading}
      />

  ## Commands

  Register commands as a list of maps:

      commands = [
        %{
          id: "deploy",
          shortcut: "/deploy",
          aliases: ["/d"],
          name: "Deploy to Environment",
          description: "Deploy a branch to an environment",
          icon: "🚀",
          steps: [
            %{id: "environment", prompt: " in ", placeholder: "Select environment..."},
            %{id: "branch", prompt: " branch ", placeholder: "Select or type branch...", free_text: true}
          ]
        }
      ]

  ## Search Contexts

  Register contexts as a list of maps:

      contexts = [
        %{id: "products", shortcut: ":products", aliases: [":p"], name: "Products", icon: "📦"},
        %{id: "orders", shortcut: ":orders", aliases: [":o"], name: "Orders", icon: "📋"}
      ]

  ## Event Protocol

  The JS hook sends these events to the LiveView:

  - `"cp:toggle"` — Ctrl+K pressed
  - `"cp:close"` — Escape at top level, backdrop click
  - `"cp:input"` — `%{"query" => string}` — input changed
  - `"cp:navigate"` — `%{"direction" => "up"|"down"}` — arrow keys
  - `"cp:page"` — `%{"direction" => "prev"|"next"}` — arrow left/right
  - `"cp:select"` — `%{"index" => integer}` — Enter or click
  - `"cp:step_back"` — Backspace at position 0 or Escape in step/context mode
  """
  use Phoenix.Component
  import PureAdmin.Helpers

  attr(:id, :string, default: "command-palette")
  attr(:is_open, :boolean, default: false)
  attr(:query, :string, default: "")

  # Mode
  attr(:mode, :string, default: "idle",
    values: ~w(idle command_list command_step context_list context_search global_search))

  # Registrations
  attr(:commands, :list, default: [], doc: "List of command maps")
  attr(:contexts, :list, default: [], doc: "List of search context maps")

  # Results (items displayed in all modes)
  attr(:results, :list, default: [], doc: "Current items to display")
  attr(:active_index, :integer, default: -1)
  attr(:is_loading, :boolean, default: false)

  # Command step state
  attr(:current_command, :map, default: nil, doc: "Active command in step mode")
  attr(:current_step, :map, default: nil, doc: "Active step")
  attr(:current_step_index, :integer, default: 0)
  attr(:total_steps, :integer, default: 0)
  attr(:selections, :list, default: [], doc: "Previous step selections as [%{step_id, label}]")
  attr(:preview, :string, default: nil, doc: "Preview text for command")

  # Search context state
  attr(:current_context, :map, default: nil, doc: "Active search context")

  # Pagination
  attr(:page, :integer, default: 1)
  attr(:total_pages, :integer, default: 1)
  attr(:total_results, :integer, default: 0)

  # UI
  attr(:placeholder, :string, default: "Type / for commands, : for search, or just type...")
  attr(:empty_text, :string, default: "Type / for commands, : to search, or just start typing")
  attr(:class, :string, default: nil)
  attr(:rest, :global)

  def command_palette(assigns) do
    ~H"""
    <div
      id={@id}
      class={build_classes("pa-command-palette", [{"pa-command-palette--active", @is_open}], @class)}
      phx-hook="PureAdminCommandPalette"
      data-mode={@mode}
      {@rest}
    >
      <div class="pa-command-palette__backdrop"></div>
      <div class="pa-command-palette__container">
        <%!-- Search header --%>
        <div class="pa-command-palette__search">
          <%!-- Step tokens (locked prefix in command_step mode) --%>
          <%= if @mode == "command_step" and @current_command do %>
            <div class="pa-command-palette__tokens">
              <span class="pa-command-palette__token pa-command-palette__token--command">
                <%= @current_command[:name] || @current_command[:shortcut] %>
              </span>
              <%= for sel <- @selections do %>
                <span class="pa-command-palette__token pa-command-palette__token--prompt">
                  <%= sel[:prompt] || "" %>
                </span>
                <span class="pa-command-palette__token pa-command-palette__token--value">
                  <%= sel[:label] %>
                </span>
              <% end %>
              <span :if={@current_step && @current_step[:prompt]} class="pa-command-palette__token pa-command-palette__token--prompt">
                <%= @current_step[:prompt] %>
              </span>
            </div>
          <% end %>

          <input
            type="text"
            class="pa-command-palette__input"
            id={"#{@id}-input"}
            value={@query}
            placeholder={step_placeholder(assigns)}
            autocomplete="off"
            spellcheck="false"
          />

          <%!-- Context label (in context_search mode) --%>
          <div class={build_classes("pa-command-palette__context", [
            {"pa-command-palette__context--visible", @mode == "context_search" and @current_context != nil}
          ])}>
            <%= if @current_context, do: "Searching in #{@current_context[:name]}" %>
          </div>
        </div>

        <%!-- Preview (command step mode only) --%>
        <div :if={@preview} class="pa-command-palette__preview">
          <%= @preview %>
        </div>

        <%!-- Step progress indicator --%>
        <div :if={@mode == "command_step" and @total_steps > 1} class="pa-command-palette__step-indicator">
          Step <%= @current_step_index + 1 %> of <%= @total_steps %>
        </div>

        <%!-- Results --%>
        <div class={build_classes("pa-command-palette__results", [
          {"pa-command-palette__results--loading", @is_loading}
        ])}>
          <%= if @is_loading and @results == [] do %>
            <div class="pa-command-palette__loader">
              <div class="pa-spinner pa-spinner--sm pa-spinner--primary"></div>
              <span>Searching...</span>
            </div>
          <% else %>
            <%= if @results != [] do %>
              <%= for {item, index} <- Enum.with_index(@results) do %>
                <div
                  class={build_classes("pa-command-palette__item", [
                    {"pa-command-palette__item--active", index == @active_index}
                  ])}
                  phx-click="cp:select"
                  phx-value-index={index}
                >
                  <div :if={item[:icon]} class="pa-command-palette__item-icon"><%= item[:icon] %></div>
                  <div class="pa-command-palette__item-content">
                    <div class="pa-command-palette__item-title"><%= item[:title] || item[:name] || item[:label] %></div>
                    <div :if={item[:subtitle] || item[:description] || item[:meta]} class="pa-command-palette__item-meta">
                      <%= item[:subtitle] || item[:description] || item[:meta] %>
                    </div>
                  </div>
                  <div :if={item[:badge]} class="pa-command-palette__item-badge"><%= item[:badge] %></div>
                  <div :if={item[:shortcut]} class="pa-command-palette__item-shortcut">
                    <code><%= item[:shortcut] %></code>
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

        <%!-- Footer with mode-aware hints --%>
        <div class="pa-command-palette__footer">
          <div class="pa-command-palette__hint">
            <span class="pa-command-palette__key">↑↓</span>
            <span>Navigate</span>
          </div>
          <div :if={@mode in ["context_search", "global_search"] and @total_pages > 1} class="pa-command-palette__hint">
            <span class="pa-command-palette__key">←→</span>
            <span>Pages</span>
          </div>
          <div class="pa-command-palette__hint">
            <span class="pa-command-palette__key">↵</span>
            <span>Select</span>
          </div>
          <div :if={@mode in ["command_step", "context_search"]} class="pa-command-palette__hint">
            <span class="pa-command-palette__key">⌫</span>
            <span>Back</span>
          </div>
          <div class="pa-command-palette__hint">
            <span class="pa-command-palette__key">Esc</span>
            <span><%= if @mode in ["command_step", "context_search"], do: "Back", else: "Close" %></span>
          </div>
        </div>
      </div>
    </div>
    """
  end

  defp step_placeholder(assigns) do
    cond do
      assigns.mode == "command_step" and assigns.current_step ->
        assigns.current_step[:placeholder] || "Type to filter..."
      true ->
        assigns.placeholder
    end
  end
end
