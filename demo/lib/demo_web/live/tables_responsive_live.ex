defmodule DemoWeb.Live.TablesResponsiveLive do
  use DemoWeb, :live_view

  @employees [
    %{id: 1, name: "Tiger Nixon", email: "tiger@example.com", department: "Engineering",
      location: "San Francisco", phone: "+1 555-0101", start_date: "2020-01-15",
      salary: "$320,000", status: "Active"},
    %{id: 2, name: "Garrett Winters", email: "garrett@example.com", department: "Marketing",
      location: "New York", phone: "+1 555-0102", start_date: "2019-06-20",
      salary: "$280,000", status: "Active"},
    %{id: 3, name: "Ashton Cox", email: "ashton@example.com", department: "Design",
      location: "London", phone: "+44 20-7946-0958", start_date: "2021-03-10",
      salary: "$250,000", status: "Inactive"},
    %{id: 4, name: "Cedric Kelly", email: "cedric@example.com", department: "Engineering",
      location: "Berlin", phone: "+49 30-1234567", start_date: "2018-11-05",
      salary: "$310,000", status: "Active"}
  ]

  @products [
    %{name: "Widget Pro", sku: "WGT-001", category: "Electronics", price: "$299.99", stock: 45, status: "In Stock"},
    %{name: "Gadget X", sku: "GDG-002", category: "Accessories", price: "$49.99", stock: 0, status: "Out of Stock"},
    %{name: "Tool Kit", sku: "TLK-003", category: "Hardware", price: "$129.99", stock: 12, status: "Low Stock"},
    %{name: "Smart Hub", sku: "SMH-004", category: "Electronics", price: "$199.99", stock: 89, status: "In Stock"}
  ]

  @orders [
    %{id: "#ORD-001", date: "2026-03-15", customer: "Tiger Nixon", items: "Widget Pro, Gadget X", total: "$349.98", status: "Delivered"},
    %{id: "#ORD-002", date: "2026-03-14", customer: "Garrett Winters", items: "Smart Hub", total: "$199.99", status: "Shipped"},
    %{id: "#ORD-003", date: "2026-03-13", customer: "Ashton Cox", items: "Tool Kit x3, Widget Pro x2", total: "$989.95", status: "Processing"}
  ]

  def mount(_params, _session, socket) do
    {:ok, assign(socket,
      page_title: "Responsive Tables",
      employees: @employees,
      products: @products,
      orders: @orders
    )}
  end

  def render(assigns) do
    ~H"""
    <p>Tables that adapt to mobile screens with card-style stacking and CSS Grid layouts.</p>

    <%!-- How it works --%>
    <.section title_text="How It Works">
      <.paragraph class="mb-2">
        Responsive tables transform into stacked card layouts on mobile devices (≤768px).
        On tablet (769–1024px), the table scrolls horizontally. On desktop, the full table is visible.
      </.paragraph>
    </.section>

    <%!-- Basic Responsive --%>
    <.card has_padding={false} title_text="Basic Responsive Table">
      <:subtitle>Resize browser to see stacking behavior. Uses is_responsive on the table component.</:subtitle>
      <.table rows={@employees} is_responsive is_striped is_hover>
        <:col :let={row} label="Name">{row.name}</:col>
        <:col :let={row} label="Email">{row.email}</:col>
        <:col :let={row} label="Department">{row.department}</:col>
        <:col :let={row} label="Location">{row.location}</:col>
        <:col :let={row} label="Phone">{row.phone}</:col>
        <:col :let={row} label="Start Date">{row.start_date}</:col>
        <:col :let={row} label="Salary">{row.salary}</:col>
        <:col :let={row} label="Status">
          <.badge variant={if row.status == "Active", do: "success", else: "secondary"} size="sm">{row.status}</.badge>
        </:col>
        <:action :let={_row}>
          <.button variant="info" size="xs">View</.button>
        </:action>
      </.table>
    </.card>

    <%!-- Product Catalog --%>
    <.card has_padding={false} title_text="Product Catalog — Responsive">
      <.table rows={@products} is_responsive is_striped>
        <:col :let={p} label="Product">{p.name}</:col>
        <:col :let={p} label="SKU">{p.sku}</:col>
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

    <%!-- Recent Orders --%>
    <.card has_padding={false} title_text="Recent Orders — Responsive">
      <.table rows={@orders} is_responsive is_hover>
        <:col :let={o} label="Order">{o.id}</:col>
        <:col :let={o} label="Date">{o.date}</:col>
        <:col :let={o} label="Customer">{o.customer}</:col>
        <:col :let={o} label="Items">{o.items}</:col>
        <:col :let={o} label="Total">{o.total}</:col>
        <:col :let={o} label="Status">
          <.badge
            variant={
              case o.status do
                "Delivered" -> "success"
                "Shipped" -> "info"
                "Processing" -> "warning"
                _ -> nil
              end
            }
            size="sm"
          >
            {o.status}
          </.badge>
        </:col>
      </.table>
    </.card>

    <%!-- Scrollable Table Container --%>
    <.section title_text="Scrollable Table Container">
      <.paragraph class="mb-2">
        Wrap wide tables in a table_responsive or use table_card with is_scrollable for horizontal scroll without card stacking.
      </.paragraph>
    </.section>

    <.table_card title_text="Scrollable Table Card" is_scrollable>
      <.table rows={@employees} is_striped is_hover>
        <:col :let={row} label="ID">{row.id}</:col>
        <:col :let={row} label="Name">{row.name}</:col>
        <:col :let={row} label="Email">{row.email}</:col>
        <:col :let={row} label="Department">{row.department}</:col>
        <:col :let={row} label="Location">{row.location}</:col>
        <:col :let={row} label="Phone">{row.phone}</:col>
        <:col :let={row} label="Start Date">{row.start_date}</:col>
        <:col :let={row} label="Salary">{row.salary}</:col>
        <:col :let={row} label="Status">
          <.badge variant={if row.status == "Active", do: "success", else: "secondary"} size="sm">{row.status}</.badge>
        </:col>
        <:action :let={_row}>
          <.button variant="info" size="xs">View</.button>
          <.button variant="warning" size="xs">Edit</.button>
        </:action>
      </.table>
    </.table_card>
    """
  end
end
