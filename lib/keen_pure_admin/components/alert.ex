defmodule KPureAdmin.Components.Alert do
  @moduledoc """
  Alert components for Pure Admin with JS-command-based dismiss support.
  """
  use Phoenix.Component

  alias Phoenix.LiveView.JS
  import KPureAdmin.Helpers

  @doc """
  Renders an alert with Pure Admin BEM classes.

  Supports dismissible alerts using `Phoenix.LiveView.JS` commands.

  ## Examples

      <.alert variant="success">Operation completed successfully.</.alert>

      <.alert variant="danger" is_dismissible id="error-alert">
        <:icon><i class="fa-solid fa-triangle-exclamation"></i></:icon>
        Something went wrong!
      </.alert>

      <.alert variant="info" heading_text="System Update">
        New features available.
        <:actions>
          <.button variant="primary" size="sm">Update Now</.button>
        </:actions>
      </.alert>

      <.alert variant="warning" heading_text="Validation Errors">
        <:list>
          <li>Name is required</li>
          <li>Email is invalid</li>
        </:list>
      </.alert>
  """
  attr(:id, :string, default: nil)
  attr(:variant, :string, default: "info",
    values: ["primary", "secondary", "success", "warning", "danger", "info", "light", "dark"],
    doc: "Color variant")
  attr(:size, :string, default: nil, values: [nil, "sm", "lg"])
  attr(:is_outline, :boolean, default: false, doc: "Outline style")
  attr(:is_dismissible, :boolean, default: false, doc: "Show close button")
  attr(:heading_text, :string, default: nil, doc: "Alert heading text (shorthand for :heading slot)")
  attr(:theme_color, :string, default: nil,
    values: [nil, "1", "2", "3", "4", "5", "6", "7", "8", "9"],
    doc: "Theme color 1-9")
  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:icon, doc: "Alert icon (wraps content in pa-alert__content)")
  slot(:heading, doc: "Alert heading (h4) - overrides heading_text")
  slot(:list, doc: "Alert list items (wrapped in ul.pa-alert__list)")
  slot(:actions, doc: "Action buttons")
  slot(:inner_block, required: true)

  def alert(assigns) do
    has_structured_content =
      assigns.icon != [] || assigns.heading != [] || assigns.heading_text != nil ||
        assigns.actions != [] || assigns.list != []

    assigns = assign(assigns, :has_structured_content, has_structured_content)

    ~H"""
    <div id={@id} class={alert_classes(assigns)} role="alert" {@rest}>
      <span :for={icon <- @icon} class="pa-alert__icon"><%= render_slot(icon) %></span>
      <div :if={@has_structured_content} class="pa-alert__content">
        <%= if @heading != [] do %>
          <h4 :for={heading <- @heading} class="pa-alert__heading"><%= render_slot(heading) %></h4>
        <% else %>
          <h4 :if={@heading_text} class="pa-alert__heading"><%= @heading_text %></h4>
        <% end %>
        <%= render_slot(@inner_block) %>
        <ul :if={@list != []} class="pa-alert__list">
          <%= for list <- @list do %>
            <%= render_slot(list) %>
          <% end %>
        </ul>
        <div :for={actions <- @actions} class="pa-alert__actions"><%= render_slot(actions) %></div>
      </div>
      <div :if={!@has_structured_content}>
        <%= render_slot(@inner_block) %>
      </div>
      <button
        :if={@is_dismissible}
        class="pa-alert__close"
        phx-click={dismiss_alert(@id)}
        aria-label="Close"
      >
        <span aria-hidden="true">&times;</span>
      </button>
    </div>
    """
  end

  @doc """
  Returns a JS command that dismisses an alert by hiding it with a fade transition.
  """
  @spec dismiss_alert(String.t()) :: Phoenix.LiveView.JS.t()
  def dismiss_alert(id) do
    JS.hide(to: "##{id}", transition: {"transition-opacity duration-300", "opacity-100", "opacity-0"})
  end

  defp alert_classes(assigns) do
    variant_class =
      if assigns.is_outline,
        do: "pa-alert--outline-#{assigns.variant}",
        else: "pa-alert--#{assigns.variant}"

    build_classes(
      "pa-alert",
      [
        {variant_class, true},
        {"pa-alert--#{assigns.size}", assigns.size != nil},
        {"pa-alert--dismissible", assigns.is_dismissible},
        {"pa-bg-color-#{assigns.theme_color}", assigns.theme_color != nil}
      ],
      assigns.class
    )
  end
end
