defmodule DemoWeb.Live.GridLive do
  use DemoWeb, :live_view

  def mount(_params, _session, socket) do
    code_examples = %{
      basic: ~s"""
      <.grid>
        <.column size="50">Left half</.column>
        <.column size="50">Right half</.column>
      </.grid>

      <!-- Thirds -->
      <.grid>
        <.column size="1-3">One third</.column>
        <.column size="2-3">Two thirds</.column>
      </.grid>\
      """,
      responsive: ~s"""
      <!-- Stack on mobile, columns on desktop -->
      <.grid>
        <.column size="100" md="50">
          Full on mobile, half on desktop
        </.column>
        <.column size="100" md="50">
          Full on mobile, half on desktop
        </.column>
      </.grid>

      <!-- Progressive breakpoints -->
      <.column size="100" sm="50" lg="25">
        100% → 50% → 25%
      </.column>\
      """,
      grid_props: ~s"""
      <!-- Alignment -->
      <.grid align="center">...</.grid>
      <.grid align="between">...</.grid>
      <.grid valign="middle">...</.grid>

      <!-- Same height columns -->
      <.grid is_same_height>...</.grid>

      <!-- No gutter -->
      <.grid is_no_gutter>...</.grid>\
      """,
      column_props: ~s"""
      <!-- Sizes (percentage or fraction) -->
      <.column size="50">Half</.column>
      <.column size="1-3">One third</.column>

      <!-- Responsive -->
      <.column size="100" md="50" lg="25">
        Mobile → Tablet → Desktop
      </.column>

      <!-- Offset -->
      <.column size="50" offset="25">
        Centered 50%
      </.column>\
      """
    }

    {:ok, assign(socket, page_title: "Grid System", code_examples: code_examples)}
  end

  def render(assigns) do
    ~H"""
    <.paragraph>Responsive grid layout with percentage and fraction-based columns.</.paragraph>

    <style>
      .grid-demo-cell { background: #007bff; color: white; padding: 1rem; text-align: center; border-radius: 4px; font-size: 1.2rem; margin-bottom: 0.4rem; }
    </style>

    <%!-- Overview --%>
    <.card title_text="Overview">
      <.paragraph class="pa-text--secondary mb-4">
        Pure Admin uses a custom flexbox grid system with intuitive naming. Columns use <.code>pa-col-&#123;size&#125;</.code> for percentages
        and <.code>pa-col-&#123;x&#125;-&#123;y&#125;</.code> for fractions.
      </.paragraph>

      <.grid>
        <.column size="100" md="50">
          <h4>Key Features</h4>
          <ul style="line-height: 1.8;">
            <li><strong>Gutter:</strong> 0.8rem (8px) per side, 1.6rem (16px) total gap</li>
            <li><strong>Percentage columns:</strong> 5% increments (5, 10, 15... 100)</li>
            <li><strong>Fraction columns:</strong> Halves, thirds, quarters, fifths, sixths, twelfths</li>
            <li><strong>Responsive:</strong> All columns have breakpoint variants</li>
            <li><strong>Offsets:</strong> Left margin in 5% increments</li>
          </ul>
        </.column>
        <.column size="100" md="50">
          <h4>Breakpoints</h4>
          <.table rows={[
            %{prefix: "sm", width: "576px", example: "pa-col-sm-50"},
            %{prefix: "md", width: "768px", example: "pa-col-md-50"},
            %{prefix: "lg", width: "992px", example: "pa-col-lg-50"},
            %{prefix: "xl", width: "1200px", example: "pa-col-xl-50"}
          ]} is_striped>
            <:col :let={row} label="Prefix"><.code>{row.prefix}</.code></:col>
            <:col :let={row} label="Min Width">{row.width}</:col>
            <:col :let={row} label="Example"><.code>{row.example}</.code></:col>
          </.table>
        </.column>
      </.grid>
    </.card>

    <%!-- Basic Usage --%>
    <.card title_text="Basic Usage">
      <:subtitle>Auto-equal width columns with <.code>.pa-col</.code></:subtitle>
      <h4>Two Equal Columns</h4>
      <.grid class="mb-4">
        <.column>
          <div class="grid-demo-cell">.pa-col</div>
        </.column>
        <.column>
          <div class="grid-demo-cell">.pa-col</div>
        </.column>
      </.grid>

      <h4>Three Equal Columns</h4>
      <.grid class="mb-4">
        <.column>
          <div class="grid-demo-cell">.pa-col</div>
        </.column>
        <.column>
          <div class="grid-demo-cell">.pa-col</div>
        </.column>
        <.column>
          <div class="grid-demo-cell">.pa-col</div>
        </.column>
      </.grid>

      <h4>Four Equal Columns</h4>
      <.grid class="mb-4">
        <.column>
          <div class="grid-demo-cell">.pa-col</div>
        </.column>
        <.column>
          <div class="grid-demo-cell">.pa-col</div>
        </.column>
        <.column>
          <div class="grid-demo-cell">.pa-col</div>
        </.column>
        <.column>
          <div class="grid-demo-cell">.pa-col</div>
        </.column>
      </.grid>

      <h4>Auto Width Column</h4>
      <.grid>
        <.column>
          <div class="grid-demo-cell">.pa-col (fills remaining)</div>
        </.column>
        <.column size="auto">
          <div class="grid-demo-cell">.pa-col-auto (content width)</div>
        </.column>
      </.grid>
    </.card>

    <%!-- Percentage Columns --%>
    <.card title_text="Percentage Columns">
      <:subtitle>Fixed widths in 5% increments: <.code>.pa-col-5</.code> through <.code>.pa-col-100</.code></:subtitle>
      <.grid class="mb-2">
        <.column size="25"><div class="grid-demo-cell">.pa-col-25</div></.column>
        <.column size="75"><div class="grid-demo-cell">.pa-col-75</div></.column>
      </.grid>
      <.grid class="mb-2">
        <.column size="1-3"><div class="grid-demo-cell">.pa-col-1-3</div></.column>
        <.column size="2-3"><div class="grid-demo-cell">.pa-col-2-3</div></.column>
      </.grid>
      <.grid class="mb-2">
        <.column size="50"><div class="grid-demo-cell">.pa-col-50</div></.column>
        <.column size="50"><div class="grid-demo-cell">.pa-col-50</div></.column>
      </.grid>
      <.grid class="mb-2">
        <.column size="40"><div class="grid-demo-cell">.pa-col-40</div></.column>
        <.column size="60"><div class="grid-demo-cell">.pa-col-60</div></.column>
      </.grid>
      <.grid class="mb-2">
        <.column size="20"><div class="grid-demo-cell">20</div></.column>
        <.column size="20"><div class="grid-demo-cell">20</div></.column>
        <.column size="20"><div class="grid-demo-cell">20</div></.column>
        <.column size="20"><div class="grid-demo-cell">20</div></.column>
        <.column size="20"><div class="grid-demo-cell">20</div></.column>
      </.grid>
      <.grid>
        <.column size="100"><div class="grid-demo-cell">.pa-col-100 (full width)</div></.column>
      </.grid>

      <.alert variant="info" class="mt-4">
        <strong>Available percentages:</strong> 5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60, 65, 70, 75, 80, 85, 90, 95, 100
      </.alert>
    </.card>

    <%!-- Fraction Columns --%>
    <.card title_text="Fraction Columns">
      <:subtitle>Intuitive naming for common layouts: <.code>.pa-col-1-3</.code>, <.code>.pa-col-2-3</.code>, etc.</:subtitle>
      <h4>Halves (1/2)</h4>
      <.grid class="mb-4">
        <.column size="1-2"><div class="grid-demo-cell">.pa-col-1-2 (50%)</div></.column>
        <.column size="1-2"><div class="grid-demo-cell">.pa-col-1-2 (50%)</div></.column>
      </.grid>

      <h4>Thirds (1/3, 2/3)</h4>
      <.grid class="mb-2">
        <.column size="1-3"><div class="grid-demo-cell">.pa-col-1-3 (33.3%)</div></.column>
        <.column size="2-3"><div class="grid-demo-cell">.pa-col-2-3 (66.7%)</div></.column>
      </.grid>
      <.grid class="mb-4">
        <.column size="1-3"><div class="grid-demo-cell">1/3</div></.column>
        <.column size="1-3"><div class="grid-demo-cell">1/3</div></.column>
        <.column size="1-3"><div class="grid-demo-cell">1/3</div></.column>
      </.grid>

      <h4>Quarters (1/4, 3/4)</h4>
      <.grid class="mb-2">
        <.column size="1-4"><div class="grid-demo-cell">.pa-col-1-4 (25%)</div></.column>
        <.column size="3-4"><div class="grid-demo-cell">.pa-col-3-4 (75%)</div></.column>
      </.grid>
      <.grid class="mb-4">
        <.column size="1-4"><div class="grid-demo-cell">1/4</div></.column>
        <.column size="1-4"><div class="grid-demo-cell">1/4</div></.column>
        <.column size="1-4"><div class="grid-demo-cell">1/4</div></.column>
        <.column size="1-4"><div class="grid-demo-cell">1/4</div></.column>
      </.grid>

      <h4>Fifths (1/5, 2/5, 3/5, 4/5)</h4>
      <.grid class="mb-2">
        <.column size="1-5"><div class="grid-demo-cell">1/5</div></.column>
        <.column size="4-5"><div class="grid-demo-cell">4/5</div></.column>
      </.grid>
      <.grid class="mb-4">
        <.column size="2-5"><div class="grid-demo-cell">2/5</div></.column>
        <.column size="3-5"><div class="grid-demo-cell">3/5</div></.column>
      </.grid>

      <h4>Sixths (1/6, 5/6)</h4>
      <.grid class="mb-2">
        <.column size="1-6"><div class="grid-demo-cell">1/6</div></.column>
        <.column size="5-6"><div class="grid-demo-cell">5/6</div></.column>
      </.grid>
      <.grid class="mb-4">
        <.column size="1-6"><div class="grid-demo-cell">1/6</div></.column>
        <.column size="1-6"><div class="grid-demo-cell">1/6</div></.column>
        <.column size="1-6"><div class="grid-demo-cell">1/6</div></.column>
        <.column size="1-6"><div class="grid-demo-cell">1/6</div></.column>
        <.column size="1-6"><div class="grid-demo-cell">1/6</div></.column>
        <.column size="1-6"><div class="grid-demo-cell">1/6</div></.column>
      </.grid>

      <h4>Twelfths (1/12, 5/12, 7/12, 11/12)</h4>
      <.grid class="mb-2">
        <.column size="1-12"><div class="grid-demo-cell">1/12</div></.column>
        <.column size="11-12"><div class="grid-demo-cell">11/12</div></.column>
      </.grid>
      <.grid>
        <.column size="5-12"><div class="grid-demo-cell">5/12</div></.column>
        <.column size="7-12"><div class="grid-demo-cell">7/12</div></.column>
      </.grid>
    </.card>

    <%!-- Responsive Grid --%>
    <.card title_text="Responsive Grid" subtitle_text="Stack on mobile, columns on larger screens. Resize your browser to see the effect.">
      <h4>Mobile-First Pattern</h4>
      <.paragraph class="pa-text--secondary mb-2">Full width on mobile, 50% on medium screens and up:</.paragraph>
      <.grid class="mb-4">
        <.column size="100" md="50"><div class="grid-demo-cell">.pa-col-100 .pa-col-md-50</div></.column>
        <.column size="100" md="50"><div class="grid-demo-cell">.pa-col-100 .pa-col-md-50</div></.column>
      </.grid>

      <h4>Progressive Columns</h4>
      <.paragraph class="pa-text--secondary mb-2">Different layouts at each breakpoint:</.paragraph>
      <.grid class="mb-4">
        <.column size="100" sm="50" lg="25">
          <div class="grid-demo-cell">100% &rarr; 50% &rarr; 25%</div>
        </.column>
        <.column size="100" sm="50" lg="25">
          <div class="grid-demo-cell">100% &rarr; 50% &rarr; 25%</div>
        </.column>
        <.column size="100" sm="50" lg="25">
          <div class="grid-demo-cell">100% &rarr; 50% &rarr; 25%</div>
        </.column>
        <.column size="100" sm="50" lg="25">
          <div class="grid-demo-cell">100% &rarr; 50% &rarr; 25%</div>
        </.column>
      </.grid>

      <h4>Responsive Fractions</h4>
      <.paragraph class="pa-text--secondary mb-2">Fractions also support breakpoints:</.paragraph>
      <.grid>
        <.column size="100" md="1-3"><div class="grid-demo-cell">.pa-col-100 .pa-col-md-1-3</div></.column>
        <.column size="100" md="2-3"><div class="grid-demo-cell">.pa-col-100 .pa-col-md-2-3</div></.column>
      </.grid>
    </.card>

    <%!-- Offsets --%>
    <.card title_text="Offsets">
      <:subtitle>Push columns with left margin: <.code>.pa-offset-{"{size}"}</.code></:subtitle>
      <h4>Centering with Offsets</h4>
      <.grid class="mb-2">
        <.column size="50" offset="25"><div class="grid-demo-cell">.pa-col-50 .pa-offset-25</div></.column>
      </.grid>
      <.grid class="mb-4">
        <.column size="1-3" class="pa-offset-33"><div class="grid-demo-cell">.pa-col-1-3 .pa-offset-33</div></.column>
      </.grid>

      <h4>Asymmetric Layouts</h4>
      <.grid>
        <.column size="30" offset="10"><div class="grid-demo-cell">.pa-col-30 .pa-offset-10</div></.column>
        <.column size="40" offset="10"><div class="grid-demo-cell">.pa-col-40 .pa-offset-10</div></.column>
      </.grid>
    </.card>

    <%!-- Row Alignment --%>
    <.card title_text="Row Alignment" subtitle_text="Control horizontal and vertical alignment of columns">
      <h4>Horizontal Alignment</h4>

      <.paragraph class="pa-text--secondary mb-2"><.code>.pa-row--center</.code></.paragraph>
      <.grid align="center" class="mb-2" style="background: var(--base-primary-bg);">
        <.column size="30"><div class="grid-demo-cell">Centered</div></.column>
      </.grid>

      <.paragraph class="pa-text--secondary mb-2"><.code>.pa-row--end</.code></.paragraph>
      <.grid align="end" class="mb-2" style="background: var(--base-primary-bg);">
        <.column size="30"><div class="grid-demo-cell">Right aligned</div></.column>
      </.grid>

      <.paragraph class="pa-text--secondary mb-2"><.code>.pa-row--between</.code></.paragraph>
      <.grid align="between" class="mb-2" style="background: var(--base-primary-bg);">
        <.column size="20"><div class="grid-demo-cell">Left</div></.column>
        <.column size="20"><div class="grid-demo-cell">Right</div></.column>
      </.grid>

      <.paragraph class="pa-text--secondary mb-2"><.code>.pa-row--around</.code></.paragraph>
      <.grid align="around" class="mb-4" style="background: var(--base-primary-bg);">
        <.column size="20"><div class="grid-demo-cell">A</div></.column>
        <.column size="20"><div class="grid-demo-cell">B</div></.column>
        <.column size="20"><div class="grid-demo-cell">C</div></.column>
      </.grid>

      <h4>Vertical Alignment</h4>
      <.grid>
        <.column size="100" md="1-3">
          <.paragraph class="pa-text--secondary mb-2"><.code>.pa-row--top</.code></.paragraph>
          <.grid valign="top" style="background: var(--base-primary-bg); min-height: 100px;">
            <.column><div class="grid-demo-cell">Top</div></.column>
            <.column><div class="grid-demo-cell">Top</div></.column>
          </.grid>
        </.column>
        <.column size="100" md="1-3">
          <.paragraph class="pa-text--secondary mb-2"><.code>.pa-row--middle</.code></.paragraph>
          <.grid valign="middle" style="background: var(--base-primary-bg); min-height: 100px;">
            <.column><div class="grid-demo-cell">Middle</div></.column>
            <.column><div class="grid-demo-cell">Middle</div></.column>
          </.grid>
        </.column>
        <.column size="100" md="1-3">
          <.paragraph class="pa-text--secondary mb-2"><.code>.pa-row--bottom</.code></.paragraph>
          <.grid valign="bottom" style="background: var(--base-primary-bg); min-height: 100px;">
            <.column><div class="grid-demo-cell">Bottom</div></.column>
            <.column><div class="grid-demo-cell">Bottom</div></.column>
          </.grid>
        </.column>
      </.grid>
    </.card>

    <%!-- No Gutter --%>
    <.card title_text="No Gutter">
      <:subtitle>Remove spacing between columns with <.code>.pa-row--no-gutter</.code></:subtitle>
      <h4>Default (with gutter)</h4>
      <.grid class="mb-4">
        <.column size="1-3"><div class="grid-demo-cell">1/3</div></.column>
        <.column size="1-3"><div class="grid-demo-cell">1/3</div></.column>
        <.column size="1-3"><div class="grid-demo-cell">1/3</div></.column>
      </.grid>

      <h4>No Gutter</h4>
      <.grid is_no_gutter>
        <.column size="1-3"><div class="grid-demo-cell">1/3</div></.column>
        <.column size="1-3"><div class="grid-demo-cell">1/3</div></.column>
        <.column size="1-3"><div class="grid-demo-cell">1/3</div></.column>
      </.grid>
    </.card>

    <%!-- Visibility Utilities --%>
    <.card title_text="Visibility Utilities" subtitle_text="Show/hide elements at different breakpoints">
      <.table rows={[
        %{class: ".pa-hide", desc: "Always hidden"},
        %{class: ".pa-show", desc: "Always visible"},
        %{class: ".pa-hide-{bp}", desc: "Hidden at breakpoint and up"},
        %{class: ".pa-show-{bp}", desc: "Visible at breakpoint and up"},
        %{class: ".pa-hide-below-{bp}", desc: "Hidden below breakpoint"},
        %{class: ".pa-show-below-{bp}", desc: "Visible below breakpoint"}
      ]} is_striped class="mb-4">
        <:col :let={row} label="Class"><.code>{row.class}</.code></:col>
        <:col :let={row} label="Description">{row.desc}</:col>
      </.table>

      <h4>Live Demo (resize browser)</h4>
      <.grid>
        <.column>
          <div class="grid-demo-cell pa-hide-md" style="background: var(--base-danger-color);">
            <strong>Mobile Only</strong><br />.pa-hide-md
          </div>
          <div class="grid-demo-cell pa-hide-below-md" style="background: var(--base-success-color);">
            <strong>Desktop Only</strong><br />.pa-hide-below-md
          </div>
        </.column>
      </.grid>
    </.card>

    <%!-- Nested Grids --%>
    <.card title_text="Nested Grids" subtitle_text="Grids can be nested inside columns">
      <.grid>
        <.column size="1-3">
          <div class="grid-demo-cell">1/3</div>
        </.column>
        <.column size="2-3">
          <div style="background: var(--base-primary-bg); padding: 0.8rem; border-radius: 4px;">
            <p class="pa-text pa-text--secondary mb-2">Nested grid inside 2/3 column:</p>
            <.grid>
              <.column size="1-2"><div class="grid-demo-cell" style="background: var(--base-text-color-2);">Nested 1/2</div></.column>
              <.column size="1-2"><div class="grid-demo-cell" style="background: var(--base-text-color-2);">Nested 1/2</div></.column>
            </.grid>
          </div>
        </.column>
      </.grid>
    </.card>

    <%!-- Quick Reference --%>
    <.card title_text="Quick Reference">
      <.grid>
        <.column size="100" md="50">
          <h4>Percentage Classes</h4>
          <.paragraph class="pa-text--secondary">
            <.code>.pa-col-5</.code> <.code>.pa-col-10</.code> <.code>.pa-col-15</.code> <.code>.pa-col-20</.code> <.code>.pa-col-25</.code><br />
            <.code>.pa-col-30</.code> <.code>.pa-col-35</.code> <.code>.pa-col-40</.code> <.code>.pa-col-45</.code> <.code>.pa-col-50</.code><br />
            <.code>.pa-col-55</.code> <.code>.pa-col-60</.code> <.code>.pa-col-65</.code> <.code>.pa-col-70</.code> <.code>.pa-col-75</.code><br />
            <.code>.pa-col-80</.code> <.code>.pa-col-85</.code> <.code>.pa-col-90</.code> <.code>.pa-col-95</.code> <.code>.pa-col-100</.code>
          </.paragraph>
        </.column>
        <.column size="100" md="50">
          <h4>Fraction Classes</h4>
          <.paragraph class="pa-text--secondary">
            <.code>.pa-col-1-2</.code><br />
            <.code>.pa-col-1-3</.code> <.code>.pa-col-2-3</.code><br />
            <.code>.pa-col-1-4</.code> <.code>.pa-col-3-4</.code><br />
            <.code>.pa-col-1-5</.code> <.code>.pa-col-2-5</.code> <.code>.pa-col-3-5</.code> <.code>.pa-col-4-5</.code><br />
            <.code>.pa-col-1-6</.code> <.code>.pa-col-5-6</.code><br />
            <.code>.pa-col-1-12</.code> <.code>.pa-col-5-12</.code> <.code>.pa-col-7-12</.code> <.code>.pa-col-11-12</.code>
          </.paragraph>
        </.column>
      </.grid>
    </.card>

    <%!-- Code Examples --%>
    <.card title_text="Code Examples">
      <.grid>
        <.column size="100" md="50">
          <h4 class="mb-2">Basic Grid</h4>
          <.code_block language="heex"><%= @code_examples.basic %></.code_block>
        </.column>
        <.column size="100" md="50">
          <h4 class="mb-2">Responsive Grid</h4>
          <.code_block language="heex"><%= @code_examples.responsive %></.code_block>
        </.column>
      </.grid>

      <.grid class="mt-4">
        <.column size="100" md="50">
          <h4 class="mb-2">Grid Props</h4>
          <.code_block language="heex"><%= @code_examples.grid_props %></.code_block>
        </.column>
        <.column size="100" md="50">
          <h4 class="mb-2">Column Props</h4>
          <.code_block language="heex"><%= @code_examples.column_props %></.code_block>
        </.column>
      </.grid>
    </.card>
    """
  end
end
