defmodule DemoWeb.Live.InputsLive do
  use DemoWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, page_title: "Inputs", is_search_mode: false)}
  end

  def handle_event("toggle_mode", _params, socket) do
    {:noreply, assign(socket, :is_search_mode, !socket.assigns.is_search_mode)}
  end

  def render(assigns) do
    ~H"""
    <.paragraph>Comprehensive showcase of all input types, states, sizes, and variations available in the framework.</.paragraph>

    <%!-- Text Inputs --%>
    <.card title_text="Text Inputs">
      <.grid>
        <%!-- States --%>
        <.column size="100" md="1-3">
          <.form_group>
            <.form_label>Normal</.form_label>
            <.input placeholder="Enter text" />
          </.form_group>
        </.column>
        <.column size="100" md="1-3">
          <.form_group>
            <.form_label>Disabled</.form_label>
            <.input placeholder="Disabled" disabled />
          </.form_group>
        </.column>
        <.column size="100" md="1-3">
          <.form_group>
            <.form_label>Readonly</.form_label>
            <.input value="Read only value" readonly />
          </.form_group>
        </.column>

        <%!-- Sizes --%>
        <.column size="100" md="20">
          <.form_group>
            <.form_label>Extra Small</.form_label>
            <.input size="xs" placeholder="XS" />
          </.form_group>
        </.column>
        <.column size="100" md="20">
          <.form_group>
            <.form_label>Small</.form_label>
            <.input size="sm" placeholder="Small" />
          </.form_group>
        </.column>
        <.column size="100" md="20">
          <.form_group>
            <.form_label>Default</.form_label>
            <.input placeholder="Default" />
          </.form_group>
        </.column>
        <.column size="100" md="20">
          <.form_group>
            <.form_label>Large</.form_label>
            <.input size="lg" placeholder="Large" />
          </.form_group>
        </.column>
        <.column size="100" md="20">
          <.form_group>
            <.form_label>Extra Large</.form_label>
            <.input size="xl" placeholder="XL" />
          </.form_group>
        </.column>

        <%!-- Validation States --%>
        <.column size="100" md="1-3">
          <.form_group validation="success">
            <.form_label>Success</.form_label>
            <.input value="Valid input" />
            <.form_help variant="success">Looks good!</.form_help>
          </.form_group>
        </.column>
        <.column size="100" md="1-3">
          <.form_group validation="warning">
            <.form_label>Warning</.form_label>
            <.input value="Warning input" />
            <.form_help variant="warning">Please check this field</.form_help>
          </.form_group>
        </.column>
        <.column size="100" md="1-3">
          <.form_group validation="error">
            <.form_label>Error</.form_label>
            <.input value="Invalid input" />
            <.form_help variant="error">This field is required</.form_help>
          </.form_group>
        </.column>

        <%!-- Theme Color Variants --%>
        <.column size="100" class="mt-4">
          <.form_label class="mb-2"><strong>Theme Color Variants</strong> (using --pa-color-* CSS variables)</.form_label>
        </.column>
        <.column size="100" md="1-3">
          <.form_group>
            <.form_label>Color 1</.form_label>
            <.input color="1" value="Color 1 input" />
            <.form_help color="1">Colored help text</.form_help>
          </.form_group>
        </.column>
        <.column size="100" md="1-3">
          <.form_group>
            <.form_label>Color 2</.form_label>
            <.input color="2" value="Color 2 input" />
            <.form_help color="2">Colored help text</.form_help>
          </.form_group>
        </.column>
        <.column size="100" md="1-3">
          <.form_group>
            <.form_label>Color 3</.form_label>
            <.input color="3" value="Color 3 input" />
            <.form_help>Gray help text (no color class)</.form_help>
          </.form_group>
        </.column>
      </.grid>
    </.card>

    <%!-- Input Groups --%>
    <.card title_text="Input Groups (Prepend/Append)">
      <.grid>
        <.column size="100" md="50">
          <.form_group>
            <.form_label>With Prepend</.form_label>
            <.input_group>
              <:prepend>@</:prepend>
              <.input placeholder="username" />
            </.input_group>
          </.form_group>
        </.column>

        <.column size="100" md="50">
          <.form_group>
            <.form_label>With Append</.form_label>
            <.input_group>
              <.input placeholder="0.00" />
              <:append>.00</:append>
            </.input_group>
          </.form_group>
        </.column>

        <.column size="100" md="50">
          <.form_group>
            <.form_label>With Both (prepend uses <code>wr-3</code> for fixed width)</.form_label>
            <.input_group>
              <:prepend><span class="wr-3">$</span></:prepend>
              <.input placeholder="0.00" />
              <:append>.00</:append>
            </.input_group>
          </.form_group>
        </.column>

        <.column size="100" md="50">
          <.form_group>
            <.form_label>With Button</.form_label>
            <.input_group>
              <.input placeholder="Search..." />
              <:button>
                <.button variant="primary" class="pa-input-group__button">Go</.button>
              </:button>
            </.input_group>
          </.form_group>
        </.column>

        <.column size="100">
          <.form_group>
            <.form_label>Multiple Prepends & Appends</.form_label>
            <.input_group>
              <:prepend>https://</:prepend>
              <:prepend>www.</:prepend>
              <.input placeholder="example" />
              <:append>.com</:append>
              <:append>🔗</:append>
            </.input_group>
          </.form_group>
        </.column>

        <.column size="100">
          <.form_group>
            <.form_label>Toggle Mode Button (Filter / Search) + Go</.form_label>
            <.input_group>
              <:button>
                <.button
                  variant="primary"
                  class="pa-input-group__button"
                  title={if @is_search_mode, do: "Search mode — click to switch to Filter", else: "Filter mode — click to switch to Search"}
                  phx-click="toggle_mode"
                >
                  <i class={if @is_search_mode, do: "fa-solid fa-magnifying-glass", else: "fa-solid fa-filter"}></i>
                </.button>
              </:button>
              <.input placeholder={if @is_search_mode, do: "Search...", else: "Filter..."} />
              <:button>
                <.button variant="primary" class="pa-input-group__button">Go</.button>
              </:button>
            </.input_group>
            <.form_help>Click the icon button to switch between Filter and Search modes</.form_help>
          </.form_group>
        </.column>

        <.column size="100" class="mt-3">
          <small class="pa-text--secondary"><strong>Tip:</strong> Use width utilities (<code>wr-*</code> for rem-based, <code>wp-*</code> for percentage-based) on prepend/append elements to control their width.</small>
        </.column>
      </.grid>
    </.card>

    <%!-- Input Types --%>
    <.card title_text="Input Types">
      <.grid>
        <.column size="100" md="1-3">
          <.form_group>
            <.form_label>Email</.form_label>
            <.input type="email" placeholder="user@example.com" />
          </.form_group>
        </.column>
        <.column size="100" md="1-3">
          <.form_group>
            <.form_label>Password</.form_label>
            <.input type="password" placeholder="••••••••" />
          </.form_group>
        </.column>
        <.column size="100" md="1-3">
          <.form_group>
            <.form_label>Number</.form_label>
            <.input type="number" placeholder="0" />
          </.form_group>
        </.column>
        <.column size="100" md="1-3">
          <.form_group>
            <.form_label>Tel</.form_label>
            <.input type="tel" placeholder="+1 (555) 123-4567" />
          </.form_group>
        </.column>
        <.column size="100" md="1-3">
          <.form_group>
            <.form_label>URL</.form_label>
            <.input type="url" placeholder="https://example.com" />
          </.form_group>
        </.column>
        <.column size="100" md="1-3">
          <.form_group>
            <.form_label>Search</.form_label>
            <.input type="search" placeholder="Search..." />
          </.form_group>
        </.column>
        <.column size="100" md="1-3">
          <.form_group>
            <.form_label>Date</.form_label>
            <.input type="date" />
          </.form_group>
        </.column>
        <.column size="100" md="1-3">
          <.form_group>
            <.form_label>Time</.form_label>
            <.input type="time" />
          </.form_group>
        </.column>
        <.column size="100" md="1-3">
          <.form_group>
            <.form_label>DateTime</.form_label>
            <.input type="datetime-local" />
          </.form_group>
        </.column>
        <.column size="100" md="1-3">
          <.form_group>
            <.form_label>Month</.form_label>
            <.input type="month" />
          </.form_group>
        </.column>
        <.column size="100" md="1-3">
          <.form_group>
            <.form_label>Week</.form_label>
            <.input type="week" />
          </.form_group>
        </.column>
        <.column size="100" md="1-3">
          <.form_group>
            <.form_label>Color</.form_label>
            <.input type="color" value="#ff0000" />
          </.form_group>
        </.column>
        <.column size="100" md="1-3">
          <.form_group>
            <.form_label>File</.form_label>
            <.input type="file" />
          </.form_group>
        </.column>
        <.column size="100" md="1-3">
          <.form_group>
            <.form_label>Range</.form_label>
            <.input type="range" />
          </.form_group>
        </.column>
      </.grid>
    </.card>

    <%!-- Select Dropdowns --%>
    <.card title_text="Select Dropdowns">
      <.grid>
        <.column size="100" md="1-3">
          <.form_group>
            <.form_label>Normal</.form_label>
            <.select options={["Option 1", "Option 2", "Option 3"]} prompt="Choose option..." />
          </.form_group>
        </.column>
        <.column size="100" md="1-3">
          <.form_group>
            <.form_label>Disabled</.form_label>
            <.select options={["Disabled"]} disabled />
          </.form_group>
        </.column>
        <.column size="100" md="1-3">
          <.form_group>
            <.form_label>Multiple</.form_label>
            <select class="pa-select" multiple>
              <option>Option 1</option>
              <option>Option 2</option>
              <option>Option 3</option>
              <option>Option 4</option>
            </select>
          </.form_group>
        </.column>

        <%!-- Sizes --%>
        <.column size="100" md="20">
          <.form_group>
            <.form_label>Extra Small</.form_label>
            <.select size="xs" options={["XS"]} />
          </.form_group>
        </.column>
        <.column size="100" md="20">
          <.form_group>
            <.form_label>Small</.form_label>
            <.select size="sm" options={["Small"]} />
          </.form_group>
        </.column>
        <.column size="100" md="20">
          <.form_group>
            <.form_label>Default</.form_label>
            <.select options={["Default"]} />
          </.form_group>
        </.column>
        <.column size="100" md="20">
          <.form_group>
            <.form_label>Large</.form_label>
            <.select size="lg" options={["Large"]} />
          </.form_group>
        </.column>
        <.column size="100" md="20">
          <.form_group>
            <.form_label>Extra Large</.form_label>
            <.select size="xl" options={["XL"]} />
          </.form_group>
        </.column>
      </.grid>
    </.card>

    <%!-- Textareas --%>
    <.card title_text="Textareas">
      <.grid>
        <.column size="100" md="50">
          <.form_group>
            <.form_label>Normal</.form_label>
            <.textarea placeholder="Enter your message..." />
          </.form_group>
        </.column>
        <.column size="100" md="50">
          <.form_group>
            <.form_label>Disabled</.form_label>
            <.textarea placeholder="Disabled" disabled />
          </.form_group>
        </.column>

        <%!-- Sizes --%>
        <.column size="100" md="20">
          <.form_group>
            <.form_label>Extra Small</.form_label>
            <.textarea size="xs" placeholder="XS" />
          </.form_group>
        </.column>
        <.column size="100" md="20">
          <.form_group>
            <.form_label>Small</.form_label>
            <.textarea size="sm" placeholder="Small" />
          </.form_group>
        </.column>
        <.column size="100" md="20">
          <.form_group>
            <.form_label>Default</.form_label>
            <.textarea placeholder="Default" />
          </.form_group>
        </.column>
        <.column size="100" md="20">
          <.form_group>
            <.form_label>Large</.form_label>
            <.textarea size="lg" placeholder="Large" />
          </.form_group>
        </.column>
        <.column size="100" md="20">
          <.form_group>
            <.form_label>Extra Large</.form_label>
            <.textarea size="xl" placeholder="XL" />
          </.form_group>
        </.column>
      </.grid>
    </.card>

    <%!-- Checkboxes & Radios --%>
    <.card title_text="Checkboxes & Radios">
      <.grid>
        <.column size="100" md="50">
          <.form_group>
            <.form_label>Checkboxes</.form_label>
            <.checkbox_group>
              <.checkbox id="input-check1" checked label="Option 1 (checked)" />
              <.checkbox id="input-check2" label="Option 2" />
              <.checkbox id="input-check3" disabled label="Option 3 (disabled)" />
            </.checkbox_group>
          </.form_group>
        </.column>

        <.column size="100" md="50">
          <.form_group>
            <.form_label>Radio Buttons</.form_label>
            <.radio_group>
              <.radio name="radio-demo" value="a" label="Option A (selected)" />
              <.radio name="radio-demo" value="b" label="Option B" />
              <.radio name="radio-demo" value="c" disabled label="Option C (disabled)" />
            </.radio_group>
          </.form_group>
        </.column>

        <.column size="100">
          <.form_group>
            <.form_label>Checkbox Sizes</.form_label>
            <.checkbox_group>
              <.checkbox id="size-check-xs" size="xs" checked label="Extra Small" />
              <.checkbox id="size-check-sm" size="sm" checked label="Small" />
              <.checkbox id="size-check-default" checked label="Default" />
              <.checkbox id="size-check-lg" size="lg" checked label="Large" />
              <.checkbox id="size-check-xl" size="xl" checked label="Extra Large" />
            </.checkbox_group>
          </.form_group>
        </.column>

        <.column size="100">
          <.form_group>
            <.form_label>Radio Sizes</.form_label>
            <.radio_group>
              <.radio name="size-demo" value="xs" label="Extra Small" />
              <.radio name="size-demo" value="sm" label="Small" />
              <.radio name="size-demo" value="default" label="Default" />
              <.radio name="size-demo" value="lg" label="Large" />
              <.radio name="size-demo" value="xl" label="Extra Large" />
            </.radio_group>
          </.form_group>
        </.column>
      </.grid>
    </.card>

    <%!-- Width Variations --%>
    <.card title_text="Width Variations">
      <.form_group>
        <.form_label>Auto Width (inline)</.form_label>
        <div style="width: auto; display: inline-block;">
          <.input placeholder="Auto width" />
        </div>
      </.form_group>
      <.form_group>
        <.form_label>25% Width</.form_label>
        <div style="width: 25%;">
          <.input placeholder="25%" />
        </div>
      </.form_group>
      <.form_group>
        <.form_label>50% Width</.form_label>
        <div style="width: 50%;">
          <.input placeholder="50%" />
        </div>
      </.form_group>
      <.form_group>
        <.form_label>75% Width</.form_label>
        <div style="width: 75%;">
          <.input placeholder="75%" />
        </div>
      </.form_group>
      <.form_group>
        <.form_label>100% Width (full width)</.form_label>
        <.input placeholder="100%" />
      </.form_group>
    </.card>

    <%!-- CSS Classes Reference --%>
    <.card title_text="CSS Classes Reference">
      <.heading level={4}>Text Inputs</.heading>
      <.basic_list spacing="compact">
        <li><code>pa-input</code> - Base input styling</li>
        <li><code>pa-input--xs</code> - Extra small input</li>
        <li><code>pa-input--sm</code> - Small input</li>
        <li><code>pa-input--lg</code> - Large input</li>
        <li><code>pa-input--xl</code> - Extra large input</li>
      </.basic_list>

      <.heading level={4} class="mt-4">Select Dropdowns</.heading>
      <.basic_list spacing="compact">
        <li><code>pa-select</code> - Base select styling</li>
        <li><code>pa-select--xs</code> - Extra small select</li>
        <li><code>pa-select--sm</code> - Small select</li>
        <li><code>pa-select--lg</code> - Large select</li>
        <li><code>pa-select--xl</code> - Extra large select</li>
      </.basic_list>

      <.heading level={4} class="mt-4">Textareas</.heading>
      <.basic_list spacing="compact">
        <li><code>pa-textarea</code> - Base textarea styling</li>
        <li><code>pa-textarea--xs</code> - Extra small textarea</li>
        <li><code>pa-textarea--sm</code> - Small textarea</li>
        <li><code>pa-textarea--lg</code> - Large textarea</li>
        <li><code>pa-textarea--xl</code> - Extra large textarea</li>
      </.basic_list>

      <.heading level={4} class="mt-4">Input Groups</.heading>
      <.basic_list spacing="compact">
        <li><code>pa-input-group</code> - Container for input with addons</li>
        <li><code>pa-input-group__prepend</code> - Addon before input</li>
        <li><code>pa-input-group__append</code> - Addon after input</li>
        <li><code>pa-input-group__button</code> - Button addon</li>
      </.basic_list>

      <.heading level={4} class="mt-4">Form Layout</.heading>
      <.basic_list spacing="compact">
        <li><code>pa-form</code> - Form container with label styling</li>
        <li><code>pa-form-group</code> - Form field container with spacing</li>
        <li><code>pa-form-group--horizontal</code> - Horizontal label/input layout</li>
        <li><code>pa-form-actions</code> - Container for form buttons</li>
      </.basic_list>

      <.heading level={4} class="mt-4">Validation States (on form-group)</.heading>
      <.basic_list spacing="compact">
        <li><code>pa-form-group--success</code> - Success state (green border)</li>
        <li><code>pa-form-group--warning</code> - Warning state (yellow border)</li>
        <li><code>pa-form-group--error</code> - Error state (red border)</li>
      </.basic_list>

      <.heading level={4} class="mt-4">Validation States (on input)</.heading>
      <.basic_list spacing="compact">
        <li><code>pa-input--success</code>, <code>pa-select--success</code>, <code>pa-textarea--success</code> - Success state</li>
        <li><code>pa-input--warning</code>, <code>pa-select--warning</code>, <code>pa-textarea--warning</code> - Warning state</li>
        <li><code>pa-input--error</code>, <code>pa-select--error</code>, <code>pa-textarea--error</code> - Error state</li>
      </.basic_list>

      <.heading level={4} class="mt-4">Theme Color Variants (on input)</.heading>
      <.basic_list spacing="compact">
        <li><code>pa-input--color-1</code> through <code>pa-input--color-9</code> - Theme color slots</li>
        <li><code>pa-select--color-1</code> through <code>pa-select--color-9</code> - Theme color slots</li>
        <li><code>pa-textarea--color-1</code> through <code>pa-textarea--color-9</code> - Theme color slots</li>
      </.basic_list>

      <.heading level={4} class="mt-4">Help Text</.heading>
      <.basic_list spacing="compact">
        <li><code>pa-form-help</code> - Help text below input</li>
        <li><code>pa-form-help--success</code> - Success colored help text</li>
        <li><code>pa-form-help--warning</code> - Warning colored help text</li>
        <li><code>pa-form-help--error</code> - Error colored help text</li>
        <li><code>pa-form-help--color-1</code> through <code>pa-form-help--color-9</code> - Theme color slots</li>
      </.basic_list>

      <.heading level={4} class="mt-4">Checkboxes</.heading>
      <.basic_list spacing="compact">
        <li><code>pa-checkbox-group</code> - Container for multiple checkboxes</li>
        <li><code>pa-checkbox</code> - Checkbox wrapper (label element)</li>
        <li><code>pa-checkbox__box</code> - Custom checkbox visual</li>
        <li><code>pa-checkbox__label</code> - Checkbox label text</li>
        <li><code>pa-checkbox--xs</code> through <code>pa-checkbox--xl</code> - Size variants</li>
        <li><code>pa-checkbox--disabled</code> - Disabled state</li>
      </.basic_list>

      <.heading level={4} class="mt-4">Radio Buttons</.heading>
      <.basic_list spacing="compact">
        <li><code>pa-radio-group</code> - Container for multiple radios</li>
        <li><code>pa-radio</code> - Radio button wrapper (label element)</li>
        <li><code>pa-radio__label</code> - Radio label text</li>
        <li><code>pa-radio--xs</code> through <code>pa-radio--xl</code> - Size variants</li>
      </.basic_list>
    </.card>
    """
  end
end
