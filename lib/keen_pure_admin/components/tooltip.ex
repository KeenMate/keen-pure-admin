defmodule PureAdmin.Components.Tooltip do
  @moduledoc """
  Tooltip and Popover components for Pure Admin.

  Tooltips use CSS-only positioning via `pa-tooltip` class with `data-tooltip` attribute.
  Popovers use a click-triggered rich content overlay.
  """
  use Phoenix.Component

  import PureAdmin.Helpers

  @doc """
  Renders a tooltip wrapper around content.

  The tooltip text appears on hover via CSS `::before`/`::after` pseudo-elements.

  ## Examples

      <.tooltip text="Save your changes">
        <.button variant="primary">Save</.button>
      </.tooltip>

      <.tooltip text="Tooltip on bottom" position="bottom" variant="success">
        Hover me
      </.tooltip>

      <.tooltip text="Long explanation text..." multiline>
        Hover for details
      </.tooltip>
  """
  attr(:text, :string, required: true, doc: "Tooltip text")
  attr(:position, :string, default: nil, values: [nil, "top", "end", "bottom", "start"],
    doc: "Tooltip position: top (default), end (right in LTR), bottom, start (left in LTR)")
  attr(:variant, :string, default: nil,
    doc: "Color variant (primary, success, warning, danger, color-1 through color-9)")
  attr(:multiline, :boolean, default: false, doc: "Multiline tooltip (wider, left-aligned)")
  attr(:is_help, :boolean, default: false, doc: "Help cursor (question mark)")
  attr(:is_inline, :boolean, default: false, doc: "Inline text style with dotted underline")
  attr(:is_keyword, :boolean, default: false, doc: "Dotted underline + help cursor for inline term explanations")
  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def tooltip(assigns) do
    ~H"""
    <span
      class={build_classes("pa-tooltip", [
        {"pa-tooltip--floating", !@is_inline},
        {"pa-tooltip--#{@position}", @position != nil},
        {"pa-tooltip--#{@variant}", @variant != nil},
        {"pa-tooltip--multiline", @multiline},
        {"pa-tooltip--help", @is_help},
        {"pa-tooltip--keyword", @is_keyword}
      ], @class)}
      data-tooltip={@text}
      {@rest}
    >
      <%= render_slot(@inner_block) %>
    </span>
    """
  end

  @doc """
  Renders a popover trigger with rich content overlay.

  Uses a click-triggered pattern with CSS positioning.

  ## Examples

      <.popover title_text="Help" placement="bottom">
        <p>Rich content with <strong>HTML</strong>.</p>
      </.popover>

      <.popover title_text="Options" placement="bottom" size="lg">
        <:trigger>
          <.button variant="info" size="xs">Help</.button>
        </:trigger>
        <p>Detailed help content.</p>
      </.popover>
  """
  attr(:id, :string, default: nil, doc: "Unique ID (auto-generated if not provided)")
  attr(:title_text, :string, required: true)
  attr(:placement, :string, default: "top", values: ["top", "end", "bottom", "start"])
  attr(:size, :string, default: nil, values: [nil, "sm", "lg"])
  attr(:alignment, :string, default: nil, values: [nil, "center", "end"])
  attr(:trigger_text, :string, default: "?", doc: "Default trigger button text")
  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:trigger, doc: "Custom trigger content")
  slot(:inner_block, required: true)

  def popover(assigns) do
    ~H"""
    <div
      class={build_classes("pa-popover", [
        {"pa-popover--#{@size}", @size != nil},
        {"pa-popover--#{@alignment}", @alignment != nil}
      ], @class)}
      data-placement={@placement}
      id={@id}
    >
      <%= if @trigger != [] do %>
        <button class="pa-popover__trigger" data-pa-popover-trigger>
          <%= render_slot(@trigger) %>
        </button>
      <% else %>
        <button class="pa-popover__trigger" data-pa-popover-trigger>
          <%= @trigger_text %>
        </button>
      <% end %>
      <div class="pa-popover__content" data-placement={@placement}>
        <div class="pa-popover__header">
          <h4><%= @title_text %></h4>
          <button class="pa-popover__close" data-pa-popover-close aria-label="Close">×</button>
        </div>
        <div class="pa-popover__body">
          <%= render_slot(@inner_block) %>
        </div>
      </div>
    </div>
    """
  end
end
