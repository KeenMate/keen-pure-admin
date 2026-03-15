defmodule DemoWeb.Live.StatsLive do
  use DemoWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, page_title: "Stats")}
  end

  def render(assigns) do
    ~H"""
    <h1 class="pa-page-title">Stats</h1>
    <p class="pa-page-subtitle">Stat and metric display components.</p>

    <.card title_text="Basic Stats">
      <.grid>
        <.column size="25">
          <.stat number="1,234" label_text="Total Users" />
        </.column>
        <.column size="25">
          <.stat number="$12,345" label_text="Revenue" />
        </.column>
        <.column size="25">
          <.stat number="567" label_text="Orders" />
        </.column>
        <.column size="25">
          <.stat number="89%" label_text="Satisfaction" />
        </.column>
      </.grid>
    </.card>

    <.card title_text="Stats with Trends">
      <.grid>
        <.column size="1-3">
          <.stat
            number="$847,392"
            label_text="Total Revenue"
            change_text="+12.5%"
            change_direction="positive"
          />
        </.column>
        <.column size="1-3">
          <.stat
            number="24,583"
            label_text="Active Users"
            change_text="-5.2%"
            change_direction="negative"
          />
        </.column>
        <.column size="1-3">
          <.stat number="3.47%" label_text="Conversion Rate" change_text="0%" change_direction="neutral" />
        </.column>
      </.grid>
    </.card>

    <.card title_text="Stats with Icons">
      <.grid>
        <.column size="25">
          <.stat number="1,234" label_text="Total Users">
            <:icon><i class="fa-solid fa-users"></i></:icon>
          </.stat>
        </.column>
        <.column size="25">
          <.stat number="$45,678" label_text="Revenue" icon_variant="success">
            <:icon><i class="fa-solid fa-dollar-sign"></i></:icon>
          </.stat>
        </.column>
        <.column size="25">
          <.stat number="567" label_text="Orders" icon_variant="warning">
            <:icon><i class="fa-solid fa-box"></i></:icon>
          </.stat>
        </.column>
        <.column size="25">
          <.stat number="+12%" label_text="Growth" change_text="+12%" change_direction="positive" icon_variant="success">
            <:icon><i class="fa-solid fa-chart-line"></i></:icon>
          </.stat>
        </.column>
      </.grid>
    </.card>

    <.card title_text="Hero Stats">
      <.grid>
        <.column size="1-3">
          <.stat variant="hero" number="$847,392" label_text="Total Revenue"
            change_text="+12.5%" change_direction="positive" />
        </.column>
        <.column size="1-3">
          <.stat variant="hero" number="24,583" label_text="Active Users"
            change_text="-5.2%" change_direction="negative" />
        </.column>
        <.column size="1-3">
          <.stat variant="hero-compact" number="3.47%" label_text="Conversion Rate"
            change_text="0%" change_direction="neutral" />
        </.column>
      </.grid>
    </.card>

    <.card title_text="Square Stats">
      <.grid>
        <.column size="25">
          <.stat variant="square" color="primary" number="42" label_text="Tasks" />
        </.column>
        <.column size="25">
          <.stat variant="square" color="success" number="18" label_text="Completed" symbol_text="%" />
        </.column>
        <.column size="25">
          <.stat variant="square" color="warning" number="7" label_text="Pending" />
        </.column>
        <.column size="25">
          <.stat variant="square" color="danger" number="3" label_text="Failed" />
        </.column>
      </.grid>
    </.card>

    <.card title_text="Stat Cards">
      <.grid>
        <.column size="25">
          <.card variant="stat">
            <.stat number="87%" label_text="Completion Rate">
              <:icon><i class="fa-solid fa-check-circle"></i></:icon>
            </.stat>
          </.card>
        </.column>
        <.column size="25">
          <.card variant="stat">
            <.stat number="94%" label_text="Customer Satisfaction" icon_variant="success">
              <:icon><i class="fa-solid fa-star"></i></:icon>
            </.stat>
          </.card>
        </.column>
        <.column size="25">
          <.card variant="stat">
            <.stat number="62%" label_text="Market Share" icon_variant="info">
              <:icon><i class="fa-solid fa-chart-pie"></i></:icon>
            </.stat>
          </.card>
        </.column>
        <.column size="25">
          <.card variant="stat">
            <.stat number="78%" label_text="Server Capacity" icon_variant="warning">
              <:icon><i class="fa-solid fa-server"></i></:icon>
            </.stat>
          </.card>
        </.column>
      </.grid>
    </.card>
    """
  end
end
