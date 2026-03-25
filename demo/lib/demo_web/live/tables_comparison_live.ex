defmodule DemoWeb.Live.TablesComparisonLive do
  use DemoWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, page_title: "Comparison Tables")}
  end

  def render(assigns) do
    ~H"""
    <.paragraph>Two-column and three-column comparison patterns for version control, data changes, and A/B comparisons.</.paragraph>

    <%!-- Two-Column Comparison --%>
    <.table_card title_text="Version Detail (2-Column)">
      <:actions>
        <.button variant="primary" size="sm">
          <:icon><i class="fa-solid fa-table-list"></i></:icon>
          View in form
        </.button>
        <.button variant="secondary" size="sm">
          <:icon><i class="fa-solid fa-table"></i></:icon>
          View in table
        </.button>
        <.button variant="secondary" size="sm" is_icon_only title="Location">
          <i class="fa-solid fa-location-dot"></i>
        </.button>
      </:actions>

      <.comparison_table>
        <:head>
          <th style="width: 20%;">#</th>
          <th style="width: 40%;">Base values</th>
          <th style="width: 40%;">New values</th>
        </:head>

        <.comparison_row label="Country Iso 2">
          <:cell><.comparison_value value="be" /></:cell>
          <:cell><.comparison_value value="be" /></:cell>
        </.comparison_row>
        <.comparison_row label="Region" cells={2} />
        <.comparison_row label="Subregion" cells={2} />
        <.comparison_row label="Town">
          <:cell><.comparison_value value="Beveren" /></:cell>
          <:cell is_changed><.comparison_value value="Antwerpen" /></:cell>
        </.comparison_row>
        <.comparison_row label="Postal Code">
          <:cell><.comparison_value value="9130" /></:cell>
          <:cell is_changed><.comparison_value value="2018" /></:cell>
        </.comparison_row>
        <.comparison_row label="Street Full Name" cells={2} />
        <.comparison_row label="Street Num." cells={2} />
        <.comparison_row label="Street Sub Num." cells={2} />
        <.comparison_row label="Street Add. Num." cells={2} />
        <.comparison_row label="Address line 1">
          <:cell><.comparison_value value="Ketenislaan 1" /></:cell>
          <:cell is_changed><.comparison_value value="Desguinlei 100" /></:cell>
        </.comparison_row>
        <.comparison_row label="Address line 2" cells={2} />
        <.comparison_row label="Address line 3" cells={2} />
        <.comparison_row label="Address line 4" cells={2} />
        <.comparison_row label="Address line 5" cells={2} />
        <.comparison_row label="Address line 6" cells={2} />
        <.comparison_row label="Address line 7" cells={2} />
        <.comparison_row label="Address line 8" cells={2} />

        <.comparison_section colspan={3}>Address metadata</.comparison_section>

        <.comparison_row label="Source Location Name">
          <:cell><.comparison_value value="2243544870:Beveren:Ketenislaan 1" /></:cell>
          <:cell is_changed><.comparison_value value="2243544870:Antwerpen:Desguinlei 100" /></:cell>
        </.comparison_row>
        <.comparison_row label="Is active">
          <:cell><i class="fa-solid fa-check" style="color: var(--base-success-color);"></i></:cell>
          <:cell><i class="fa-solid fa-check" style="color: var(--base-success-color);"></i></:cell>
        </.comparison_row>
        <.comparison_row label="Coordinates (lat,lng)" cells={2} />
      </.comparison_table>
    </.table_card>

    <%!-- Three-Column Comparison --%>
    <.table_card title_text="Merge Comparison (3-Column)">
      <:actions>
        <.button variant="success" size="sm">
          <:icon><i class="fa-solid fa-code-merge"></i></:icon>
          Accept A
        </.button>
        <.button variant="info" size="sm">
          <:icon><i class="fa-solid fa-code-merge"></i></:icon>
          Accept B
        </.button>
        <.button variant="secondary" size="sm">
          <:icon><i class="fa-solid fa-xmark"></i></:icon>
          Reject Both
        </.button>
      </:actions>

      <.comparison_table>
        <:head>
          <th style="width: 20%;">#</th>
          <th style="width: 26.67%;">Base</th>
          <th style="width: 26.67%;">Change A</th>
          <th style="width: 26.67%;">Change B</th>
        </:head>

        <.comparison_section colspan={4}>Contact Information</.comparison_section>

        <.comparison_row label="Email">
          <:cell><.comparison_value value="john.doe@company.com" /></:cell>
          <:cell is_changed><.comparison_value value="john.doe@newcompany.com" /></:cell>
          <:cell><.comparison_value value="john.doe@company.com" /></:cell>
        </.comparison_row>
        <.comparison_row label="Phone">
          <:cell><.comparison_value value="+32 123 456 789" /></:cell>
          <:cell><.comparison_value value="+32 123 456 789" /></:cell>
          <:cell is_changed><.comparison_value value="+32 987 654 321" /></:cell>
        </.comparison_row>
        <.comparison_row label="Department">
          <:cell><.comparison_value value="Sales" /></:cell>
          <:cell is_changed><.comparison_value value="Marketing" /></:cell>
          <:cell is_changed is_conflict><.comparison_value value="Engineering" /></:cell>
        </.comparison_row>

        <.comparison_section colspan={4}>Employment Details</.comparison_section>

        <.comparison_row label="Start Date">
          <:cell><.comparison_value value="2020-01-15" /></:cell>
          <:cell><.comparison_value value="2020-01-15" /></:cell>
          <:cell><.comparison_value value="2020-01-15" /></:cell>
        </.comparison_row>
        <.comparison_row label="Status">
          <:cell><.badge variant="success">Active</.badge></:cell>
          <:cell><.badge variant="success">Active</.badge></:cell>
          <:cell><.badge variant="success">Active</.badge></:cell>
        </.comparison_row>
      </.comparison_table>
    </.table_card>

    <%!-- Solid Background Variant --%>
    <.table_card title_text="Version Detail (Solid Background Variant)">
      <:header>
        <h3>Version Detail (Solid Background Variant)</h3>
        <p class="pa-text pa-text--sm pa-text--secondary mt-2">
          Using <code>pa-comparison-table__changed--solid</code> for uniform background highlighting without left border accent
        </p>
      </:header>

      <.comparison_table>
        <:head>
          <th style="width: 20%;">#</th>
          <th style="width: 40%;">Base values</th>
          <th style="width: 40%;">New values</th>
        </:head>

        <.comparison_row label="Country Iso 2">
          <:cell><.comparison_value value="be" /></:cell>
          <:cell><.comparison_value value="be" /></:cell>
        </.comparison_row>
        <.comparison_row label="Town">
          <:cell><.comparison_value value="Beveren" /></:cell>
          <:cell is_changed is_solid><.comparison_value value="Antwerpen" /></:cell>
        </.comparison_row>
        <.comparison_row label="Postal Code">
          <:cell><.comparison_value value="9130" /></:cell>
          <:cell is_changed is_solid><.comparison_value value="2018" /></:cell>
        </.comparison_row>
        <.comparison_row label="Address line 1">
          <:cell><.comparison_value value="Ketenislaan 1" /></:cell>
          <:cell is_changed is_solid><.comparison_value value="Desguinlei 100" /></:cell>
        </.comparison_row>
      </.comparison_table>
    </.table_card>

    <%!-- Implementation Notes --%>
    <.card title_text="Implementation Notes">
      <.heading level={4}>Component Classes</.heading>
      <ul>
        <li><code>pa-comparison-table</code> - Apply to table element</li>
        <li><code>pa-comparison-table__label</code> - Field name column</li>
        <li><code>pa-comparison-table__value</code> - Wrapper for value + copy button</li>
        <li><code>pa-comparison-table__copy</code> - Copy button styling</li>
        <li><code>pa-comparison-table__changed</code> - Pink highlight for changed values (light bg + left border)</li>
        <li><code>pa-comparison-table__changed--solid</code> - Solid pink background (no left border accent)</li>
        <li><code>pa-comparison-table__conflict</code> - Orange highlight for merge conflicts</li>
        <li><code>pa-comparison-table__conflict--solid</code> - Solid orange background (no left border accent)</li>
        <li><code>pa-comparison-table__section</code> - Section header row</li>
      </ul>
    </.card>
    """
  end
end
