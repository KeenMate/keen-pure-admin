defmodule DemoWeb.Live.DetailPanelLive do
  use DemoWeb, :live_view

  @users [
    %{id: 1, name: "John Doe", email: "john.doe@company.com", role: "Senior Developer", department: "Engineering", status: "Active", phone: "+420 777 123 456", start_date: "2019-03-15", location: "Prague"},
    %{id: 2, name: "Jane Smith", email: "jane.smith@company.com", role: "Product Manager", department: "Product", status: "Active", phone: "+420 777 234 567", start_date: "2020-06-01", location: "Brno"},
    %{id: 3, name: "Bob Wilson", email: "bob.wilson@company.com", role: "UX Designer", department: "Design", status: "On Leave", phone: "+420 777 345 678", start_date: "2021-01-10", location: "Prague"},
    %{id: 4, name: "Alice Brown", email: "alice.brown@company.com", role: "DevOps Engineer", department: "Engineering", status: "Active", phone: "+420 777 456 789", start_date: "2018-09-20", location: "Remote"},
    %{id: 5, name: "Charlie Davis", email: "charlie.davis@company.com", role: "QA Lead", department: "Quality", status: "Active", phone: "+420 777 567 890", start_date: "2022-04-05", location: "Prague"}
  ]

  def mount(_params, _session, socket) do
    {:ok, assign(socket,
      page_title: "Detail Panel",
      users: @users,
      selected_user: nil,
      panel_mode: "inline"
    )}
  end

  def handle_event("select_user", %{"id" => id}, socket) do
    user = Enum.find(socket.assigns.users, &(&1.id == String.to_integer(id)))
    {:noreply, assign(socket, :selected_user, user)}
  end

  def handle_event("close_panel", _params, socket) do
    {:noreply, assign(socket, :selected_user, nil)}
  end

  def handle_event("set_mode", %{"mode" => mode}, socket) do
    {:noreply, assign(socket, panel_mode: mode, selected_user: nil)}
  end

  def render(assigns) do
    ~H"""
    <.paragraph>
      Detail panels display row details alongside a table. Supports inline split-view, card overlay, and full overlay modes.
    </.paragraph>

    <%!-- Mode Selector --%>
    <.card title_text="Panel Mode">
      <.button_group>
        <.button
          variant={if @panel_mode == "inline", do: "primary", else: "secondary"}
          phx-click="set_mode"
          phx-value-mode="inline"
        >
          <i class="fa-solid fa-columns me-1"></i> Inline Split-View
        </.button>
        <.button
          variant={if @panel_mode == "card-overlay", do: "primary", else: "secondary"}
          phx-click="set_mode"
          phx-value-mode="card-overlay"
        >
          <i class="fa-solid fa-clone me-1"></i> Card Overlay
        </.button>
        <.button
          variant={if @panel_mode == "overlay", do: "primary", else: "secondary"}
          phx-click="set_mode"
          phx-value-mode="overlay"
        >
          <i class="fa-solid fa-layer-group me-1"></i> Overlay
        </.button>
      </.button_group>
    </.card>

    <%!-- Inline Split-View --%>
    <.card :if={@panel_mode == "inline"} title_text="Inline Split-View" subtitle_text="Click a row to open the detail panel alongside the table. The table shrinks to make room." has_padding={false}>
      <div class="pa-detail-view">
        <div class="pa-detail-view__main">
          <.users_table users={@users} selected_user={@selected_user} />
        </div>
        <div class={"pa-detail-view__panel #{if @selected_user, do: "pa-detail-view__panel--open"}"}>
          <.detail_panel :if={@selected_user} user={@selected_user} />
        </div>
      </div>
    </.card>

    <%!-- Card Overlay Mode --%>
    <.card :if={@panel_mode == "card-overlay"} title_text="Card Overlay" subtitle_text="Panel overlays the table within the card with a backdrop." has_padding={false}>
      <div class="pa-detail-view pa-detail-view--overlay">
        <div
          class={"pa-detail-view__overlay #{if @selected_user, do: "pa-detail-view__overlay--visible"}"}
          phx-click="close_panel"
        />
        <div class="pa-detail-view__main">
          <.users_table users={@users} selected_user={@selected_user} />
        </div>
        <div class={"pa-detail-view__panel #{if @selected_user, do: "pa-detail-view__panel--open"}"}>
          <.detail_panel :if={@selected_user} user={@selected_user} />
        </div>
      </div>
    </.card>

    <%!-- Overlay Mode --%>
    <%= if @panel_mode == "overlay" do %>
      <.card title_text="Overlay Mode" subtitle_text="Click a row to open an overlay panel that slides in from the right.">
        <.users_table users={@users} selected_user={@selected_user} />
      </.card>

      <div class={"pa-detail-panel--overlay #{if @selected_user, do: "pa-detail-panel--overlay--open"}"}>
        <div class="pa-detail-panel__overlay" phx-click="close_panel" />
        <.detail_panel :if={@selected_user} user={@selected_user} />
      </div>
    <% end %>
    """
  end

  defp users_table(assigns) do
    ~H"""
    <table class="pa-table pa-table--hover pa-table--striped">
      <thead>
        <tr>
          <th>Name</th>
          <th>Email</th>
          <th>Role</th>
          <th>Department</th>
          <th>Status</th>
        </tr>
      </thead>
      <tbody>
        <tr
          :for={user <- @users}
          phx-click="select_user"
          phx-value-id={user.id}
          class={if @selected_user && @selected_user.id == user.id, do: "is-selected"}
          style="cursor: pointer;"
        >
          <td>{user.name}</td>
          <td>{user.email}</td>
          <td>{user.role}</td>
          <td>{user.department}</td>
          <td>
            <.badge variant={status_variant(user.status)} size="sm">
              {user.status}
            </.badge>
          </td>
        </tr>
      </tbody>
    </table>
    """
  end

  defp detail_panel(assigns) do
    ~H"""
    <div class="pa-detail-panel__content">
      <div class="pa-detail-panel__header">
        <h4 class="pa-detail-panel__title">{@user.name}</h4>
        <button class="pa-detail-panel__close" phx-click="close_panel" aria-label="Close panel">
          <i class="fa-solid fa-xmark"></i>
        </button>
      </div>
      <div class="pa-detail-panel__body">
        <div class="pa-field-group">
          <div class="pa-field-group__title">Personal</div>
          <div class="pa-fields pa-fields--cols-2">
            <div class="pa-field">
              <span class="pa-field__label">Name</span>
              <span class="pa-field__value">{@user.name}</span>
            </div>
            <div class="pa-field">
              <span class="pa-field__label">Email</span>
              <span class="pa-field__value">{@user.email}</span>
            </div>
            <div class="pa-field">
              <span class="pa-field__label">Phone</span>
              <span class="pa-field__value">{@user.phone}</span>
            </div>
            <div class="pa-field">
              <span class="pa-field__label">Location</span>
              <span class="pa-field__value">{@user.location}</span>
            </div>
          </div>
        </div>

        <div class="pa-field-group">
          <div class="pa-field-group__title">Employment</div>
          <div class="pa-fields pa-fields--cols-2">
            <div class="pa-field">
              <span class="pa-field__label">Role</span>
              <span class="pa-field__value">{@user.role}</span>
            </div>
            <div class="pa-field">
              <span class="pa-field__label">Department</span>
              <span class="pa-field__value">{@user.department}</span>
            </div>
            <div class="pa-field">
              <span class="pa-field__label">Start Date</span>
              <span class="pa-field__value">{@user.start_date}</span>
            </div>
            <div class="pa-field">
              <span class="pa-field__label">Status</span>
              <span class="pa-field__value">
                <.badge variant={status_variant(@user.status)} size="sm">
                  {@user.status}
                </.badge>
              </span>
            </div>
          </div>
        </div>
      </div>
      <div class="pa-detail-panel__footer">
        <.button variant="primary" size="sm">
          <i class="fa-solid fa-pen-to-square"></i> Edit
        </.button>
        <.button variant="outline-danger" size="sm">
          <i class="fa-solid fa-trash"></i> Delete
        </.button>
        <.button variant="secondary" size="sm" style="margin-left: auto;" phx-click="close_panel">
          Close
        </.button>
      </div>
    </div>
    """
  end

  defp status_variant("Active"), do: "success"
  defp status_variant("On Leave"), do: "warning"
  defp status_variant("Inactive"), do: "danger"
  defp status_variant(_), do: "secondary"
end
