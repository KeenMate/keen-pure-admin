defmodule KPureAdmin.Components.Form do
  @moduledoc """
  Form components for Pure Admin.

  Provides both low-level HTML components (`input/1`, `select/1`, `textarea/1`,
  `checkbox/1`, `radio/1`) and Phoenix-aware components (`form_group/1`,
  `form_field/1`, `simple_form/1`).
  """
  use Phoenix.Component

  import KPureAdmin.Helpers

  # ─── Low-level components ───

  @doc """
  Renders a text input with Pure Admin BEM classes.

  ## Examples

      <.input type="text" name="username" placeholder="Enter username" />
      <.input type="email" size="lg" validation="error" />
  """
  attr(:type, :string, default: "text")
  attr(:name, :string, default: nil)
  attr(:id, :string, default: nil)
  attr(:value, :any, default: nil)
  attr(:size, :string, default: nil, values: [nil, "xs", "sm", "lg", "xl"])
  attr(:validation, :string, default: nil, values: [nil, "success", "warning", "error"])
  attr(:is_error, :boolean, default: false, doc: "Shorthand for validation=\"error\"")
  attr(:is_success, :boolean, default: false, doc: "Shorthand for validation=\"success\"")
  attr(:color, :string, default: nil, doc: "Theme color (1-9)")
  attr(:class, :string, default: nil)
  attr(:rest, :global, include: ~w(placeholder disabled readonly required autocomplete autofocus
    min max step pattern maxlength minlength form phx-change phx-blur phx-focus phx-debounce))

  def input(assigns) do
    ~H"""
    <input
      type={@type}
      name={@name}
      id={@id}
      value={@value}
      class={input_classes(assigns)}
      {@rest}
    />
    """
  end

  defp input_classes(assigns) do
    validation =
      cond do
        assigns.is_error -> "error"
        assigns.is_success -> "success"
        true -> assigns.validation
      end

    build_classes(
      "pa-input",
      [
        {"pa-input--#{assigns.size}", assigns.size != nil},
        {"pa-input--#{validation}", validation != nil},
        {"pa-input--color-#{assigns.color}", assigns.color != nil}
      ],
      assigns.class
    )
  end

  @doc """
  Renders a textarea with Pure Admin BEM classes.

  ## Examples

      <.textarea name="message" rows={4} placeholder="Enter message" />
  """
  attr(:name, :string, default: nil)
  attr(:id, :string, default: nil)
  attr(:value, :any, default: nil)
  attr(:size, :string, default: nil, values: [nil, "xs", "sm", "lg", "xl"])
  attr(:validation, :string, default: nil, values: [nil, "success", "warning", "error"])
  attr(:color, :string, default: nil)
  attr(:class, :string, default: nil)
  attr(:rest, :global, include: ~w(placeholder disabled readonly required rows cols
    form phx-change phx-blur phx-debounce))

  def textarea(assigns) do
    ~H"""
    <textarea
      name={@name}
      id={@id}
      class={textarea_classes(assigns)}
      {@rest}
    ><%= @value %></textarea>
    """
  end

  defp textarea_classes(assigns) do
    build_classes(
      "pa-textarea",
      [
        {"pa-textarea--#{assigns.size}", assigns.size != nil},
        {"pa-textarea--#{assigns.validation}", assigns.validation != nil},
        {"pa-textarea--color-#{assigns.color}", assigns.color != nil}
      ],
      assigns.class
    )
  end

  @doc """
  Renders a select dropdown with Pure Admin BEM classes.

  ## Examples

      <.select name="country" options={[{"US", "United States"}, {"UK", "United Kingdom"}]} />
  """
  attr(:name, :string, default: nil)
  attr(:id, :string, default: nil)
  attr(:value, :any, default: nil)
  attr(:options, :list, default: [], doc: "List of {value, label} tuples or strings")
  attr(:prompt, :string, default: nil, doc: "Placeholder option")
  attr(:size, :string, default: nil, values: [nil, "xs", "sm", "lg", "xl"])
  attr(:validation, :string, default: nil, values: [nil, "success", "warning", "error"])
  attr(:color, :string, default: nil)
  attr(:class, :string, default: nil)
  attr(:rest, :global, include: ~w(disabled required multiple form phx-change phx-blur phx-debounce))

  def select(assigns) do
    ~H"""
    <select name={@name} id={@id} class={select_classes(assigns)} {@rest}>
      <option :if={@prompt} value=""><%= @prompt %></option>
      <%= Phoenix.HTML.Form.options_for_select(@options, @value) %>
    </select>
    """
  end

  defp select_classes(assigns) do
    build_classes(
      "pa-select",
      [
        {"pa-select--#{assigns.size}", assigns.size != nil},
        {"pa-select--#{assigns.validation}", assigns.validation != nil},
        {"pa-select--color-#{assigns.color}", assigns.color != nil}
      ],
      assigns.class
    )
  end

  @doc """
  Renders a custom tri-state checkbox with Pure Admin BEM classes.

  ## Examples

      <.checkbox name="agree" label="I agree to the terms" />
      <.checkbox name="option" label="Option A" checked size="lg" />
  """
  attr(:name, :string, default: nil)
  attr(:id, :string, default: nil)
  attr(:value, :string, default: "true")
  attr(:checked, :boolean, default: false)
  attr(:label, :string, default: nil)
  attr(:size, :string, default: nil, values: [nil, "xs", "sm", "lg", "xl"])
  attr(:class, :string, default: nil)
  attr(:rest, :global, include: ~w(disabled required form phx-change phx-click phx-debounce))

  def checkbox(assigns) do
    ~H"""
    <label class={checkbox_classes(assigns)}>
      <input type="checkbox" name={@name} id={@id} value={@value} checked={@checked} {@rest} />
      <span class="pa-checkbox__box"></span>
      <span :if={@label} class="pa-checkbox__label"><%= @label %></span>
    </label>
    """
  end

  defp checkbox_classes(assigns) do
    build_classes(
      "pa-checkbox",
      [
        {"pa-checkbox--#{assigns.size}", assigns.size != nil}
      ],
      assigns.class
    )
  end

  @doc """
  Renders a radio button with Pure Admin BEM classes.

  ## Examples

      <.radio name="plan" value="basic" label="Basic Plan" />
  """
  attr(:name, :string, default: nil)
  attr(:id, :string, default: nil)
  attr(:value, :string, required: true)
  attr(:checked, :boolean, default: false)
  attr(:label, :string, default: nil)
  attr(:class, :string, default: nil)
  attr(:rest, :global, include: ~w(disabled required form phx-change phx-click phx-debounce))

  def radio(assigns) do
    ~H"""
    <label class={build_classes("pa-radio", [], @class)}>
      <input type="radio" name={@name} id={@id} value={@value} checked={@checked} {@rest} />
      <%= @label %>
    </label>
    """
  end

  # ─── Form structure components ───

  @doc """
  Renders a form group wrapper with optional validation state.

  ## Examples

      <.form_group>
        <.form_label for="email">Email</.form_label>
        <.input type="email" name="email" id="email" />
      </.form_group>

      <.form_group validation="error" is_required>
        <.form_label for="name">Name</.form_label>
        <.input type="text" name="name" id="name" />
        <.form_help variant="error">Name is required</.form_help>
      </.form_group>
  """
  attr(:label, :string, default: nil, doc: "Shorthand for a simple text label")
  attr(:validation, :string, default: nil, values: [nil, "success", "warning", "error"])
  attr(:is_required, :boolean, default: false)
  attr(:is_horizontal, :boolean, default: false)
  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def form_group(assigns) do
    ~H"""
    <div class={form_group_classes(assigns)} {@rest}>
      <label :if={@label} class="pa-form-label"><%= @label %></label>
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  defp form_group_classes(assigns) do
    build_classes(
      "pa-form-group",
      [
        {"pa-form-group--#{assigns.validation}", assigns.validation != nil},
        {"pa-form-group--required", assigns.is_required},
        {"pa-form-group--horizontal", assigns.is_horizontal}
      ],
      assigns.class
    )
  end

  @doc """
  Renders a form label.
  """
  attr(:for, :string, default: nil)
  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def form_label(assigns) do
    ~H"""
    <label for={@for} class={build_classes("pa-form-label", [], @class)} {@rest}>
      <%= render_slot(@inner_block) %>
    </label>
    """
  end

  @doc """
  Renders help/hint text below inputs.
  """
  attr(:variant, :string, default: nil, values: [nil, "success", "warning", "error"])
  attr(:color, :string, default: nil, doc: "Theme color (1-9)")
  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def form_help(assigns) do
    ~H"""
    <small
      class={build_classes("pa-form-help", [
        {"pa-form-help--#{@variant}", @variant != nil},
        {"pa-form-help--color-#{@color}", @color != nil}
      ], @class)}
      {@rest}
    >
      <%= render_slot(@inner_block) %>
    </small>
    """
  end

  @doc """
  Renders an input group (input with prepend/append elements).

  ## Examples

      <.input_group>
        <:prepend>@</:prepend>
        <.input type="text" name="username" placeholder="Username" />
      </.input_group>

      <.input_group>
        <.input type="text" name="search" placeholder="Search..." />
        <:button>
          <.button variant="primary">Search</.button>
        </:button>
      </.input_group>
  """
  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:prepend, doc: "Left addon text")
  slot(:append, doc: "Right addon text")
  slot(:button, doc: "Button addon")
  slot(:inner_block, required: true)

  def input_group(assigns) do
    ~H"""
    <div class={build_classes("pa-input-group", [], @class)} {@rest}>
      <span :for={prepend <- @prepend} class="pa-input-group__prepend"><%= render_slot(prepend) %></span>
      <%= render_slot(@inner_block) %>
      <span :for={append <- @append} class="pa-input-group__append"><%= render_slot(append) %></span>
      <%= for button <- @button do %>
        <%= render_slot(button) %>
      <% end %>
    </div>
    """
  end

  @doc """
  Renders a checkbox group (vertical stack).
  """
  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def checkbox_group(assigns) do
    ~H"""
    <div class={build_classes("pa-checkbox-group", [], @class)} {@rest}>
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  @doc """
  Renders a radio button group (vertical stack).
  """
  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def radio_group(assigns) do
    ~H"""
    <div class={build_classes("pa-radio-group", [], @class)} {@rest}>
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  @doc """
  Renders a Phoenix-aware form with Pure Admin classes.

  Wraps `Phoenix.Component.form/1` with Pure Admin styling.

  ## Examples

      <.simple_form for={@form} phx-change="validate" phx-submit="save">
        <.form_group is_required>
          <.form_label for="name">Name</.form_label>
          <.input type="text" name={@form[:name].name} value={@form[:name].value} />
        </.form_group>
        <:actions>
          <.button variant="primary" type="submit">Save</.button>
        </:actions>
      </.simple_form>
  """
  attr(:for, :any, required: true, doc: "Phoenix form struct or changeset")
  attr(:as, :any, default: nil)
  attr(:is_inline, :boolean, default: false)
  attr(:class, :string, default: nil)
  attr(:rest, :global, include: ~w(phx-change phx-submit phx-target autocomplete))
  slot(:inner_block, required: true)
  slot(:actions, doc: "Form action buttons")

  def simple_form(assigns) do
    ~H"""
    <.form
      for={@for}
      as={@as}
      class={build_classes("pa-form", [{"pa-form--inline", @is_inline}], @class)}
      {@rest}
    >
      <%= render_slot(@inner_block) %>
      <div :for={actions <- @actions} class="pa-row">
        <div class="pa-col-100 text-end">
          <%= render_slot(actions) %>
        </div>
      </div>
    </.form>
    """
  end
end
