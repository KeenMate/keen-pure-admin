defmodule DemoWeb.Live.BadgesLive do
  use DemoWeb, :live_view

  @project_tags [
    %{label: "React", variant: "primary"},
    %{label: "TypeScript", variant: "info"},
    %{label: "Node.js", variant: "success"},
    %{label: "Express", variant: "warning"},
    %{label: "PostgreSQL", variant: "secondary"},
    %{label: "Redux", variant: "primary"},
    %{label: "Sass", variant: "info"},
    %{label: "Docker", variant: "success"},
    %{label: "AWS", variant: "warning"},
    %{label: "Redis", variant: "danger"},
    %{label: "GraphQL", variant: "secondary"},
    %{label: "Jest", variant: "primary"},
    %{label: "Webpack", variant: "info"},
    %{label: "ESLint", variant: "success"},
    %{label: "GitHub Actions", variant: "dark"}
  ]

  @user_skills [
    %{label: "JavaScript", variant: "primary"},
    %{label: "Python", variant: "info"},
    %{label: "Java", variant: "success"},
    %{label: "C++", variant: "warning"},
    %{label: "Ruby", variant: "secondary"},
    %{label: "Go", variant: "primary"},
    %{label: "Rust", variant: "info"}
  ]

  @status_badges [
    %{label: "Approved", variant: "success"},
    %{label: "Pending", variant: "warning"},
    %{label: "Rejected", variant: "danger"},
    %{label: "Review", variant: "info"},
    %{label: "Draft", variant: "secondary"},
    %{label: "Published", variant: "primary"},
    %{label: "Archived", variant: "light"},
    %{label: "Deleted", variant: "dark"}
  ]

  def mount(_params, _session, socket) do
    {:ok, assign(socket,
      page_title: "Badges",
      project_tags: @project_tags,
      project_tags_expanded: false,
      user_skills: @user_skills,
      status_badges: @status_badges
    )}
  end

  def handle_event("expand_project_tags", _params, socket) do
    {:noreply, assign(socket, project_tags_expanded: !socket.assigns.project_tags_expanded)}
  end

  def handle_event("badge_label_click", %{"label" => label}, socket) do
    {:noreply, put_flash(socket, :info, "Viewing details for: #{label}")}
  end

  def handle_event("badge_button_click", %{"label" => label, "action" => action}, socket) do
    {:noreply, put_flash(socket, :info, "Action '#{action}' on: #{label}")}
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

    <%!-- Badge Groups with Limits --%>
    <.card title_text="Badge Groups with Limits">
      <:description>Display many badges with automatic overflow handling - shows 5 badges and "... N more" indicator</:description>
      <.grid>
        <.column size="100">
          <.heading level={4}>Server-side: Project Tags (15 total, click loads from server)</.heading>
          <% visible_tags = if @project_tags_expanded, do: @project_tags, else: Enum.take(@project_tags, 5) %>
          <.badge_group limit={5} total={length(@project_tags)} is_expanded={@project_tags_expanded} on_toggle="expand_project_tags" class="mb-3">
            <.badge :for={tag <- visible_tags} variant={tag.variant}><%= tag.label %></.badge>
          </.badge_group>

          <.heading level={4}>Client-side: User Skills (7 total, JS toggle, no server round-trip)</.heading>
          <.badge_group limit={5} total={length(@user_skills)} class="mb-3">
            <.badge :for={skill <- @user_skills} is_pill variant={skill.variant}><%= skill.label %></.badge>
          </.badge_group>

          <.heading level={4}>Client-side: Status Badges (8 total, small size)</.heading>
          <.badge_group limit={5} total={length(@status_badges)}>
            <.badge :for={status <- @status_badges} size="sm" variant={status.variant}><%= status.label %></.badge>
          </.badge_group>
        </.column>
      </.grid>

      <.alert variant="info" class="mt-4">
        <small><strong>Two modes:</strong> Set <code>on_toggle="event_name"</code> for server-side loading (fires LiveView event). Omit it for client-side JS toggle (no round-trip). Both support <code>limit</code>, <code>total</code>, and translatable <code>more_text</code>/<code>collapse_text</code>.</small>
      </.alert>

      <.grid class="mt-4">
        <.column size="100" md="1-3">
          <.heading level={4}>Narrow Container</.heading>
          <.badge_group limit={5} total={length(@project_tags)}>
            <.badge :for={tag <- @project_tags} variant={tag.variant}><%= tag.label %></.badge>
          </.badge_group>
        </.column>
        <.column size="100" md="2-3">
          <.heading level={4}>Full Width Comparison</.heading>
          <.badge_group limit={5} total={length(@project_tags)}>
            <.badge :for={tag <- @project_tags} variant={tag.variant}><%= tag.label %></.badge>
          </.badge_group>
        </.column>
      </.grid>

      <.grid class="mt-4">
        <.column size="100" md="1-6">
          <.heading level={4}>Wrapping Demo (Static)</.heading>
          <.badge_group is_show_all>
            <.badge size="sm" variant="primary">React</.badge>
            <.badge size="sm" variant="info">Vue</.badge>
            <.badge size="sm" variant="success">Angular</.badge>
            <.badge size="sm" variant="warning">Svelte</.badge>
            <.badge size="sm" variant="secondary">Solid</.badge>
            <.badge size="sm" variant="primary">TypeScript</.badge>
            <.badge size="sm" variant="info">JavaScript</.badge>
            <.badge size="sm" variant="success">Python</.badge>
            <.badge size="sm" variant="warning">Go</.badge>
            <.badge size="sm" variant="danger">Rust</.badge>
            <.badge size="sm" variant="secondary">Java</.badge>
            <.badge size="sm" variant="primary">C++</.badge>
            <.badge size="sm" variant="info">Elixir</.badge>
          </.badge_group>
        </.column>
        <.column size="100" md="5-6">
          <.heading level={4}>Full Width Comparison</.heading>
          <.badge_group is_show_all>
            <.badge size="sm" variant="primary">React</.badge>
            <.badge size="sm" variant="info">Vue</.badge>
            <.badge size="sm" variant="success">Angular</.badge>
            <.badge size="sm" variant="warning">Svelte</.badge>
            <.badge size="sm" variant="secondary">Solid</.badge>
            <.badge size="sm" variant="primary">TypeScript</.badge>
            <.badge size="sm" variant="info">JavaScript</.badge>
            <.badge size="sm" variant="success">Python</.badge>
            <.badge size="sm" variant="warning">Go</.badge>
            <.badge size="sm" variant="danger">Rust</.badge>
            <.badge size="sm" variant="secondary">Java</.badge>
            <.badge size="sm" variant="primary">C++</.badge>
            <.badge size="sm" variant="info">Elixir</.badge>
          </.badge_group>
        </.column>
      </.grid>
    </.card>

    <%!-- Fixed-Width Badges with Ellipsis --%>
    <.card title_text="Fixed-Width Badges with Ellipsis">
      <:description>Badges with constrained width show ellipsis for overflow text. Hover for tooltip with full text.</:description>
      <.grid>
        <.column size="100" md="1-2">
          <.heading level={4}>Various Fixed Widths</.heading>
          <div class="component-showcase">
            <span class="pa-tooltip pa-tooltip--bottom" data-tooltip="Short">
              <.badge variant="primary" max_width="5">Short</.badge>
            </span>
            <span class="pa-tooltip pa-tooltip--bottom" data-tooltip="This is medium text">
              <.badge variant="info" max_width="8">This is medium text</.badge>
            </span>
            <span class="pa-tooltip pa-tooltip--bottom" data-tooltip="This is longer text that will be truncated">
              <.badge variant="success" max_width="10">This is longer text that will be truncated</.badge>
            </span>
            <span class="pa-tooltip pa-tooltip--bottom" data-tooltip="Very long badge text that definitely needs ellipsis">
              <.badge variant="warning" max_width="15">Very long badge text that definitely needs ellipsis</.badge>
            </span>
            <span class="pa-tooltip pa-tooltip--bottom" data-tooltip="Super extremely long badge text example">
              <.badge variant="danger" max_width="20">Super extremely long badge text example</.badge>
            </span>
          </div>
        </.column>
        <.column size="100" md="1-2">
          <.heading level={4}>Small Fixed-Width Badges</.heading>
          <div class="component-showcase">
            <span class="pa-tooltip pa-tooltip--bottom" data-tooltip="OK">
              <.badge size="sm" variant="primary" max_width="4">OK</.badge>
            </span>
            <span class="pa-tooltip pa-tooltip--bottom" data-tooltip="Status">
              <.badge size="sm" variant="info" max_width="6">Status</.badge>
            </span>
            <span class="pa-tooltip pa-tooltip--bottom" data-tooltip="Completed Task">
              <.badge size="sm" variant="success" max_width="8">Completed Task</.badge>
            </span>
            <span class="pa-tooltip pa-tooltip--bottom" data-tooltip="Pending Review Process">
              <.badge size="sm" variant="warning" max_width="10">Pending Review Process</.badge>
            </span>
            <span class="pa-tooltip pa-tooltip--bottom" data-tooltip="Critical Error in Production">
              <.badge size="sm" variant="danger" max_width="15">Critical Error in Production</.badge>
            </span>
          </div>
        </.column>
      </.grid>

      <.grid class="mt-4">
        <.column size="100">
          <.heading level={4}>Practical Example: Tags with Consistent Width</.heading>
          <div class="component-showcase">
            <span class="pa-tooltip pa-tooltip--bottom" data-tooltip="JavaScript">
              <.badge is_pill variant="secondary" max_width="10">JavaScript</.badge>
            </span>
            <span class="pa-tooltip pa-tooltip--bottom" data-tooltip="TypeScript">
              <.badge is_pill variant="secondary" max_width="10">TypeScript</.badge>
            </span>
            <span class="pa-tooltip pa-tooltip--bottom" data-tooltip="React">
              <.badge is_pill variant="secondary" max_width="10">React</.badge>
            </span>
            <span class="pa-tooltip pa-tooltip--bottom" data-tooltip="Node.js">
              <.badge is_pill variant="secondary" max_width="10">Node.js</.badge>
            </span>
            <span class="pa-tooltip pa-tooltip--bottom" data-tooltip="PostgreSQL Database">
              <.badge is_pill variant="secondary" max_width="10">PostgreSQL Database</.badge>
            </span>
            <span class="pa-tooltip pa-tooltip--bottom" data-tooltip="Express.js Framework">
              <.badge is_pill variant="secondary" max_width="10">Express.js Framework</.badge>
            </span>
          </div>
        </.column>
      </.grid>

      <.grid class="mt-4">
        <.column size="100">
          <.heading level={4}>Start-Side Ellipsis (Path/Hierarchy Display)</.heading>
          <.paragraph class="text-xs mb-2">When the important part is at the end (breadcrumbs, file paths, etc.)</.paragraph>
          <div class="component-showcase">
            <span class="pa-tooltip pa-tooltip--bottom pa-tooltip--multiline" data-tooltip="Settings > User Preferences > Notifications > Email">
              <.badge variant="secondary" max_width="15" is_ellipsis_start>Settings > User Preferences > Notifications > Email</.badge>
            </span>
            <span class="pa-tooltip pa-tooltip--bottom pa-tooltip--multiline" data-tooltip="/var/www/html/application/config/database.php">
              <.badge variant="info" max_width="20" is_ellipsis_start>/var/www/html/application/config/database.php</.badge>
            </span>
            <span class="pa-tooltip pa-tooltip--bottom pa-tooltip--multiline" data-tooltip="Components > Forms > Inputs > TextArea.svelte">
              <.badge variant="primary" max_width="15" is_ellipsis_start>Components > Forms > Inputs > TextArea.svelte</.badge>
            </span>
            <span class="pa-tooltip pa-tooltip--bottom pa-tooltip--multiline" data-tooltip="Europe > Germany > Berlin > Mitte > Alexanderplatz">
              <.badge variant="warning" max_width="15" is_ellipsis_start>Europe > Germany > Berlin > Mitte > Alexanderplatz</.badge>
            </span>
          </div>
        </.column>
      </.grid>

      <.alert variant="info" class="mt-3">
        <small><strong>Note:</strong> Use <code>max_width="5"</code> etc. to constrain badge width with truncation. Use <code>is_ellipsis_start</code> to truncate from the start side instead.</small>
      </.alert>
    </.card>

    <%!-- Composite Badges --%>
    <.card title_text="Composite Badges">
      <:description>Three-part badges with separate icon, label, and button sections</:description>
      <.grid>
        <.column size="100" md="1-2">
          <.heading level={4}>Standard Color Variations</.heading>
          <div class="component-showcase">
            <.composite_badge variant="primary" icon="✓" label="Primary" button_text="×" is_interactive />
            <.composite_badge variant="secondary" icon="⚙" label="Secondary" button_text="×" is_interactive />
            <.composite_badge variant="success" icon="★" label="Success" button_text="×" is_interactive />
            <.composite_badge variant="danger" icon="🔥" label="Danger" button_text="×" is_interactive />
            <.composite_badge variant="warning" icon="⚠" label="Warning" button_text="×" is_interactive />
            <.composite_badge variant="info" icon="ℹ" label="Info" button_text="×" is_interactive />
            <.composite_badge variant="light" icon="◇" label="Light" button_text="×" is_interactive />
            <.composite_badge variant="dark" icon="◆" label="Dark" button_text="×" is_interactive />
          </div>
        </.column>
        <.column size="100" md="1-2">
          <.heading level={4}>More Examples</.heading>
          <div class="component-showcase">
            <.composite_badge variant="danger" icon="🔥" label="Critical" button_text="×" is_interactive />
            <.composite_badge variant="light" icon="◇" label="Draft" button_text="↗" is_interactive />
            <.composite_badge variant="dark" icon="◆" label="Published" button_text="⚙" is_interactive />
          </div>
        </.column>
      </.grid>

      <.grid class="mt-4">
        <.column size="100">
          <.heading level={4}>Advanced: Mixed Section Colors</.heading>
          <.paragraph class="text-sm text-secondary mb-3">
            For advanced customization, you can mix individual section colors using separate classes.
          </.paragraph>
          <div class="component-showcase">
            <.composite_badge variant="primary" label_variant="secondary" button_variant="danger" icon="📁" label="Project Alpha" button_text="×" is_interactive />
            <.composite_badge variant="success" label_variant="light" button_variant="warning" icon="🎯" label="Target Met" button_text="⋯" is_interactive />
            <.composite_badge variant="dark" label_variant="primary" button_variant="info" icon="⚡" label="High Performance" button_text="↑" is_interactive />
            <.composite_badge variant="secondary" label_variant="warning" button_variant="success" icon="🔧" label="Maintenance" button_text="✓" is_interactive />
          </div>
        </.column>
      </.grid>
    </.card>

    <%!-- Interactive Composite Badges --%>
    <.card title_text="Interactive Composite Badges">
      <:description>Examples with click handlers and dynamic behavior</:description>
      <div class="component-showcase">
        <.composite_badge variant="info" icon="📋" label="Task #1234" button_text="×" is_interactive on_label_click="badge_label_click" on_button_click="badge_button_click" />
        <.composite_badge variant="success" icon="👤" label="John Doe" button_text="✎" is_interactive on_label_click="badge_label_click" on_button_click="badge_button_click" />
        <.composite_badge variant="warning" icon="🏷️" label="v2.1.0" button_text="↓" is_interactive on_label_click="badge_label_click" on_button_click="badge_button_click" />
      </div>

      <.alert variant="primary" class="mt-4">
        <small><strong>Try it:</strong> Click label text to see details flash, click the button (×, ✎, ↓) for action flash. Uses <code>on_label_click</code> and <code>on_button_click</code> attrs with separate LiveView events.</small>
      </.alert>
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
