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
      <.flash_message kind={:info} flash={@flash} />
      <.flash_message kind={:error} flash={@flash} />
    </div>
    """
  end

  attr :kind, :atom, values: [:info, :error]
  attr :flash, :map, default: %{}

  defp flash_message(assigns) do
    variant = if assigns.kind == :info, do: "info", else: "danger"
    assigns = assign(assigns, :variant, variant)

    ~H"""
    <div
      :if={msg = Phoenix.Flash.get(@flash, @kind)}
      id={"flash-#{@kind}"}
      phx-click={Phoenix.LiveView.JS.push("lv:clear-flash", value: %{key: @kind})}
      role="alert"
      class={"pa-alert pa-alert--#{@variant}"}
      style="cursor: pointer;"
    >
      {msg}
    </div>
    """
  end
end
