defmodule DemoWeb.Live.FormsLive do
  use DemoWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, page_title: "Forms")}
  end

  def render(assigns) do
    ~H"""
    <.paragraph>Complete set of form elements with various styles and states for data input.</.paragraph>

    <%!-- Input Sizes Reference — heights are measured client-side (MeasureFormSizes hook) --%>
    <.table_card title_text="Input Sizes Reference" is_scrollable>
      <table id="sizesTable" class="pa-table pa-table--striped" phx-hook="MeasureFormSizes">
        <thead>
          <tr>
            <th>Size</th>
            <th>Class</th>
            <th>Font Size</th>
            <th>Padding (v/h)</th>
            <th>Input + Button</th>
            <th>Input Height</th>
            <th>Button Height</th>
          </tr>
        </thead>
        <tbody>
          <tr :for={row <- size_rows()}>
            <td><strong><%= row.size %></strong></td>
            <td><code><%= row.class %></code></td>
            <td><%= row.font %></td>
            <td><%= row.padding %></td>
            <td>
              <div class="d-flex align-items-center gap-sm">
                <.input type="text" size={row.mod} placeholder={row.placeholder} style="width: 120px;" data-measure="input" />
                <.button variant="primary" size={row.mod} data-measure="button">Submit</.button>
              </div>
            </td>
            <td class="height-input">-</td>
            <td class="height-button">-</td>
          </tr>
        </tbody>
      </table>
    </.table_card>

    <%!-- Form with Buttons in Header --%>
    <.card title_text="User Profile">
      <:tools>
        <.button variant="secondary" size="sm"><:icon>×</:icon>Cancel</.button>
        <.button type="submit" variant="success" size="sm"><:icon>✓</:icon>Save</.button>
      </:tools>
      <form class="pa-form">
        <.grid>
          <.column size="100" md="50">
            <.form_group>
              <.form_label for="text-input">Text Input</.form_label>
              <.input type="text" id="text-input" placeholder="Enter text" required />
            </.form_group>
          </.column>
          <.column size="100" md="50">
            <.form_group>
              <.form_label for="email-input">Email Input</.form_label>
              <.input type="email" id="email-input" placeholder="user@example.com" required />
            </.form_group>
          </.column>
          <.column size="100" md="50">
            <.form_group>
              <.form_label for="password-input">Password Input</.form_label>
              <.input type="password" id="password-input" placeholder="Enter password" />
            </.form_group>
          </.column>
          <.column size="100" md="50">
            <.form_group>
              <.form_label for="number-input">Number Input</.form_label>
              <.input type="number" id="number-input" placeholder="0" />
            </.form_group>
          </.column>
          <.column size="100" md="50">
            <.form_group>
              <.form_label for="basic-select">Select Dropdown</.form_label>
              <.select id="basic-select" prompt="Choose an option..." options={["Option 1", "Option 2", "Option 3"]} required />
            </.form_group>
          </.column>
          <.column size="100" md="50">
            <.form_group>
              <.form_label for="date-input">Date Input</.form_label>
              <.input type="date" id="date-input" />
            </.form_group>
          </.column>
          <.column size="100">
            <.form_group>
              <.form_label for="textarea">Textarea (Full Width)</.form_label>
              <.textarea id="textarea" placeholder="Enter your message here..." required />
            </.form_group>
          </.column>
        </.grid>
      </form>
    </.card>

    <%!-- Form with Buttons in Footer --%>
    <.card title_text="Contact Information">
      <form class="pa-form">
        <.grid>
          <.column size="100" md="50">
            <.form_group>
              <.form_label for="fname2">First Name</.form_label>
              <.input type="text" id="fname2" placeholder="John" />
            </.form_group>
          </.column>
          <.column size="100" md="50">
            <.form_group>
              <.form_label for="lname2">Last Name</.form_label>
              <.input type="text" id="lname2" placeholder="Doe" />
            </.form_group>
          </.column>
          <.column size="100">
            <.form_group>
              <.form_label for="address">Address</.form_label>
              <.input type="text" id="address" placeholder="123 Main St" />
            </.form_group>
          </.column>
        </.grid>
      </form>
      <:footer>
        <.button variant="secondary"><:icon>←</:icon>Back</.button>
        <.button variant="light"><:icon>🗑</:icon>Delete</.button>
        <div class="ml-auto d-flex gap-5">
          <.button variant="secondary">Cancel</.button>
          <.button type="submit" variant="success"><:icon>✓</:icon>Save Changes</.button>
        </div>
      </:footer>
    </.card>

    <%!-- Form with Buttons in Body --%>
    <.card title_text="Quick Settings">
      <form class="pa-form">
        <.form_group>
          <.form_label for="setting1">Setting Name</.form_label>
          <.input type="text" id="setting1" placeholder="Enter value" />
        </.form_group>
        <.form_group>
          <.form_label for="setting2">Notification Preference</.form_label>
          <.select id="setting2" options={["All notifications", "Important only", "None"]} />
        </.form_group>
        <.button_group>
          <.button variant="secondary">Cancel</.button>
          <.button variant="primary"><:icon>📄</:icon>Preview</.button>
          <.button type="submit" variant="success"><:icon>✓</:icon>Apply</.button>
        </.button_group>
      </form>
    </.card>

    <%!-- Three Column Compact Form --%>
    <.card title_text="Compact Three Column Layout">
      <form class="pa-form">
        <.grid>
          <.column size="100" md="1-3">
            <.form_group>
              <.form_label for="fname">First Name</.form_label>
              <.input type="text" id="fname" placeholder="John" />
            </.form_group>
          </.column>
          <.column size="100" md="1-3">
            <.form_group>
              <.form_label for="lname">Last Name</.form_label>
              <.input type="text" id="lname" placeholder="Doe" />
            </.form_group>
          </.column>
          <.column size="100" md="1-3">
            <.form_group>
              <.form_label for="email3">Email</.form_label>
              <.input type="email" id="email3" placeholder="john@example.com" />
            </.form_group>
          </.column>
          <.column size="100" md="1-3">
            <.form_group>
              <.form_label for="phone">Phone</.form_label>
              <.input type="tel" id="phone" placeholder="+1 234 567 8900" />
            </.form_group>
          </.column>
          <.column size="100" md="1-3">
            <.form_group>
              <.form_label for="country">Country</.form_label>
              <.select id="country" options={["United States", "Canada", "United Kingdom"]} />
            </.form_group>
          </.column>
          <.column size="100" md="1-3">
            <.form_group>
              <.form_label for="zip">ZIP Code</.form_label>
              <.input type="text" id="zip" placeholder="12345" />
            </.form_group>
          </.column>
        </.grid>
      </form>
    </.card>

    <%!-- Input Groups with Icons --%>
    <.card title_text="Input Groups">
      <form class="pa-form">
        <.grid>
          <.column size="100" md="50">
            <.form_group>
              <.form_label for="prepend-input">Input with Prepended Text</.form_label>
              <.input_group>
                <:prepend>@</:prepend>
                <.input type="text" id="prepend-input" placeholder="username" />
              </.input_group>
            </.form_group>
          </.column>

          <.column size="100" md="50">
            <.form_group>
              <.form_label for="append-input">Input with Appended Text</.form_label>
              <.input_group>
                <.input type="text" id="append-input" placeholder="0.00" />
                <:append>USD</:append>
              </.input_group>
            </.form_group>
          </.column>

          <.column size="100" md="50">
            <.form_group>
              <.form_label for="both-input">Input with Both Prepend and Append</.form_label>
              <.input_group>
                <:prepend>$</:prepend>
                <.input type="text" id="both-input" placeholder="0.00" />
                <:append>.00</:append>
              </.input_group>
            </.form_group>
          </.column>

          <.column size="100" md="50">
            <.form_group>
              <.form_label for="button-append">Input with Button</.form_label>
              <.input_group>
                <.input type="text" id="button-append" placeholder="Search..." />
                <:button>
                  <.button variant="primary" class="pa-input-group__button">Search</.button>
                </:button>
              </.input_group>
            </.form_group>
          </.column>

          <.column size="100" md="50">
            <.form_group>
              <.form_label for="prepend-button">Prepend + Input + Button</.form_label>
              <.input_group>
                <:prepend>🔍</:prepend>
                <.input type="text" id="prepend-button" placeholder="Search..." />
                <:button>
                  <.button variant="primary" class="pa-input-group__button">Go</.button>
                </:button>
              </.input_group>
            </.form_group>
          </.column>

          <.column size="100" md="50">
            <.form_group>
              <.form_label for="append-button">Input + Append + Button</.form_label>
              <.input_group>
                <.input type="text" id="append-button" placeholder="Enter amount" />
                <:append>USD</:append>
                <:button>
                  <.button variant="success" class="pa-input-group__button">Convert</.button>
                </:button>
              </.input_group>
            </.form_group>
          </.column>

          <.column size="100" md="50">
            <.form_group>
              <.form_label for="button-append-input">Button + Input + Append</.form_label>
              <div class="pa-input-group">
                <.button variant="secondary" class="pa-input-group__button">-</.button>
                <.input type="number" id="button-append-input" value="1" />
                <span class="pa-input-group__append">items</span>
              </div>
            </.form_group>
          </.column>

          <.column size="100" md="50">
            <.form_group>
              <.form_label for="full-group">Prepend + Input + Append + Button</.form_label>
              <.input_group>
                <:prepend>https://</:prepend>
                <.input type="text" id="full-group" placeholder="example.com" />
                <:append>.com</:append>
                <:button>
                  <.button variant="primary" class="pa-input-group__button">Visit</.button>
                </:button>
              </.input_group>
            </.form_group>
          </.column>

          <.column size="100" md="50">
            <.form_group>
              <.form_label for="quantity-input">Button + Input + Button (Quantity)</.form_label>
              <div class="pa-input-group">
                <.button variant="secondary" class="pa-input-group__button">-</.button>
                <.input type="number" id="quantity-input" value="1" style="text-align: center;" />
                <.button variant="secondary" class="pa-input-group__button">+</.button>
              </div>
            </.form_group>
          </.column>
        </.grid>
      </form>
    </.card>

    <%!-- Form States --%>
    <.card title_text="Form States">
      <form class="pa-form">
        <.grid>
          <.column size="100" md="1-3">
            <.form_group>
              <.form_label for="disabled-input">Disabled Input</.form_label>
              <.input type="text" id="disabled-input" placeholder="Disabled" disabled />
            </.form_group>
          </.column>

          <.column size="100" md="1-3">
            <.form_group>
              <.form_label for="readonly-input">Readonly Input</.form_label>
              <.input type="text" id="readonly-input" value="Read only value" readonly />
            </.form_group>
          </.column>

          <.column size="100" md="1-3">
            <.form_group>
              <.form_label for="help-input">Input with Help Text</.form_label>
              <.input type="text" id="help-input" placeholder="Username" />
              <.form_help>Must be 3-20 characters long</.form_help>
            </.form_group>
          </.column>

          <.column size="100" md="50">
            <.form_group validation="error">
              <.form_label for="error-input">Input with Error</.form_label>
              <.input type="text" id="error-input" is_error placeholder="Invalid input" />
              <.form_help variant="error">This field is required</.form_help>
            </.form_group>
          </.column>

          <.column size="100" md="50">
            <.form_group validation="success">
              <.form_label for="success-input">Input with Success</.form_label>
              <.input type="text" id="success-input" is_success value="Valid input" />
              <.form_help variant="success">Looks good!</.form_help>
            </.form_group>
          </.column>
        </.grid>
      </form>
    </.card>

    <%!-- Input Sizes --%>
    <.card title_text="Input Sizes">
      <form class="pa-form">
        <.form_group>
          <.form_label for="xs-input">Extra Small Input</.form_label>
          <.input type="text" id="xs-input" size="xs" placeholder="Extra small" />
        </.form_group>
        <.form_group>
          <.form_label for="sm-input">Small Input</.form_label>
          <.input type="text" id="sm-input" size="sm" placeholder="Small" />
        </.form_group>
        <.form_group>
          <.form_label for="normal-input">Normal Input (Default)</.form_label>
          <.input type="text" id="normal-input" placeholder="Normal" />
        </.form_group>
        <.form_group>
          <.form_label for="lg-input">Large Input</.form_label>
          <.input type="text" id="lg-input" size="lg" placeholder="Large" />
        </.form_group>
        <.form_group>
          <.form_label for="xl-input">Extra Large Input</.form_label>
          <.input type="text" id="xl-input" size="xl" placeholder="Extra large" />
        </.form_group>
      </form>
    </.card>

    <%!-- Checkboxes and Radio Buttons — basics + tri-state --%>
    <.card title_text="Checkboxes & Radio Buttons">
      <form class="pa-form">
        <.form_group>
          <.form_label>Checkboxes (Custom Tri-State)</.form_label>
          <.checkbox_group>
            <.checkbox checked label="Option 1 (checked)" />
            <.checkbox label="Option 2" />
            <.checkbox disabled label="Option 3 (disabled)" />
          </.checkbox_group>
        </.form_group>

        <.form_group>
          <.form_label>Radio Buttons</.form_label>
          <.radio_group>
            <.radio name="radio-group" value="a" checked label="Choice A (selected)" />
            <.radio name="radio-group" value="b" label="Choice B" />
            <.radio name="radio-group" value="c" disabled label="Choice C (disabled)" />
          </.radio_group>
        </.form_group>

        <.form_group>
          <.form_label>Two-state &amp; Three-state (indeterminate)</.form_label>
          <.checkbox_group>
            <%!-- Two-state: a normal checkbox --%>
            <.checkbox checked label="Two-state (checked / unchecked)" />
            <%!-- Static indeterminate via the PureAdminCheckbox hook --%>
            <.checkbox is_indeterminate label="Indeterminate (mixed) — static" />
            <%!-- Three-state cycler: FormsTristate hook cycles unchecked → checked → indeterminate --%>
            <label class="pa-checkbox" id="tristate-cycler" phx-hook="FormsTristate">
              <input type="checkbox" />
              <span class="pa-checkbox__box"></span>
              <span class="pa-checkbox__label">Three-state — click to cycle</span>
            </label>
          </.checkbox_group>
        </.form_group>
      </form>
    </.card>

    <%!-- Label position --%>
    <.card title_text="Label Position">
      <:description>One position per group. End/start stack; top reads best in an auto-flow grid.</:description>
      <form class="pa-form">
        <.form_group class="mb-2xl">
          <.form_label>Checkbox · label end &amp; start</.form_label>
          <.grid>
            <.column size="100" md="1-2">
              <.checkbox_group>
                <.checkbox class="pa-checkbox--label-end" checked label="End · Option 1" />
                <.checkbox class="pa-checkbox--label-end" label="End · Option 2" />
                <.checkbox class="pa-checkbox--label-end" checked label="End · Option 3" />
              </.checkbox_group>
            </.column>
            <.column size="100" md="1-2">
              <.checkbox_group>
                <.checkbox class="pa-checkbox--label-start" checked label="Start · Option 1" />
                <.checkbox class="pa-checkbox--label-start" label="Start · Option 2" />
                <.checkbox class="pa-checkbox--label-start" checked label="Start · Option 3" />
              </.checkbox_group>
            </.column>
          </.grid>
        </.form_group>

        <.form_group class="mb-2xl">
          <.form_label>Checkbox · label top (auto-flow grid, 6 options)</.form_label>
          <.checkbox_group class="pa-checkbox-group--grid">
            <.checkbox class="pa-checkbox--label-top" checked label="Top · Option 1" />
            <.checkbox class="pa-checkbox--label-top" label="Top · Option 2" />
            <.checkbox class="pa-checkbox--label-top" checked label="Top · Option 3" />
            <.checkbox class="pa-checkbox--label-top" label="Top · Option 4" />
            <.checkbox class="pa-checkbox--label-top" checked label="Top · Option 5" />
            <.checkbox class="pa-checkbox--label-top" label="Top · Option 6" />
          </.checkbox_group>
        </.form_group>

        <.form_group class="mb-2xl">
          <.form_label>Radio · label end &amp; start</.form_label>
          <.grid>
            <.column size="100" md="1-2">
              <div class="pa-radio-group">
                <label class="pa-radio pa-radio--label-end"><input type="radio" name="rl-end" checked /><span class="pa-radio__label">End · Option 1</span></label>
                <label class="pa-radio pa-radio--label-end"><input type="radio" name="rl-end" /><span class="pa-radio__label">End · Option 2</span></label>
                <label class="pa-radio pa-radio--label-end"><input type="radio" name="rl-end" /><span class="pa-radio__label">End · Option 3</span></label>
              </div>
            </.column>
            <.column size="100" md="1-2">
              <div class="pa-radio-group">
                <label class="pa-radio pa-radio--label-start"><input type="radio" name="rl-start" checked /><span class="pa-radio__label">Start · Option 1</span></label>
                <label class="pa-radio pa-radio--label-start"><input type="radio" name="rl-start" /><span class="pa-radio__label">Start · Option 2</span></label>
                <label class="pa-radio pa-radio--label-start"><input type="radio" name="rl-start" /><span class="pa-radio__label">Start · Option 3</span></label>
              </div>
            </.column>
          </.grid>
        </.form_group>

        <.form_group>
          <.form_label>Radio · label top (auto-flow grid, 6 options)</.form_label>
          <div class="pa-radio-group pa-radio-group--grid">
            <label class="pa-radio pa-radio--label-top"><input type="radio" name="rl-top" checked /><span class="pa-radio__label">Top · Option 1</span></label>
            <label class="pa-radio pa-radio--label-top"><input type="radio" name="rl-top" /><span class="pa-radio__label">Top · Option 2</span></label>
            <label class="pa-radio pa-radio--label-top"><input type="radio" name="rl-top" /><span class="pa-radio__label">Top · Option 3</span></label>
            <label class="pa-radio pa-radio--label-top"><input type="radio" name="rl-top" /><span class="pa-radio__label">Top · Option 4</span></label>
            <label class="pa-radio pa-radio--label-top"><input type="radio" name="rl-top" /><span class="pa-radio__label">Top · Option 5</span></label>
            <label class="pa-radio pa-radio--label-top"><input type="radio" name="rl-top" /><span class="pa-radio__label">Top · Option 6</span></label>
          </div>
        </.form_group>
      </form>
    </.card>

    <%!-- Orientation & required --%>
    <.card title_text="Orientation &amp; Required">
      <.callout variant="info">
        <:icon>💡</:icon>
        <:title>How the required asterisk is placed</:title>
        <p>The danger <strong>*</strong> is driven by the native <code>required</code> attribute — no class needed. Where it lands depends on the field's shape:</p>
        <ul>
          <li><strong>Simple fields</strong> (input / select / textarea) → the group's <code>&lt;label&gt;</code>, via <code>.pa-form-group:has(:required) &gt; label</code>.</li>
          <li><strong>Grouped choices</strong> (radios/checkboxes inside a <code>.pa-radio-group</code> / <code>.pa-checkbox-group</code>) → the requirement belongs to the group, so the <strong>*</strong> sits once on the group <strong>heading</strong> and the per-option markers are suppressed. See <em>Priority</em> below.</li>
          <li><strong>Standalone choice</strong> (a lone <code>.pa-checkbox</code> / <code>.pa-radio</code>, e.g. a consent box with no <code>*-group</code> wrapper) → the <strong>*</strong> sits on its <strong>own</strong> option label. See <em>I accept the terms</em> below.</li>
          <li><strong>Complex widgets</strong> with no native control (image browser, dropzone, web component) → add <code>.pa-form-group--required</code> to the group as the explicit trigger.</li>
        </ul>
        <p class="mb-0">The first “Horizontal orientation” group has no <code>required</code>, so it shows no marker.</p>
      </.callout>
      <form class="pa-form">
        <.form_group>
          <.form_label>Horizontal orientation</.form_label>
          <.checkbox_group class="pa-checkbox-group--horizontal">
            <.checkbox checked label="Red" />
            <.checkbox label="Green" />
            <.checkbox label="Blue" />
          </.checkbox_group>
          <.radio_group class="pa-radio-group--horizontal">
            <.radio name="radio-horiz" value="low" checked label="Low" />
            <.radio name="radio-horiz" value="medium" label="Medium" />
            <.radio name="radio-horiz" value="high" label="High" />
          </.radio_group>
        </.form_group>

        <%!-- Grouped choice: the requirement belongs to the group ("pick one"),
             so the asterisk sits once on the GROUP HEADING — the options stay clean. --%>
        <.form_group>
          <.form_label>Priority (required group)</.form_label>
          <.radio_group class="pa-radio-group--horizontal">
            <.radio name="req-priority" value="low" required label="Low" />
            <.radio name="req-priority" value="medium" required label="Medium" />
            <.radio name="req-priority" value="high" required label="High" />
          </.radio_group>
        </.form_group>

        <%!-- Standalone consent checkbox (no *-group wrapper): the requirement IS
             this one control, so the asterisk sits on its OWN option label. --%>
        <.form_group>
          <.checkbox required label="I accept the terms" />
        </.form_group>
      </form>
    </.card>

    <%!-- Checkbox and Radio Sizes --%>
    <.card title_text="Checkbox & Radio Sizes">
      <form class="pa-form">
        <.grid>
          <.column size="100" md="50">
            <.form_group>
              <.form_label>Checkbox Sizes</.form_label>
              <.checkbox_group>
                <.checkbox size="xs" checked label="Extra Small (12px)" />
                <.checkbox size="sm" checked label="Small (14px)" />
                <.checkbox checked label="Default (16px)" />
                <.checkbox size="lg" checked label="Large (20px)" />
                <.checkbox size="xl" checked label="Extra Large (24px)" />
              </.checkbox_group>
            </.form_group>
          </.column>

          <.column size="100" md="50">
            <.form_group>
              <.form_label>Radio Button Sizes</.form_label>
              <.radio_group>
                <.radio name="radio-sizes" value="xs" size="xs" checked label="Extra Small (12px)" />
                <.radio name="radio-sizes" value="sm" size="sm" label="Small (14px)" />
                <.radio name="radio-sizes" value="default" label="Default (16px)" />
                <.radio name="radio-sizes" value="lg" size="lg" label="Large (20px)" />
                <.radio name="radio-sizes" value="xl" size="xl" label="Extra Large (24px)" />
              </.radio_group>
            </.form_group>
          </.column>
        </.grid>
      </form>
    </.card>

    <%!-- Horizontal Form Layout --%>
    <.card title_text="Horizontal Form Layout" subtitle_text="Labels on the left, inputs on the right with varying field widths">
      <form class="pa-form">
        <%!-- Line 1: First Name, Last Name, Email (equal widths) --%>
        <.grid>
          <.column size="100" md="1-3">
            <.form_group is_horizontal label="First Name">
              <.input type="text" id="h-fname" placeholder="John" />
            </.form_group>
          </.column>
          <.column size="100" md="1-3">
            <.form_group is_horizontal label="Last Name">
              <.input type="text" id="h-lname" placeholder="Doe" />
            </.form_group>
          </.column>
          <.column size="100" md="1-3">
            <.form_group is_horizontal label="Email">
              <.input type="email" id="h-email" placeholder="john.doe@company.com" />
            </.form_group>
          </.column>
        </.grid>

        <%!-- Line 2: Phone (smaller), Department (larger), Job Title (medium) --%>
        <.grid>
          <.column size="100" md="25">
            <.form_group is_horizontal label="Phone">
              <.input type="tel" id="h-phone" placeholder="+1 555-0123" />
            </.form_group>
          </.column>
          <.column size="100" md="42">
            <.form_group is_horizontal label="Department">
              <.select id="h-dept" prompt="Select department..." options={[{"engineering", "Engineering"}, {"marketing", "Marketing"}, {"sales", "Sales"}, {"hr", "Human Resources"}]} />
            </.form_group>
          </.column>
          <.column size="100" md="1-3">
            <.form_group is_horizontal label="Job Title">
              <.input type="text" id="h-title" placeholder="Senior Developer" />
            </.form_group>
          </.column>
        </.grid>

        <%!-- Line 3: Address (larger), City (medium), Zip (small) --%>
        <.grid>
          <.column size="100" md="50">
            <.form_group is_horizontal label="Address">
              <.input type="text" id="h-address" placeholder="123 Main Street" />
            </.form_group>
          </.column>
          <.column size="100" md="1-3">
            <.form_group is_horizontal label="City">
              <.input type="text" id="h-city" placeholder="San Francisco" />
            </.form_group>
          </.column>
          <.column size="100" md="15">
            <.form_group is_horizontal label="Zip">
              <.input type="text" id="h-zip" placeholder="94102" />
            </.form_group>
          </.column>
        </.grid>

        <%!-- Submit Buttons --%>
        <.grid>
          <.column size="100" class="text-end mt-3">
            <.button variant="secondary">Cancel</.button>
            <.button type="submit" variant="primary">Submit</.button>
          </.column>
        </.grid>
      </form>
      <:footer>
        <p class="pa-text pa-text--sm pa-text--secondary m-0">
          <strong>Layout pattern:</strong> Each field uses <code>.pa-form-group--horizontal</code> (label left, input right) inside <code>pc-col-*</code> columns.
          Line 1: equal widths (1/3 each).
          Line 2: varying sizes (1/4 + 5/12 + 1/3).
          Line 3: very different sizes (1/2 + 1/3 + 1/6).
        </p>
      </:footer>
    </.card>
    """
  end

  # Rows for the "Input Sizes Reference" table. Heights are measured client-side.
  defp size_rows do
    [
      %{size: "XS", class: "--xs", font: "1.2rem (12px)", padding: "0.6rem / 0.8rem", mod: "xs", placeholder: "Extra small"},
      %{size: "SM", class: "--sm", font: "1.4rem (14px)", padding: "0.8rem / 0.8rem", mod: "sm", placeholder: "Small"},
      %{size: "Default", class: "(none)", font: "1.4rem (14px)", padding: "0.8rem / 0.8rem", mod: nil, placeholder: "Default"},
      %{size: "LG", class: "--lg", font: "1.6rem (16px)", padding: "0.8rem / 0.8rem", mod: "lg", placeholder: "Large"},
      %{size: "XL", class: "--xl", font: "1.8rem (18px)", padding: "0.8rem / 0.8rem", mod: "xl", placeholder: "Extra large"}
    ]
  end
end
