defmodule DemoWeb.Live.DataVisualizationLive do
  use DemoWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, page_title: "Data Visualization")}
  end

  def render(assigns) do
    ~H"""
    <h1 class="pa-page-title">Data Visualization</h1>
    <p class="pa-page-subtitle">CSS-only data visualization components for dashboards and reports.</p>

    <%!-- 1. Progress Bars --%>
    <.card title_text="Progress Bars">
      <.paragraph>Default progress bars with labels.</.paragraph>

      <div class="pa-progress-group" style="margin-bottom: 1rem;">
        <div class="pa-progress__label">Storage Usage — 65%</div>
        <div class="pa-progress">
          <div class="pa-progress__fill" style="--value: 65%"></div>
        </div>
      </div>

      <div class="pa-progress-group" style="margin-bottom: 1rem;">
        <div class="pa-progress__label">Bandwidth — 42%</div>
        <div class="pa-progress">
          <div class="pa-progress__fill" style="--value: 42%"></div>
        </div>
      </div>

      <div class="pa-progress-group" style="margin-bottom: 2rem;">
        <div class="pa-progress__label">CPU Load — 87%</div>
        <div class="pa-progress">
          <div class="pa-progress__fill" style="--value: 87%"></div>
        </div>
      </div>

      <.paragraph>Color Variants</.paragraph>
      <.grid>
        <.column size="50">
          <div class="pa-progress-group" style="margin-bottom: 0.5rem;">
            <div class="pa-progress__label">Primary (default) — 60%</div>
            <div class="pa-progress">
              <div class="pa-progress__fill" style="--value: 60%"></div>
            </div>
          </div>
          <div class="pa-progress-group" style="margin-bottom: 0.5rem;">
            <div class="pa-progress__label">Success — 75%</div>
            <div class="pa-progress pa-progress--success">
              <div class="pa-progress__fill" style="--value: 75%"></div>
            </div>
          </div>
          <div class="pa-progress-group" style="margin-bottom: 0.5rem;">
            <div class="pa-progress__label">Warning — 50%</div>
            <div class="pa-progress pa-progress--warning">
              <div class="pa-progress__fill" style="--value: 50%"></div>
            </div>
          </div>
          <div class="pa-progress-group" style="margin-bottom: 0.5rem;">
            <div class="pa-progress__label">Danger — 90%</div>
            <div class="pa-progress pa-progress--danger">
              <div class="pa-progress__fill" style="--value: 90%"></div>
            </div>
          </div>
          <div class="pa-progress-group" style="margin-bottom: 0.5rem;">
            <div class="pa-progress__label">Info — 35%</div>
            <div class="pa-progress pa-progress--info">
              <div class="pa-progress__fill" style="--value: 35%"></div>
            </div>
          </div>
        </.column>
      </.grid>

      <.paragraph>Sizes</.paragraph>
      <div class="pa-progress-group" style="margin-bottom: 0.5rem;">
        <div class="pa-progress__label">Extra Small (xs)</div>
        <div class="pa-progress pa-progress--xs">
          <div class="pa-progress__fill" style="--value: 55%"></div>
        </div>
      </div>
      <div class="pa-progress-group" style="margin-bottom: 0.5rem;">
        <div class="pa-progress__label">Small (sm)</div>
        <div class="pa-progress pa-progress--sm">
          <div class="pa-progress__fill" style="--value: 55%"></div>
        </div>
      </div>
      <div class="pa-progress-group" style="margin-bottom: 0.5rem;">
        <div class="pa-progress__label">Default</div>
        <div class="pa-progress">
          <div class="pa-progress__fill" style="--value: 55%"></div>
        </div>
      </div>
      <div class="pa-progress-group" style="margin-bottom: 0.5rem;">
        <div class="pa-progress__label">Large (lg)</div>
        <div class="pa-progress pa-progress--lg">
          <div class="pa-progress__fill" style="--value: 55%"></div>
        </div>
      </div>

      <.paragraph>Striped &amp; Animated</.paragraph>
      <div class="pa-progress-group" style="margin-bottom: 0.5rem;">
        <div class="pa-progress__label">Striped — 70%</div>
        <div class="pa-progress pa-progress--striped">
          <div class="pa-progress__fill" style="--value: 70%"></div>
        </div>
      </div>
      <div class="pa-progress-group" style="margin-bottom: 0.5rem;">
        <div class="pa-progress__label">Striped + Animated — 60%</div>
        <div class="pa-progress pa-progress--striped pa-progress--animated">
          <div class="pa-progress__fill" style="--value: 60%"></div>
        </div>
      </div>
      <div class="pa-progress-group" style="margin-bottom: 0.5rem;">
        <div class="pa-progress__label">Striped Success — 80%</div>
        <div class="pa-progress pa-progress--striped pa-progress--animated pa-progress--success">
          <div class="pa-progress__fill" style="--value: 80%"></div>
        </div>
      </div>

      <.paragraph>Rounded</.paragraph>
      <div class="pa-progress-group" style="margin-bottom: 0.5rem;">
        <div class="pa-progress__label">Rounded — 45%</div>
        <div class="pa-progress pa-progress--rounded">
          <div class="pa-progress__fill" style="--value: 45%"></div>
        </div>
      </div>
      <div class="pa-progress-group" style="margin-bottom: 0.5rem;">
        <div class="pa-progress__label">Rounded + Striped — 65%</div>
        <div class="pa-progress pa-progress--rounded pa-progress--striped pa-progress--animated">
          <div class="pa-progress__fill" style="--value: 65%"></div>
        </div>
      </div>
    </.card>

    <%!-- 2. Stacked Bars --%>
    <.card title_text="Stacked Bars">
      <.paragraph>Disk Usage</.paragraph>
      <div class="pa-stacked-bar" style="margin-bottom: 0.75rem;">
        <div class="pa-stacked-bar__segment pa-stacked-bar__segment--primary" style="--value: 35%" title="System (35%)"></div>
        <div class="pa-stacked-bar__segment pa-stacked-bar__segment--success" style="--value: 25%" title="Apps (25%)"></div>
        <div class="pa-stacked-bar__segment pa-stacked-bar__segment--warning" style="--value: 20%" title="Media (20%)"></div>
        <div class="pa-stacked-bar__segment pa-stacked-bar__segment--danger" style="--value: 10%" title="Logs (10%)"></div>
      </div>
      <div style="display: flex; gap: 1rem; flex-wrap: wrap; margin-bottom: 2rem;">
        <span><.badge variant="primary">System — 35%</.badge></span>
        <span><.badge variant="success">Apps — 25%</.badge></span>
        <span><.badge variant="warning">Media — 20%</.badge></span>
        <span><.badge variant="danger">Logs — 10%</.badge></span>
        <span><.badge>Free — 10%</.badge></span>
      </div>

      <.paragraph>Browser Share (Rounded, Large)</.paragraph>
      <div class="pa-stacked-bar pa-stacked-bar--rounded pa-stacked-bar--lg" style="margin-bottom: 0.75rem;">
        <div class="pa-stacked-bar__segment pa-stacked-bar__segment--primary" style="--value: 40%" title="Chrome (40%)"></div>
        <div class="pa-stacked-bar__segment pa-stacked-bar__segment--success" style="--value: 22%" title="Safari (22%)"></div>
        <div class="pa-stacked-bar__segment pa-stacked-bar__segment--warning" style="--value: 18%" title="Firefox (18%)"></div>
        <div class="pa-stacked-bar__segment pa-stacked-bar__segment--info" style="--value: 12%" title="Edge (12%)"></div>
        <div class="pa-stacked-bar__segment pa-stacked-bar__segment--danger" style="--value: 8%" title="Other (8%)"></div>
      </div>
      <div style="display: flex; gap: 1rem; flex-wrap: wrap;">
        <span><.badge variant="primary">Chrome — 40%</.badge></span>
        <span><.badge variant="success">Safari — 22%</.badge></span>
        <span><.badge variant="warning">Firefox — 18%</.badge></span>
        <span><.badge variant="info">Edge — 12%</.badge></span>
        <span><.badge variant="danger">Other — 8%</.badge></span>
      </div>
    </.card>

    <%!-- 3. Progress Rings --%>
    <.card title_text="Progress Rings">
      <.paragraph>Color Variants</.paragraph>
      <.grid>
        <.column size="20">
          <div style="display: flex; justify-content: center;">
            <div class="pa-progress-ring" style="--value: 72">
              <div class="pa-progress-ring__inner">
                <span class="pa-progress-ring__value">72%</span>
                <span class="pa-progress-ring__label">Primary</span>
              </div>
            </div>
          </div>
        </.column>
        <.column size="20">
          <div style="display: flex; justify-content: center;">
            <div class="pa-progress-ring pa-progress-ring--success" style="--value: 88">
              <div class="pa-progress-ring__inner">
                <span class="pa-progress-ring__value">88%</span>
                <span class="pa-progress-ring__label">Success</span>
              </div>
            </div>
          </div>
        </.column>
        <.column size="20">
          <div style="display: flex; justify-content: center;">
            <div class="pa-progress-ring pa-progress-ring--warning" style="--value: 55">
              <div class="pa-progress-ring__inner">
                <span class="pa-progress-ring__value">55%</span>
                <span class="pa-progress-ring__label">Warning</span>
              </div>
            </div>
          </div>
        </.column>
        <.column size="20">
          <div style="display: flex; justify-content: center;">
            <div class="pa-progress-ring pa-progress-ring--danger" style="--value: 31">
              <div class="pa-progress-ring__inner">
                <span class="pa-progress-ring__value">31%</span>
                <span class="pa-progress-ring__label">Danger</span>
              </div>
            </div>
          </div>
        </.column>
        <.column size="20">
          <div style="display: flex; justify-content: center;">
            <div class="pa-progress-ring pa-progress-ring--info" style="--value: 63">
              <div class="pa-progress-ring__inner">
                <span class="pa-progress-ring__value">63%</span>
                <span class="pa-progress-ring__label">Info</span>
              </div>
            </div>
          </div>
        </.column>
      </.grid>

      <.paragraph>Sizes</.paragraph>
      <.grid>
        <.column size="1-3">
          <div style="display: flex; justify-content: center;">
            <div class="pa-progress-ring pa-progress-ring--sm" style="--value: 45">
              <div class="pa-progress-ring__inner">
                <span class="pa-progress-ring__value">45%</span>
                <span class="pa-progress-ring__label">Small</span>
              </div>
            </div>
          </div>
        </.column>
        <.column size="1-3">
          <div style="display: flex; justify-content: center;">
            <div class="pa-progress-ring" style="--value: 60">
              <div class="pa-progress-ring__inner">
                <span class="pa-progress-ring__value">60%</span>
                <span class="pa-progress-ring__label">Default</span>
              </div>
            </div>
          </div>
        </.column>
        <.column size="1-3">
          <div style="display: flex; justify-content: center;">
            <div class="pa-progress-ring pa-progress-ring--lg" style="--value: 78">
              <div class="pa-progress-ring__inner">
                <span class="pa-progress-ring__value">78%</span>
                <span class="pa-progress-ring__label">Large</span>
              </div>
            </div>
          </div>
        </.column>
      </.grid>
    </.card>

    <%!-- 4. Dashboard Gauges --%>
    <.card title_text="Dashboard Gauges">
      <.grid>
        <.column size="25">
          <div style="display: flex; justify-content: center;">
            <div class="pa-gauge" style="--value: 72">
              <div class="pa-gauge__inner">
                <span class="pa-gauge__value">72%</span>
                <span class="pa-gauge__label">CPU</span>
              </div>
              <span class="pa-gauge__min">0</span>
              <span class="pa-gauge__max">100</span>
            </div>
          </div>
        </.column>
        <.column size="25">
          <div style="display: flex; justify-content: center;">
            <div class="pa-gauge pa-gauge--success" style="--value: 48">
              <div class="pa-gauge__inner">
                <span class="pa-gauge__value">48%</span>
                <span class="pa-gauge__label">Memory</span>
              </div>
              <span class="pa-gauge__min">0</span>
              <span class="pa-gauge__max">100</span>
            </div>
          </div>
        </.column>
        <.column size="25">
          <div style="display: flex; justify-content: center;">
            <div class="pa-gauge pa-gauge--danger" style="--value: 89">
              <div class="pa-gauge__inner">
                <span class="pa-gauge__value">89°C</span>
                <span class="pa-gauge__label">Temp</span>
              </div>
              <span class="pa-gauge__min">0</span>
              <span class="pa-gauge__max">100</span>
            </div>
          </div>
        </.column>
        <.column size="25">
          <div style="display: flex; justify-content: center;">
            <div class="pa-gauge pa-gauge--zones" style="--value: 62">
              <div class="pa-gauge__inner">
                <span class="pa-gauge__value">62</span>
                <span class="pa-gauge__label">Speed</span>
              </div>
              <span class="pa-gauge__min">0</span>
              <span class="pa-gauge__max">100</span>
            </div>
          </div>
        </.column>
      </.grid>
    </.card>

    <%!-- 5. Data Bars in Tables --%>
    <.card title_text="Data Bars in Tables">
      <table class="pa-table pa-table--striped pa-table--hover">
        <thead>
          <tr>
            <th>Sales Rep</th>
            <th>Region</th>
            <th>Revenue</th>
            <th style="width: 40%;">Performance</th>
          </tr>
        </thead>
        <tbody>
          <tr>
            <td>Alice Johnson</td>
            <td>North</td>
            <td>$95,400</td>
            <td>
              <div class="pa-data-bar pa-data-bar--success">
                <div class="pa-data-bar__track">
                  <div class="pa-data-bar__fill" style="--value: 95%"></div>
                </div>
              </div>
            </td>
          </tr>
          <tr>
            <td>Bob Smith</td>
            <td>East</td>
            <td>$82,100</td>
            <td>
              <div class="pa-data-bar pa-data-bar--primary">
                <div class="pa-data-bar__track">
                  <div class="pa-data-bar__fill" style="--value: 82%"></div>
                </div>
              </div>
            </td>
          </tr>
          <tr>
            <td>Carol Davis</td>
            <td>South</td>
            <td>$67,300</td>
            <td>
              <div class="pa-data-bar pa-data-bar--warning">
                <div class="pa-data-bar__track">
                  <div class="pa-data-bar__fill" style="--value: 67%"></div>
                </div>
              </div>
            </td>
          </tr>
          <tr>
            <td>Dan Wilson</td>
            <td>West</td>
            <td>$41,800</td>
            <td>
              <div class="pa-data-bar pa-data-bar--danger">
                <div class="pa-data-bar__track">
                  <div class="pa-data-bar__fill" style="--value: 42%"></div>
                </div>
              </div>
            </td>
          </tr>
          <tr>
            <td>Eve Martinez</td>
            <td>Central</td>
            <td>$73,600</td>
            <td>
              <div class="pa-data-bar pa-data-bar--info">
                <div class="pa-data-bar__track">
                  <div class="pa-data-bar__fill" style="--value: 74%"></div>
                </div>
              </div>
            </td>
          </tr>
        </tbody>
      </table>
    </.card>

    <%!-- 6. Activity Heatmap --%>
    <.card title_text="Activity Heatmap">
      <.paragraph>Default</.paragraph>
      <div class="pa-heatmap" style="grid-template-columns: repeat(12, 1.2rem); margin-bottom: 0.5rem;">
        <%!-- Week 1 (7 days) --%>
        <div class="pa-heatmap__cell" data-level="0"></div>
        <div class="pa-heatmap__cell" data-level="1"></div>
        <div class="pa-heatmap__cell" data-level="2"></div>
        <div class="pa-heatmap__cell" data-level="0"></div>
        <div class="pa-heatmap__cell" data-level="1"></div>
        <div class="pa-heatmap__cell" data-level="3"></div>
        <div class="pa-heatmap__cell" data-level="0"></div>
        <%!-- Week 2 --%>
        <div class="pa-heatmap__cell" data-level="1"></div>
        <div class="pa-heatmap__cell" data-level="2"></div>
        <div class="pa-heatmap__cell" data-level="3"></div>
        <div class="pa-heatmap__cell" data-level="4"></div>
        <div class="pa-heatmap__cell" data-level="2"></div>
        <div class="pa-heatmap__cell" data-level="1"></div>
        <div class="pa-heatmap__cell" data-level="0"></div>
        <%!-- Week 3 --%>
        <div class="pa-heatmap__cell" data-level="0"></div>
        <div class="pa-heatmap__cell" data-level="0"></div>
        <div class="pa-heatmap__cell" data-level="1"></div>
        <div class="pa-heatmap__cell" data-level="2"></div>
        <div class="pa-heatmap__cell" data-level="3"></div>
        <div class="pa-heatmap__cell" data-level="4"></div>
        <div class="pa-heatmap__cell" data-level="4"></div>
        <%!-- Week 4 --%>
        <div class="pa-heatmap__cell" data-level="2"></div>
        <div class="pa-heatmap__cell" data-level="3"></div>
        <div class="pa-heatmap__cell" data-level="1"></div>
        <div class="pa-heatmap__cell" data-level="0"></div>
        <div class="pa-heatmap__cell" data-level="2"></div>
        <div class="pa-heatmap__cell" data-level="3"></div>
        <div class="pa-heatmap__cell" data-level="1"></div>
        <%!-- Week 5 --%>
        <div class="pa-heatmap__cell" data-level="4"></div>
        <div class="pa-heatmap__cell" data-level="4"></div>
        <div class="pa-heatmap__cell" data-level="3"></div>
        <div class="pa-heatmap__cell" data-level="2"></div>
        <div class="pa-heatmap__cell" data-level="1"></div>
        <div class="pa-heatmap__cell" data-level="0"></div>
        <div class="pa-heatmap__cell" data-level="1"></div>
        <%!-- Week 6 --%>
        <div class="pa-heatmap__cell" data-level="0"></div>
        <div class="pa-heatmap__cell" data-level="1"></div>
        <div class="pa-heatmap__cell" data-level="3"></div>
        <div class="pa-heatmap__cell" data-level="4"></div>
        <div class="pa-heatmap__cell" data-level="2"></div>
        <div class="pa-heatmap__cell" data-level="1"></div>
        <div class="pa-heatmap__cell" data-level="0"></div>
        <%!-- Week 7 --%>
        <div class="pa-heatmap__cell" data-level="2"></div>
        <div class="pa-heatmap__cell" data-level="1"></div>
        <div class="pa-heatmap__cell" data-level="0"></div>
        <div class="pa-heatmap__cell" data-level="3"></div>
        <div class="pa-heatmap__cell" data-level="4"></div>
        <div class="pa-heatmap__cell" data-level="2"></div>
        <div class="pa-heatmap__cell" data-level="1"></div>
        <%!-- Week 8 --%>
        <div class="pa-heatmap__cell" data-level="1"></div>
        <div class="pa-heatmap__cell" data-level="0"></div>
        <div class="pa-heatmap__cell" data-level="2"></div>
        <div class="pa-heatmap__cell" data-level="3"></div>
        <div class="pa-heatmap__cell" data-level="1"></div>
        <div class="pa-heatmap__cell" data-level="4"></div>
        <div class="pa-heatmap__cell" data-level="3"></div>
        <%!-- Week 9 --%>
        <div class="pa-heatmap__cell" data-level="3"></div>
        <div class="pa-heatmap__cell" data-level="2"></div>
        <div class="pa-heatmap__cell" data-level="4"></div>
        <div class="pa-heatmap__cell" data-level="1"></div>
        <div class="pa-heatmap__cell" data-level="0"></div>
        <div class="pa-heatmap__cell" data-level="2"></div>
        <div class="pa-heatmap__cell" data-level="3"></div>
        <%!-- Week 10 --%>
        <div class="pa-heatmap__cell" data-level="0"></div>
        <div class="pa-heatmap__cell" data-level="1"></div>
        <div class="pa-heatmap__cell" data-level="1"></div>
        <div class="pa-heatmap__cell" data-level="2"></div>
        <div class="pa-heatmap__cell" data-level="4"></div>
        <div class="pa-heatmap__cell" data-level="3"></div>
        <div class="pa-heatmap__cell" data-level="2"></div>
        <%!-- Week 11 --%>
        <div class="pa-heatmap__cell" data-level="1"></div>
        <div class="pa-heatmap__cell" data-level="3"></div>
        <div class="pa-heatmap__cell" data-level="2"></div>
        <div class="pa-heatmap__cell" data-level="0"></div>
        <div class="pa-heatmap__cell" data-level="1"></div>
        <div class="pa-heatmap__cell" data-level="4"></div>
        <div class="pa-heatmap__cell" data-level="3"></div>
        <%!-- Week 12 --%>
        <div class="pa-heatmap__cell" data-level="2"></div>
        <div class="pa-heatmap__cell" data-level="4"></div>
        <div class="pa-heatmap__cell" data-level="3"></div>
        <div class="pa-heatmap__cell" data-level="1"></div>
        <div class="pa-heatmap__cell" data-level="0"></div>
        <div class="pa-heatmap__cell" data-level="2"></div>
        <div class="pa-heatmap__cell" data-level="1"></div>
      </div>
      <div class="pa-heatmap__legend">
        <span>Less</span>
        <div class="pa-heatmap__cell" data-level="0"></div>
        <div class="pa-heatmap__cell" data-level="1"></div>
        <div class="pa-heatmap__cell" data-level="2"></div>
        <div class="pa-heatmap__cell" data-level="3"></div>
        <div class="pa-heatmap__cell" data-level="4"></div>
        <span>More</span>
      </div>

      <.paragraph>Success Color Variant</.paragraph>
      <div class="pa-heatmap pa-heatmap--success" style="grid-template-columns: repeat(12, 1.2rem); margin-bottom: 0.5rem;">
        <%!-- Week 1 --%>
        <div class="pa-heatmap__cell" data-level="1"></div>
        <div class="pa-heatmap__cell" data-level="0"></div>
        <div class="pa-heatmap__cell" data-level="3"></div>
        <div class="pa-heatmap__cell" data-level="2"></div>
        <div class="pa-heatmap__cell" data-level="4"></div>
        <div class="pa-heatmap__cell" data-level="1"></div>
        <div class="pa-heatmap__cell" data-level="0"></div>
        <%!-- Week 2 --%>
        <div class="pa-heatmap__cell" data-level="2"></div>
        <div class="pa-heatmap__cell" data-level="3"></div>
        <div class="pa-heatmap__cell" data-level="4"></div>
        <div class="pa-heatmap__cell" data-level="1"></div>
        <div class="pa-heatmap__cell" data-level="0"></div>
        <div class="pa-heatmap__cell" data-level="2"></div>
        <div class="pa-heatmap__cell" data-level="3"></div>
        <%!-- Week 3 --%>
        <div class="pa-heatmap__cell" data-level="4"></div>
        <div class="pa-heatmap__cell" data-level="2"></div>
        <div class="pa-heatmap__cell" data-level="1"></div>
        <div class="pa-heatmap__cell" data-level="0"></div>
        <div class="pa-heatmap__cell" data-level="3"></div>
        <div class="pa-heatmap__cell" data-level="4"></div>
        <div class="pa-heatmap__cell" data-level="2"></div>
        <%!-- Week 4 --%>
        <div class="pa-heatmap__cell" data-level="0"></div>
        <div class="pa-heatmap__cell" data-level="1"></div>
        <div class="pa-heatmap__cell" data-level="3"></div>
        <div class="pa-heatmap__cell" data-level="2"></div>
        <div class="pa-heatmap__cell" data-level="4"></div>
        <div class="pa-heatmap__cell" data-level="1"></div>
        <div class="pa-heatmap__cell" data-level="3"></div>
        <%!-- Week 5 --%>
        <div class="pa-heatmap__cell" data-level="2"></div>
        <div class="pa-heatmap__cell" data-level="4"></div>
        <div class="pa-heatmap__cell" data-level="0"></div>
        <div class="pa-heatmap__cell" data-level="1"></div>
        <div class="pa-heatmap__cell" data-level="3"></div>
        <div class="pa-heatmap__cell" data-level="2"></div>
        <div class="pa-heatmap__cell" data-level="4"></div>
        <%!-- Week 6 --%>
        <div class="pa-heatmap__cell" data-level="1"></div>
        <div class="pa-heatmap__cell" data-level="0"></div>
        <div class="pa-heatmap__cell" data-level="2"></div>
        <div class="pa-heatmap__cell" data-level="3"></div>
        <div class="pa-heatmap__cell" data-level="4"></div>
        <div class="pa-heatmap__cell" data-level="1"></div>
        <div class="pa-heatmap__cell" data-level="2"></div>
        <%!-- Week 7 --%>
        <div class="pa-heatmap__cell" data-level="3"></div>
        <div class="pa-heatmap__cell" data-level="1"></div>
        <div class="pa-heatmap__cell" data-level="4"></div>
        <div class="pa-heatmap__cell" data-level="0"></div>
        <div class="pa-heatmap__cell" data-level="2"></div>
        <div class="pa-heatmap__cell" data-level="3"></div>
        <div class="pa-heatmap__cell" data-level="1"></div>
        <%!-- Week 8 --%>
        <div class="pa-heatmap__cell" data-level="0"></div>
        <div class="pa-heatmap__cell" data-level="2"></div>
        <div class="pa-heatmap__cell" data-level="3"></div>
        <div class="pa-heatmap__cell" data-level="1"></div>
        <div class="pa-heatmap__cell" data-level="4"></div>
        <div class="pa-heatmap__cell" data-level="0"></div>
        <div class="pa-heatmap__cell" data-level="2"></div>
        <%!-- Week 9 --%>
        <div class="pa-heatmap__cell" data-level="4"></div>
        <div class="pa-heatmap__cell" data-level="3"></div>
        <div class="pa-heatmap__cell" data-level="1"></div>
        <div class="pa-heatmap__cell" data-level="2"></div>
        <div class="pa-heatmap__cell" data-level="0"></div>
        <div class="pa-heatmap__cell" data-level="3"></div>
        <div class="pa-heatmap__cell" data-level="4"></div>
        <%!-- Week 10 --%>
        <div class="pa-heatmap__cell" data-level="1"></div>
        <div class="pa-heatmap__cell" data-level="2"></div>
        <div class="pa-heatmap__cell" data-level="0"></div>
        <div class="pa-heatmap__cell" data-level="4"></div>
        <div class="pa-heatmap__cell" data-level="3"></div>
        <div class="pa-heatmap__cell" data-level="1"></div>
        <div class="pa-heatmap__cell" data-level="2"></div>
        <%!-- Week 11 --%>
        <div class="pa-heatmap__cell" data-level="3"></div>
        <div class="pa-heatmap__cell" data-level="4"></div>
        <div class="pa-heatmap__cell" data-level="2"></div>
        <div class="pa-heatmap__cell" data-level="1"></div>
        <div class="pa-heatmap__cell" data-level="0"></div>
        <div class="pa-heatmap__cell" data-level="3"></div>
        <div class="pa-heatmap__cell" data-level="4"></div>
        <%!-- Week 12 --%>
        <div class="pa-heatmap__cell" data-level="2"></div>
        <div class="pa-heatmap__cell" data-level="1"></div>
        <div class="pa-heatmap__cell" data-level="0"></div>
        <div class="pa-heatmap__cell" data-level="3"></div>
        <div class="pa-heatmap__cell" data-level="4"></div>
        <div class="pa-heatmap__cell" data-level="2"></div>
        <div class="pa-heatmap__cell" data-level="1"></div>
      </div>
      <div class="pa-heatmap__legend">
        <span>Less</span>
        <div class="pa-heatmap__cell" data-level="0"></div>
        <div class="pa-heatmap__cell" data-level="1"></div>
        <div class="pa-heatmap__cell" data-level="2"></div>
        <div class="pa-heatmap__cell" data-level="3"></div>
        <div class="pa-heatmap__cell" data-level="4"></div>
        <span>More</span>
      </div>
    </.card>

    <%!-- 7. Sparkline Bars --%>
    <.card title_text="Sparkline Bars">
      <.grid>
        <.column size="25">
          <.paragraph>Default</.paragraph>
          <div class="pa-sparkline">
            <div class="pa-sparkline__bar" style="--value: 40%"></div>
            <div class="pa-sparkline__bar" style="--value: 65%"></div>
            <div class="pa-sparkline__bar" style="--value: 30%"></div>
            <div class="pa-sparkline__bar" style="--value: 80%"></div>
            <div class="pa-sparkline__bar" style="--value: 55%"></div>
            <div class="pa-sparkline__bar" style="--value: 70%"></div>
            <div class="pa-sparkline__bar" style="--value: 45%"></div>
            <div class="pa-sparkline__bar" style="--value: 90%"></div>
            <div class="pa-sparkline__bar" style="--value: 60%"></div>
            <div class="pa-sparkline__bar" style="--value: 35%"></div>
          </div>
        </.column>
        <.column size="25">
          <.paragraph>Success</.paragraph>
          <div class="pa-sparkline pa-sparkline--success">
            <div class="pa-sparkline__bar" style="--value: 50%"></div>
            <div class="pa-sparkline__bar" style="--value: 75%"></div>
            <div class="pa-sparkline__bar" style="--value: 60%"></div>
            <div class="pa-sparkline__bar" style="--value: 85%"></div>
            <div class="pa-sparkline__bar" style="--value: 70%"></div>
            <div class="pa-sparkline__bar" style="--value: 90%"></div>
            <div class="pa-sparkline__bar" style="--value: 80%"></div>
            <div class="pa-sparkline__bar" style="--value: 95%"></div>
            <div class="pa-sparkline__bar" style="--value: 88%"></div>
            <div class="pa-sparkline__bar" style="--value: 72%"></div>
          </div>
        </.column>
        <.column size="25">
          <.paragraph>Warning</.paragraph>
          <div class="pa-sparkline pa-sparkline--warning">
            <div class="pa-sparkline__bar" style="--value: 60%"></div>
            <div class="pa-sparkline__bar" style="--value: 45%"></div>
            <div class="pa-sparkline__bar" style="--value: 55%"></div>
            <div class="pa-sparkline__bar" style="--value: 40%"></div>
            <div class="pa-sparkline__bar" style="--value: 50%"></div>
            <div class="pa-sparkline__bar" style="--value: 35%"></div>
            <div class="pa-sparkline__bar" style="--value: 65%"></div>
            <div class="pa-sparkline__bar" style="--value: 48%"></div>
            <div class="pa-sparkline__bar" style="--value: 52%"></div>
            <div class="pa-sparkline__bar" style="--value: 42%"></div>
          </div>
        </.column>
        <.column size="25">
          <.paragraph>Danger</.paragraph>
          <div class="pa-sparkline pa-sparkline--danger">
            <div class="pa-sparkline__bar" style="--value: 80%"></div>
            <div class="pa-sparkline__bar" style="--value: 60%"></div>
            <div class="pa-sparkline__bar" style="--value: 90%"></div>
            <div class="pa-sparkline__bar" style="--value: 70%"></div>
            <div class="pa-sparkline__bar" style="--value: 85%"></div>
            <div class="pa-sparkline__bar" style="--value: 50%"></div>
            <div class="pa-sparkline__bar" style="--value: 75%"></div>
            <div class="pa-sparkline__bar" style="--value: 95%"></div>
            <div class="pa-sparkline__bar" style="--value: 65%"></div>
            <div class="pa-sparkline__bar" style="--value: 55%"></div>
          </div>
        </.column>
      </.grid>
    </.card>
    """
  end
end
