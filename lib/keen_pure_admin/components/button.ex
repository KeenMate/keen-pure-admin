defmodule KPureAdmin.Components.Button do
  @moduledoc """
  Button components for Pure Admin.

  Provides `button/1` and `button_group/1` function components wrapping
  Pure Admin's `pa-btn` and `pa-btn-group` BEM classes.

  When `href` is provided, renders as `<a>` tag instead of `<button>`.
  """
  use Phoenix.Component

  import KPureAdmin.Helpers

  # -- button/1 --

  @doc """
  Renders a button styled with Pure Admin BEM classes.

  When `href` is provided, renders as an anchor tag instead of a button.

  ## Variants
  primary, secondary, success, danger, warning, info, light, dark

  ## Examples

      <.button variant="primary">Save</.button>
      <.button variant="danger" size="sm" is_outline>Delete</.button>
      <.button variant="primary" is_loading>Saving...</.button>
      <.button variant="primary" is_icon_only title="Save"><i class="fa-solid fa-floppy-disk"></i></.button>
      <.button href="/settings" variant="secondary">Settings</.button>
      <.button variant="primary">
        Save
        <:icon><i class="fa-solid fa-floppy-disk"></i></:icon>
      </.button>
  """
  attr(:variant, :string, default: "primary",
    values: ["primary", "secondary", "success", "warning", "danger", "info", "light", "dark", "ghost"],
    doc: "Color variant")
  attr(:size, :string, default: nil, values: [nil, "xs", "sm", "lg", "xl"], doc: "Button size")
  attr(:is_outline, :boolean, default: false, doc: "Outline style")
  attr(:is_block, :boolean, default: false, doc: "Full-width block button")
  attr(:is_loading, :boolean, default: false, doc: "Loading state with spinner")
  attr(:is_icon_only, :boolean, default: false, doc: "Icon-only button (square)")
  attr(:is_ripple, :boolean, default: false, doc: "Ripple effect on click")
  attr(:align, :string, default: nil, values: [nil, "start", "end", "center", "justify"], doc: "Content alignment")
  attr(:icon_position, :string, default: "start", values: ["start", "end"], doc: "Icon position relative to text")
  attr(:type, :string, default: "button", doc: "HTML button type")
  attr(:href, :string, default: nil, doc: "Link URL (renders as <a> tag)")
  attr(:target, :string, default: nil, doc: "Link target (_blank, _self, etc.)")
  attr(:class, :string, default: nil, doc: "Additional CSS classes")
  attr(:rest, :global, include: ~w(disabled name value form phx-click phx-disable-with title navigate patch))
  slot(:icon, doc: "Icon slot rendered inside pa-btn__icon span")
  slot(:inner_block, required: true)

  def button(assigns) do
    assigns = assign(assigns, :btn_classes, button_classes(assigns))

    ~H"""
    <%= if @href do %>
      <a
        href={@href}
        target={@target}
        class={@btn_classes}
        data-ripple={@is_ripple || nil}
        {@rest}
      >
        <span :if={@is_loading} class="pa-btn__spinner"></span>
        <span :if={@icon != [] && @icon_position == "start"} :for={icon <- @icon} class="pa-btn__icon"><%= render_slot(icon) %></span>
        <%= render_slot(@inner_block) %>
        <span :if={@icon != [] && @icon_position == "end"} :for={icon <- @icon} class="pa-btn__icon"><%= render_slot(icon) %></span>
      </a>
    <% else %>
      <button
        type={@type}
        class={@btn_classes}
        disabled={@is_loading || Map.get(@rest, :disabled, false)}
        data-ripple={@is_ripple || nil}
        {@rest}
      >
        <span :if={@is_loading} class="pa-btn__spinner"></span>
        <span :if={@icon != [] && @icon_position == "start"} :for={icon <- @icon} class="pa-btn__icon"><%= render_slot(icon) %></span>
        <%= render_slot(@inner_block) %>
        <span :if={@icon != [] && @icon_position == "end"} :for={icon <- @icon} class="pa-btn__icon"><%= render_slot(icon) %></span>
      </button>
    <% end %>
    """
  end

  defp button_classes(assigns) do
    variant_class =
      if assigns.is_outline,
        do: "pa-btn--outline-#{assigns.variant}",
        else: "pa-btn--#{assigns.variant}"

    build_classes(
      "pa-btn",
      [
        {variant_class, true},
        {"pa-btn--#{assigns.size}", assigns.size != nil},
        {"pa-btn--block", assigns.is_block},
        {"pa-btn--loading", assigns.is_loading},
        {"pa-btn--icon-only", assigns.is_icon_only},
        {"pa-btn--ripple", assigns.is_ripple},
        {"pa-btn--align-#{assigns.align}", assigns.align != nil}
      ],
      assigns.class
    )
  end

  # -- button_group/1 --

  @doc """
  Renders a button group container.

  ## Examples

      <.button_group>
        <.button variant="secondary">Left</.button>
        <.button variant="secondary">Right</.button>
      </.button_group>

      <.button_group is_vertical align="stretch">
        <.button variant="primary">Save</.button>
        <.button variant="danger">Delete</.button>
      </.button_group>
  """
  attr(:is_vertical, :boolean, default: false, doc: "Vertical orientation")
  attr(:align, :string, default: nil, values: [nil, "center", "end", "stretch"], doc: "Vertical alignment")
  attr(:is_nowrap, :boolean, default: false, doc: "Prevent wrapping")
  attr(:responsive, :string, default: nil,
    values: [nil, "sm-vertical", "sm-horizontal", "md-vertical", "md-horizontal",
             "lg-vertical", "lg-horizontal", "xl-vertical", "xl-horizontal"],
    doc: "Responsive direction change at breakpoint (e.g. 'md-vertical' becomes vertical at 768px+)")
  attr(:class, :string, default: nil, doc: "Additional CSS classes")
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def button_group(assigns) do
    ~H"""
    <div class={button_group_classes(assigns)} {@rest}>
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  defp button_group_classes(assigns) do
    build_classes(
      "pa-btn-group",
      [
        {"pa-btn-group--vertical", assigns.is_vertical},
        {"pa-btn-group--#{assigns.align}", assigns.align != nil},
        {"pa-btn-group--nowrap", assigns.is_nowrap},
        {"pa-btn-group--#{assigns.responsive}", assigns.responsive != nil}
      ],
      assigns.class
    )
  end

  # -- split_button/1 --

  @doc """
  Renders a split button with a primary action and a dropdown toggle.

  Uses the `PureAdminSplitButton` JS hook for Floating UI positioning.
  Menu items are rendered from the `:item` slot.

  ## Examples

      <.split_button label="Save" variant="primary">
        <:item>Save as Draft</:item>
        <:item>Save & Close</:item>
      </.split_button>

      <.split_button label="Export" variant="primary" on_click="export">
        <:item phx-click="export-csv">Export as CSV</:item>
        <:item phx-click="export-pdf">Export as PDF</:item>
        <:item is_danger phx-click="delete-all">Delete All</:item>
      </.split_button>

      <.split_button label="Upload" variant="primary" placement="top-end">
        <:item>Upload File</:item>
        <:item>Upload Folder</:item>
      </.split_button>
  """
  attr(:label, :string, required: true, doc: "Primary button label")
  attr(:variant, :string, default: "primary",
    values: ~w(primary secondary success warning danger info light dark))
  attr(:size, :string, default: nil, values: [nil, "xs", "sm", "lg", "xl"])
  attr(:placement, :string, default: "bottom-end", doc: "Menu placement (Floating UI)")
  attr(:on_click, :string, default: nil, doc: "phx-click event for the primary button")
  attr(:disabled, :boolean, default: false)
  attr(:class, :string, default: nil)
  attr(:rest, :global)

  slot :item, required: true, doc: "Menu items" do
    attr(:is_danger, :boolean, doc: "Danger styling for destructive actions")
    attr(:on_click, :string, doc: "LiveView click event name")
    attr(:action, :string, doc: "Action value sent with the click event")
  end

  def split_button(assigns) do
    size_class = if assigns.size, do: " pa-btn--#{assigns.size}", else: ""
    assigns = assign(assigns, :size_class, size_class)

    ~H"""
    <div
      class={build_classes("pa-btn-split", [], @class)}
      data-placement={@placement}
      phx-hook="PureAdminSplitButton"
      id={@rest[:id] || "split-btn-#{System.unique_integer([:positive])}"}
      {@rest}
    >
      <button
        class={"pa-btn pa-btn--#{@variant}#{@size_class}"}
        type="button"
        disabled={@disabled}
        phx-click={@on_click}
      >
        <%= @label %>
      </button>
      <button
        class={"pa-btn pa-btn--#{@variant}#{@size_class} pa-btn-split__toggle"}
        type="button"
        disabled={@disabled}
      >
        <i class="fas fa-chevron-down text-2xs pa-btn-split__chevron"></i>
      </button>
      <div class="pa-btn-split__menu">
        <button
          :for={item <- @item}
          class={"pa-btn-split__item#{if item[:is_danger], do: " pa-btn-split__item--danger", else: ""}"}
          type="button"
          data-phx-click={item[:on_click]}
          data-phx-value-action={item[:action]}
        >
          <%= render_slot(item) %>
        </button>
      </div>
    </div>
    """
  end
end
