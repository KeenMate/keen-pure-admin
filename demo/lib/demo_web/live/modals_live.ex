defmodule DemoWeb.Live.ModalsLive do
  use DemoWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, page_title: "Modals")}
  end

  def render(assigns) do
    ~H"""
    <h1 class="pa-page-title">Modals</h1>
    <p class="pa-page-subtitle">Dialog windows for focused content and user interactions.</p>

    <%!-- Standard Sizes --%>
    <.card title_text="Standard Sizes">
      <div style="display: flex; gap: 8px; flex-wrap: wrap;">
        <.button variant="primary" phx-click={show_modal("modal-sm")}>Small</.button>
        <.button variant="primary" phx-click={show_modal("modal-md")}>Medium</.button>
        <.button variant="primary" phx-click={show_modal("modal-lg")}>Large</.button>
        <.button variant="primary" phx-click={show_modal("modal-xl")}>XL</.button>
        <.button variant="primary" phx-click={show_modal("modal-xxl")}>XXL</.button>
        <.button variant="primary" phx-click={show_modal("modal-fw")}>Full Width</.button>
      </div>
    </.card>

    <%!-- Modal Types --%>
    <.card title_text="Modal Types">
      <div style="display: flex; gap: 8px; flex-wrap: wrap;">
        <.button variant="success" phx-click={show_modal("modal-success")}>Success</.button>
        <.button variant="warning" phx-click={show_modal("modal-warning")}>Warning</.button>
        <.button variant="danger" phx-click={show_modal("modal-danger")}>Danger</.button>
      </div>
    </.card>

    <%!-- Position and Behavior --%>
    <.grid>
      <.column size="50">
        <.card title_text="Position Modifiers">
          <div style="display: flex; gap: 8px;">
            <.button variant="secondary" phx-click={show_modal("modal-md")}>
              Centered (Default)
            </.button>
            <.button variant="secondary" phx-click={show_modal("modal-top")}>Top-Aligned</.button>
          </div>
        </.card>
      </.column>
      <.column size="50">
        <.card title_text="Behavior Modifiers">
          <div style="display: flex; gap: 8px;">
            <.button variant="secondary" phx-click={show_modal("modal-static")}>Static Modal</.button>
            <.button variant="secondary" phx-click={show_modal("modal-scroll")}>
              Scrollable Body
            </.button>
          </div>
        </.card>
      </.column>
    </.grid>

    <%!-- Form Modals --%>
    <.card title_text="Form Modals">
      <div style="display: flex; gap: 8px; flex-wrap: wrap;">
        <.button variant="primary" phx-click={show_modal("modal-contact")}>Contact Form</.button>
        <.button variant="primary" phx-click={show_modal("modal-login")}>Login Form</.button>
      </div>
    </.card>

    <%!-- Confirmation Modals --%>
    <.card title_text="Confirmation Modals">
      <div style="display: flex; gap: 8px; flex-wrap: wrap;">
        <.button variant="danger" is_outline phx-click={show_modal("modal-delete")}>
          Delete Confirmation
        </.button>
        <.button variant="warning" is_outline phx-click={show_modal("modal-confirm")}>
          Action Confirmation
        </.button>
        <.button variant="info" is_outline phx-click={show_modal("modal-info")}>
          Information Dialog
        </.button>
      </div>
    </.card>

    <%!-- Modal Definitions --%>
    <.modal id="modal-sm" size="sm" title_text="Small Modal">
      <p>This is a small modal window for simple notifications and confirmations.</p>
      <:footer>
        <.button variant="secondary" phx-click={hide_modal("modal-sm")}>Close</.button>
      </:footer>
    </.modal>

    <.modal id="modal-md" title_text="Medium Modal">
      <p>This is a medium-sized modal, the default size. It works well for most content types.</p>
      <p>You can include multiple paragraphs, lists, and other content elements here.</p>
      <:footer>
        <.button variant="secondary" phx-click={hide_modal("modal-md")}>Close</.button>
        <.button variant="primary" phx-click={hide_modal("modal-md")}>Save Changes</.button>
      </:footer>
    </.modal>

    <.modal id="modal-lg" size="lg" title_text="Large Modal">
      <.grid>
        <.column size="50">
          <h4>Left Column</h4>
          <p>
            Large modals are great for complex layouts that need more space, such as forms with many fields or detailed content.
          </p>
        </.column>
        <.column size="50">
          <h4>Right Column</h4>
          <p>You can use the grid system inside modals for multi-column layouts.</p>
          <.alert variant="info">This is an alert inside a modal.</.alert>
        </.column>
      </.grid>
      <:footer>
        <.button variant="secondary" phx-click={hide_modal("modal-lg")}>Close</.button>
      </:footer>
    </.modal>

    <.modal id="modal-xl" size="xl" title_text="Extra Large Modal">
      <.grid>
        <.column size="1-3">
          <.card>Column 1</.card>
        </.column>
        <.column size="1-3">
          <.card>Column 2</.card>
        </.column>
        <.column size="1-3">
          <.card>Column 3</.card>
        </.column>
      </.grid>
      <:footer>
        <.button variant="secondary" phx-click={hide_modal("modal-xl")}>Close</.button>
      </:footer>
    </.modal>

    <.modal id="modal-xxl" size="xxl" title_text="XXL Modal">
      <p>XXL modals provide extensive space for complex interfaces.</p>
      <.grid>
        <.column size="25">
          <.card>Section 1</.card>
        </.column>
        <.column size="25">
          <.card>Section 2</.card>
        </.column>
        <.column size="25">
          <.card>Section 3</.card>
        </.column>
        <.column size="25">
          <.card>Section 4</.card>
        </.column>
      </.grid>
      <:footer>
        <.button variant="secondary" phx-click={hide_modal("modal-xxl")}>Close</.button>
      </:footer>
    </.modal>

    <.modal id="modal-fw" size="fw" title_text="Full Width Modal">
      <p>Full-width modals span the entire viewport width for maximum content area.</p>
      <:footer>
        <.button variant="secondary" phx-click={hide_modal("modal-fw")}>Close</.button>
      </:footer>
    </.modal>

    <.modal id="modal-success" variant="success" header_variant="success" title_text="Success">
      <p>
        <i class="fa-solid fa-circle-check" style="color: var(--pa-success);"></i>
        Operation completed successfully!
      </p>
      <:footer>
        <.button variant="success" phx-click={hide_modal("modal-success")}>Great!</.button>
      </:footer>
    </.modal>

    <.modal id="modal-warning" variant="warning" header_variant="warning" title_text="Warning">
      <p>
        <i class="fa-solid fa-triangle-exclamation" style="color: var(--pa-warning);"></i>
        Please proceed with caution. This action may have consequences.
      </p>
      <:footer>
        <.button variant="secondary" phx-click={hide_modal("modal-warning")}>Cancel</.button>
        <.button variant="warning" phx-click={hide_modal("modal-warning")}>Continue</.button>
      </:footer>
    </.modal>

    <.modal id="modal-danger" variant="danger" header_variant="danger" title_text="Danger">
      <p>
        <i class="fa-solid fa-circle-exclamation" style="color: var(--pa-danger);"></i>
        This is a destructive action that cannot be undone.
      </p>
      <:footer>
        <.button variant="secondary" phx-click={hide_modal("modal-danger")}>Cancel</.button>
        <.button variant="danger" phx-click={hide_modal("modal-danger")}>Delete</.button>
      </:footer>
    </.modal>

    <.modal id="modal-top" is_top title_text="Top-Aligned Modal">
      <p>This modal is aligned to the top of the viewport instead of being centered vertically.</p>
      <:footer>
        <.button variant="secondary" phx-click={hide_modal("modal-top")}>Close</.button>
      </:footer>
    </.modal>

    <.modal id="modal-static" is_static variant="warning" title_text="Static Modal">
      <p>
        This modal cannot be closed by clicking the backdrop or pressing ESC. You must use the close button.
      </p>
      <:footer>
        <.button variant="primary" phx-click={hide_modal("modal-static")}>I Understand</.button>
      </:footer>
    </.modal>

    <.modal id="modal-scroll" size="lg" is_scrollable title_text="Scrollable Modal">
      <p>This modal has a scrollable body for long content.</p>
      <%= for i <- 1..15 do %>
        <p>
          Paragraph {i}: Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.
        </p>
      <% end %>
      <:footer>
        <.button variant="secondary" phx-click={hide_modal("modal-scroll")}>Close</.button>
      </:footer>
    </.modal>

    <.modal id="modal-contact" title_text="Contact Form">
      <.form_group label="Name">
        <.input type="text" placeholder="Your name" />
      </.form_group>
      <.form_group label="Email">
        <.input type="email" placeholder="your@email.com" />
      </.form_group>
      <.form_group label="Message">
        <.textarea placeholder="Your message..." rows="4" />
      </.form_group>
      <:footer>
        <.button variant="secondary" phx-click={hide_modal("modal-contact")}>Cancel</.button>
        <.button variant="primary" phx-click={hide_modal("modal-contact")}>Send Message</.button>
      </:footer>
    </.modal>

    <.modal id="modal-login" size="sm" title_text="Login">
      <.form_group label="Username">
        <.input type="text" placeholder="Username" />
      </.form_group>
      <.form_group label="Password">
        <.input type="password" placeholder="Password" />
      </.form_group>
      <.checkbox label="Remember me" />
      <:footer>
        <.button variant="primary" is_block phx-click={hide_modal("modal-login")}>Sign In</.button>
      </:footer>
    </.modal>

    <.modal id="modal-delete" size="sm" variant="danger" title_text="Delete Confirmation">
      <.alert variant="danger">
        <:icon><i class="fa-solid fa-triangle-exclamation"></i></:icon>
        This action cannot be undone.
      </.alert>
      <p>
        Are you sure you want to delete this item? All associated data will be permanently removed.
      </p>
      <:footer>
        <.button variant="secondary" phx-click={hide_modal("modal-delete")}>Cancel</.button>
        <.button variant="danger" phx-click={hide_modal("modal-delete")}>Delete</.button>
      </:footer>
    </.modal>

    <.modal id="modal-confirm" size="sm" title_text="Confirm Action">
      <p>Are you sure you want to proceed with this action?</p>
      <p>This will apply changes to all selected items.</p>
      <:footer>
        <.button variant="secondary" phx-click={hide_modal("modal-confirm")}>Cancel</.button>
        <.button variant="primary" phx-click={hide_modal("modal-confirm")}>Confirm</.button>
      </:footer>
    </.modal>

    <.modal id="modal-info" variant="info" title_text="Information">
      <p>Your subscription will expire in 7 days. Please renew to continue using all features:</p>
      <ul style="margin: 12px 0; padding-left: 20px;">
        <li>Unlimited projects</li>
        <li>Priority support</li>
        <li>Advanced analytics</li>
      </ul>
      <:footer>
        <.button variant="secondary" phx-click={hide_modal("modal-info")}>Later</.button>
        <.button variant="info" phx-click={hide_modal("modal-info")}>Renew Now</.button>
      </:footer>
    </.modal>
    """
  end
end
