defmodule DemoWeb.Live.DashboardLive do
  use DemoWeb, :live_view

  def mount(_params, _session, socket) do
    orders = [
      %{id: "#ORD-001", customer: "Alice Brown", amount: "$234.50", status: "Completed", status_variant: "success"},
      %{id: "#ORD-002", customer: "Bob Wilson", amount: "$189.00", status: "Pending", status_variant: "warning"},
      %{id: "#ORD-003", customer: "Carol Davis", amount: "$567.25", status: "Processing", status_variant: "info"},
      %{id: "#ORD-004", customer: "David Lee", amount: "$432.00", status: "Completed", status_variant: "success"},
      %{id: "#ORD-005", customer: "Eve Miller", amount: "$98.75", status: "Pending", status_variant: "warning"}
    ]

    {:ok, assign(socket, page_title: "Dashboard", orders: orders)}
  end

  def render(assigns) do
    ~H"""
    <h1 class="pa-page-title">Dashboard</h1>
    <p class="pa-page-subtitle">Real-time overview of key performance metrics</p>

    <%!-- KPI Cards --%>
    <.grid>
      <.column size="25">
        <.card variant="stat">
          <.stat number="$847,392" label_text="Total Revenue"
            change_text="+12.5%" change_direction="positive" />
        </.card>
      </.column>
      <.column size="25">
        <.card variant="stat">
          <.stat number="24,583" label_text="Active Users"
            change_text="+8.3%" change_direction="positive" />
        </.card>
      </.column>
      <.column size="25">
        <.card variant="stat">
          <.stat number="3.47%" label_text="Conversion Rate"
            change_text="-2.1%" change_direction="negative" />
        </.card>
      </.column>
      <.column size="25">
        <.card variant="stat">
          <.stat number="$134.52" label_text="Avg Order Value"
            change_text="+5.7%" change_direction="positive" />
        </.card>
      </.column>
    </.grid>

    <%!-- Charts row --%>
    <.grid>
      <.column size="2-3">
        <.card title_text="Top Sales Products">
          <div
            style="height: 200px; display: flex; align-items: center; justify-content: center; background: var(--pa-bg-light); border-radius: 4px;"
          >
            <span style="opacity: 0.5">
              <i class="fa-solid fa-chart-bar fa-2x"></i> Chart Placeholder
            </span>
          </div>
        </.card>
      </.column>
      <.column size="1-3">
        <.card title_text="Key Performance">
          <.stat number="87%" label_text="Completion Rate" icon_variant="primary">
            <:icon><i class="fa-solid fa-check-circle"></i></:icon>
          </.stat>
          <.stat number="94%" label_text="Customer Satisfaction" icon_variant="success">
            <:icon><i class="fa-solid fa-star"></i></:icon>
          </.stat>
          <.stat number="78%" label_text="Server Capacity" icon_variant="warning">
            <:icon><i class="fa-solid fa-server"></i></:icon>
          </.stat>
        </.card>
      </.column>
    </.grid>

    <%!-- Activity and Orders --%>
    <.grid>
      <.column size="50">
        <.card title_text="Recent Activity">
          <.list>
            <.list_item>
              <:avatar><i class="fa-solid fa-user-plus"></i></:avatar>
              <span>New user registered — <strong>Sarah Johnson</strong></span>
            </.list_item>
            <.list_item>
              <:avatar><i class="fa-solid fa-shopping-cart"></i></:avatar>
              <span>Order completed — <strong>#ORD-2024-1234</strong></span>
            </.list_item>
            <.list_item>
              <:avatar><i class="fa-solid fa-triangle-exclamation"></i></:avatar>
              <span>Low stock alert — <strong>Widget Pro X</strong></span>
            </.list_item>
            <.list_item>
              <:avatar><i class="fa-solid fa-credit-card"></i></:avatar>
              <span>Payment received — <strong>$1,234.00</strong></span>
            </.list_item>
            <.list_item>
              <:avatar><i class="fa-solid fa-file-lines"></i></:avatar>
              <span>Monthly report generated</span>
            </.list_item>
          </.list>
          <:footer>
            <.button variant="secondary" size="sm">View All Activity</.button>
          </:footer>
        </.card>
      </.column>
      <.column size="50">
        <.card has_padding={false} title_text="Recent Orders">
          <.table rows={@orders} size="xs">
            <:col :let={order} label="Order ID"><%= order.id %></:col>
            <:col :let={order} label="Customer"><%= order.customer %></:col>
            <:col :let={order} label="Amount"><%= order.amount %></:col>
            <:col :let={order} label="Status">
              <.badge variant={order.status_variant}><%= order.status %></.badge>
            </:col>
          </.table>
          <:footer>
            <.button variant="secondary" size="sm">View All Orders</.button>
          </:footer>
        </.card>
      </.column>
    </.grid>

    <%!-- Bottom row --%>
    <.grid>
      <.column size="1-3">
        <.card title_text="System Status">
          <.list>
            <.list_item title_text="API Services" meta_text="Operational">
              <:avatar><span style="color: var(--pa-success)"><i class="fa-solid fa-circle"></i></span></:avatar>
            </.list_item>
            <.list_item title_text="Database" meta_text="Operational">
              <:avatar><span style="color: var(--pa-success)"><i class="fa-solid fa-circle"></i></span></:avatar>
            </.list_item>
            <.list_item title_text="Payment Gateway" meta_text="Degraded">
              <:avatar><span style="color: var(--pa-warning)"><i class="fa-solid fa-circle"></i></span></:avatar>
            </.list_item>
            <.list_item title_text="Email Service" meta_text="Operational">
              <:avatar><span style="color: var(--pa-success)"><i class="fa-solid fa-circle"></i></span></:avatar>
            </.list_item>
          </.list>
        </.card>
      </.column>
      <.column size="1-3">
        <.card title_text="Quick Actions">
          <.button_group is_vertical>
            <.button variant="primary" is_block>New Order</.button>
            <.button variant="secondary" is_block>Add Customer</.button>
            <.button variant="secondary" is_block>Generate Report</.button>
            <.button variant="secondary" is_block>Export Data</.button>
          </.button_group>
        </.card>
      </.column>
    </.grid>
    """
  end
end
