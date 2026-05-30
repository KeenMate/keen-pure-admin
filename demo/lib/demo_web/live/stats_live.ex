defmodule DemoWeb.Live.StatsLive do
  use DemoWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, page_title: "Stats")}
  end

  def render(assigns) do
    ~H"""
    <p>Stat and metric display components.</p>

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

    <.card title_text="5-step sentiment scale · v2.7.0">
      <:description>
        The hero delta scale grew from 3 (<code>positive</code> / <code>negative</code> / <code>neutral</code>) to 5 with the addition of <code>very_positive</code> and <code>very_negative</code> for outlier deltas. Neutral colour shifted from <code>--pa-text-color-2</code> (grey) to <code>--pa-neutral</code>. Compare the five deltas side-by-side below.
      </:description>
      <.grid>
        <.column size="1-5">
          <.stat variant="hero" number="$12.4M" label_text="ARR" change_text="+38.1% breakout" change_direction="very_positive" />
        </.column>
        <.column size="1-5">
          <.stat variant="hero" number="$847K" label_text="MRR" change_text="+12.5%" change_direction="positive" />
        </.column>
        <.column size="1-5">
          <.stat variant="hero" number="148 ms" label_text="Latency p95" change_text="±0.7%" change_direction="neutral" />
        </.column>
        <.column size="1-5">
          <.stat variant="hero" number="2.4%" label_text="Churn" change_text="-5.2%" change_direction="negative" />
        </.column>
        <.column size="1-5">
          <.stat variant="hero" number="$103K" label_text="Cloud Spend" change_text="-38% collapse" change_direction="very_negative" />
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

    <.card title_text="Square stats — mixed units · v2.6.0">
      <p>
        v2.6.0 redesigned <code>pa-stat--square</code> so the decorative <code>__symbol</code> watermark sits inline with the big <code>__number</code>. Markup order alone drives visual order — pass <code>is_prefix_symbol</code> to render the symbol BEFORE the number for prefix currencies (<code>$847K</code>, <code>¥12.4M</code>); leave it off for suffix units (<code>87%</code>, <code>23°C</code>). Number font-size scales with the tile width via <code>cqi</code> (container-query inline-size), so a row of squares stays balanced regardless of grid breakpoint.
      </p>
      <.grid>
        <.column size="25">
          <.stat variant="square" color="success" number="87" symbol_text="%" label_text="Completion" />
        </.column>
        <.column size="25">
          <.stat variant="square" color="info" number="23" symbol_text="°C" label_text="Server temp" />
        </.column>
        <.column size="25">
          <.stat variant="square" color="primary" number="847K" symbol_text="$" label_text="MRR" is_prefix_symbol />
        </.column>
        <.column size="25">
          <.stat variant="square" color="warning" number="12.4M" symbol_text="¥" label_text="JPY revenue" is_prefix_symbol />
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
