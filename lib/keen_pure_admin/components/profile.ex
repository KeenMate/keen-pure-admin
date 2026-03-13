defmodule KPureAdmin.Components.Profile do
  @moduledoc """
  Profile panel components for Pure Admin. (Phase 3)
  """
  use Phoenix.Component

  import KPureAdmin.Helpers

  @doc "Renders a profile panel container."
  attr(:id, :string, default: "profile-panel")
  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def profile_panel(assigns) do
    ~H"""
    <div id={@id} class={build_classes("pa-profile-panel", [], @class)} {@rest}>
      <div class="pa-profile-panel__content">
        <%= render_slot(@inner_block) %>
      </div>
    </div>
    """
  end
end
