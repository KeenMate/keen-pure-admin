defmodule KPureAdmin.Components.Tooltip do
  @moduledoc """
  Tooltip and Popover components for Pure Admin.

  Tooltips use CSS-only positioning via `pa-tooltip` class with `data-tooltip` attribute.
  Popovers use a click-triggered rich content overlay.
  """
  use Phoenix.Component

  import KPureAdmin.Helpers

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
  attr(:position, :string, default: nil, values: [nil, "top", "right", "bottom", "left"],
    doc: "Tooltip position (default: top)")
  attr(:variant, :string, default: nil,
    doc: "Color variant (primary, success, warning, danger, color-1 through color-9)")
  attr(:multiline, :boolean, default: false, doc: "Multiline tooltip (wider, left-aligned)")
  attr(:is_help, :boolean, default: false, doc: "Help cursor (question mark)")
  attr(:is_inline, :boolean, default: false, doc: "Inline text style with dotted underline")
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
        {"pa-tooltip--help", @is_help}
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
  attr(:placement, :string, default: "top", values: ["top", "right", "bottom", "left"])
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
        {"pa-popover--#{@size}", @size != nil}
      ], @class)}
      data-placement={@placement}
      id={@id}
    >
      <%= if @trigger != [] do %>
        <button class="pa-popover__trigger" onclick="document.querySelectorAll('.pa-popover__content[data-show]').forEach(function(el){if(el!==this.nextElementSibling)el.removeAttribute('data-show')}.bind(this)); var c=this.nextElementSibling; c.hasAttribute('data-show') ? c.removeAttribute('data-show') : c.setAttribute('data-show',''); return false;">
          <%= render_slot(@trigger) %>
        </button>
      <% else %>
        <button class="pa-popover__trigger" onclick="document.querySelectorAll('.pa-popover__content[data-show]').forEach(function(el){if(el!==this.nextElementSibling)el.removeAttribute('data-show')}.bind(this)); var c=this.nextElementSibling; c.hasAttribute('data-show') ? c.removeAttribute('data-show') : c.setAttribute('data-show',''); return false;">
          <%= @trigger_text %>
        </button>
      <% end %>
      <div class={build_classes("pa-popover__content", [
        {"pa-popover__content--#{@alignment}", @alignment != nil}
      ])}>
        <div class="pa-popover__header">
          <span class="pa-popover__title"><%= @title_text %></span>
          <button class="pa-popover__close" onclick="this.closest('.pa-popover__content').removeAttribute('data-show'); return false;" aria-label="Close">×</button>
        </div>
        <div class="pa-popover__body">
          <%= render_slot(@inner_block) %>
        </div>
      </div>
    </div>
    """
  end
end
