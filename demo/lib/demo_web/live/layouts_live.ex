defmodule DemoWeb.Live.LayoutsLive do
  use DemoWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, page_title: "Layouts")}
  end

  def render(assigns) do
    ~H"""
    <.paragraph class="mb-6">Pure Admin's layout system: navbar + sidebar + content + footer with configurable behavior</.paragraph>

    <.card title_text="Layout Structure">
      <:description>The three-level nesting pattern</:description>
      <.code_block language="html">
        &lt;.layout&gt;
          &lt;.navbar&gt;
            &lt;:start&gt;...&lt;/:start&gt;
            &lt;:center&gt;...&lt;/:center&gt;
            &lt;:end_&gt;...&lt;/:end_&gt;
          &lt;/.navbar&gt;

          &lt;.layout_inner&gt;
            &lt;.sidebar&gt;
              &lt;.sidebar_item label="Dashboard" icon="..." href="/" /&gt;
              &lt;.sidebar_submenu id="settings" label="Settings" icon="..."&gt;
                &lt;.sidebar_item label="General" href="/settings" /&gt;
              &lt;/.sidebar_submenu&gt;
            &lt;/.sidebar&gt;

            &lt;.layout_content&gt;
              &lt;.main&gt;content&lt;/.main&gt;
              &lt;.footer&gt;
                &lt;:start&gt;...&lt;/:start&gt;
                &lt;:end_&gt;...&lt;/:end_&gt;
              &lt;/.footer&gt;
            &lt;/.layout_content&gt;
          &lt;/.layout_inner&gt;
        &lt;/.layout&gt;
      </.code_block>
    </.card>

    <.card title_text="Layout CSS Classes">
      <.table rows={[
        %{class: "pc-layout", desc: "Root layout container (100vh flex column)"},
        %{class: "pc-layout__inner", desc: "Content area below navbar (flex row)"},
        %{class: "pc-layout__sidebar", desc: "Sidebar container (fixed width)"},
        %{class: "pc-layout__sidebar--icon-collapse", desc: "Sidebar shows icons only when collapsed"},
        %{class: "pc-layout__sidebar--resizable", desc: "Enable drag-to-resize sidebar"},
        %{class: "pc-layout__content", desc: "Main content + footer wrapper (flex grow)"},
        %{class: "pc-layout--sticky", desc: "Sticky sidebar (doesn't scroll with content)"}
      ]} is_striped>
        <:col :let={row} label="Class"><code>.{row.class}</code></:col>
        <:col :let={row} label="Description">{row.desc}</:col>
      </.table>
    </.card>

    <.card title_text="Navbar Structure">
      <.table rows={[
        %{class: "pc-navbar", desc: "Top navigation bar (3-section flex layout)"},
        %{class: "pc-navbar__start", desc: "Left section: burger + brand + nav items"},
        %{class: "pc-navbar__center", desc: "Center section: page title"},
        %{class: "pc-navbar__end", desc: "Right section: nav + notifications + profile"},
        %{class: "pc-navbar__brand", desc: "Brand/logo container"},
        %{class: "pc-navbar__nav", desc: "Navigation link group"},
        %{class: "pc-navbar__nav-item", desc: "Individual nav link"},
        %{class: "pc-navbar__dropdown", desc: "CSS dropdown menu"},
        %{class: "pc-navbar__title", desc: "Page title in center section"}
      ]} is_striped>
        <:col :let={row} label="Class"><code>.{row.class}</code></:col>
        <:col :let={row} label="Description">{row.desc}</:col>
      </.table>
    </.card>

    <.card title_text="Sidebar Components">
      <.grid>
        <.column size="50">
          <.heading level={4}>LiveView Components</.heading>
          <.basic_list spacing="compact">
            <li><code>&lt;.sidebar&gt;</code> - Sidebar container with optional <code>id</code></li>
            <li><code>&lt;.sidebar_item&gt;</code> - Link item with <code>label</code>, <code>icon</code>, <code>href</code>, <code>is_active</code></li>
            <li><code>&lt;.sidebar_submenu&gt;</code> - Expandable group with <code>id</code>, <code>label</code>, <code>icon</code>, <code>is_open</code></li>
          </.basic_list>
        </.column>
        <.column size="50">
          <.heading level={4}>Sidebar Behavior</.heading>
          <.basic_list spacing="compact">
            <li><strong>Hide</strong> - <code>sidebar-hidden</code> on body hides completely</li>
            <li><strong>Icon collapse</strong> - <code>pc-layout__sidebar--icon-collapse</code> shows icons only</li>
            <li><strong>Resizable</strong> - <code>pc-layout__sidebar--resizable</code> enables drag handle</li>
            <li><strong>Sticky</strong> - <code>pc-layout--sticky</code> on body fixes sidebar position</li>
            <li><strong>Submenu persistence</strong> - <code>PureAdminSidebarSubmenu</code> hook saves open/closed state to localStorage</li>
          </.basic_list>
        </.column>
      </.grid>
    </.card>

    <.card title_text="Container Width">
      <:description>Control the maximum width of the content area</:description>
      <.table rows={[
        %{class: "(none)", width: "100%", desc: "Fluid - full width (default)"},
        %{class: "pc-container-sm", width: "768px", desc: "Small"},
        %{class: "pc-container-md", width: "1024px", desc: "Medium"},
        %{class: "pc-container-lg", width: "1280px", desc: "Large"},
        %{class: "pc-container-xl", width: "1600px", desc: "Extra large"},
        %{class: "pc-container-2xl", width: "1920px", desc: "2X large"}
      ]} is_striped>
        <:col :let={row} label="Class"><code>.{row.class}</code></:col>
        <:col :let={row} label="Max Width">{row.width}</:col>
        <:col :let={row} label="Description">{row.desc}</:col>
      </.table>
      <.callout variant="info" class="mt-4">
        Apply container width classes to <code>&lt;body&gt;</code>. The settings panel manages this automatically via localStorage.
      </.callout>
    </.card>
    """
  end
end
