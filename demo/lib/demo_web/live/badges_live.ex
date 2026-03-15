defmodule DemoWeb.Live.BadgesLive do
  use DemoWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, page_title: "Badges")}
  end

  def render(assigns) do
    ~H"""
    <.paragraph>Badges, labels, and composite badges for status display and categorization.</.paragraph>

    <%!-- Badge Sizes Reference --%>
    <.card title_text="Badge Sizes Reference" has_padding={false}>
      <table class="pa-table pa-table--striped">
        <thead>
          <tr>
            <th>Size</th>
            <th>Class</th>
            <th>Font Size</th>
            <th>Padding</th>
            <th>Example</th>
          </tr>
        </thead>
        <tbody>
          <tr>
            <td><strong>XS</strong></td>
            <td><code>.pa-badge--xs</code></td>
            <td>1rem (10px)</td>
            <td>0.2rem 0.4rem</td>
            <td><.badge size="xs" variant="primary">Extra Small</.badge></td>
          </tr>
          <tr>
            <td><strong>SM</strong></td>
            <td><code>.pa-badge--sm</code></td>
            <td>1.2rem (12px)</td>
            <td>0.25rem 0.5rem</td>
            <td><.badge size="sm" variant="primary">Small Badge</.badge></td>
          </tr>
          <tr>
            <td><strong>Default</strong></td>
            <td><code>.pa-badge</code></td>
            <td>1.2rem (12px)</td>
            <td>0.4rem 0.8rem</td>
            <td><.badge variant="primary">Default Badge</.badge></td>
          </tr>
          <tr>
            <td><strong>LG</strong></td>
            <td><code>.pa-badge--lg</code></td>
            <td>1.4rem (14px)</td>
            <td>0.5rem 1rem</td>
            <td><.badge size="lg" variant="primary">Large Badge</.badge></td>
          </tr>
          <tr>
            <td><strong>XL</strong></td>
            <td><code>.pa-badge--xl</code></td>
            <td>1.6rem (16px)</td>
            <td>0.6rem 1.2rem</td>
            <td><.badge size="xl" variant="primary">Extra Large</.badge></td>
          </tr>
        </tbody>
      </table>
    </.card>

    <%!-- Basic Badges --%>
    <.card title_text="Basic Badges">
      <:description>Simple badges for status indication and categorization</:description>
      <.grid>
        <.column size="100" md="1-2">
          <.heading level={4}>Default Badges</.heading>
          <div class="component-showcase">
            <.badge>Default</.badge>
            <.badge variant="primary">Primary</.badge>
            <.badge variant="secondary">Secondary</.badge>
            <.badge variant="success">Success</.badge>
            <.badge variant="warning">Warning</.badge>
            <.badge variant="danger">Danger</.badge>
            <.badge variant="info">Info</.badge>
            <.badge variant="light">Light</.badge>
            <.badge variant="dark">Dark</.badge>
          </div>
        </.column>
        <.column size="100" md="1-2">
          <.heading level={4}>Small Badges</.heading>
          <div class="component-showcase">
            <.badge size="sm">Default</.badge>
            <.badge size="sm" variant="primary">Primary</.badge>
            <.badge size="sm" variant="secondary">Secondary</.badge>
            <.badge size="sm" variant="success">Success</.badge>
            <.badge size="sm" variant="warning">Warning</.badge>
            <.badge size="sm" variant="danger">Danger</.badge>
            <.badge size="sm" variant="info">Info</.badge>
            <.badge size="sm" variant="light">Light</.badge>
            <.badge size="sm" variant="dark">Dark</.badge>
          </div>
        </.column>
      </.grid>
    </.card>

    <%!-- Pill Badges --%>
    <.card title_text="Pill Badges">
      <:description>Rounded badges for a softer, modern appearance</:description>
      <.grid>
        <.column size="100" md="1-2">
          <.heading level={4}>Regular Pills</.heading>
          <div class="component-showcase">
            <.badge is_pill>Default</.badge>
            <.badge is_pill variant="primary">Primary</.badge>
            <.badge is_pill variant="secondary">Secondary</.badge>
            <.badge is_pill variant="success">Success</.badge>
            <.badge is_pill variant="warning">Warning</.badge>
            <.badge is_pill variant="danger">Danger</.badge>
            <.badge is_pill variant="info">Info</.badge>
          </div>
        </.column>
        <.column size="100" md="1-2">
          <.heading level={4}>Small Pills</.heading>
          <div class="component-showcase">
            <.badge is_pill size="sm">Default</.badge>
            <.badge is_pill size="sm" variant="primary">Primary</.badge>
            <.badge is_pill size="sm" variant="secondary">Secondary</.badge>
            <.badge is_pill size="sm" variant="success">Success</.badge>
            <.badge is_pill size="sm" variant="warning">Warning</.badge>
            <.badge is_pill size="sm" variant="danger">Danger</.badge>
            <.badge is_pill size="sm" variant="info">Info</.badge>
          </div>
        </.column>
      </.grid>
    </.card>

    <%!-- Badges with Icons --%>
    <.card title_text="Badges with Icons">
      <:description>Enhanced badges with icon indicators</:description>
      <div class="component-showcase">
        <.badge variant="primary">
          <:icon>✓</:icon>
          Completed
        </.badge>
        <.badge variant="warning">
          <:icon>!</:icon>
          Warning
        </.badge>
        <.badge variant="danger">
          <:icon>✕</:icon>
          Error
        </.badge>
        <.badge variant="info">
          <:icon>ℹ</:icon>
          Info
        </.badge>
        <.badge variant="success">
          <:icon>★</:icon>
          Featured
        </.badge>
        <.badge variant="secondary">
          <:icon>⏱</:icon>
          Pending
        </.badge>
      </div>
    </.card>

    <%!-- Label Sizes Reference --%>
    <.card title_text="Label Sizes Reference" has_padding={false}>
      <table class="pa-table pa-table--striped">
        <thead>
          <tr>
            <th>Size</th>
            <th>Class</th>
            <th>Font Size</th>
            <th>Padding</th>
            <th>Example</th>
          </tr>
        </thead>
        <tbody>
          <tr>
            <td><strong>XS</strong></td>
            <td><code>.pa-label--xs</code></td>
            <td>1rem (10px)</td>
            <td>0.2rem 0.4rem</td>
            <td><.label size="sm" variant="primary">Extra Small</.label></td>
          </tr>
          <tr>
            <td><strong>SM</strong></td>
            <td><code>.pa-label--sm</code></td>
            <td>1.2rem (12px)</td>
            <td>0.25rem 0.5rem</td>
            <td><.label size="sm" variant="primary">Small Label</.label></td>
          </tr>
          <tr>
            <td><strong>Default</strong></td>
            <td><code>.pa-label</code></td>
            <td>1.2rem (12px)</td>
            <td>0.4rem 0.8rem</td>
            <td><.label variant="primary">Default Label</.label></td>
          </tr>
          <tr>
            <td><strong>LG</strong></td>
            <td><code>.pa-label--lg</code></td>
            <td>1.4rem (14px)</td>
            <td>0.5rem 1rem</td>
            <td><.label size="lg" variant="primary">Large Label</.label></td>
          </tr>
        </tbody>
      </table>
    </.card>

    <%!-- Labels --%>
    <.card title_text="Labels">
      <:description>Text labels for categorization and tagging</:description>
      <.grid>
        <.column size="100" md="1-2">
          <.heading level={4}>Basic Labels</.heading>
          <div class="component-showcase">
            <.label>Frontend</.label>
            <.label variant="primary">React</.label>
            <.label variant="secondary">TypeScript</.label>
            <.label variant="success">Bug Fix</.label>
            <.label variant="warning">Enhancement</.label>
            <.label variant="danger">Breaking Change</.label>
            <.label variant="info">Documentation</.label>
          </div>
        </.column>
        <.column size="100" md="1-2">
          <.heading level={4}>Outlined Labels</.heading>
          <div class="component-showcase">
            <.label is_outline>Frontend</.label>
            <.label is_outline variant="primary">React</.label>
            <.label is_outline variant="secondary">TypeScript</.label>
            <.label is_outline variant="success">Bug Fix</.label>
            <.label is_outline variant="warning">Enhancement</.label>
            <.label is_outline variant="danger">Breaking Change</.label>
            <.label is_outline variant="info">Documentation</.label>
          </div>
        </.column>
      </.grid>
    </.card>

    <%!-- Badge Groups --%>
    <.card title_text="Badge Groups">
      <:description>Display many badges with automatic wrapping</:description>
      <.grid>
        <.column size="100">
          <.heading level={4}>Project Tags</.heading>
          <.badge_group>
            <.badge variant="primary">React</.badge>
            <.badge variant="info">TypeScript</.badge>
            <.badge variant="success">Node.js</.badge>
            <.badge variant="warning">Express</.badge>
            <.badge variant="secondary">PostgreSQL</.badge>
            <.badge variant="primary">Redux</.badge>
            <.badge variant="info">Sass</.badge>
            <.badge variant="success">Docker</.badge>
            <.badge variant="warning">AWS</.badge>
            <.badge variant="danger">Redis</.badge>
            <.badge variant="secondary">GraphQL</.badge>
            <.badge variant="primary">Jest</.badge>
            <.badge variant="info">Webpack</.badge>
            <.badge variant="success">ESLint</.badge>
            <.badge variant="dark">GitHub Actions</.badge>
          </.badge_group>
        </.column>
      </.grid>

      <.grid class="mt-4">
        <.column size="100">
          <.heading level={4}>User Skills (Pill Style)</.heading>
          <.badge_group>
            <.badge is_pill variant="primary">JavaScript</.badge>
            <.badge is_pill variant="info">Python</.badge>
            <.badge is_pill variant="success">Java</.badge>
            <.badge is_pill variant="warning">C++</.badge>
            <.badge is_pill variant="secondary">Ruby</.badge>
            <.badge is_pill variant="primary">Go</.badge>
            <.badge is_pill variant="info">Rust</.badge>
          </.badge_group>
        </.column>
      </.grid>

      <.grid class="mt-4">
        <.column size="100" md="1-3">
          <.heading level={4}>Narrow Container</.heading>
          <.badge_group>
            <.badge size="sm" variant="primary">React</.badge>
            <.badge size="sm" variant="info">Vue</.badge>
            <.badge size="sm" variant="success">Angular</.badge>
            <.badge size="sm" variant="warning">Svelte</.badge>
            <.badge size="sm" variant="secondary">Solid</.badge>
            <.badge size="sm" variant="primary">TypeScript</.badge>
            <.badge size="sm" variant="info">JavaScript</.badge>
            <.badge size="sm" variant="success">Python</.badge>
          </.badge_group>
        </.column>
        <.column size="100" md="2-3">
          <.heading level={4}>Full Width Comparison</.heading>
          <.badge_group>
            <.badge size="sm" variant="primary">React</.badge>
            <.badge size="sm" variant="info">Vue</.badge>
            <.badge size="sm" variant="success">Angular</.badge>
            <.badge size="sm" variant="warning">Svelte</.badge>
            <.badge size="sm" variant="secondary">Solid</.badge>
            <.badge size="sm" variant="primary">TypeScript</.badge>
            <.badge size="sm" variant="info">JavaScript</.badge>
            <.badge size="sm" variant="success">Python</.badge>
          </.badge_group>
        </.column>
      </.grid>
    </.card>

    <%!-- Fixed-Width Badges with Ellipsis --%>
    <.card title_text="Fixed-Width Badges with Ellipsis">
      <:description>Badges with constrained width show ellipsis for overflow text</:description>
      <.grid>
        <.column size="100" md="1-2">
          <.heading level={4}>Various Fixed Widths</.heading>
          <div class="component-showcase">
            <.badge variant="primary" class="wr-3 text-truncate">Short</.badge>
            <.badge variant="info" class="wr-4 text-truncate">This is medium text</.badge>
            <.badge variant="success" class="wr-5 text-truncate">This is longer text that will be truncated</.badge>
            <.badge variant="warning" class="wr-6 text-truncate">Very long badge text that definitely needs ellipsis</.badge>
            <.badge variant="danger" class="wr-7 text-truncate">Super extremely long badge text example</.badge>
          </div>
        </.column>
        <.column size="100" md="1-2">
          <.heading level={4}>Small Fixed-Width Badges</.heading>
          <div class="component-showcase">
            <.badge size="sm" variant="primary" class="wr-2 text-truncate">OK</.badge>
            <.badge size="sm" variant="info" class="wr-3 text-truncate">Status</.badge>
            <.badge size="sm" variant="success" class="wr-4 text-truncate">Completed Task</.badge>
            <.badge size="sm" variant="warning" class="wr-5 text-truncate">Pending Review Process</.badge>
            <.badge size="sm" variant="danger" class="wr-6 text-truncate">Critical Error in Production</.badge>
          </div>
        </.column>
      </.grid>

      <.grid class="mt-4">
        <.column size="100">
          <.heading level={4}>Practical Example: Tags with Consistent Width</.heading>
          <div class="component-showcase">
            <.badge is_pill variant="secondary" class="wr-5 text-truncate">JavaScript</.badge>
            <.badge is_pill variant="secondary" class="wr-5 text-truncate">TypeScript</.badge>
            <.badge is_pill variant="secondary" class="wr-5 text-truncate">React</.badge>
            <.badge is_pill variant="secondary" class="wr-5 text-truncate">Node.js</.badge>
            <.badge is_pill variant="secondary" class="wr-5 text-truncate">PostgreSQL Database</.badge>
            <.badge is_pill variant="secondary" class="wr-5 text-truncate">Express.js Framework</.badge>
          </div>
        </.column>
      </.grid>

      <.alert variant="info" class="mt-3">
        <small><strong>Note:</strong> Use utility width classes like <code>wr-3</code> to <code>wr-10</code> combined with <code>text-truncate</code> for fixed-width badges.</small>
      </.alert>
    </.card>

    <%!-- Composite Badges --%>
    <.card title_text="Composite Badges">
      <:description>Three-part badges with separate icon, label, and button sections</:description>
      <.grid>
        <.column size="100" md="1-2">
          <.heading level={4}>Standard Color Variations</.heading>
          <div class="component-showcase">
            <.composite_badge variant="primary" icon="✓" label="Primary" count="×" />
            <.composite_badge variant="secondary" icon="⚙" label="Secondary" count="×" />
            <.composite_badge variant="success" icon="★" label="Success" count="×" />
            <.composite_badge variant="danger" icon="🔥" label="Danger" count="×" />
            <.composite_badge variant="warning" icon="⚠" label="Warning" count="×" />
            <.composite_badge variant="info" icon="ℹ" label="Info" count="×" />
          </div>
        </.column>
        <.column size="100" md="1-2">
          <.heading level={4}>More Examples</.heading>
          <div class="component-showcase">
            <.composite_badge variant="danger" icon="🔥" label="Critical" count="×" />
            <.composite_badge variant="light" icon="◇" label="Draft" count="↗" />
            <.composite_badge variant="dark" icon="◆" label="Published" count="⚙" />
          </div>
        </.column>
      </.grid>
    </.card>

    <%!-- Usage Examples --%>
    <.card title_text="Usage Examples">
      <:description>Real-world examples of badges and labels in context</:description>
      <.grid>
        <.column size="100" md="1-2">
          <.heading level={4}>User Status</.heading>
          <div class="usage-example">
            <div style="display: flex; align-items: center; gap: 8px; margin-bottom: 8px;">
              <span>John Doe</span>
              <.badge size="sm" variant="success">Online</.badge>
            </div>
            <div style="display: flex; align-items: center; gap: 8px; margin-bottom: 8px;">
              <span>Jane Smith</span>
              <.badge size="sm" variant="warning">Away</.badge>
            </div>
            <div style="display: flex; align-items: center; gap: 8px;">
              <span>Mike Johnson</span>
              <.badge size="sm" variant="secondary">Offline</.badge>
            </div>
          </div>
        </.column>
        <.column size="100" md="1-2">
          <.heading level={4}>Project Tags</.heading>
          <div class="usage-example">
            <div style="margin-bottom: 12px;">
              <.heading level={5}>Website Redesign</.heading>
              <div style="display: flex; gap: 4px; flex-wrap: wrap; margin-top: 4px;">
                <.label size="sm" variant="primary">Frontend</.label>
                <.label size="sm" variant="info">Design</.label>
                <.label size="sm" variant="warning">High Priority</.label>
              </div>
            </div>
            <div>
              <.heading level={5}>API Integration</.heading>
              <div style="display: flex; gap: 4px; flex-wrap: wrap; margin-top: 4px;">
                <.label size="sm" variant="secondary">Backend</.label>
                <.label size="sm" variant="success">REST API</.label>
                <.label size="sm" variant="danger">Critical</.label>
              </div>
            </div>
          </div>
        </.column>
      </.grid>
    </.card>
    """
  end
end
