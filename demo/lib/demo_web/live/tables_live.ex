defmodule DemoWeb.Live.TablesLive do
  use DemoWeb, :live_view

  @users [
    %{id: 1, name: "Tiger Nixon", email: "tiger@example.com", role: "Admin", status: "Active"},
    %{id: 2, name: "Garrett Winters", email: "garrett@example.com", role: "Editor", status: "Active"},
    %{id: 3, name: "Ashton Cox", email: "ashton@example.com", role: "User", status: "Inactive"},
    %{id: 4, name: "Cedric Kelly", email: "cedric@example.com", role: "Admin", status: "Active"},
    %{id: 5, name: "Airi Satou", email: "airi@example.com", role: "Editor", status: "Active"}
  ]

  @products [
    %{name: "Widget Pro", category: "Electronics", price: "$299.99", stock: 45, status: "In Stock"},
    %{name: "Gadget X", category: "Accessories", price: "$49.99", stock: 0, status: "Out of Stock"},
    %{name: "Tool Kit", category: "Hardware", price: "$129.99", stock: 12, status: "Low Stock"},
    %{name: "Smart Hub", category: "Electronics", price: "$199.99", stock: 89, status: "In Stock"}
  ]

  @wide_data [
    %{id: 1, name: "Tiger Nixon", email: "tiger@example.com", department: "Engineering",
      location: "San Francisco", phone: "+1 555-0101", start_date: "2020-01-15",
      salary: "$320,000", status: "Active"},
    %{id: 2, name: "Garrett Winters", email: "garrett@example.com", department: "Marketing",
      location: "New York", phone: "+1 555-0102", start_date: "2019-06-20",
      salary: "$280,000", status: "Active"}
  ]

  def mount(_params, _session, socket) do
    {:ok, assign(socket,
      page_title: "Tables",
      users: @users,
      products: @products,
      wide_data: @wide_data
    )}
  end

  def render(assigns) do
    ~H"""
    <h1 class="pa-page-title">Tables</h1>
    <p class="pa-page-subtitle">Data tables with sorting, pagination, and various styling options.</p>

    <%!-- Basic Table --%>
    <.card has_padding={false} title_text="Basic Table with Actions">
      <.table rows={@users}>
        <:col :let={user} label="ID">{user.id}</:col>
        <:col :let={user} label="Name">{user.name}</:col>
        <:col :let={user} label="Email">{user.email}</:col>
        <:col :let={user} label="Role">{user.role}</:col>
        <:col :let={user} label="Status">
          <.badge variant={if user.status == "Active", do: "success", else: "secondary"} size="sm">
            {user.status}
          </.badge>
        </:col>
        <:action :let={user}>
          <.button variant="info" size="xs" is_icon_only title={"View #{user.name}"}>
            <i class="fa-solid fa-eye"></i>
          </.button>
          <.button variant="warning" size="xs" is_icon_only title={"Edit #{user.name}"}>
            <i class="fa-solid fa-pen"></i>
          </.button>
          <.button variant="danger" size="xs" is_icon_only title={"Delete #{user.name}"}>
            <i class="fa-solid fa-trash"></i>
          </.button>
        </:action>
      </.table>
    </.card>

    <%!-- Striped & Hover Table --%>
    <.card has_padding={false} title_text="Striped & Hover Table">
      <.table rows={@products} is_striped is_hover>
        <:col :let={p} label="Product">{p.name}</:col>
        <:col :let={p} label="Category">{p.category}</:col>
        <:col :let={p} label="Price">{p.price}</:col>
        <:col :let={p} label="Stock">{p.stock}</:col>
        <:col :let={p} label="Status">
          <.badge
            variant={
              cond do
                p.status == "In Stock" -> "success"
                p.status == "Low Stock" -> "warning"
                true -> "danger"
              end
            }
            size="sm"
          >
            {p.status}
          </.badge>
        </:col>
      </.table>
    </.card>

    <%!-- Table Size Variants --%>
    <.section title_text="Table Size Variants">
      <.paragraph class="mb-2">Table size variants synchronized with button/input sizes.</.paragraph>
    </.section>

    <.grid>
      <.column size="50">
        <.card has_padding={false} title_text="XS Size Table">
          <.table rows={Enum.take(@users, 3)} size="xs">
            <:col :let={user} label="Name">{user.name}</:col>
            <:col :let={user} label="Role">{user.role}</:col>
            <:action :let={_user}>
              <.button variant="info" size="xs" is_icon_only title="Edit">
                <i class="fa-solid fa-pen"></i>
              </.button>
              <.button variant="danger" size="xs" is_icon_only title="Delete">
                <i class="fa-solid fa-trash"></i>
              </.button>
            </:action>
          </.table>
        </.card>
      </.column>
      <.column size="50">
        <.card has_padding={false} title_text="LG Size Table">
          <.table rows={Enum.take(@users, 3)} size="lg">
            <:col :let={user} label="Name">{user.name}</:col>
            <:col :let={user} label="Role">{user.role}</:col>
            <:action :let={_user}>
              <.button variant="info" size="lg" is_icon_only title="Edit">
                <i class="fa-solid fa-pen"></i>
              </.button>
              <.button variant="danger" size="lg" is_icon_only title="Delete">
                <i class="fa-solid fa-trash"></i>
              </.button>
            </:action>
          </.table>
        </.card>
      </.column>
    </.grid>

    <%!-- Bordered & Borderless Tables --%>
    <.grid>
      <.column size="50">
        <.card has_padding={false} title_text="Bordered Table">
          <.table rows={Enum.take(@users, 3)} is_bordered>
            <:col :let={user} label="Name">{user.name}</:col>
            <:col :let={user} label="Email">{user.email}</:col>
            <:col :let={user} label="Role">{user.role}</:col>
          </.table>
        </.card>
      </.column>
      <.column size="50">
        <.card has_padding={false} title_text="Compact Table">
          <.table rows={Enum.take(@users, 3)} is_compact>
            <:col :let={user} label="Name">{user.name}</:col>
            <:col :let={user} label="Email">{user.email}</:col>
            <:col :let={user} label="Role">{user.role}</:col>
          </.table>
        </.card>
      </.column>
    </.grid>

    <%!-- Responsive Table --%>
    <.card title_text="Responsive Table">
      <.table rows={@wide_data} is_responsive>
        <:col :let={row} label="ID">{row.id}</:col>
        <:col :let={row} label="Name">{row.name}</:col>
        <:col :let={row} label="Email">{row.email}</:col>
        <:col :let={row} label="Department">{row.department}</:col>
        <:col :let={row} label="Location">{row.location}</:col>
        <:col :let={row} label="Phone">{row.phone}</:col>
        <:col :let={row} label="Start Date">{row.start_date}</:col>
        <:col :let={row} label="Salary">{row.salary}</:col>
        <:col :let={row} label="Status">
          <.badge variant="success" size="sm">{row.status}</.badge>
        </:col>
        <:action :let={_row}>
          <.button variant="info" size="xs">View</.button>
        </:action>
      </.table>
    </.card>
    """
  end
end
