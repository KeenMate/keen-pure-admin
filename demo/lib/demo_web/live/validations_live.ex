defmodule DemoWeb.Live.ValidationsLive do
  use DemoWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, page_title: "Validations")}
  end

  def render(assigns) do
    ~H"""
    <.paragraph>Different UI patterns for displaying form validation errors. Choose the pattern that best fits your UX requirements.</.paragraph>

    <%!-- Pattern 1: Inline Field Errors --%>
    <.card title_text="1. Inline Field Errors">
      <.paragraph class="mb-3">The most common pattern. Error messages appear directly below each field. Best for forms where users need immediate field-level feedback.</.paragraph>

      <form class="pa-form">
        <.grid>
          <.column size="100" md="50">
            <.form_group validation="error">
              <.form_label>Email Address</.form_label>
              <.input type="email" value="invalid-email" validation="error" />
              <.form_help variant="error">Please enter a valid email address</.form_help>
            </.form_group>
          </.column>
          <.column size="100" md="50">
            <.form_group validation="error">
              <.form_label>Password</.form_label>
              <.input type="password" value="123" validation="error" />
              <.form_help variant="error">Password must be at least 8 characters</.form_help>
            </.form_group>
          </.column>
          <.column size="100" md="50">
            <.form_group validation="success">
              <.form_label>Username</.form_label>
              <.input type="text" value="johndoe" validation="success" />
              <.form_help variant="success">Username is available</.form_help>
            </.form_group>
          </.column>
          <.column size="100" md="50">
            <.form_group validation="warning">
              <.form_label>Phone Number</.form_label>
              <.input type="tel" value="555-1234" validation="warning" />
              <.form_help variant="warning">Consider adding country code for international format</.form_help>
            </.form_group>
          </.column>
        </.grid>
      </form>

      <.callout variant="info" class="mt-4">
        <strong>Usage:</strong> Add <code>pa-form-group--error</code> to the form group and <code>pa-form-help--error</code> to the help text.
      </.callout>
    </.card>

    <%!-- Pattern 2: Summary Block --%>
    <.card title_text="2. Summary Block (Top of Form)">
      <.paragraph class="mb-3">All errors collected in a single alert at the top. Good for accessibility and giving users a quick overview of all issues.</.paragraph>

      <form class="pa-form">
        <.alert variant="danger" class="mb-4">
          <strong>Please fix the following errors:</strong>
          <ul class="mt-0 mb-0">
            <li>First name is required</li>
            <li>Email address is not valid</li>
            <li>Password must contain at least one uppercase letter</li>
            <li>Please accept the terms and conditions</li>
          </ul>
        </.alert>

        <.grid>
          <.column size="100" md="50">
            <.form_group validation="error">
              <.form_label>First Name</.form_label>
              <.input type="text" placeholder="Enter first name" validation="error" />
            </.form_group>
          </.column>
          <.column size="100" md="50">
            <.form_group>
              <.form_label>Last Name</.form_label>
              <.input type="text" value="Smith" />
            </.form_group>
          </.column>
          <.column size="100" md="50">
            <.form_group validation="error">
              <.form_label>Email</.form_label>
              <.input type="email" value="not-an-email" validation="error" />
            </.form_group>
          </.column>
          <.column size="100" md="50">
            <.form_group validation="error">
              <.form_label>Password</.form_label>
              <.input type="password" value="password" validation="error" />
            </.form_group>
          </.column>
          <.column size="100">
            <.form_group validation="error">
              <.checkbox id="terms" label="I accept the terms and conditions" />
            </.form_group>
          </.column>
        </.grid>
      </form>

      <.callout variant="info" class="mt-4">
        <strong>Best Practice:</strong> Combine summary block with inline errors for maximum accessibility. Screen readers can announce all errors at once.
      </.callout>
    </.card>

    <%!-- Pattern 3: Inline + Summary Combined --%>
    <.card title_text="3. Combined: Summary + Inline (Recommended)">
      <.paragraph class="mb-3">The best of both worlds. Summary for overview, inline for specific guidance. Most accessible approach.</.paragraph>

      <form class="pa-form">
        <.alert variant="danger" class="mb-4">
          <strong>2 errors found:</strong>
          <ul class="mt-0 mb-0">
            <li><a href="#card-number">Card number</a> - Invalid card number format</li>
            <li><a href="#cvv">CVV</a> - Must be 3 or 4 digits</li>
          </ul>
        </.alert>

        <.grid>
          <.column size="100" md="50">
            <.form_group validation="error">
              <.form_label for="card-number">Card Number</.form_label>
              <.input type="text" id="card-number" value="1234-5678-XXXX" validation="error" />
              <.form_help variant="error">Invalid card number format. Please use 16 digits.</.form_help>
            </.form_group>
          </.column>
          <.column size="100" md="25">
            <.form_group validation="success">
              <.form_label>Expiry Date</.form_label>
              <.input type="text" value="12/25" validation="success" />
              <.form_help variant="success">Valid</.form_help>
            </.form_group>
          </.column>
          <.column size="100" md="25">
            <.form_group validation="error">
              <.form_label for="cvv">CVV</.form_label>
              <.input type="text" id="cvv" value="12" validation="error" />
              <.form_help variant="error">Must be 3 or 4 digits</.form_help>
            </.form_group>
          </.column>
        </.grid>
      </form>

      <.callout variant="success" class="mt-4">
        <strong>Tip:</strong> Make summary items clickable links that jump to the relevant field using anchor IDs.
      </.callout>
    </.card>

    <%!-- Pattern 4: Border + Icon Only --%>
    <.card title_text="4. Border + Icon Only (Minimal)">
      <.paragraph class="mb-3">Space-efficient but less informative. Red border and icon indicate error without text message. User must infer the issue or hover/click for details.</.paragraph>

      <form class="pa-form">
        <.grid>
          <.column size="100" md="1-3">
            <.form_group>
              <.form_label>Username</.form_label>
              <.input_group>
                <.input type="text" value="" validation="error" />
                <:append>
                  <span class="pa-text--danger" title="This field is required">!</span>
                </:append>
              </.input_group>
            </.form_group>
          </.column>
          <.column size="100" md="1-3">
            <.form_group>
              <.form_label>Email</.form_label>
              <.input_group>
                <.input type="email" value="bad@" validation="error" />
                <:append>
                  <span class="pa-text--danger" title="Invalid email format">!</span>
                </:append>
              </.input_group>
            </.form_group>
          </.column>
          <.column size="100" md="1-3">
            <.form_group>
              <.form_label>Password</.form_label>
              <.input_group>
                <.input type="password" value="securepass123" validation="success" />
                <:append>
                  <span class="pa-text--success">&#10003;</span>
                </:append>
              </.input_group>
            </.form_group>
          </.column>
        </.grid>
      </form>

      <.callout variant="warning" class="mt-4">
        <strong>Caution:</strong> This pattern provides poor accessibility. Consider using tooltips or aria-describedby for screen readers.
      </.callout>
    </.card>

    <%!-- Pattern 5: Right-side Indicators --%>
    <.card title_text="5. Right-side Indicators">
      <.paragraph class="mb-3">Error text positioned to the right of the input. Works well in horizontal form layouts with more screen real estate.</.paragraph>

      <form class="pa-form">
        <.form_group is_horizontal class="align-items-center">
          <.form_label class="pa-col-md-25" for="company-name">Company Name</.form_label>
          <div class="pa-col-md-40">
            <.input type="text" id="company-name" value="" validation="error" />
          </div>
          <div class="pa-col-md-35">
            <.form_help variant="error" class="mt-0">Company name is required</.form_help>
          </div>
        </.form_group>
        <.form_group is_horizontal class="align-items-center">
          <.form_label class="pa-col-md-25" for="website-url">Website URL</.form_label>
          <div class="pa-col-md-40">
            <.input type="url" id="website-url" value="not-a-url" validation="error" />
          </div>
          <div class="pa-col-md-35">
            <.form_help variant="error" class="mt-0">Please enter a valid URL (e.g., https://example.com)</.form_help>
          </div>
        </.form_group>
        <.form_group is_horizontal class="align-items-center">
          <.form_label class="pa-col-md-25" for="industry-select">Industry</.form_label>
          <div class="pa-col-md-40">
            <.select id="industry-select" validation="success" options={["Technology"]} />
          </div>
          <div class="pa-col-md-35">
            <.form_help variant="success" class="mt-0">&#10003; Valid selection</.form_help>
          </div>
        </.form_group>
      </form>
    </.card>

    <%!-- Pattern 6: Helper Text Transforms to Error --%>
    <.card title_text="6. Helper Text Transforms to Error">
      <.paragraph class="mb-3">Helper text below the field transforms into error text when validation fails. Maintains consistent spacing.</.paragraph>

      <form class="pa-form">
        <.grid>
          <.column size="100" md="50">
            <.form_group>
              <.form_label>Bio</.form_label>
              <.textarea rows={3} value="This is my bio text that keeps going and going..." />
              <.form_help>Maximum 100 characters (85/100)</.form_help>
            </.form_group>
          </.column>
          <.column size="100" md="50">
            <.form_group validation="error">
              <.form_label>Bio (Over Limit)</.form_label>
              <.textarea rows={3} validation="error" value="This is my bio text that keeps going and going and going until it exceeds the character limit which causes a validation error..." />
              <.form_help variant="error">Maximum 100 characters exceeded (142/100)</.form_help>
            </.form_group>
          </.column>
        </.grid>
      </form>
    </.card>

    <%!-- Pattern 7: Toast Notifications --%>
    <.card title_text="7. Toast Notifications">
      <.paragraph class="mb-3">Validation errors shown as toast notifications. Best for submit-level errors or async validation (e.g., server-side checks).</.paragraph>

      <form class="pa-form">
        <.grid>
          <.column size="100" md="50">
            <.form_group>
              <.form_label>Email</.form_label>
              <.input type="email" value="user@example.com" />
            </.form_group>
          </.column>
          <.column size="100" md="50">
            <.form_group>
              <.form_label>Password</.form_label>
              <.input type="password" value="password123" />
            </.form_group>
          </.column>
        </.grid>
      </form>

      <%!-- Simulated toast preview --%>
      <.card class="mt-4" has_padding>
        <.paragraph class="text-muted mb-2"><em>Toast preview (normally appears in corner):</em></.paragraph>
        <.alert variant="danger">
          <strong>Validation Failed</strong> — Invalid credentials. Please check your email and password.
        </.alert>
      </.card>

      <.callout variant="warning" class="mt-4">
        <strong>Note:</strong> Toasts are ephemeral. Don't use them as the only validation feedback - users may miss them.
      </.callout>
    </.card>

    <%!-- Pattern 8: Validation Timing --%>
    <.card title_text="8. Validation Timing Strategies">
      <.paragraph class="mb-3">When to trigger validation affects user experience significantly.</.paragraph>

      <.grid>
        <.column size="100" md="1-3">
          <.card class="pa-card--bordered" variant="warning" title_text="On Input (Real-time)">
            <.form_group validation="error">
              <.form_label>Email</.form_label>
              <.input type="email" value="user@" validation="error" placeholder="Type to see validation..." />
              <.form_help variant="error">Email incomplete</.form_help>
            </.form_group>
            <small class="mt-2 text-muted">Validates as user types. Can feel aggressive.</small>
          </.card>
        </.column>
        <.column size="100" md="1-3">
          <.card class="pa-card--bordered" variant="success" title_text="On Blur (Recommended)">
            <.form_group validation="error">
              <.form_label>Email</.form_label>
              <.input type="email" value="invalid" validation="error" placeholder="Tab out to validate..." />
              <.form_help variant="error">Invalid email format</.form_help>
            </.form_group>
            <small class="mt-2 text-muted">Validates when field loses focus. Good balance.</small>
          </.card>
        </.column>
        <.column size="100" md="1-3">
          <.card class="pa-card--bordered" variant="info" title_text="On Submit">
            <.form_group>
              <.form_label>Email</.form_label>
              <.input type="email" value="anything" placeholder="No validation until submit" />
            </.form_group>
            <small class="mt-2 text-muted">All errors shown at once on submit. Traditional approach.</small>
          </.card>
        </.column>
      </.grid>
    </.card>

    <%!-- Pattern 9: Multi-field Validation --%>
    <.card title_text="9. Multi-field / Cross-field Validation">
      <.paragraph class="mb-3">When validation depends on multiple fields (e.g., password confirmation, date ranges).</.paragraph>

      <form class="pa-form">
        <.grid>
          <.column size="100" md="50">
            <.form_group validation="success">
              <.form_label>New Password</.form_label>
              <.input type="password" value="SecurePass123!" validation="success" />
              <.form_help variant="success">Strong password</.form_help>
            </.form_group>
          </.column>
          <.column size="100" md="50">
            <.form_group validation="error">
              <.form_label>Confirm Password</.form_label>
              <.input type="password" value="SecurePass123" validation="error" />
              <.form_help variant="error">Passwords do not match</.form_help>
            </.form_group>
          </.column>
        </.grid>

        <.divider />

        <.grid>
          <.column size="100" md="50">
            <.form_group validation="error">
              <.form_label>Start Date</.form_label>
              <.input type="date" value="2025-12-31" validation="error" />
            </.form_group>
          </.column>
          <.column size="100" md="50">
            <.form_group validation="error">
              <.form_label>End Date</.form_label>
              <.input type="date" value="2025-01-01" validation="error" />
            </.form_group>
          </.column>
          <.column size="100">
            <.alert variant="danger">
              End date must be after start date
            </.alert>
          </.column>
        </.grid>
      </form>
    </.card>

    <%!-- Pattern 10: Progressive Validation --%>
    <.card title_text="10. Progressive Validation (Multi-step Forms)">
      <.paragraph class="mb-3">Validate each step before allowing progression. Prevents users from reaching the end with invalid data.</.paragraph>

      <%!-- Step indicators --%>
      <.grid class="mb-4">
        <.column size="1-3" class="text-center">
          <.badge variant="success" size="lg">1</.badge>
          <.paragraph class="mt-2 text-success">Account</.paragraph>
        </.column>
        <.column size="1-3" class="text-center">
          <.badge variant="danger" size="lg">2</.badge>
          <.paragraph class="mt-2 text-danger">Profile</.paragraph>
        </.column>
        <.column size="1-3" class="text-center">
          <.badge size="lg" class="pa-badge--default">3</.badge>
          <.paragraph class="mt-2 text-muted">Confirm</.paragraph>
        </.column>
      </.grid>

      <.alert variant="danger" class="mb-3">
        Please complete all required fields in Step 2 before proceeding.
      </.alert>

      <form class="pa-form">
        <.grid>
          <.column size="100" md="50">
            <.form_group validation="error">
              <.form_label>Display Name</.form_label>
              <.input type="text" placeholder="Enter display name" validation="error" />
              <.form_help variant="error">Display name is required</.form_help>
            </.form_group>
          </.column>
          <.column size="100" md="50">
            <.form_group validation="success">
              <.form_label>Avatar URL</.form_label>
              <.input type="url" value="https://example.com/avatar.jpg" validation="success" />
              <.form_help variant="success">Valid URL</.form_help>
            </.form_group>
          </.column>
        </.grid>
        <.button_group class="pa-form-actions">
          <.button variant="secondary">Back</.button>
          <.button variant="primary" disabled>Next Step</.button>
        </.button_group>
      </form>
    </.card>

    <%!-- CSS Classes Reference --%>
    <.card title_text="CSS Classes Reference">
      <.heading level={4}>Form Group States</.heading>
      <ul class="pa-list-basic--compact">
        <li><code>pa-form-group--success</code> - Success state (green)</li>
        <li><code>pa-form-group--warning</code> - Warning state (yellow/orange)</li>
        <li><code>pa-form-group--error</code> - Error state (red)</li>
      </ul>

      <.heading level={4} class="mt-4">Input States</.heading>
      <ul class="pa-list-basic--compact">
        <li><code>pa-input--success</code> - Success border on input</li>
        <li><code>pa-input--warning</code> - Warning border on input</li>
        <li><code>pa-input--error</code> - Error border on input</li>
      </ul>

      <.heading level={4} class="mt-4">Help/Message Text</.heading>
      <ul class="pa-list-basic--compact">
        <li><code>pa-form-help</code> - Base help text styling</li>
        <li><code>pa-form-help--success</code> - Green help text</li>
        <li><code>pa-form-help--warning</code> - Yellow/orange help text</li>
        <li><code>pa-form-help--error</code> - Red help text</li>
      </ul>

      <.heading level={4} class="mt-4">Alert Variants (for Summary Blocks)</.heading>
      <ul class="pa-list-basic--compact">
        <li><code>pa-alert pa-alert--danger</code> - Error summary block</li>
        <li><code>pa-alert pa-alert--warning</code> - Warning summary block</li>
        <li><code>pa-alert pa-alert--success</code> - Success message block</li>
        <li><code>pa-alert pa-alert--info</code> - Info message block</li>
      </ul>

      <.heading level={4} class="mt-4">Text Utility Classes</.heading>
      <ul class="pa-list-basic--compact">
        <li><code>text-danger</code> - Red text color</li>
        <li><code>text-warning</code> - Yellow/orange text color</li>
        <li><code>text-success</code> - Green text color</li>
        <li><code>text-muted</code> - Muted/gray text color</li>
      </ul>
    </.card>
    """
  end
end
