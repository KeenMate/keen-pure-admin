defmodule DemoWeb.Live.TablesSizingLive do
  use DemoWeb, :live_view

  @users [
    %{id: 1, name: "Tiger Nixon", email: "tiger@example.com", role: "Admin", status: "Active"},
    %{id: 2, name: "Garrett Winters", email: "garrett@example.com", role: "Editor", status: "Active"},
    %{id: 3, name: "Ashton Cox", email: "ashton@example.com", role: "User", status: "Inactive"},
    %{id: 4, name: "Cedric Kelly", email: "cedric@example.com", role: "Admin", status: "Active"},
    %{id: 5, name: "Airi Satou", email: "airi@example.com", role: "Editor", status: "Active"}
  ]

  @sizes [
    %{size: "xs", label: "XS — Extra Small", desc: "Dense data, logs, compact lists", btn_size: "xs"},
    %{size: nil, label: "Default", desc: "Standard tables, most use cases", btn_size: "sm"},
    %{size: "sm", label: "SM — Small", desc: "Slightly wider spacing", btn_size: "sm"},
    %{size: "lg", label: "LG — Large", desc: "Forms in tables, spacious layouts", btn_size: "lg"},
    %{size: "xl", label: "XL — Extra Large", desc: "Presentation tables, dashboards", btn_size: "lg"}
  ]

  def mount(_params, _session, socket) do
    {:ok, assign(socket,
      page_title: "Table Sizing",
      users: @users,
      sizes: @sizes
    )}
  end

  def render(assigns) do
    ~H"""
    <p>Size variants synchronized with button and input sizes.</p>

    <%= for s <- @sizes do %>
      <.card has_padding={false} title_text={s.label}>
        <:subtitle>{s.desc}</:subtitle>
        <.table rows={Enum.take(@users, 3)} size={s.size} is_striped>
          <:col :let={user} label="Name">{user.name}</:col>
          <:col :let={user} label="Email">{user.email}</:col>
          <:col :let={user} label="Role">{user.role}</:col>
          <:col :let={user} label="Status">
            <.badge variant={if user.status == "Active", do: "success", else: "secondary"} size="sm">
              {user.status}
            </.badge>
          </:col>
          <:action :let={_user}>
            <.button variant="info" size={s.btn_size} is_icon_only title="Edit">
              <i class="fa-solid fa-pen"></i>
            </.button>
            <.button variant="danger" size={s.btn_size} is_icon_only title="Delete">
              <i class="fa-solid fa-trash"></i>
            </.button>
          </:action>
        </.table>
      </.card>
    <% end %>

    <%!-- Reference Table --%>
    <.card has_padding={false} title_text="Size Reference">
      <.table rows={@sizes} is_bordered>
        <:col :let={s} label="Size">{s.size || "default"}</:col>
        <:col :let={s} label="Label">{s.label}</:col>
        <:col :let={s} label="Use Case">{s.desc}</:col>
        <:col :let={s} label="Button Size">{s.btn_size}</:col>
      </.table>
    </.card>
    """
  end
end
