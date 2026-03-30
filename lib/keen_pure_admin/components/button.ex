defmodule PureAdmin.Components.Button do
  @moduledoc """
  Button components for Pure Admin.

  Provides `button/1` and `button_group/1` function components wrapping
  Pure Admin's `pa-btn` and `pa-btn-group` BEM classes.

  When `href` is provided, renders as `<a>` tag instead of `<button>`.
  """
  use Phoenix.Component

  import PureAdmin.Helpers

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
  attr(:theme_color, :string, default: nil,
    values: [nil, "1", "2", "3", "4", "5", "6", "7", "8", "9"],
    doc: "Theme color slot 1-9 (overrides variant)")
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
        <%= if @icon != [] do %><span class="pa-btn__label"><%= render_slot(@inner_block) %></span><% else %><%= render_slot(@inner_block) %><% end %>
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
        <%= if @icon != [] do %><span class="pa-btn__label"><%= render_slot(@inner_block) %></span><% else %><%= render_slot(@inner_block) %><% end %>
        <span :if={@icon != [] && @icon_position == "end"} :for={icon <- @icon} class="pa-btn__icon"><%= render_slot(icon) %></span>
      </button>
    <% end %>
    """
  end

  defp button_classes(assigns) do
    variant_class =
      cond do
        assigns.theme_color != nil and assigns.is_outline ->
          "pa-btn--outline-color-#{assigns.theme_color}"
        assigns.theme_color != nil ->
          "pa-btn--color-#{assigns.theme_color}"
        assigns.is_outline ->
          "pa-btn--outline-#{assigns.variant}"
        true ->
          "pa-btn--#{assigns.variant}"
      end

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

      <.split_button label="Save" variant="primary" on_click="save">
        <:item icon="fas fa-file" on_click="save" action="draft">Save as Draft</:item>
        <:item icon="fas fa-door-closed" on_click="save" action="close">Save & Close</:item>
      </.split_button>

      <.split_button label="Export" icon="fas fa-download" variant="secondary" on_click="export">
        <:item icon="fas fa-file-csv" on_click="export" action="csv">Export as CSV</:item>
        <:item icon="fas fa-file-pdf" on_click="export" action="pdf">Export as PDF</:item>
        <:item is_danger on_click="export" action="delete-all">Delete All</:item>
      </.split_button>

  ## Item icons

  Menu items can have icons via the `icon` attr, rendered as `pa-btn-split__item-icon`.

  ## Inline action buttons

  Items can include an inline action button (e.g. delete) beside the item text.
  Set `action_icon` to enable it:

      <.split_button label="Bookmarks" icon="fas fa-bookmark" variant="primary">
        <:item icon="fas fa-home" on_click="navigate" action="dashboard"
               action_icon="fas fa-trash-can" action_event="remove_bookmark" action_value="dashboard">
          Dashboard
        </:item>
      </.split_button>

  - `action_icon` — Font Awesome class for the inline button (required to show it)
  - `action_event` — LiveView event name pushed when clicked
  - `action_value` — string value sent as `%{"action" => value}` with the event.
    Falls back to the item's `action` attr if not set
  - `action_variant` — button color variant (default: `"danger"`)

  ## Upward placement

  Use `placement="top-end"` to open the menu upward. The chevron icon
  automatically points up. Floating UI will auto-flip if there's not enough space.
  """
  attr(:label, :string, required: true, doc: "Primary button label")
  attr(:icon, :string, default: nil, doc: "Font Awesome icon class for the primary button (e.g. \"fas fa-download\")")
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
    attr(:icon, :string, doc: "Font Awesome icon class for the item (e.g. \"fas fa-file\")")
    attr(:action_icon, :string, doc: "Inline action button icon (e.g. \"fas fa-trash-can\")")
    attr(:action_event, :string, doc: "LiveView event for the inline action button")
    attr(:action_value, :string, doc: "Value sent with the inline action event")
    attr(:action_variant, :string, doc: "Variant for the inline action button (default: \"danger\")")
  end

  def split_button(assigns) do
    size_class = if assigns.size, do: " pa-btn--#{assigns.size}", else: ""
    chevron = if String.starts_with?(assigns.placement, "top"), do: "fa-chevron-up", else: "fa-chevron-down"
    assigns = assigns |> assign(:size_class, size_class) |> assign(:chevron, chevron)

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
        <span :if={@icon} class="pa-btn__icon"><i class={@icon}></i></span>
        <%= @label %>
      </button>
      <button
        class={"pa-btn pa-btn--#{@variant}#{@size_class} pa-btn-split__toggle"}
        type="button"
        disabled={@disabled}
      >
        <i class={"fas #{@chevron} text-2xs pa-btn-split__chevron"}></i>
      </button>
      <div class="pa-btn-split__menu">
        <div class="pa-btn-split__menu-inner">
          <%= for item <- @item do %>
            <%= if item[:action_icon] do %>
              <div class="pa-btn-split__item-row">
                <button
                  class={"pa-btn-split__item#{if item[:is_danger], do: " pa-btn-split__item--danger", else: ""}"}
                  type="button"
                  data-phx-click={item[:on_click]}
                  data-phx-value-action={item[:action]}
                >
                  <span :if={item[:icon]} class="pa-btn-split__item-icon"><i class={item[:icon]}></i></span>
                  <%= render_slot(item) %>
                </button>
                <button
                  class={"pa-btn pa-btn--#{item[:action_variant] || "danger"} pa-btn--xs pa-btn--icon-only"}
                  type="button"
                  phx-click={item[:action_event]}
                  phx-value-action={item[:action_value] || item[:action]}
                >
                  <i class={item[:action_icon]}></i>
                </button>
              </div>
            <% else %>
              <button
                class={"pa-btn-split__item#{if item[:is_danger], do: " pa-btn-split__item--danger", else: ""}"}
                type="button"
                data-phx-click={item[:on_click]}
                data-phx-value-action={item[:action]}
              >
                <span :if={item[:icon]} class="pa-btn-split__item-icon"><i class={item[:icon]}></i></span>
                <%= render_slot(item) %>
              </button>
            <% end %>
          <% end %>
        </div>
      </div>
    </div>
    """
  end
end
