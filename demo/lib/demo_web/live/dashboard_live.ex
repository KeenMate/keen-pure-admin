defmodule DemoWeb.Live.DashboardLive do
  use DemoWeb, :live_view

  def mount(_params, _session, socket) do
    orders = [
      %{id: "#4892", customer: "Alice Johnson", amount: "$234.50", status: "Completed", status_variant: "success"},
      %{id: "#4891", customer: "Bob Williams", amount: "$456.00", status: "Processing", status_variant: "warning"},
      %{id: "#4890", customer: "Carol Davis", amount: "$123.75", status: "Completed", status_variant: "success"},
      %{id: "#4889", customer: "David Miller", amount: "$789.25", status: "Shipped", status_variant: "info"},
      %{id: "#4888", customer: "Emma Wilson", amount: "$345.60", status: "Completed", status_variant: "success"}
    ]

    traffic_sources = [
      %{source: "Organic Search", pct: "42.3%"},
      %{source: "Direct", pct: "28.7%"},
      %{source: "Social Media", pct: "15.8%"},
      %{source: "Referral", pct: "9.4%"},
      %{source: "Email", pct: "3.8%"}
    ]

    top_products = [
      %{name: "Product Alpha", revenue: "$24,532"},
      %{name: "Product Beta", revenue: "$18,940"},
      %{name: "Product Gamma", revenue: "$15,677"},
      %{name: "Product Delta", revenue: "$12,234"}
    ]

    {:ok, assign(socket, page_title: "Dashboard", orders: orders, traffic_sources: traffic_sources, top_products: top_products)}
  end

  def render(assigns) do
    ~H"""
    <p class="text-muted">Real-time overview of key performance metrics</p>

    <%!-- KPI Metric Cards --%>
    <.grid>
      <.column size="25">
        <.card>
          <.stat variant="hero" number="$847,392" label_text="Total Revenue"
            change_text="▲ 12.5% vs last month" change_direction="positive" />
        </.card>
      </.column>
      <.column size="25">
        <.card>
          <.stat variant="hero" number="24,583" label_text="Active Users"
            change_text="▲ 8.3% vs last month" change_direction="positive" />
        </.card>
      </.column>
      <.column size="25">
        <.card>
          <.stat variant="hero" number="3.47%" label_text="Conversion Rate"
            change_text="▼ 2.1% vs last month" change_direction="negative" />
        </.card>
      </.column>
      <.column size="25">
        <.card>
          <.stat variant="hero" number="$134.52" label_text="Avg Order Value"
            change_text="▲ 5.7% vs last month" change_direction="positive" />
        </.card>
      </.column>
    </.grid>

    <%!-- Top Sales Products & KPIs --%>
    <.grid>
      <.column size="2-3">
        <.card title_text="Top Sales Products">
          <div style="height: 200px; display: flex; align-items: center; justify-content: center; background: var(--pa-bg-light); border-radius: 4px;">
            <span style="opacity: 0.5">
              <i class="fa-solid fa-chart-bar fa-2x"></i> Chart Placeholder
            </span>
          </div>
        </.card>
      </.column>
      <.column size="1-3">
        <.card title_text="Key Performance Indicators">
          <.grid>
            <.column size="50">
              <.stat variant="square" color="primary" number="87" symbol_text="%" label_text="Completion Rate" />
            </.column>
            <.column size="50">
              <.stat variant="square" color="success" number="94" symbol_text="%" label_text="Customer Satisfaction" />
            </.column>
            <.column size="50">
              <.stat variant="square" color="info" number="62" symbol_text="%" label_text="Market Share" />
            </.column>
            <.column size="50">
              <.stat variant="square" color="warning" number="78" symbol_text="%" label_text="Server Capacity" />
            </.column>
            <.column size="50">
              <.stat variant="square" color="danger" number="23" symbol_text="%" label_text="Error Rate" />
            </.column>
            <.column size="50">
              <.stat variant="square" color="secondary" number="91" symbol_text="%" label_text="Uptime" />
            </.column>
          </.grid>
        </.card>
      </.column>
    </.grid>

    <%!-- Revenue Trend & Traffic Sources --%>
    <.grid>
      <.column size="2-3">
        <.card title_text="Revenue Trend">
          <div>
            <p class="text-center text-muted">Chart placeholder - integrate with Chart.js, D3.js, or similar</p>
            <svg width="100%" height="200" viewBox="0 0 600 200" preserveAspectRatio="none">
              <polyline
                fill="none"
                stroke="currentColor"
                stroke-width="2"
                points="0,150 60,140 120,120 180,110 240,100 300,90 360,85 420,75 480,70 540,60 600,50"
                opacity="0.6"
              />
              <polyline
                fill="none"
                stroke="currentColor"
                stroke-width="2"
                points="0,180 60,170 120,165 180,160 240,155 300,150 360,145 420,140 480,135 540,130 600,125"
                opacity="0.3"
              />
            </svg>
          </div>
        </.card>
      </.column>
      <.column size="1-3">
        <.card has_padding={false} title_text="Traffic Sources">
          <.table rows={@traffic_sources} size="sm" is_compact>
            <:col :let={row} label="Source">{row.source}</:col>
            <:col :let={row} label="%" align="end"><strong>{row.pct}</strong></:col>
          </.table>
        </.card>
      </.column>
    </.grid>

    <%!-- Activity Feed & Recent Orders --%>
    <.grid>
      <.column size="50">
        <.card title_text="Recent Activity">
          <.timeline variant="simple">
            <.timeline_item variant="primary" time_text="2 min ago">
              New user registration: <strong>john.smith@example.com</strong>
            </.timeline_item>
            <.timeline_item variant="success" time_text="8 min ago">
              Order #4892 completed - <strong>$234.50</strong>
            </.timeline_item>
            <.timeline_item variant="warning" time_text="15 min ago">
              Low stock alert: <strong>Product A-123</strong>
            </.timeline_item>
            <.timeline_item variant="success" time_text="23 min ago">
              Payment received: <strong>Invoice #2847</strong>
            </.timeline_item>
            <.timeline_item variant="info" time_text="1 hr ago">
              Monthly report generated
            </.timeline_item>
          </.timeline>
          <:footer>
            <.button variant="secondary" size="sm">View All Activity</.button>
          </:footer>
        </.card>
      </.column>
      <.column size="50">
        <.card has_padding={false} title_text="Recent Orders">
          <.table rows={@orders} size="sm" is_compact>
            <:col :let={order} label="Order ID">{order.id}</:col>
            <:col :let={order} label="Customer">{order.customer}</:col>
            <:col :let={order} label="Amount">{order.amount}</:col>
            <:col :let={order} label="Status">
              <.badge variant={order.status_variant}>{order.status}</.badge>
            </:col>
          </.table>
          <:footer>
            <.button variant="secondary" size="sm">View All Orders</.button>
          </:footer>
        </.card>
      </.column>
    </.grid>

    <%!-- Bottom Row - Performance Metrics --%>
    <.grid>
      <.column size="1-3">
        <.card has_padding={false} title_text="Top Products">
          <.table rows={@top_products} size="sm" is_compact>
            <:col :let={row} label="Product">{row.name}</:col>
            <:col :let={row} label="Revenue" align="end"><strong>{row.revenue}</strong></:col>
          </.table>
        </.card>
      </.column>
      <.column size="1-3">
        <.card has_padding={false} title_text="System Status">
          <.list>
            <.list_item title_text="API Services">
              <:meta><.badge variant="success">Operational</.badge></:meta>
            </.list_item>
            <.list_item title_text="Database">
              <:meta><.badge variant="success">Operational</.badge></:meta>
            </.list_item>
            <.list_item title_text="Payment Gateway">
              <:meta><.badge variant="warning">Degraded</.badge></:meta>
            </.list_item>
            <.list_item title_text="Email Service">
              <:meta><.badge variant="success">Operational</.badge></:meta>
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
