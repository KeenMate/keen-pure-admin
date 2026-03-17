defmodule DemoWeb.Live.DataDisplayLive do
  use DemoWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, page_title: "Data Display")}
  end

  def render(assigns) do
    ~H"""
    <.paragraph>
      Read-only data display components for showing label-value pairs without form inputs. Useful for profile pages, detail views, order summaries, and anywhere you need to present structured data.
    </.paragraph>

    <%!-- ============================================================
         Row 1: Multiple pa-fields Blocks (50%) | Multi-Column Grid (50%)
         ============================================================ --%>

    <.grid>
      <.column size="1-2">
        <.card title_text="Multiple pa-fields Blocks">
          <:description>Consecutive <code>pa-fields</code> blocks get automatic spacing via <code>.pa-fields + .pa-fields</code>.</:description>

          <div class="pa-fields pa-fields--row">
            <div class="pa-field">
              <span class="pa-field__label">First Name</span>
              <span class="pa-field__value">Elena</span>
            </div>
            <div class="pa-field">
              <span class="pa-field__label">Last Name</span>
              <span class="pa-field__value">Petrova</span>
            </div>
          </div>
          <div class="pa-fields pa-fields--cols-2">
            <div class="pa-field">
              <span class="pa-field__label">Date of Birth</span>
              <span class="pa-field__value">14 March 1992</span>
            </div>
            <div class="pa-field">
              <span class="pa-field__label">Role</span>
              <span class="pa-field__value">Senior Developer</span>
            </div>
            <div class="pa-field">
              <span class="pa-field__label">Office</span>
              <span class="pa-field__value">Prague, Karlin</span>
            </div>
            <div class="pa-field">
              <span class="pa-field__label">Start Date</span>
              <span class="pa-field__value">1 Sep 2019</span>
            </div>
          </div>
          <div class="pa-fields">
            <div class="pa-field">
              <span class="pa-field__label">Notes</span>
              <span class="pa-field__value">Team lead for the frontend platform team. Available for mentoring.</span>
            </div>
          </div>
        </.card>
      </.column>

      <.column size="1-2">
        <.card title_text="Multi-Column Grid">
          <:description>Uses <code>pa-fields--cols-2/3/4</code>. Use <code>pa-field--full</code> to span all columns.</:description>

          <div class="pa-fields pa-fields--cols-2">
            <div class="pa-field">
              <span class="pa-field__label">Company</span>
              <span class="pa-field__value">Acme Logistics</span>
            </div>
            <div class="pa-field">
              <span class="pa-field__label">Reg. No.</span>
              <span class="pa-field__value">CZ27082440</span>
            </div>
            <div class="pa-field">
              <span class="pa-field__label">Contact</span>
              <span class="pa-field__value">Jan Kratochvil</span>
            </div>
            <div class="pa-field">
              <span class="pa-field__label">Phone</span>
              <span class="pa-field__value">+420 234 567 890</span>
            </div>
            <div class="pa-field pa-field--full">
              <span class="pa-field__label">Notes</span>
              <span class="pa-field__value">Preferred carrier for Central European routes.</span>
            </div>
          </div>
        </.card>
      </.column>
    </.grid>

    <%!-- ============================================================
         Row 2: Field Groups (100%)
         ============================================================ --%>

    <.card title_text="Field Groups">
      <:description>Labeled sections using <code>pa-field-group</code> with <code>pa-field-group__title</code>.</:description>

      <.grid>
        <.column size="1-3">
          <div class="pa-field-group">
            <div class="pa-field-group__title">Personal</div>
            <div class="pa-fields">
              <div class="pa-field">
                <span class="pa-field__label">Full Name</span>
                <span class="pa-field__value">Petra Konecna</span>
              </div>
              <div class="pa-field">
                <span class="pa-field__label">Date of Birth</span>
                <span class="pa-field__value">22 June 1990</span>
              </div>
            </div>
          </div>
        </.column>

        <.column size="1-3">
          <div class="pa-field-group">
            <div class="pa-field-group__title">Employment</div>
            <div class="pa-fields">
              <div class="pa-field">
                <span class="pa-field__label">Position</span>
                <span class="pa-field__value">Product Manager</span>
              </div>
              <div class="pa-field">
                <span class="pa-field__label">Department</span>
                <span class="pa-field__value">Product Dev</span>
              </div>
            </div>
          </div>
        </.column>

        <.column size="1-3">
          <div class="pa-field-group">
            <div class="pa-field-group__title">Emergency Contact</div>
            <div class="pa-fields">
              <div class="pa-field">
                <span class="pa-field__label">Name</span>
                <span class="pa-field__value">Martin Konecny</span>
              </div>
              <div class="pa-field">
                <span class="pa-field__label">Phone</span>
                <span class="pa-field__value">+420 777 888 999</span>
              </div>
            </div>
          </div>
        </.column>
      </.grid>
    </.card>

    <%!-- ============================================================
         Row 3: Horizontal (1/3) | Table-Style Bordered (1/3) | Striped (1/3)
         ============================================================ --%>

    <.grid>
      <.column size="1-3">
        <.card title_text="Horizontal">
          <:description>Uses <code>pa-fields--horizontal</code>.</:description>

          <div class="pa-fields pa-fields--horizontal">
            <div class="pa-field">
              <span class="pa-field__label">Company</span>
              <span class="pa-field__value">Acme Corp</span>
            </div>
            <div class="pa-field">
              <span class="pa-field__label">Reg. No.</span>
              <span class="pa-field__value">CZ12345678</span>
            </div>
            <div class="pa-field">
              <span class="pa-field__label">VAT ID</span>
              <span class="pa-field__value">CZ12345678</span>
            </div>
            <div class="pa-field">
              <span class="pa-field__label">Industry</span>
              <span class="pa-field__value">Software</span>
            </div>
          </div>
        </.card>
      </.column>

      <.column size="1-3">
        <.card title_text="Table-Style Bordered">
          <:description>Uses <code>pa-fields--table pa-fields--bordered</code>.</:description>

          <div class="pa-fields pa-fields--table pa-fields--bordered">
            <div class="pa-field">
              <span class="pa-field__label">Order ID</span>
              <span class="pa-field__value">#ORD-00847</span>
            </div>
            <div class="pa-field">
              <span class="pa-field__label">Status</span>
              <span class="pa-field__value"><.badge variant="success">Delivered</.badge></span>
            </div>
            <div class="pa-field">
              <span class="pa-field__label">Payment</span>
              <span class="pa-field__value">Visa *4242</span>
            </div>
            <div class="pa-field">
              <span class="pa-field__label">Total</span>
              <span class="pa-field__value"><strong>$1,249</strong></span>
            </div>
          </div>
        </.card>
      </.column>

      <.column size="1-3">
        <.card title_text="Striped">
          <:description>Uses <code>pa-fields--striped</code>.</:description>

          <div class="pa-fields pa-fields--striped">
            <div class="pa-field">
              <span class="pa-field__label">Server</span>
              <span class="pa-field__value">prod-api-01</span>
            </div>
            <div class="pa-field">
              <span class="pa-field__label">IP</span>
              <span class="pa-field__value">10.0.12.45</span>
            </div>
            <div class="pa-field">
              <span class="pa-field__label">OS</span>
              <span class="pa-field__value">Ubuntu 22.04</span>
            </div>
            <div class="pa-field">
              <span class="pa-field__label">Memory</span>
              <span class="pa-field__value">16 GB</span>
            </div>
          </div>
        </.card>
      </.column>
    </.grid>

    <%!-- ============================================================
         Row 4: Compact (25%) | Inline (25%) | Row (25%) | Relaxed (25%)
         ============================================================ --%>

    <.grid>
      <.column size="1-4">
        <.card title_text="Compact">
          <:description><code>pa-fields--compact</code></:description>

          <div class="pa-fields pa-fields--compact">
            <div class="pa-field">
              <span class="pa-field__label">Name</span>
              <span class="pa-field__value">Martin</span>
            </div>
            <div class="pa-field">
              <span class="pa-field__label">Role</span>
              <span class="pa-field__value">DevOps</span>
            </div>
            <div class="pa-field">
              <span class="pa-field__label">Team</span>
              <span class="pa-field__value">Infra</span>
            </div>
          </div>
        </.card>
      </.column>

      <.column size="1-4">
        <.card title_text="Inline">
          <:description><code>pa-fields--inline</code></:description>

          <div class="pa-fields pa-fields--inline">
            <div class="pa-field">
              <span class="pa-field__label">Browser</span>
              <span class="pa-field__value">Chrome</span>
            </div>
            <div class="pa-field">
              <span class="pa-field__label">OS</span>
              <span class="pa-field__value">Win 11</span>
            </div>
            <div class="pa-field">
              <span class="pa-field__label">Lang</span>
              <span class="pa-field__value">en-US</span>
            </div>
          </div>
        </.card>
      </.column>

      <.column size="1-4">
        <.card title_text="Row">
          <:description><code>pa-fields--row</code></:description>

          <div class="pa-fields pa-fields--row">
            <div class="pa-field">
              <span class="pa-field__label">Width</span>
              <span class="pa-field__value">120cm</span>
            </div>
            <div class="pa-field">
              <span class="pa-field__label">Height</span>
              <span class="pa-field__value">80cm</span>
            </div>
            <div class="pa-field">
              <span class="pa-field__label">Depth</span>
              <span class="pa-field__value">60cm</span>
            </div>
          </div>
        </.card>
      </.column>

      <.column size="1-4">
        <.card title_text="Relaxed">
          <:description><code>pa-fields--relaxed</code></:description>

          <div class="pa-fields pa-fields--relaxed">
            <div class="pa-field">
              <span class="pa-field__label">Name</span>
              <span class="pa-field__value">Elena</span>
            </div>
            <div class="pa-field">
              <span class="pa-field__label">Role</span>
              <span class="pa-field__value">Developer</span>
            </div>
          </div>
        </.card>
      </.column>
    </.grid>

    <%!-- ============================================================
         Row 5: Filled Fields (75%) | Form vs Display (25%)
         ============================================================ --%>

    <.grid>
      <.column size="3-4">
        <.card title_text="Filled Fields">
          <:description>Subtle background to distinguish data blocks. Uses <code>pa-fields--filled</code>.</:description>

          <.grid>
            <.column size="1-2">
              <div class="pa-fields pa-fields--filled">
                <div class="pa-field">
                  <span class="pa-field__label">Contract No.</span>
                  <span class="pa-field__value">CTR-2025-00194</span>
                </div>
                <div class="pa-field">
                  <span class="pa-field__label">Type</span>
                  <span class="pa-field__value">Framework Agreement</span>
                </div>
                <div class="pa-field">
                  <span class="pa-field__label">Status</span>
                  <span class="pa-field__value"><.badge variant="success">Active</.badge></span>
                </div>
              </div>
            </.column>
            <.column size="1-2">
              <div class="pa-fields pa-fields--filled pa-fields--row">
                <div class="pa-field">
                  <span class="pa-field__label">Plan</span>
                  <span class="pa-field__value">Enterprise</span>
                </div>
                <div class="pa-field">
                  <span class="pa-field__label">Renewal</span>
                  <span class="pa-field__value">1 Jan 2027</span>
                </div>
                <div class="pa-field">
                  <span class="pa-field__label">Seats</span>
                  <span class="pa-field__value">48 / 50</span>
                </div>
              </div>
            </.column>
          </.grid>
        </.card>
      </.column>

      <.column size="1-4">
        <.card title_text="Form vs Display">
          <h4>Edit</h4>
          <.form_group>
            <.form_label>Name</.form_label>
            <.input type="text" value="Tomas" />
          </.form_group>
          <h4>View</h4>
          <div class="pa-fields">
            <div class="pa-field">
              <span class="pa-field__label">Name</span>
              <span class="pa-field__value">Tomas</span>
            </div>
          </div>
        </.card>
      </.column>
    </.grid>

    <%!-- ============================================================
         Row 6: Color Variants (100%)
         ============================================================ --%>

    <.card title_text="Color Variants">
      <:description>Theme colors for border and filled background. Uses <code>pa-fields--color-{1-9}</code>. Combine with <code>pa-fields--filled</code> for tinted backgrounds. Use <code>pa-fields--no-border</code> to remove the border.</:description>

      <h4>Border Colors</h4>
      <.grid>
        <.column size="1-3">
          <div class="pa-fields pa-fields--color-1">
            <div class="pa-field">
              <span class="pa-field__label">Color 1</span>
              <span class="pa-field__value">Red / Primary</span>
            </div>
          </div>
        </.column>
        <.column size="1-3">
          <div class="pa-fields pa-fields--color-4">
            <div class="pa-field">
              <span class="pa-field__label">Color 4</span>
              <span class="pa-field__value">Green / Success</span>
            </div>
          </div>
        </.column>
        <.column size="1-3">
          <div class="pa-fields pa-fields--color-7">
            <div class="pa-field">
              <span class="pa-field__label">Color 7</span>
              <span class="pa-field__value">Blue / Info</span>
            </div>
          </div>
        </.column>
      </.grid>

      <h4 class="mt-4">Filled + Color (Tinted Background)</h4>
      <.grid>
        <.column size="1-3">
          <div class="pa-fields pa-fields--filled pa-fields--color-1">
            <div class="pa-field">
              <span class="pa-field__label">Status</span>
              <span class="pa-field__value"><.badge variant="danger">Error</.badge></span>
            </div>
            <div class="pa-field">
              <span class="pa-field__label">Message</span>
              <span class="pa-field__value">Connection failed</span>
            </div>
          </div>
        </.column>
        <.column size="1-3">
          <div class="pa-fields pa-fields--filled pa-fields--color-4">
            <div class="pa-field">
              <span class="pa-field__label">Status</span>
              <span class="pa-field__value"><.badge variant="success">Success</.badge></span>
            </div>
            <div class="pa-field">
              <span class="pa-field__label">Message</span>
              <span class="pa-field__value">Order completed</span>
            </div>
          </div>
        </.column>
        <.column size="1-3">
          <div class="pa-fields pa-fields--filled pa-fields--color-3">
            <div class="pa-field">
              <span class="pa-field__label">Status</span>
              <span class="pa-field__value"><.badge variant="warning">Warning</.badge></span>
            </div>
            <div class="pa-field">
              <span class="pa-field__label">Message</span>
              <span class="pa-field__value">Low inventory</span>
            </div>
          </div>
        </.column>
      </.grid>

      <h4 class="mt-4">No Border</h4>
      <.grid>
        <.column size="1-2">
          <div class="pa-fields pa-fields--no-border">
            <div class="pa-field">
              <span class="pa-field__label">Name</span>
              <span class="pa-field__value">Elena Petrova</span>
            </div>
            <div class="pa-field">
              <span class="pa-field__label">Email</span>
              <span class="pa-field__value">elena@acme.com</span>
            </div>
          </div>
        </.column>
        <.column size="1-2">
          <div class="pa-fields pa-fields--filled pa-fields--no-border">
            <div class="pa-field">
              <span class="pa-field__label">Name</span>
              <span class="pa-field__value">Elena Petrova</span>
            </div>
            <div class="pa-field">
              <span class="pa-field__label">Email</span>
              <span class="pa-field__value">elena@acme.com</span>
            </div>
          </div>
        </.column>
      </.grid>
    </.card>

    <%!-- ============================================================
         Row 7: Copyable Fields (100%)
         ============================================================ --%>

    <.card title_text="Copyable Fields">
      <:description>Three styles for copy-to-clipboard functionality. Click to test each variant.</:description>

      <.grid>
        <.column size="1-3">
          <h4>Copy Button (always visible)</h4>
          <p class="text-secondary mb-2">Uses <code>pa-field--copy-btn</code></p>
          <div class="pa-fields pa-fields--no-border">
            <div class="pa-field pa-field--copy-btn">
              <span class="pa-field__label">Email</span>
              <span class="pa-field__value">
                <span data-copy-value>elena.petrova@example.com</span>
                <button class="pa-field__copy" onclick="copyValue(this)" title="Copy to clipboard">
                  <i class="fas fa-copy"></i>
                </button>
              </span>
            </div>
            <div class="pa-field pa-field--copy-btn">
              <span class="pa-field__label">API Key</span>
              <span class="pa-field__value">
                <span data-copy-value><code>sk_live_abc123xyz789</code></span>
                <button class="pa-field__copy" onclick="copyValue(this)" title="Copy to clipboard">
                  <i class="fas fa-copy"></i>
                </button>
              </span>
            </div>
          </div>
        </.column>
        <.column size="1-3">
          <h4>Click Value to Copy</h4>
          <p class="text-secondary mb-2">Uses <code>pa-field--copy-click</code></p>
          <div class="pa-fields pa-fields--no-border">
            <div class="pa-field pa-field--copy-click">
              <span class="pa-field__label">Phone</span>
              <span class="pa-field__value" onclick="copyClickValue(this)" data-copy-value="+420 776 123 456">+420 776 123 456</span>
            </div>
            <div class="pa-field pa-field--copy-click">
              <span class="pa-field__label">Order ID</span>
              <span class="pa-field__value" onclick="copyClickValue(this)" data-copy-value="ORD-2026-00847">#ORD-2026-00847</span>
            </div>
          </div>
        </.column>
        <.column size="1-3">
          <h4>Icon on Hover Only</h4>
          <p class="text-secondary mb-2">Uses <code>pa-field--copy-hover</code></p>
          <div class="pa-fields pa-fields--no-border">
            <div class="pa-field pa-field--copy-hover">
              <span class="pa-field__label">IBAN</span>
              <span class="pa-field__value">
                <span data-copy-value>CZ65 0800 0000 1920 0014 5399</span>
                <button class="pa-field__copy" onclick="copyValue(this)" title="Copy to clipboard">
                  <i class="fas fa-copy"></i>
                </button>
              </span>
            </div>
            <div class="pa-field pa-field--copy-hover">
              <span class="pa-field__label">BIC/SWIFT</span>
              <span class="pa-field__value">
                <span data-copy-value>GIBACZPX</span>
                <button class="pa-field__copy" onclick="copyValue(this)" title="Copy to clipboard">
                  <i class="fas fa-copy"></i>
                </button>
              </span>
            </div>
          </div>
        </.column>
      </.grid>
    </.card>

    <script>
    function copyValue(btn) {
        const field = btn.closest('.pa-field');
        const valueEl = field.querySelector('[data-copy-value]');
        const text = valueEl.getAttribute('data-copy-value') || valueEl.textContent.trim();

        navigator.clipboard.writeText(text).then(() => {
            // Visual feedback
            const originalIcon = btn.innerHTML;
            btn.innerHTML = '<i class="fas fa-check"></i>';
            btn.style.color = 'var(--pa-color-4, #28a745)';

            setTimeout(() => {
                btn.innerHTML = originalIcon;
                btn.style.color = '';
            }, 1500);
        });
    }

    function copyClickValue(el) {
        const text = el.getAttribute('data-copy-value') || el.textContent.trim();
        const field = el.closest('.pa-field');

        navigator.clipboard.writeText(text).then(() => {
            // Visual feedback
            field.classList.add('pa-field--copied');

            setTimeout(() => {
                field.classList.remove('pa-field--copied');
            }, 1500);
        });
    }
    </script>

    <%!-- ============================================================
         Row 8: Invoice Layout (100%)
         ============================================================ --%>

    <.card title_text="Real-World: Invoice Layout">
      <:description>Customer (full width) + Receipt/Delivery addresses (50/50). Combines <code>pa-field-group</code> with <code>pa-row</code>/<code>pa-col-*</code>.</:description>

      <div class="pa-field-group">
        <div class="pa-field-group__title">Customer</div>
        <div class="pa-fields pa-fields--cols-3">
          <div class="pa-field">
            <span class="pa-field__label">Name</span>
            <span class="pa-field__value">Novak &amp; Partners s.r.o.</span>
          </div>
          <div class="pa-field">
            <span class="pa-field__label">Registration No.</span>
            <span class="pa-field__value">CZ48207497</span>
          </div>
          <div class="pa-field">
            <span class="pa-field__label">VAT ID</span>
            <span class="pa-field__value">CZ48207497</span>
          </div>
          <div class="pa-field">
            <span class="pa-field__label">Contact</span>
            <span class="pa-field__value">Jan Novak</span>
          </div>
          <div class="pa-field">
            <span class="pa-field__label">Email</span>
            <span class="pa-field__value">jan.novak@novakpartners.cz</span>
          </div>
          <div class="pa-field">
            <span class="pa-field__label">Phone</span>
            <span class="pa-field__value">+420 234 111 222</span>
          </div>
        </div>
      </div>

      <.grid style="margin-top: 2.4rem;">
        <.column size="1-2">
          <div class="pa-field-group">
            <div class="pa-field-group__title">Receipt Address</div>
            <div class="pa-fields pa-fields--filled">
              <div class="pa-field">
                <span class="pa-field__label">Street</span>
                <span class="pa-field__value">Vinohradska 2468/164</span>
              </div>
              <div class="pa-field">
                <span class="pa-field__label">City</span>
                <span class="pa-field__value">Prague 3, 130 00</span>
              </div>
              <div class="pa-field">
                <span class="pa-field__label">Country</span>
                <span class="pa-field__value">Czech Republic</span>
              </div>
            </div>
          </div>
        </.column>
        <.column size="1-2">
          <div class="pa-field-group">
            <div class="pa-field-group__title">Delivery Address</div>
            <div class="pa-fields pa-fields--filled">
              <div class="pa-field">
                <span class="pa-field__label">Street</span>
                <span class="pa-field__value">Prumyslova 1234/5</span>
              </div>
              <div class="pa-field">
                <span class="pa-field__label">City</span>
                <span class="pa-field__value">Brno-Slatina, 627 00</span>
              </div>
              <div class="pa-field">
                <span class="pa-field__label">Country</span>
                <span class="pa-field__value">Czech Republic</span>
              </div>
            </div>
          </div>
        </.column>
      </.grid>

      <div class="pa-field-group" style="margin-top: 2.4rem;">
        <div class="pa-field-group__title">Items</div>
        <table class="pa-table pa-table--hover pa-table--striped">
          <thead>
            <tr>
              <th>Product</th>
              <th>SKU</th>
              <th style="text-align: right;">Qty</th>
              <th style="text-align: right;">Price</th>
              <th style="text-align: right;">Total</th>
            </tr>
          </thead>
          <tbody>
            <tr>
              <td>Mechanical Keyboard</td>
              <td>KB-MX-BRN</td>
              <td style="text-align: right;">2</td>
              <td style="text-align: right;">$149</td>
              <td style="text-align: right;">$298</td>
            </tr>
            <tr>
              <td>27" 4K Monitor</td>
              <td>MON-27-4K</td>
              <td style="text-align: right;">4</td>
              <td style="text-align: right;">$449</td>
              <td style="text-align: right;">$1,796</td>
            </tr>
          </tbody>
        </table>
      </div>

      <div class="pa-fields pa-fields--horizontal" style="max-width: 25rem; margin-left: auto; margin-top: 1.2rem;">
        <div class="pa-field">
          <span class="pa-field__label">Subtotal</span>
          <span class="pa-field__value" style="text-align: right;">$2,094</span>
        </div>
        <div class="pa-field">
          <span class="pa-field__label">VAT 21%</span>
          <span class="pa-field__value" style="text-align: right;">$439.74</span>
        </div>
        <div class="pa-field" style="border-top: 1px solid; padding-top: 0.8rem;">
          <span class="pa-field__label" style="font-weight: 700;">Total</span>
          <span class="pa-field__value" style="text-align: right; font-weight: 700; font-size: 1.6rem;">$2,533.74</span>
        </div>
      </div>
    </.card>

    <%!-- ============================================================
         User Profile (1/3) | CSS Reference (2/3)
         ============================================================ --%>

    <.grid>
      <.column size="1-3">
        <.card title_text="User Profile">
          <div style="text-align: center; margin-bottom: 1.6rem;">
            <div style="width: 64px; height: 64px; border-radius: 50%; background: linear-gradient(135deg, #667eea, #764ba2); margin: 0 auto 0.8rem; display: flex; align-items: center; justify-content: center; color: #fff; font-size: 2rem; font-weight: 600;">EP</div>
            <strong>Elena Petrova</strong><br>
            <.badge variant="success">Active</.badge>
          </div>
          <div class="pa-field-group">
            <div class="pa-field-group__title">Contact</div>
            <div class="pa-fields pa-fields--compact">
              <div class="pa-field">
                <span class="pa-field__label">Email</span>
                <span class="pa-field__value">elena@acme.com</span>
              </div>
              <div class="pa-field">
                <span class="pa-field__label">Phone</span>
                <span class="pa-field__value">+420 776 123 456</span>
              </div>
            </div>
          </div>
          <div class="pa-field-group">
            <div class="pa-field-group__title">Skills</div>
            <div class="pa-fields">
              <div class="pa-field">
                <span class="pa-field__value">
                  <.badge>TypeScript</.badge>
                  <.badge>React</.badge>
                  <.badge>Node.js</.badge>
                </span>
              </div>
            </div>
          </div>
        </.card>
      </.column>

      <.column size="2-3">
        <.card title_text="CSS Classes Reference">
          <.grid>
            <.column size="1-2">
              <h4>Field Elements</h4>
              <ul class="pa-list-basic pa-list-basic--compact">
                <li><code>pa-field</code> - Label-value pair</li>
                <li><code>pa-field__label</code> - Label element</li>
                <li><code>pa-field__value</code> - Value element</li>
                <li><code>pa-field--full</code> - Span all grid columns</li>
              </ul>

              <h4 class="mt-4">Container &amp; Groups</h4>
              <ul class="pa-list-basic pa-list-basic--compact">
                <li><code>pa-fields</code> - Field container</li>
                <li><code>pa-field-group</code> - Section wrapper</li>
                <li><code>pa-field-group__title</code> - Section title</li>
              </ul>

              <h4 class="mt-4">Grid Columns</h4>
              <ul class="pa-list-basic pa-list-basic--compact">
                <li><code>pa-fields--cols-2</code> - 2 columns</li>
                <li><code>pa-fields--cols-3</code> - 3 columns</li>
                <li><code>pa-fields--cols-4</code> - 4 columns</li>
              </ul>
            </.column>
            <.column size="1-2">
              <h4>Layout Modifiers</h4>
              <ul class="pa-list-basic pa-list-basic--compact">
                <li><code>pa-fields--horizontal</code> - Label left, value right</li>
                <li><code>pa-fields--table</code> - Table-like widths</li>
                <li><code>pa-fields--bordered</code> - Row separators</li>
                <li><code>pa-fields--striped</code> - Alternating bg</li>
                <li><code>pa-fields--compact</code> - Tighter spacing</li>
                <li><code>pa-fields--relaxed</code> - Larger spacing</li>
                <li><code>pa-fields--inline</code> - Inline flow</li>
                <li><code>pa-fields--row</code> - Equal-width columns</li>
                <li><code>pa-fields--filled</code> - Background panel</li>
                <li><code>pa-fields--color-{1-9}</code> - Border color</li>
                <li><code>pa-fields--no-border</code> - Remove border</li>
              </ul>

              <h4 class="mt-4">Combining</h4>
              <ul class="pa-list-basic pa-list-basic--compact">
                <li><code>--table --bordered</code></li>
                <li><code>--horizontal --compact</code></li>
                <li><code>--filled --cols-2</code></li>
                <li><code>--filled --color-1</code> (tinted bg)</li>
              </ul>
            </.column>
          </.grid>
        </.card>
      </.column>
    </.grid>
    """
  end
end
