defmodule PureAdmin.Components.CommandPalette do
  @moduledoc """
  Command palette component with multi-step commands and scoped search.

  Supports three modes:

  - **Commands** (`/prefix`) — multi-step action wizards with step progression
  - **Search contexts** (`:prefix`) — scoped entity search
  - **Global search** (no prefix) — search across everything

  ## Display Styles

  Two display styles for command step progression:

  - `"inline"` (default) — Svelte-style, the input shows the full accumulated text
    like a sentence: `/assign iPad Air to |`. A command badge shows on the right.
    The editable portion is after the last prompt.
  - `"tokens"` — The input is cleared on each step. Previous selections show as
    colored token spans above the input.

  ## Usage

      <%!-- Inline style (default, matches Svelte) --%>
      <.command_palette id="cmd" is_open={@cp_open} mode={@cp_mode} ... />

      <%!-- Token style --%>
      <.command_palette id="cmd" display="tokens" is_open={@cp_open} mode={@cp_mode} ... />
  """
  use Phoenix.Component
  alias Phoenix.LiveView.JS
  import PureAdmin.Helpers
  import PureAdmin.Translations, only: [t: 1, t: 2]

  @doc """
  JS command that opens the command palette by id — wire it to any trigger
  (e.g. `navbar_search/1`, `sidebar_search/1`) via `phx-click`.

  It dispatches `pa:command-palette:open` to the palette element; the
  `PureAdminCommandPalette` hook listens and toggles the palette open. This
  avoids each trigger needing its own LiveView event plumbing.

  ## Examples

      <.navbar_search phx-click={show_command_palette()} />
      <.sidebar_search phx-click={show_command_palette("my-palette")} />
  """
  def show_command_palette(js_or_id \\ %JS{}, id \\ "command-palette")

  # Ergonomic single-arg id form: show_command_palette("my-palette").
  def show_command_palette(id, _default) when is_binary(id) do
    JS.dispatch(%JS{}, "pa:command-palette:open", to: "##{id}")
  end

  # Piped/default form: show_command_palette() or JS.push(...) |> show_command_palette("id").
  def show_command_palette(js, id) do
    JS.dispatch(js, "pa:command-palette:open", to: "##{id}")
  end

  attr(:id, :string, default: "command-palette")
  attr(:is_open, :boolean, default: false)
  attr(:query, :string, default: "")

  # Size preset (rc15): sets container width + results height together. For an
  # arbitrary size, leave this nil and override the runtime CSS variables
  # (`--pc-command-palette-width` / `-offset-top` / `-results-max-height`) at
  # `:root`, inline, or per-instance instead — no recompile needed.
  attr(:size, :string,
    default: nil,
    values: [nil, "sm", "lg", "xl"],
    doc: "Size preset: sm (48/28.8rem), lg (76.8/51.2rem), xl (89.6/64rem); nil keeps the 60.8/38.4rem default."
  )

  # Display style
  attr(:display, :string,
    default: "inline",
    values: ~w(inline tokens),
    doc: "Step display style: inline (sentence in input) or tokens (spans above input)"
  )

  # Mode
  attr(:mode, :string,
    default: "idle",
    values: ~w(idle command_list command_step context_list context_search global_search)
  )

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

  # Inline mode: full input text including command prefix and selections
  attr(:input_text, :string, default: "", doc: "Full input text for inline display mode")

  # Search context state
  attr(:current_context, :map, default: nil, doc: "Active search context")

  # Pagination
  attr(:page, :integer, default: 1)
  attr(:total_pages, :integer, default: 1)
  attr(:total_results, :integer, default: 0)

  # UI
  attr(:placeholder, :string, default: nil)
  attr(:empty_text, :string, default: nil)
  attr(:class, :string, default: nil)
  attr(:rest, :global)

  def command_palette(assigns) do
    assigns =
      assigns
      |> assign(:placeholder, assigns.placeholder || t("pureAdmin.commandPalette.placeholder"))
      |> assign(:empty_text, assigns.empty_text || t("pureAdmin.commandPalette.emptyText"))

    # For inline mode, use input_text as the displayed value; for tokens mode, use query
    display_value =
      if assigns.display == "inline" and assigns.mode == "command_step" do
        assigns.input_text
      else
        assigns.query
      end

    # Calculate locked prefix length for inline mode
    locked_length =
      if assigns.display == "inline" and assigns.mode == "command_step" and assigns.input_text != "" do
        # The locked portion is input_text minus whatever the user typed for the current step
        prefix_len = String.length(assigns.input_text) - String.length(assigns.query || "")
        max(0, prefix_len)
      else
        0
      end

    assigns = assigns |> assign(:display_value, display_value) |> assign(:locked_length, locked_length)

    ~H"""
    <div
      id={@id}
      class={build_classes("pa-command-palette", [{"pa-command-palette--active", @is_open}, {"pa-command-palette--#{@size}", @size != nil}], @class)}
      phx-hook="PureAdminCommandPalette"
      data-mode={@mode}
      data-display={@display}
      data-locked-length={@locked_length}
      {@rest}
    >
      <div class="pa-command-palette__backdrop"></div>
      <div class="pa-command-palette__container">
        <%!-- Search header --%>
        <div class="pa-command-palette__search">
          <%!-- Token display (tokens mode only) --%>
          <div :if={@display == "tokens"} class="pa-command-palette__tokens">
            <%= if @mode == "command_step" and @current_command do %>
              <span class="pa-badge pa-badge--primary">
                <%= @current_command[:name] || @current_command[:shortcut] %>
              </span>
              <%= for sel <- @selections do %>
                <span class="pa-command-palette__token-prompt">
                  <%= sel[:prompt] || "" %>
                </span>
                <span class="pa-badge">
                  <%= sel[:label] %>
                </span>
              <% end %>
              <span :if={@current_step && @current_step[:prompt]} class="pa-command-palette__token-prompt">
                <%= @current_step[:prompt] %>
              </span>
            <% end %>
          </div>

          <div class="pa-command-palette__input-wrapper">
            <input
              type="text"
              class="pa-command-palette__input"
              id={"#{@id}-input"}
              value={@display_value}
              placeholder={step_placeholder(assigns)}
              autocomplete="off"
              spellcheck="false"
            />

            <%!-- Command badge (inline mode, shown in step mode) --%>
            <div
              :if={@display == "inline" and @mode == "command_step" and @current_command}
              class="pa-command-palette__context pa-command-palette__context--visible"
            >
              <%= @current_command[:name] %>
            </div>

            <%!-- Context label (in context_search mode) --%>
            <div class={build_classes("pa-command-palette__context", [
              {"pa-command-palette__context--visible", @mode == "context_search" and @current_context != nil}
            ])}>
              <%= if @current_context, do: t("pureAdmin.commandPalette.searchingIn", %{name: @current_context[:name]}) %>
            </div>
          </div>
        </div>

        <%!-- Step progress indicator (tokens mode only) --%>
        <div :if={@display == "tokens" and @mode == "command_step" and @total_steps > 1} class="pa-command-palette__step-indicator">
          <%= t("pureAdmin.commandPalette.stepOf", %{current: @current_step_index + 1, total: @total_steps}) %>
        </div>

        <%!-- Results --%>
        <div class={build_classes("pa-command-palette__results", [
          {"pa-command-palette__results--loading", @is_loading}
        ])}>
          <%= if @is_loading and @results == [] do %>
            <div class="pa-command-palette__loader">
              <div class="pa-spinner pa-spinner--primary"></div>
              <span><%= t("pureAdmin.commandPalette.searching") %></span>
            </div>
          <% else %>
            <%= if @mode == "idle" and @results == [] do %>
              <%!-- Home screen: show commands + contexts --%>
              <div class="pa-command-palette__home">
                <div :if={@commands != []} class="pa-command-palette__home-section">
                  <div class="pa-command-palette__home-heading"><%= t("pureAdmin.commandPalette.commands") %></div>
                  <%= for cmd <- @commands do %>
                    <div class="pa-command-palette__item" phx-click="cp:home_select" phx-value-type="command" phx-value-shortcut={cmd.shortcut}>
                      <div :if={cmd[:icon]} class="pa-command-palette__item-icon"><%= cmd[:icon] %></div>
                      <div class="pa-command-palette__item-content">
                        <div class="pa-command-palette__item-title"><%= cmd[:name] %></div>
                        <div class="pa-command-palette__item-meta"><%= cmd[:description] %></div>
                      </div>
                      <%= if cmd[:hotkey] do %>
                        <div class="pa-command-palette__shortcut">
                          <%= for key <- String.split(cmd[:hotkey], "+") do %>
                            <span class="pa-command-palette__key"><%= key %></span>
                          <% end %>
                        </div>
                      <% else %>
                        <span class="pa-command-palette__key"><%= cmd[:shortcut] %></span>
                      <% end %>
                    </div>
                  <% end %>
                </div>
                <div :if={@contexts != []} class="pa-command-palette__home-section">
                  <div class="pa-command-palette__home-heading"><%= t("pureAdmin.commandPalette.search") %></div>
                  <%= for ctx <- @contexts do %>
                    <div class="pa-command-palette__item" phx-click="cp:home_select" phx-value-type="context" phx-value-shortcut={ctx.shortcut}>
                      <div :if={ctx[:icon]} class="pa-command-palette__item-icon"><%= ctx[:icon] %></div>
                      <div class="pa-command-palette__item-content">
                        <div class="pa-command-palette__item-title"><%= ctx[:name] %></div>
                        <div :if={ctx[:description]} class="pa-command-palette__item-meta"><%= ctx[:description] %></div>
                      </div>
                      <span class="pa-command-palette__key"><%= ctx[:shortcut] %></span>
                    </div>
                  <% end %>
                </div>
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
                    <span :if={item[:badge]} class="pa-badge"><%= item[:badge] %></span>
                    <div :if={item[:shortcut]} class="pa-command-palette__shortcut">
                      <span class="pa-command-palette__key"><%= item[:shortcut] %></span>
                    </div>
                  </div>
                <% end %>
                <div :if={@total_pages > 1} class="pa-command-palette__pagination">
                  <%= t("pureAdmin.commandPalette.pageOf", %{page: @page, total: @total_pages, count: @total_results}) %>
                </div>
              <% else %>
                <div class="pa-command-palette__empty"><%= @empty_text %></div>
              <% end %>
            <% end %>
          <% end %>
        </div>

        <%!-- Footer with mode-aware hints --%>
        <div class="pa-command-palette__footer">
          <div class="pa-command-palette__hint">
            <span class="pa-command-palette__key">↑↓</span>
            <span><%= t("pureAdmin.commandPalette.navigate") %></span>
          </div>
          <div :if={@mode in ["context_search", "global_search"] and @total_pages > 1} class="pa-command-palette__hint">
            <span class="pa-command-palette__key">←→</span>
            <span><%= t("pureAdmin.commandPalette.pages") %></span>
          </div>
          <div class="pa-command-palette__hint">
            <span class="pa-command-palette__key">↵</span>
            <span><%= t("pureAdmin.commandPalette.select") %></span>
          </div>
          <div :if={@mode in ["command_step", "context_search"]} class="pa-command-palette__hint">
            <span class="pa-command-palette__key">⌫</span>
            <span><%= t("pureAdmin.commandPalette.back") %></span>
          </div>
          <div class="pa-command-palette__hint">
            <span class="pa-command-palette__key">Esc</span>
            <span><%= if @mode in ["command_step", "context_search"], do: t("pureAdmin.commandPalette.back"), else: t("pureAdmin.commandPalette.close") %></span>
          </div>
        </div>
      </div>
    </div>
    """
  end

  defp step_placeholder(assigns) do
    cond do
      assigns.display == "inline" and assigns.mode == "command_step" ->
        # In inline mode, no separate placeholder — the accumulated text IS the context
        ""

      assigns.mode == "command_step" and assigns.current_step ->
        assigns.current_step[:placeholder] || t("pureAdmin.commandPalette.filterPlaceholder")

      true ->
        assigns.placeholder
    end
  end
end
