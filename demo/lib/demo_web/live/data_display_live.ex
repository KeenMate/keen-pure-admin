defmodule DemoWeb.Live.DataDisplayLive do
  use DemoWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, page_title: "Data Display")}
  end

  def render(assigns) do
    ~H"""
    <.paragraph>
      Read-only label-value display using <code>pa-fields</code>, <code>pa-field</code>,
      and <code>pa-field-group</code> BEM classes for structured data presentation.
    </.paragraph>

    <%!-- Section 1: Multiple pa-fields Blocks + Multi-Column Grid --%>
    <.grid>
      <.column size="100" md="1-2">
        <.card title_text="Multiple pa-fields Blocks">
          <:description>Combining row, multi-column, and default layouts in one view</:description>

          <h5>Employee Overview</h5>
          <dl class="pa-fields pa-fields--row">
            <div class="pa-field">
              <dt class="pa-field__label">Full Name</dt>
              <dd class="pa-field__value">Elena Vasquez</dd>
            </div>
            <div class="pa-field">
              <dt class="pa-field__label">Employee ID</dt>
              <dd class="pa-field__value">EMP-2024-0847</dd>
            </div>
            <div class="pa-field">
              <dt class="pa-field__label">Department</dt>
              <dd class="pa-field__value">Engineering</dd>
            </div>
          </dl>

          <h5>Details</h5>
          <dl class="pa-fields pa-fields--cols-2">
            <div class="pa-field">
              <dt class="pa-field__label">Email</dt>
              <dd class="pa-field__value">elena.vasquez@company.com</dd>
            </div>
            <div class="pa-field">
              <dt class="pa-field__label">Phone</dt>
              <dd class="pa-field__value">+1 (555) 234-8901</dd>
            </div>
            <div class="pa-field">
              <dt class="pa-field__label">Office</dt>
              <dd class="pa-field__value">Building C, Floor 3</dd>
            </div>
            <div class="pa-field">
              <dt class="pa-field__label">Start Date</dt>
              <dd class="pa-field__value">March 15, 2022</dd>
            </div>
          </dl>

          <h5>Notes</h5>
          <dl class="pa-fields">
            <div class="pa-field">
              <dt class="pa-field__label">Bio</dt>
              <dd class="pa-field__value">
                Senior software engineer with 8 years of experience in distributed systems
                and cloud infrastructure. Currently leading the platform reliability team.
              </dd>
            </div>
            <div class="pa-field">
              <dt class="pa-field__label">Skills</dt>
              <dd class="pa-field__value">Elixir, Rust, Kubernetes, AWS, PostgreSQL</dd>
            </div>
          </dl>
        </.card>
      </.column>

      <.column size="100" md="1-2">
        <.card title_text="Multi-Column Grid">
          <:description>Two-column layout with a full-width spanning field</:description>

          <dl class="pa-fields pa-fields--cols-2">
            <div class="pa-field">
              <dt class="pa-field__label">Order ID</dt>
              <dd class="pa-field__value">ORD-2024-19382</dd>
            </div>
            <div class="pa-field">
              <dt class="pa-field__label">Order Date</dt>
              <dd class="pa-field__value">January 8, 2025</dd>
            </div>
            <div class="pa-field">
              <dt class="pa-field__label">Customer</dt>
              <dd class="pa-field__value">Marcus Chen</dd>
            </div>
            <div class="pa-field">
              <dt class="pa-field__label">Payment Method</dt>
              <dd class="pa-field__value">Visa ending in 4821</dd>
            </div>
            <div class="pa-field">
              <dt class="pa-field__label">Subtotal</dt>
              <dd class="pa-field__value">$1,249.00</dd>
            </div>
            <div class="pa-field">
              <dt class="pa-field__label">Tax</dt>
              <dd class="pa-field__value">$99.92</dd>
            </div>
            <div class="pa-field pa-field--full">
              <dt class="pa-field__label">Shipping Address</dt>
              <dd class="pa-field__value">
                742 Evergreen Terrace, Apt 3B, Springfield, IL 62704, United States
              </dd>
            </div>
          </dl>
        </.card>
      </.column>
    </.grid>

    <%!-- Section 2: Field Groups --%>
    <.card title_text="Field Groups">
      <:description>Organized sections using pa-field-group for logical grouping</:description>

      <.grid>
        <.column size="100" md="1-3">
          <div class="pa-field-group">
            <h5 class="pa-field-group__title">Personal Information</h5>
            <dl class="pa-fields">
              <div class="pa-field">
                <dt class="pa-field__label">Full Name</dt>
                <dd class="pa-field__value">Sarah Mitchell</dd>
              </div>
              <div class="pa-field">
                <dt class="pa-field__label">Date of Birth</dt>
                <dd class="pa-field__value">April 12, 1988</dd>
              </div>
              <div class="pa-field">
                <dt class="pa-field__label">Nationality</dt>
                <dd class="pa-field__value">Canadian</dd>
              </div>
              <div class="pa-field">
                <dt class="pa-field__label">Email</dt>
                <dd class="pa-field__value">s.mitchell@email.com</dd>
              </div>
              <div class="pa-field">
                <dt class="pa-field__label">Phone</dt>
                <dd class="pa-field__value">+1 (604) 555-0193</dd>
              </div>
            </dl>
          </div>
        </.column>

        <.column size="100" md="1-3">
          <div class="pa-field-group">
            <h5 class="pa-field-group__title">Employment Details</h5>
            <dl class="pa-fields">
              <div class="pa-field">
                <dt class="pa-field__label">Position</dt>
                <dd class="pa-field__value">Product Manager</dd>
              </div>
              <div class="pa-field">
                <dt class="pa-field__label">Department</dt>
                <dd class="pa-field__value">Product Development</dd>
              </div>
              <div class="pa-field">
                <dt class="pa-field__label">Manager</dt>
                <dd class="pa-field__value">David Park</dd>
              </div>
              <div class="pa-field">
                <dt class="pa-field__label">Hire Date</dt>
                <dd class="pa-field__value">June 1, 2021</dd>
              </div>
              <div class="pa-field">
                <dt class="pa-field__label">Salary Band</dt>
                <dd class="pa-field__value">L5 - Senior</dd>
              </div>
            </dl>
          </div>
        </.column>

        <.column size="100" md="1-3">
          <div class="pa-field-group">
            <h5 class="pa-field-group__title">Emergency Contact</h5>
            <dl class="pa-fields">
              <div class="pa-field">
                <dt class="pa-field__label">Name</dt>
                <dd class="pa-field__value">Robert Mitchell</dd>
              </div>
              <div class="pa-field">
                <dt class="pa-field__label">Relationship</dt>
                <dd class="pa-field__value">Spouse</dd>
              </div>
              <div class="pa-field">
                <dt class="pa-field__label">Phone</dt>
                <dd class="pa-field__value">+1 (604) 555-0287</dd>
              </div>
              <div class="pa-field">
                <dt class="pa-field__label">Email</dt>
                <dd class="pa-field__value">r.mitchell@email.com</dd>
              </div>
              <div class="pa-field">
                <dt class="pa-field__label">Address</dt>
                <dd class="pa-field__value">1200 Burrard St, Vancouver</dd>
              </div>
            </dl>
          </div>
        </.column>
      </.grid>
    </.card>

    <%!-- Section 3: Horizontal + Table-Style Bordered + Striped --%>
    <.grid>
      <.column size="100" md="1-3">
        <.card title_text="Horizontal">
          <:description>Labels and values side by side</:description>

          <dl class="pa-fields pa-fields--horizontal">
            <div class="pa-field">
              <dt class="pa-field__label">Hostname</dt>
              <dd class="pa-field__value">srv-prod-us-east-01</dd>
            </div>
            <div class="pa-field">
              <dt class="pa-field__label">IP Address</dt>
              <dd class="pa-field__value">10.42.18.105</dd>
            </div>
            <div class="pa-field">
              <dt class="pa-field__label">OS</dt>
              <dd class="pa-field__value">Ubuntu 22.04 LTS</dd>
            </div>
            <div class="pa-field">
              <dt class="pa-field__label">Uptime</dt>
              <dd class="pa-field__value">142 days, 7 hours</dd>
            </div>
            <div class="pa-field">
              <dt class="pa-field__label">CPU Load</dt>
              <dd class="pa-field__value">23.4%</dd>
            </div>
          </dl>
        </.card>
      </.column>

      <.column size="100" md="1-3">
        <.card title_text="Table-Style Bordered">
          <:description>Bordered rows with structured data</:description>

          <dl class="pa-fields pa-fields--table pa-fields--bordered">
            <div class="pa-field">
              <dt class="pa-field__label">Plan</dt>
              <dd class="pa-field__value">Enterprise</dd>
            </div>
            <div class="pa-field">
              <dt class="pa-field__label">Status</dt>
              <dd class="pa-field__value">
                <.badge variant="success" size="sm">Active</.badge>
              </dd>
            </div>
            <div class="pa-field">
              <dt class="pa-field__label">Billing Cycle</dt>
              <dd class="pa-field__value">Annual</dd>
            </div>
            <div class="pa-field">
              <dt class="pa-field__label">Next Invoice</dt>
              <dd class="pa-field__value">Feb 1, 2026</dd>
            </div>
            <div class="pa-field">
              <dt class="pa-field__label">Amount</dt>
              <dd class="pa-field__value">$2,400.00 / year</dd>
            </div>
          </dl>
        </.card>
      </.column>

      <.column size="100" md="1-3">
        <.card title_text="Striped">
          <:description>Alternating row backgrounds</:description>

          <dl class="pa-fields pa-fields--striped">
            <div class="pa-field">
              <dt class="pa-field__label">Protocol</dt>
              <dd class="pa-field__value">HTTPS</dd>
            </div>
            <div class="pa-field">
              <dt class="pa-field__label">Port</dt>
              <dd class="pa-field__value">443</dd>
            </div>
            <div class="pa-field">
              <dt class="pa-field__label">SSL Certificate</dt>
              <dd class="pa-field__value">Let's Encrypt (RSA 2048)</dd>
            </div>
            <div class="pa-field">
              <dt class="pa-field__label">Expires</dt>
              <dd class="pa-field__value">June 15, 2026</dd>
            </div>
            <div class="pa-field">
              <dt class="pa-field__label">HSTS</dt>
              <dd class="pa-field__value">Enabled (max-age=31536000)</dd>
            </div>
          </dl>
        </.card>
      </.column>
    </.grid>

    <%!-- Section 4: Compact + Inline + Row + Relaxed --%>
    <.grid>
      <.column size="100" md="25">
        <.card title_text="Compact">
          <:description>Reduced spacing between fields</:description>

          <dl class="pa-fields pa-fields--compact">
            <div class="pa-field">
              <dt class="pa-field__label">CPU</dt>
              <dd class="pa-field__value">Intel Xeon E5-2690</dd>
            </div>
            <div class="pa-field">
              <dt class="pa-field__label">Cores</dt>
              <dd class="pa-field__value">16</dd>
            </div>
            <div class="pa-field">
              <dt class="pa-field__label">RAM</dt>
              <dd class="pa-field__value">64 GB DDR4</dd>
            </div>
            <div class="pa-field">
              <dt class="pa-field__label">Storage</dt>
              <dd class="pa-field__value">2x 1TB NVMe SSD</dd>
            </div>
            <div class="pa-field">
              <dt class="pa-field__label">NIC</dt>
              <dd class="pa-field__value">10 GbE</dd>
            </div>
          </dl>
        </.card>
      </.column>

      <.column size="100" md="25">
        <.card title_text="Inline">
          <:description>Fields displayed inline</:description>

          <dl class="pa-fields pa-fields--inline">
            <div class="pa-field">
              <dt class="pa-field__label">Repo</dt>
              <dd class="pa-field__value">keen-pure-admin</dd>
            </div>
            <div class="pa-field">
              <dt class="pa-field__label">Branch</dt>
              <dd class="pa-field__value">main</dd>
            </div>
            <div class="pa-field">
              <dt class="pa-field__label">Commit</dt>
              <dd class="pa-field__value">a3f8c21</dd>
            </div>
            <div class="pa-field">
              <dt class="pa-field__label">Author</dt>
              <dd class="pa-field__value">evasquez</dd>
            </div>
            <div class="pa-field">
              <dt class="pa-field__label">CI</dt>
              <dd class="pa-field__value">Passing</dd>
            </div>
          </dl>
        </.card>
      </.column>

      <.column size="100" md="25">
        <.card title_text="Row">
          <:description>Fields in a horizontal row</:description>

          <dl class="pa-fields pa-fields--row">
            <div class="pa-field">
              <dt class="pa-field__label">Region</dt>
              <dd class="pa-field__value">US-East</dd>
            </div>
            <div class="pa-field">
              <dt class="pa-field__label">Zone</dt>
              <dd class="pa-field__value">us-east-1a</dd>
            </div>
            <div class="pa-field">
              <dt class="pa-field__label">VPC</dt>
              <dd class="pa-field__value">vpc-0a1b2c</dd>
            </div>
            <div class="pa-field">
              <dt class="pa-field__label">Subnet</dt>
              <dd class="pa-field__value">10.0.1.0/24</dd>
            </div>
          </dl>
        </.card>
      </.column>

      <.column size="100" md="25">
        <.card title_text="Relaxed">
          <:description>Extra spacing between fields</:description>

          <dl class="pa-fields pa-fields--relaxed">
            <div class="pa-field">
              <dt class="pa-field__label">Project</dt>
              <dd class="pa-field__value">Atlas Platform</dd>
            </div>
            <div class="pa-field">
              <dt class="pa-field__label">Sprint</dt>
              <dd class="pa-field__value">Sprint 24</dd>
            </div>
            <div class="pa-field">
              <dt class="pa-field__label">Velocity</dt>
              <dd class="pa-field__value">42 points</dd>
            </div>
            <div class="pa-field">
              <dt class="pa-field__label">Deadline</dt>
              <dd class="pa-field__value">March 31, 2026</dd>
            </div>
          </dl>
        </.card>
      </.column>
    </.grid>

    <%!-- Section 5: Filled Background + Color-Coded Borders --%>
    <.grid>
      <.column size="100" md="1-2">
        <.card title_text="Filled Background">
          <:description>Fields with a filled background style</:description>

          <dl class="pa-fields pa-fields--filled">
            <div class="pa-field">
              <dt class="pa-field__label">API Endpoint</dt>
              <dd class="pa-field__value">https://api.example.com/v2</dd>
            </div>
            <div class="pa-field">
              <dt class="pa-field__label">Auth Method</dt>
              <dd class="pa-field__value">Bearer Token (OAuth 2.0)</dd>
            </div>
            <div class="pa-field">
              <dt class="pa-field__label">Rate Limit</dt>
              <dd class="pa-field__value">1,000 requests/minute</dd>
            </div>
            <div class="pa-field">
              <dt class="pa-field__label">Response Format</dt>
              <dd class="pa-field__value">JSON (application/json)</dd>
            </div>
            <div class="pa-field">
              <dt class="pa-field__label">Timeout</dt>
              <dd class="pa-field__value">30 seconds</dd>
            </div>
          </dl>
        </.card>
      </.column>

      <.column size="100" md="1-2">
        <.card title_text="Color-Coded Borders">
          <:description>Border colors for visual categorization (color-1 through color-5)</:description>

          <dl class="pa-fields pa-fields--color-1">
            <div class="pa-field">
              <dt class="pa-field__label">Environment</dt>
              <dd class="pa-field__value">Production</dd>
            </div>
          </dl>

          <dl class="pa-fields pa-fields--color-2">
            <div class="pa-field">
              <dt class="pa-field__label">Environment</dt>
              <dd class="pa-field__value">Staging</dd>
            </div>
          </dl>

          <dl class="pa-fields pa-fields--color-3">
            <div class="pa-field">
              <dt class="pa-field__label">Environment</dt>
              <dd class="pa-field__value">Development</dd>
            </div>
          </dl>

          <dl class="pa-fields pa-fields--color-4">
            <div class="pa-field">
              <dt class="pa-field__label">Environment</dt>
              <dd class="pa-field__value">QA / Testing</dd>
            </div>
          </dl>

          <dl class="pa-fields pa-fields--color-5">
            <div class="pa-field">
              <dt class="pa-field__label">Environment</dt>
              <dd class="pa-field__value">Sandbox</dd>
            </div>
          </dl>
        </.card>
      </.column>
    </.grid>
    """
  end
end
