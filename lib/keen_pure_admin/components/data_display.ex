defmodule KPureAdmin.Components.DataDisplay do
  @moduledoc """
  Data display components for Pure Admin. (Phase 2)

  Includes Field, Fields, FieldGroup, DescTable, DotLeaders, PropCard,
  Banded, AccentGrid and their sub-components.
  """
  use Phoenix.Component

  import KPureAdmin.Helpers

  @doc "Renders a single field display (label + value)."
  attr(:label, :string, required: true)
  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def field(assigns) do
    ~H"""
    <div class={build_classes("pa-field", [], @class)} {@rest}>
      <dt class="pa-field__label"><%= @label %></dt>
      <dd class="pa-field__value"><%= render_slot(@inner_block) %></dd>
    </div>
    """
  end

  @doc "Renders a group of fields."
  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def fields(assigns) do
    ~H"""
    <dl class={build_classes("pa-fields", [], @class)} {@rest}>
      <%= render_slot(@inner_block) %>
    </dl>
    """
  end
end
