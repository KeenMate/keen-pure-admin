defmodule DemoWeb.Live.GridLive do
  use DemoWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, page_title: "Grid System")}
  end

  def render(assigns) do
    ~H"""
    <h1 class="pa-page-title">Grid System</h1>
    <p class="pa-page-subtitle">Responsive grid layout with percentage and fraction-based columns.</p>

    <style>
      .demo-col { background: var(--pa-primary-bg, #e3f2fd); padding: 12px; text-align: center; border-radius: 4px; border: 1px solid var(--pa-primary-border, #90caf9); font-size: 0.875rem; }
      .demo-col--alt { background: var(--pa-success-bg, #e8f5e9); border-color: var(--pa-success-border, #a5d6a7); }
    </style>

    <%!-- Overview --%>
    <.grid>
      <.column size="66">
        <.card title_text="Grid System">
          <p><strong>Key features:</strong></p>
          <ul style="padding-left: 20px; margin-top: 8px;">
            <li>0.8rem gutter per side</li>
            <li>Percentage widths in 5% increments</li>
            <li>Fraction-based columns (halves, thirds, quarters, fifths, sixths)</li>
            <li>Responsive breakpoints (sm, md, lg, xl)</li>
            <li>Column offsets</li>
          </ul>
        </.card>
      </.column>
      <.column size="33">
        <.card title_text="Breakpoints">
          <table class="pa-table pa-table--xs">
            <thead>
              <tr>
                <th>Name</th>
                <th>Width</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td>sm</td>
                <td>576px</td>
              </tr>
              <tr>
                <td>md</td>
                <td>768px</td>
              </tr>
              <tr>
                <td>lg</td>
                <td>992px</td>
              </tr>
              <tr>
                <td>xl</td>
                <td>1200px</td>
              </tr>
            </tbody>
          </table>
        </.card>
      </.column>
    </.grid>

    <%!-- Basic Usage --%>
    <.card title_text="Auto Grid">
      <.grid>
        <.column>
          <div class="demo-col">Auto</div>
        </.column>
        <.column>
          <div class="demo-col">Auto</div>
        </.column>
      </.grid>
      <br />
      <.grid>
        <.column>
          <div class="demo-col">Auto</div>
        </.column>
        <.column>
          <div class="demo-col">Auto</div>
        </.column>
        <.column>
          <div class="demo-col">Auto</div>
        </.column>
      </.grid>
      <br />
      <.grid>
        <.column>
          <div class="demo-col">Auto</div>
        </.column>
        <.column>
          <div class="demo-col">Auto</div>
        </.column>
        <.column>
          <div class="demo-col">Auto</div>
        </.column>
        <.column>
          <div class="demo-col">Auto</div>
        </.column>
      </.grid>
    </.card>

    <%!-- Percentage Columns --%>
    <.card title_text="Percentage Grid">
      <.grid>
        <.column size="25">
          <div class="demo-col">25%</div>
        </.column>
        <.column size="75">
          <div class="demo-col--alt demo-col">75%</div>
        </.column>
      </.grid>
      <br />
      <.grid>
        <.column size="33">
          <div class="demo-col">33%</div>
        </.column>
        <.column size="66">
          <div class="demo-col--alt demo-col">66%</div>
        </.column>
      </.grid>
      <br />
      <.grid>
        <.column size="50">
          <div class="demo-col">50%</div>
        </.column>
        <.column size="50">
          <div class="demo-col--alt demo-col">50%</div>
        </.column>
      </.grid>
      <br />
      <.grid>
        <.column size="40">
          <div class="demo-col">40%</div>
        </.column>
        <.column size="60">
          <div class="demo-col--alt demo-col">60%</div>
        </.column>
      </.grid>
      <br />
      <.grid>
        <.column size="20">
          <div class="demo-col">20%</div>
        </.column>
        <.column size="20">
          <div class="demo-col--alt demo-col">20%</div>
        </.column>
        <.column size="20">
          <div class="demo-col">20%</div>
        </.column>
        <.column size="20">
          <div class="demo-col--alt demo-col">20%</div>
        </.column>
        <.column size="20">
          <div class="demo-col">20%</div>
        </.column>
      </.grid>
    </.card>

    <%!-- Fraction Columns --%>
    <.card title_text="Fraction Grid">
      <p style="margin-bottom: 12px;">Halves</p>
      <.grid>
        <.column size="1-2">
          <div class="demo-col">1/2</div>
        </.column>
        <.column size="1-2">
          <div class="demo-col--alt demo-col">1/2</div>
        </.column>
      </.grid>
      <br />
      <p>Thirds</p>
      <.grid>
        <.column size="1-3">
          <div class="demo-col">1/3</div>
        </.column>
        <.column size="2-3">
          <div class="demo-col--alt demo-col">2/3</div>
        </.column>
      </.grid>
      <br />
      <p>Quarters</p>
      <.grid>
        <.column size="1-4">
          <div class="demo-col">1/4</div>
        </.column>
        <.column size="3-4">
          <div class="demo-col--alt demo-col">3/4</div>
        </.column>
      </.grid>
    </.card>

    <%!-- Row Alignment --%>
    <.card title_text="Alignment">
      <p style="margin-bottom: 8px;"><strong>Horizontal: Center</strong></p>
      <.grid align="center">
        <.column size="25">
          <div class="demo-col">25%</div>
        </.column>
        <.column size="25">
          <div class="demo-col--alt demo-col">25%</div>
        </.column>
      </.grid>
      <br />
      <p><strong>Horizontal: End</strong></p>
      <.grid align="end">
        <.column size="25">
          <div class="demo-col">25%</div>
        </.column>
        <.column size="25">
          <div class="demo-col--alt demo-col">25%</div>
        </.column>
      </.grid>
      <br />
      <p><strong>Horizontal: Between</strong></p>
      <.grid align="between">
        <.column size="25">
          <div class="demo-col">25%</div>
        </.column>
        <.column size="25">
          <div class="demo-col--alt demo-col">25%</div>
        </.column>
      </.grid>
    </.card>

    <%!-- No Gutter --%>
    <.card title_text="No Gutter">
      <p style="margin-bottom: 8px;"><strong>Default (with gutter)</strong></p>
      <.grid>
        <.column size="33">
          <div class="demo-col">1/3</div>
        </.column>
        <.column size="33">
          <div class="demo-col--alt demo-col">1/3</div>
        </.column>
        <.column size="33">
          <div class="demo-col">1/3</div>
        </.column>
      </.grid>
      <br />
      <p><strong>No Gutter</strong></p>
      <.grid is_no_gutter>
        <.column size="33">
          <div class="demo-col">1/3</div>
        </.column>
        <.column size="33">
          <div class="demo-col--alt demo-col">1/3</div>
        </.column>
        <.column size="33">
          <div class="demo-col">1/3</div>
        </.column>
      </.grid>
    </.card>

    <%!-- Nested Grids --%>
    <.card title_text="Nested Grids">
      <.grid>
        <.column size="33">
          <div class="demo-col">Outer 1/3</div>
        </.column>
        <.column size="66">
          <div class="demo-col--alt demo-col">
            Outer 2/3
            <.grid>
              <.column size="50">
                <div class="demo-col" style="margin-top: 8px;">Nested 1/2</div>
              </.column>
              <.column size="50">
                <div class="demo-col" style="margin-top: 8px;">Nested 1/2</div>
              </.column>
            </.grid>
          </div>
        </.column>
      </.grid>
    </.card>
    """
  end
end
