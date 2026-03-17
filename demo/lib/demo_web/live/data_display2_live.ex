defmodule DemoWeb.Live.DataDisplay2Live do
  use DemoWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, page_title: "Data Display 2")}
  end

  def render(assigns) do
    ~H"""
    <.paragraph>Advanced data display patterns: description tables, dot leaders, property cards, and banded rows.</.paragraph>

    <%!-- Descriptions Table (1-column) --%>
    <.card title_text="Descriptions Table">
      <:description>Ant Design style description table with tinted labels and plain values</:description>
      <div class="pa-desc-container">
        <div class="pa-desc-table">
          <span class="pa-desc-table__label">Company</span>
          <span class="pa-desc-table__value">Acme Corporation s.r.o.</span>
          <span class="pa-desc-table__label">Reg. No.</span>
          <span class="pa-desc-table__value">12345678</span>
          <span class="pa-desc-table__label">VAT ID</span>
          <span class="pa-desc-table__value">CZ12345678</span>
          <span class="pa-desc-table__label">Contact</span>
          <span class="pa-desc-table__value">Jan Novak</span>
          <span class="pa-desc-table__label">Email</span>
          <span class="pa-desc-table__value">jan.novak@acme.cz</span>
          <span class="pa-desc-table__label">Phone</span>
          <span class="pa-desc-table__value">+420 123 456 789</span>
          <span class="pa-desc-table__label pa-desc-table__label--full">Notes</span>
          <span class="pa-desc-table__value pa-desc-table__value--full">
            This is a long note that spans the full width of the description table.
            It can contain multiple sentences and provides additional context about the company record.
          </span>
        </div>
      </div>
    </.card>

    <%!-- Descriptions Table 2-column --%>
    <.card title_text="Descriptions Table (2-column)">
      <:description>Two-column layout for denser information display</:description>
      <div class="pa-desc-container">
        <div class="pa-desc-table pa-desc-table--cols-2">
          <span class="pa-desc-table__label">First Name</span>
          <span class="pa-desc-table__value">Jana</span>
          <span class="pa-desc-table__label">Last Name</span>
          <span class="pa-desc-table__value">Svobodova</span>
          <span class="pa-desc-table__label">Date of Birth</span>
          <span class="pa-desc-table__value">1990-05-14</span>
          <span class="pa-desc-table__label">Role</span>
          <span class="pa-desc-table__value">Senior Developer</span>
          <span class="pa-desc-table__label">Office</span>
          <span class="pa-desc-table__value">Prague HQ</span>
          <span class="pa-desc-table__label">Start Date</span>
          <span class="pa-desc-table__value">2018-03-01</span>
        </div>
      </div>
    </.card>

    <%!-- Fixed + Truncate & Custom Label Width --%>
    <.grid>
      <.column size="100" md="1-2">
        <.card title_text="Fixed + Truncate">
          <:description>Equal-width columns with text truncation for overflow</:description>
          <div class="pa-desc-container">
            <div class="pa-desc-table pa-desc-table--cols-2 pa-desc-table--fixed pa-desc-table--truncate">
              <span class="pa-desc-table__label">Project Name</span>
              <span class="pa-desc-table__value">Enterprise Resource Planning System Overhaul</span>
              <span class="pa-desc-table__label">Lead Developer</span>
              <span class="pa-desc-table__value">Alexandra Konstantinova-Petrova</span>
              <span class="pa-desc-table__label">Department</span>
              <span class="pa-desc-table__value">Software Engineering & Architecture</span>
              <span class="pa-desc-table__label">Status</span>
              <span class="pa-desc-table__value">In Progress - Phase 2 Implementation</span>
              <span class="pa-desc-table__label">Deadline</span>
              <span class="pa-desc-table__value">2026-12-31</span>
              <span class="pa-desc-table__label">Budget</span>
              <span class="pa-desc-table__value">1,250,000 CZK</span>
            </div>
          </div>
        </.card>
      </.column>
      <.column size="100" md="1-2">
        <.card title_text="Custom Label Width">
          <:description>Fixed layout with custom label width via CSS variable</:description>
          <div class="pa-desc-container">
            <div class="pa-desc-table pa-desc-table--fixed" style="--label-width: 20rem">
              <span class="pa-desc-table__label">Server Hostname</span>
              <span class="pa-desc-table__value">prod-web-01.acme.internal</span>
              <span class="pa-desc-table__label">Operating System</span>
              <span class="pa-desc-table__value">Ubuntu 24.04 LTS</span>
              <span class="pa-desc-table__label">CPU Cores</span>
              <span class="pa-desc-table__value">16</span>
              <span class="pa-desc-table__label">Memory</span>
              <span class="pa-desc-table__value">64 GB</span>
              <span class="pa-desc-table__label">Storage</span>
              <span class="pa-desc-table__value">2 TB NVMe SSD</span>
              <span class="pa-desc-table__label">Last Maintenance</span>
              <span class="pa-desc-table__value">2026-02-15</span>
            </div>
          </div>
        </.card>
      </.column>
    </.grid>

    <%!-- Dot Leaders --%>
    <.grid>
      <.column size="100" md="1-2">
        <.card title_text="Dot Leaders">
          <:description>Dot leaders connect labels to values for easy scanning</:description>
          <div class="pa-dot-leaders">
            <div class="pa-dot-leaders__item">
              <span class="pa-dot-leaders__label">Contract No.</span>
              <span class="pa-dot-leaders__leader"></span>
              <span class="pa-dot-leaders__value">SLA-2026-00142</span>
            </div>
            <div class="pa-dot-leaders__item">
              <span class="pa-dot-leaders__label">Type</span>
              <span class="pa-dot-leaders__leader"></span>
              <span class="pa-dot-leaders__value">Enterprise Support</span>
            </div>
            <div class="pa-dot-leaders__item">
              <span class="pa-dot-leaders__label">Status</span>
              <span class="pa-dot-leaders__leader"></span>
              <span class="pa-dot-leaders__value">Active</span>
            </div>
            <div class="pa-dot-leaders__item">
              <span class="pa-dot-leaders__label">Renewal Date</span>
              <span class="pa-dot-leaders__leader"></span>
              <span class="pa-dot-leaders__value">2027-01-15</span>
            </div>
            <div class="pa-dot-leaders__item">
              <span class="pa-dot-leaders__label">Seats</span>
              <span class="pa-dot-leaders__leader"></span>
              <span class="pa-dot-leaders__value">250</span>
            </div>
          </div>
        </.card>
      </.column>
      <.column size="100" md="1-2">
        <.card title_text="Dot Leaders - Invoice Totals">
          <:description>Invoice summary with dot leaders and emphasized total</:description>
          <div class="pa-dot-leaders">
            <div class="pa-dot-leaders__item">
              <span class="pa-dot-leaders__label">Subtotal</span>
              <span class="pa-dot-leaders__leader"></span>
              <span class="pa-dot-leaders__value">12,500.00 CZK</span>
            </div>
            <div class="pa-dot-leaders__item">
              <span class="pa-dot-leaders__label">Tax (21%)</span>
              <span class="pa-dot-leaders__leader"></span>
              <span class="pa-dot-leaders__value">2,625.00 CZK</span>
            </div>
            <div class="pa-dot-leaders__item">
              <span class="pa-dot-leaders__label">Shipping</span>
              <span class="pa-dot-leaders__leader"></span>
              <span class="pa-dot-leaders__value">150.00 CZK</span>
            </div>
            <div class="pa-dot-leaders__item">
              <span class="pa-dot-leaders__label">Discount</span>
              <span class="pa-dot-leaders__leader"></span>
              <span class="pa-dot-leaders__value">-500.00 CZK</span>
            </div>
            <div class="pa-dot-leaders__item">
              <span class="pa-dot-leaders__label"><strong>Total</strong></span>
              <span class="pa-dot-leaders__leader"></span>
              <span class="pa-dot-leaders__value"><strong>14,775.00 CZK</strong></span>
            </div>
          </div>
        </.card>
      </.column>
    </.grid>

    <%!-- Property Cards --%>
    <.card title_text="Property Cards">
      <:description>Small stat cards showing key metrics at a glance</:description>
      <.grid>
        <.column size="100" md="1-4">
          <div class="pa-prop-card">
            <div class="pa-prop-card__label">Total Users</div>
            <div class="pa-prop-card__value">12,847</div>
          </div>
        </.column>
        <.column size="100" md="1-4">
          <div class="pa-prop-card">
            <div class="pa-prop-card__label">Active Sessions</div>
            <div class="pa-prop-card__value">1,024</div>
          </div>
        </.column>
        <.column size="100" md="1-4">
          <div class="pa-prop-card">
            <div class="pa-prop-card__label">Uptime</div>
            <div class="pa-prop-card__value">99.97%</div>
          </div>
        </.column>
        <.column size="100" md="1-4">
          <div class="pa-prop-card">
            <div class="pa-prop-card__label">Avg. Response</div>
            <div class="pa-prop-card__value">42 ms</div>
          </div>
        </.column>
      </.grid>
    </.card>

    <%!-- Banded Rows --%>
    <.card title_text="Banded Rows">
      <:description>Alternating background rows for improved readability</:description>
      <div class="pa-banded">
        <div class="pa-banded__row">
          <span class="pa-banded__label">Operating System</span>
          <span class="pa-banded__value">Ubuntu 24.04 LTS</span>
        </div>
        <div class="pa-banded__row">
          <span class="pa-banded__label">Kernel Version</span>
          <span class="pa-banded__value">6.8.0-45-generic</span>
        </div>
        <div class="pa-banded__row">
          <span class="pa-banded__label">Architecture</span>
          <span class="pa-banded__value">x86_64</span>
        </div>
        <div class="pa-banded__row">
          <span class="pa-banded__label">Hostname</span>
          <span class="pa-banded__value">app-server-01</span>
        </div>
        <div class="pa-banded__row">
          <span class="pa-banded__label">IP Address</span>
          <span class="pa-banded__value">192.168.1.42</span>
        </div>
        <div class="pa-banded__row">
          <span class="pa-banded__label">DNS</span>
          <span class="pa-banded__value">8.8.8.8, 8.8.4.4</span>
        </div>
        <div class="pa-banded__row">
          <span class="pa-banded__label">Timezone</span>
          <span class="pa-banded__value">Europe/Prague (CET)</span>
        </div>
        <div class="pa-banded__row">
          <span class="pa-banded__label">Last Boot</span>
          <span class="pa-banded__value">2026-03-10 06:00:00 UTC</span>
        </div>
      </div>
    </.card>
    """
  end
end
