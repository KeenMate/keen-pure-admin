defmodule KPureAdmin.Components.Toast do
  @moduledoc """
  Toast components for Pure Admin. (Phase 3/4)
  """
  use Phoenix.Component

  import KPureAdmin.Helpers

  @doc "Renders a static toast notification."
  attr(:variant, :string, default: "info")
  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def toast(assigns) do
    ~H"""
    <div class={build_classes("pa-toast", [{"pa-toast--#{@variant}", true}], @class)} {@rest}>
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  @doc "Renders a toast container."
  attr(:position, :string, default: "top-right")
  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def toast_container(assigns) do
    ~H"""
    <div class={build_classes("pa-toast-container", [{"pa-toast-container--#{@position}", true}], @class)} {@rest}>
      <%= render_slot(@inner_block) %>
    </div>
    """
  end
end
