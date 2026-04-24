defmodule PureAdmin.Components.Card do
  @moduledoc """
  Card components for Pure Admin.

  Provides `card/1` with named slots for header, body, footer, tabs, and tools.
  Supports ghost mode, header underlines, live state indicators, and theme colors.
  """
  use Phoenix.Component

  import PureAdmin.Helpers

  @doc """
  Renders a card with Pure Admin BEM classes.

  ## Examples

      <.card>
        <p>Simple card content.</p>
      </.card>

      <.card title_text="Analytics Dashboard" description_text="Last 30 days">
        Dashboard content.
      </.card>

      <.card variant="primary" is_header_underlined>
        <:title text="Analytics Dashboard" icon="📊" />
        <:tools>
          <.button variant="secondary" size="sm">Refresh</.button>
        </:tools>
        Dashboard content.
      </.card>

      <.card is_ghost>
        <p>Ghost card with no background, border, or shadow.</p>
      </.card>
  """
  attr(:variant, :string, default: nil,
    values: [nil, "primary", "success", "warning", "danger", "info", "stat",
             "color-1", "color-2", "color-3", "color-4", "color-5",
             "color-6", "color-7", "color-8", "color-9"])
  attr(:live_state, :string, default: nil, values: [nil, "up", "down", "neutral"],
    doc: "Persistent tinted background reflecting latest change")
  attr(:is_ghost, :boolean, default: false, doc: "Ghost mode with no bg, border, shadow")
  attr(:is_bordered, :boolean, default: false, doc: "Bordered card with colored left border")
  attr(:has_padding, :boolean, default: true, doc: "Body padding toggle")
  attr(:title_text, :string, default: nil, doc: "Simple title text (shorthand for :title slot)")
  attr(:description_text, :string, default: nil, doc: "Inline description text, truncates with ellipsis")
  attr(:subtitle_text, :string, default: nil, doc: "Secondary/subtitle text")
  attr(:is_header_underlined, :boolean, default: false, doc: "Accent border under heading")
  attr(:header_underline_color, :string, default: nil,
    values: [nil, "success", "warning", "danger", "info"],
    doc: "Underline color variant")
  attr(:has_inline_tabs, :boolean, default: false, doc: "Pill-style buttons in header")
  attr(:header_wrap, :boolean, default: false, doc: "Allow header description to wrap")
  attr(:header_class, :string, default: nil, doc: "Additional CSS classes for header element")
  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:header, doc: "Full custom header content (overrides title_text/description_text)")

  slot :title, doc: "Structured title with icon" do
    attr(:icon, :string)
    attr(:text, :string, required: true)
  end

  slot(:title_icon, doc: "Icon rendering before title")
  slot(:subtitle, doc: "Rich subtitle content (alternative to subtitle_text)")
  slot(:description, doc: "Rich description content (alternative to description_text)")
  slot(:tools, doc: "Header tools/actions")
  slot(:meta, doc: "Metadata text in header")
  slot(:tabs, doc: "Card tabs in header")
  slot(:footer, doc: "Card footer content")
  slot(:actions, doc: "Footer actions (right-aligned)")
  slot(:inner_block, required: true)

  def card(assigns) do
    has_structured_header =
      assigns.title != [] || assigns.title_text != nil || assigns.tools != [] ||
        assigns.meta != [] || assigns.tabs != [] || assigns.description != [] ||
        assigns.description_text != nil || assigns.title_icon != [] ||
        assigns.subtitle != [] || assigns.subtitle_text != nil

    has_header = assigns.header != [] || has_structured_header

    assigns =
      assigns
      |> assign(:has_header, has_header)
      |> assign(:has_structured_header, has_structured_header)

    ~H"""
    <div class={card_classes(assigns)} {@rest}>
      <%!-- Full custom header --%>
      <div :if={@has_header && @header != []} class={header_classes(assigns)}>
        <%= for header <- @header do %>
          <%= render_slot(header) %>
        <% end %>
      </div>

      <%!-- Structured header --%>
      <div :if={@has_header && @header == []} class={header_classes(assigns)}>
        <%!-- Title with icon: wrapped in pa-card__title div --%>
        <div :if={@title_icon != [] && (@title != [] || @title_text != nil)} class="pa-card__title">
          <%= for title_icon <- @title_icon do %>
            <span class="pa-card__title-icon"><%= render_slot(title_icon) %></span>
          <% end %>
          <%= for title <- @title do %>
            <h3 class="pa-card__title-text"><%= title.text %></h3>
          <% end %>
          <h3 :if={@title == [] && @title_text != nil} class="pa-card__title-text"><%= @title_text %></h3>
        </div>
        <%!-- Title with icon via :title slot attr --%>
        <%= for title <- @title do %>
          <div :if={@title_icon == [] && title[:icon]} class="pa-card__title">
            <span class="pa-card__title-icon"><%= title[:icon] %></span>
            <h3 class="pa-card__title-text"><%= title.text %></h3>
          </div>
          <h3 :if={@title_icon == [] && !title[:icon]}><%= title.text %></h3>
        <% end %>
        <%!-- Title text only: plain h3 --%>
        <h3 :if={@title_icon == [] && @title == [] && @title_text != nil}><%= @title_text %></h3>

        <%!-- Inline tabs (after title) --%>
        <div :if={@tabs != [] && @has_inline_tabs} class="pa-card__tabs pa-card__tabs--inline">
          <%= for tabs <- @tabs do %>
            <%= render_slot(tabs) %>
          <% end %>
        </div>

        <%!-- Description --%>
        <p :if={@description_text != nil && @description == []} class={
          if @header_wrap, do: "pa-card__description", else: "pa-card__description pa-card__description--truncate"
        }>
          <%= @description_text %>
        </p>
        <%= for description <- @description do %>
          <p class="pa-card__description"><%= render_slot(description) %></p>
        <% end %>

        <%!-- Subtitle --%>
        <p :if={@subtitle_text != nil && @subtitle == []} class="pa-text pa-text--secondary"><%= @subtitle_text %></p>
        <%= for subtitle <- @subtitle do %>
          <p class="pa-text pa-text--secondary"><%= render_slot(subtitle) %></p>
        <% end %>

        <%!-- Metadata --%>
        <%= for meta <- @meta do %>
          <span class="pa-card__meta"><%= render_slot(meta) %></span>
        <% end %>

        <%!-- Tools (slot kept as `:tools` for API stability; CSS class is
             `pa-card__actions` per pure-admin-core snippet). --%>
        <%= for tools <- @tools do %>
          <div class="pa-card__actions"><%= render_slot(tools) %></div>
        <% end %>

      </div>
      <%!-- Tabs (non-inline, outside header) --%>
      <div :if={@has_header && @header == [] && @tabs != [] && !@has_inline_tabs} class="pa-card__tabs">
        <%= for tabs <- @tabs do %>
          <%= render_slot(tabs) %>
        <% end %>
      </div>

      <div class={body_classes(assigns)}>
        <%= render_slot(@inner_block) %>
      </div>
      <div :if={@footer != [] || @actions != []} class="pa-card__footer">
        <%= for footer <- @footer do %>
          <%= render_slot(footer) %>
        <% end %>
        <%= for actions <- @actions do %>
          <div class="pa-card__actions"><%= render_slot(actions) %></div>
        <% end %>
      </div>
    </div>
    """
  end

  @doc """
  Renders a card tab button.

  ## Examples

      <.card_tab is_active phx-click="switch-tab" phx-value-tab="overview">Overview</.card_tab>
  """
  attr(:is_active, :boolean, default: false)
  attr(:class, :string, default: nil)
  attr(:rest, :global, include: ~w(phx-click phx-value-tab))
  slot(:inner_block, required: true)

  def card_tab(assigns) do
    ~H"""
    <button
      class={build_classes("pa-card__tab", [{"pa-card__tab--active", @is_active}], @class)}
      {@rest}
    >
      <%= render_slot(@inner_block) %>
    </button>
    """
  end

  defp card_classes(assigns) do
    build_classes(
      "pa-card",
      [
        {"pa-card--#{assigns.variant}", assigns.variant != nil},
        {"pa-card--ghost", assigns.is_ghost},
        {"pa-card--bordered", assigns.is_bordered},
        {"pa-card--live-#{assigns.live_state}", assigns.live_state != nil}
      ],
      assigns.class
    )
  end

  defp header_classes(assigns) do
    build_classes(
      "pa-card__header",
      [
        {"pa-card__header--wrap", assigns.header_wrap},
        {"pa-card__header--underlined", assigns.is_header_underlined},
        {"pa-card__header--underline-#{assigns.header_underline_color}", assigns.header_underline_color != nil}
      ],
      assigns.header_class
    )
  end

  defp body_classes(assigns) do
    build_classes("pa-card__body", [
      {"pa-card__body--no-padding", !assigns.has_padding}
    ])
  end
end
