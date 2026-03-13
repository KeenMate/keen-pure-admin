defmodule DemoWeb.Layouts do
  @moduledoc """
  Layout components for the demo app.
  """
  use DemoWeb, :html

  embed_templates "layouts/*"

  @doc "Renders flash notices."
  attr :flash, :map, required: true, doc: "the map of flash messages"
  attr :id, :string, default: "flash-group", doc: "the optional id of flash container"

  def flash_group(assigns) do
    ~H"""
    <div id={@id} aria-live="polite">
      <.flash kind={:info} flash={@flash} />
      <.flash kind={:error} flash={@flash} />
    </div>
    """
  end
end
