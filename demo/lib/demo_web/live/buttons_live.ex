defmodule DemoWeb.Live.ButtonsLive do
  use DemoWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, page_title: "Buttons", loading_btn: nil)}
  end

  def handle_event("toggle_loading", %{"btn" => btn}, socket) do
    Process.send_after(self(), {:stop_loading, btn}, Enum.random(1000..3000))
    {:noreply, assign(socket, :loading_btn, btn)}
  end

  def handle_event("split_action", params, socket) do
    action = params["action"] || "primary click"
    {:noreply, PureAdmin.Components.Toast.push_toast(socket, "info", "Split Button", "Action: #{action}")}
  end

  def handle_info({:stop_loading, _btn}, socket) do
    {:noreply, assign(socket, :loading_btn, nil)}
  end

  def render(assigns) do
    ~H"""
    <.paragraph>Various button styles and sizes for actions and navigation.</.paragraph>

    <script>
      document.addEventListener("click", function(e) {
        var btn = e.target.closest("[data-ripple]");
        if (!btn) return;
        btn.classList.add("pa-btn--ripple-active");
        setTimeout(function() { btn.classList.remove("pa-btn--ripple-active"); }, 600);
      });
    </script>

    <%!-- Button Variants and Sizes --%>
    <.grid>
      <.column size="100" lg="1-2">
        <.card title_text="Button Variants">
          <.button_group>
            <.button variant="primary">Primary</.button>
            <.button variant="secondary">Secondary</.button>
            <.button variant="success">Success</.button>
            <.button variant="warning">Warning</.button>
            <.button variant="danger">Danger</.button>
            <.button variant="info">Info</.button>
            <.button variant="light">Light</.button>
            <.button variant="dark">Dark</.button>
          </.button_group>
        </.card>
      </.column>

      <.column size="100" lg="1-2">
        <.card title_text="Button Sizes">
          <.button_group>
            <.button variant="primary" size="xs">Extra Small</.button>
            <.button variant="primary" size="sm">Small</.button>
            <.button variant="primary">Default</.button>
            <.button variant="primary" size="lg">Large</.button>
            <.button variant="primary" size="xl">Extra Large</.button>
          </.button_group>
        </.card>
      </.column>
    </.grid>

    <%!-- Theme Color Buttons --%>
    <.grid>
      <.column size="100" lg="1-2">
        <.card title_text="Theme Color Buttons">
          <.button_group>
            <.button :for={n <- 1..9} theme_color={to_string(n)}>Color {n}</.button>
          </.button_group>
        </.card>
      </.column>
      <.column size="100" lg="1-2">
        <.card title_text="Theme Color Outline Buttons">
          <.button_group>
            <.button :for={n <- 1..9} theme_color={to_string(n)} is_outline>Color {n}</.button>
          </.button_group>
        </.card>
      </.column>
    </.grid>

    <%!-- Outline and States --%>
    <.grid>
      <.column size="100" lg="1-2">
        <.card title_text="Outline Buttons">
          <.button_group>
            <.button variant="primary" is_outline>Primary</.button>
            <.button variant="secondary" is_outline>Secondary</.button>
            <.button variant="success" is_outline>Success</.button>
            <.button variant="warning" is_outline>Warning</.button>
            <.button variant="danger" is_outline>Danger</.button>
            <.button variant="info" is_outline>Info</.button>
          </.button_group>
        </.card>
      </.column>

      <.column size="100" lg="1-2">
        <.card title_text="Button States">
          <.button_group>
            <.button variant="primary">Normal</.button>
            <.button variant="primary" disabled>Disabled</.button>
            <.button variant="primary" is_loading>Loading...</.button>
          </.button_group>
        </.card>
      </.column>
    </.grid>

    <%!-- Block Buttons --%>
    <.card title_text="Block Buttons">
      <.button_group is_vertical>
        <.button variant="primary" is_block>Block Level Button</.button>
        <.button variant="secondary" is_block>Another Block Button</.button>
      </.button_group>
    </.card>

    <%!-- Button Groups --%>
    <.grid>
      <.column size="100" lg="1-2">
        <.card title_text="Button Groups - Basic">
          <.heading level={4}>Horizontal (default)</.heading>
          <.button_group>
            <.button variant="secondary">Start</.button>
            <.button variant="secondary">Middle</.button>
            <.button variant="secondary">End</.button>
          </.button_group>

          <.heading level={4} class="mt-2">Vertical</.heading>
          <.button_group is_vertical>
            <.button variant="secondary">Top</.button>
            <.button variant="secondary">Middle</.button>
            <.button variant="secondary">Bottom</.button>
          </.button_group>

          <.heading level={4} class="mt-2">No-Wrap (prevents line breaks)</.heading>
          <.button_group is_nowrap>
            <.button variant="primary">One</.button>
            <.button variant="primary">Two</.button>
            <.button variant="primary">Three</.button>
            <.button variant="primary">Four</.button>
            <.button variant="primary">Five</.button>
          </.button_group>
        </.card>
      </.column>

      <.column size="100" lg="1-2">
        <.card title_text="Button Groups - Gap Sizes">
          <.heading level={4}>Semantic Gap Classes</.heading>
          <.paragraph class="text-muted mb-1"><code>gap-xs</code> (4px)</.paragraph>
          <.button_group class="gap-xs mb-1">
            <.button variant="primary">A</.button>
            <.button variant="primary">B</.button>
            <.button variant="primary">C</.button>
            <.button variant="primary">D</.button>
          </.button_group>
          <.paragraph class="text-muted mb-1"><code>gap-sm</code> (8px)</.paragraph>
          <.button_group class="gap-sm mb-1">
            <.button variant="secondary">A</.button>
            <.button variant="secondary">B</.button>
            <.button variant="secondary">C</.button>
            <.button variant="secondary">D</.button>
          </.button_group>
          <.paragraph class="text-muted mb-1"><code>gap-md</code> (12px)</.paragraph>
          <.button_group class="gap-md mb-1">
            <.button variant="success">A</.button>
            <.button variant="success">B</.button>
            <.button variant="success">C</.button>
            <.button variant="success">D</.button>
          </.button_group>
          <.paragraph class="text-muted mb-1"><code>gap-base</code> (16px)</.paragraph>
          <.button_group class="gap-base mb-1">
            <.button variant="info">A</.button>
            <.button variant="info">B</.button>
            <.button variant="info">C</.button>
            <.button variant="info">D</.button>
          </.button_group>
          <.paragraph class="text-muted mb-1"><code>gap-lg</code> (24px)</.paragraph>
          <.button_group class="gap-lg mb-1">
            <.button variant="warning">A</.button>
            <.button variant="warning">B</.button>
            <.button variant="warning">C</.button>
            <.button variant="warning">D</.button>
          </.button_group>
          <.paragraph class="text-muted mb-1"><code>gap-xl</code> (32px)</.paragraph>
          <.button_group class="gap-xl">
            <.button variant="danger">A</.button>
            <.button variant="danger">B</.button>
            <.button variant="danger">C</.button>
            <.button variant="danger">D</.button>
          </.button_group>
        </.card>
      </.column>
    </.grid>

    <%!-- Vertical Alignment & Responsive --%>
    <.grid>
      <.column size="100" lg="1-2">
        <.card title_text="Vertical Alignment">
          <.paragraph class="text-muted mb-md">
            Use semantic gap classes (<code>gap-sm</code>, <code>gap-md</code>, <code>gap-lg</code>, <code>gap-xl</code>) to control vertical spacing between buttons.
          </.paragraph>
          <.grid>
            <.column size="50" xl="25">
              <.heading level={4}>Start <code>gap-sm</code></.heading>
              <.button_group is_vertical class="gap-sm">
                <.button variant="secondary" class="text-truncate">Short</.button>
                <.button variant="secondary" class="text-truncate">Medium Btn</.button>
                <.button variant="secondary" class="text-truncate">Long Button</.button>
              </.button_group>
            </.column>
            <.column size="50" xl="25">
              <.heading level={4}>Center <code>gap-md</code></.heading>
              <.button_group is_vertical align="center" class="gap-md">
                <.button variant="secondary" class="text-truncate">Short</.button>
                <.button variant="secondary" class="text-truncate">Medium Btn</.button>
                <.button variant="secondary" class="text-truncate">Long Button</.button>
              </.button_group>
            </.column>
            <.column size="50" xl="25">
              <.heading level={4}>End <code>gap-lg</code></.heading>
              <.button_group is_vertical align="end" class="gap-lg">
                <.button variant="secondary" class="text-truncate">Short</.button>
                <.button variant="secondary" class="text-truncate">Medium Btn</.button>
                <.button variant="secondary" class="text-truncate">Long Button</.button>
              </.button_group>
            </.column>
            <.column size="50" xl="25">
              <.heading level={4}>Stretch <code>gap-xl</code></.heading>
              <.button_group is_vertical align="stretch" class="gap-xl">
                <.button variant="primary" class="text-truncate">Save</.button>
                <.button variant="secondary" class="text-truncate">Cancel</.button>
                <.button variant="danger" class="text-truncate">DELETE</.button>
              </.button_group>
            </.column>
          </.grid>
        </.card>
      </.column>

      <.column size="100" lg="1-2">
        <.card title_text="Responsive Direction">
          <.heading level={4}>Horizontal → Vertical at md (768px)</.heading>
          <.paragraph class="text-muted mb-1">Resize window to see change</.paragraph>
          <.button_group responsive="md-vertical">
            <.button variant="primary">Save</.button>
            <.button variant="secondary">Cancel</.button>
            <.button variant="danger">Delete</.button>
          </.button_group>

          <.heading level={4} class="mt-2">Vertical → Horizontal at lg (992px)</.heading>
          <.paragraph class="text-muted mb-1">Starts vertical, becomes horizontal on large screens</.paragraph>
          <.button_group is_vertical responsive="lg-horizontal">
            <.button variant="success">Approve</.button>
            <.button variant="warning">Review</.button>
            <.button variant="danger">Reject</.button>
          </.button_group>

          <.heading level={4} class="mt-2">Class Reference</.heading>
          <ul class="text-sm">
            <li><code>--sm-vertical</code> / <code>--sm-horizontal</code> at 576px</li>
            <li><code>--md-vertical</code> / <code>--md-horizontal</code> at 768px</li>
            <li><code>--lg-vertical</code> / <code>--lg-horizontal</code> at 992px</li>
            <li><code>--xl-vertical</code> / <code>--xl-horizontal</code> at 1200px</li>
          </ul>
        </.card>
      </.column>
    </.grid>

    <%!-- Text Truncation --%>
    <.card title_text="Text Truncation">
      <.paragraph class="text-muted mb-1">
        Use <code>.text-truncate</code> with a fixed width (<code>.wr-*</code>) to truncate long text with ellipsis
      </.paragraph>
      <div class="component-showcase">
        <.button variant="secondary" class="text-truncate wr-15">
          This is a very long button text that will be truncated with ellipsis
        </.button>
        <.button variant="primary" class="text-truncate wr-10">
          Another long button
        </.button>
        <.button variant="success" class="text-truncate wr-8">
          Short width truncation
        </.button>
      </div>
    </.card>

    <%!-- Icon Buttons --%>
    <.grid>
      <.column size="100" lg="1-2">
        <.card title_text="Buttons with Text Icons">
          <.paragraph class="mb-1">
            Buttons with icons are automatically left-aligned with fixed-width icon container:
          </.paragraph>
          <.button_group>
            <.button variant="primary">
              <:icon>→</:icon>
              Next
            </.button>
            <.button variant="secondary">
              <:icon>←</:icon>
              Previous
            </.button>
            <.button variant="success">
              <:icon>✓</:icon>
              Save
            </.button>
            <.button variant="danger">
              <:icon>×</:icon>
              Delete
            </.button>
          </.button_group>
        </.card>
      </.column>

      <.column size="100" lg="1-2">
        <.card title_text="Icon Only Buttons">
          <.paragraph class="mb-2">Icon-only button sizes (XS → XL):</.paragraph>
          <.button_group class="mb-2">
            <.button variant="primary" is_icon_only size="xs" title="XS - 28px"><i class="fa-solid fa-star"></i></.button>
            <.button variant="primary" is_icon_only size="sm" title="SM - 32px"><i class="fa-solid fa-star"></i></.button>
            <.button variant="primary" is_icon_only title="Default - 40px"><i class="fa-solid fa-star"></i></.button>
            <.button variant="primary" is_icon_only size="lg" title="LG - 48px"><i class="fa-solid fa-star"></i></.button>
            <.button variant="primary" is_icon_only size="xl" title="XL - 56px"><i class="fa-solid fa-star"></i></.button>
          </.button_group>
          <.paragraph class="mb-2">Various colors - default size:</.paragraph>
          <.button_group class="mb-2">
            <.button variant="primary" is_icon_only title="Save"><i class="fa-solid fa-floppy-disk"></i></.button>
            <.button variant="secondary" is_icon_only title="Search"><i class="fa-solid fa-magnifying-glass"></i></.button>
            <.button variant="success" is_icon_only title="Check"><i class="fa-solid fa-check"></i></.button>
            <.button variant="warning" is_icon_only title="Warning"><i class="fa-solid fa-triangle-exclamation"></i></.button>
            <.button variant="danger" is_icon_only title="Trash"><i class="fa-solid fa-trash"></i></.button>
            <.button variant="info" is_icon_only title="Info"><i class="fa-solid fa-circle-info"></i></.button>
          </.button_group>
          <.paragraph class="mb-2">Compact (XS) - perfect for table actions:</.paragraph>
          <.button_group>
            <.button variant="primary" is_icon_only size="xs" title="View">👁️</.button>
            <.button variant="secondary" is_icon_only size="xs" title="Edit">✏️</.button>
            <.button variant="danger" is_icon_only size="xs" title="Delete">🗑️</.button>
            <.button variant="success" is_icon_only size="xs" title="Check"><i class="fa-solid fa-check"></i></.button>
            <.button variant="warning" is_icon_only size="xs" title="Warning"><i class="fa-solid fa-triangle-exclamation"></i></.button>
            <.button variant="info" is_icon_only size="xs" title="Download"><i class="fa-solid fa-download"></i></.button>
          </.button_group>
          <.paragraph class="mb-2">With ripple and loading states (click to test):</.paragraph>
          <.button_group>
            <.button variant="primary" is_icon_only is_ripple title="Save" is_loading={@loading_btn == "icon-save"} phx-click="toggle_loading" phx-value-btn="icon-save"><i class="fa-solid fa-floppy-disk"></i></.button>
            <.button variant="secondary" is_icon_only is_ripple title="Refresh" is_loading={@loading_btn == "icon-refresh"} phx-click="toggle_loading" phx-value-btn="icon-refresh"><i class="fa-solid fa-rotate-right"></i></.button>
            <.button variant="success" is_icon_only is_ripple title="Upload" is_loading={@loading_btn == "icon-upload"} phx-click="toggle_loading" phx-value-btn="icon-upload"><i class="fa-solid fa-upload"></i></.button>
            <.button variant="danger" is_icon_only is_ripple title="Delete" is_loading={@loading_btn == "icon-delete"} phx-click="toggle_loading" phx-value-btn="icon-delete"><i class="fa-solid fa-trash"></i></.button>
          </.button_group>
        </.card>
      </.column>
    </.grid>

    <%!-- Fixed Width Buttons --%>
    <.card title_text="Fixed Width Buttons">
      <.paragraph class="mb-1">
        Use <code>minwr-*</code> + <code>maxwr-*</code> to constrain width. Add <code>text-truncate</code> on an inner span for ellipsis:
      </.paragraph>
      <div class="d-flex flex-column align-items-start gap-sm">
        <.button variant="primary" class="minwr-10 maxwr-10">
          <:icon>✓</:icon>
          <span class="text-truncate">OK</span>
        </.button>
        <.button variant="success" class="minwr-10 maxwr-10">
          <:icon>→</:icon>
          <span class="text-truncate">Save Changes</span>
        </.button>
        <.button variant="secondary" class="minwr-10 maxwr-10">
          <:icon>×</:icon>
          <span class="text-truncate">Cancel and Go Back</span>
        </.button>
      </div>

      <.heading level={4} class="mt-6">Different Widths (<code>minwr-8</code> to <code>minwr-20</code>)</.heading>
      <div class="d-flex flex-column align-items-start gap-sm">
        <.button variant="primary" class="minwr-8">minwr-8</.button>
        <.button variant="primary" class="minwr-10">minwr-10</.button>
        <.button variant="primary" class="minwr-15">minwr-15</.button>
        <.button variant="primary" class="minwr-20">minwr-20</.button>
      </div>
    </.card>

    <%!-- Button Text Alignment --%>
    <.grid>
      <.column size="100" lg="1-2">
        <.card title_text="Button Text Alignment">
          <.paragraph class="mb-1">Control text alignment within fixed-width buttons. Note the varied text lengths to show the effect:</.paragraph>

          <.heading level={4}>Inline Start Aligned</.heading>
          <.button_group is_vertical>
            <.button variant="primary" class="wr-20" align="start">
              <:icon>✓</:icon>
              OK
            </.button>
            <.button variant="success" class="wr-20" align="start">
              <:icon>→</:icon>
              Continue
            </.button>
            <.button variant="secondary" class="wr-20" align="start">
              <:icon>×</:icon>
              Discard All Changes
            </.button>
          </.button_group>

          <.heading level={4} class="mt-6">Inline End Aligned</.heading>
          <.button_group is_vertical>
            <.button variant="primary" class="wr-20" align="end" icon_position="end">
              <:icon>✓</:icon>
              OK
            </.button>
            <.button variant="success" class="wr-20" align="end" icon_position="end">
              <:icon>→</:icon>
              Continue
            </.button>
            <.button variant="secondary" class="wr-20" align="end" icon_position="end">
              <:icon>×</:icon>
              Discard All Changes
            </.button>
          </.button_group>

          <.heading level={4} class="mt-6">Center Aligned</.heading>
          <.button_group is_vertical>
            <.button variant="primary" class="wr-20" align="center">
              <:icon>✓</:icon>
              OK
            </.button>
            <.button variant="success" class="wr-20" align="center">Continue</.button>
            <.button variant="secondary" class="wr-20" align="center">Discard All Changes</.button>
          </.button_group>

          <.heading level={4} class="mt-6">Justified</.heading>
          <.button_group is_vertical>
            <.button variant="primary" class="wr-20" align="justify">
              <:icon>✓</:icon>
              OK
            </.button>
            <.button variant="success" class="wr-20" align="justify">
              <:icon>→</:icon>
              Continue
            </.button>
            <.button variant="secondary" class="wr-20" align="justify">
              <:icon>×</:icon>
              Discard All Changes
            </.button>
          </.button_group>
        </.card>
      </.column>

      <.column size="100" lg="1-2">
        <.card title_text="Font Awesome Icons">
          <.paragraph class="mb-1">Font Awesome icons with varied text lengths to show alignment:</.paragraph>

          <.heading level={4}>Inline Start Aligned</.heading>
          <.button_group is_vertical>
            <.button variant="primary" class="wr-20" align="start">
              <:icon><i class="fa-solid fa-floppy-disk"></i></:icon>
              Save
            </.button>
            <.button variant="success" class="wr-20" align="start">
              <:icon><i class="fa-solid fa-check"></i></:icon>
              Approve Request
            </.button>
            <.button variant="danger" class="wr-20" align="start">
              <:icon><i class="fa-solid fa-trash"></i></:icon>
              Delete Selected Items
            </.button>
          </.button_group>

          <.heading level={4} class="mt-6">Inline End Aligned</.heading>
          <.button_group is_vertical>
            <.button variant="primary" class="wr-20" align="end" icon_position="end">
              <:icon><i class="fa-solid fa-floppy-disk"></i></:icon>
              Save
            </.button>
            <.button variant="success" class="wr-20" align="end" icon_position="end">
              <:icon><i class="fa-solid fa-arrow-right"></i></:icon>
              Approve Request
            </.button>
            <.button variant="secondary" class="wr-20" align="end" icon_position="end">
              <:icon><i class="fa-solid fa-gear"></i></:icon>
              Delete Selected Items
            </.button>
          </.button_group>

          <.heading level={4} class="mt-6">Center Aligned</.heading>
          <.button_group is_vertical>
            <.button variant="primary" class="wr-20" align="center">
              <:icon><i class="fa-solid fa-upload"></i></:icon>
              Upload
            </.button>
            <.button variant="success" class="wr-20" align="center">
              <:icon><i class="fa-solid fa-plus"></i></:icon>
              Add New Item
            </.button>
            <.button variant="info" class="wr-20" align="center">
              <:icon><i class="fa-solid fa-magnifying-glass"></i></:icon>
              Search Entire Database
            </.button>
          </.button_group>

          <.heading level={4} class="mt-6">Justified</.heading>
          <.button_group is_vertical>
            <.button variant="primary" class="wr-20" align="justify">
              <:icon><i class="fa-solid fa-user"></i></:icon>
              Profile
            </.button>
            <.button variant="success" class="wr-20" align="justify">
              <:icon><i class="fa-solid fa-envelope"></i></:icon>
              Messages
            </.button>
            <.button variant="danger" class="wr-20" align="justify">
              <:icon><i class="fa-solid fa-right-from-bracket"></i></:icon>
              Logout
            </.button>
          </.button_group>
        </.card>
      </.column>
    </.grid>

    <%!-- Interactive Effects --%>
    <.grid>
      <.column size="100" lg="1-2">
        <.card title_text="Ripple Effect Buttons">
          <.paragraph class="mb-1">Click buttons to see ripple animation effect:</.paragraph>
          <.button_group>
            <.button variant="primary" is_ripple>Primary Ripple</.button>
            <.button variant="secondary" is_ripple>Secondary Ripple</.button>
            <.button variant="success" is_ripple>Success Ripple</.button>
            <.button variant="warning" is_ripple>Warning Ripple</.button>
            <.button variant="danger" is_ripple>Danger Ripple</.button>
          </.button_group>
        </.card>
      </.column>

      <.column size="100" lg="1-2">
        <.card title_text="Loading State Buttons">
          <.paragraph class="mb-1">Click buttons to simulate loading states (1-3s):</.paragraph>
          <.button_group>
            <.button
              variant="primary"
              is_loading={@loading_btn == "save"}
              phx-click="toggle_loading"
              phx-value-btn="save"
            >
              Save Changes
            </.button>
            <.button
              variant="secondary"
              is_loading={@loading_btn == "load"}
              phx-click="toggle_loading"
              phx-value-btn="load"
            >
              Load Data
            </.button>
            <.button
              variant="success"
              is_loading={@loading_btn == "submit"}
              phx-click="toggle_loading"
              phx-value-btn="submit"
            >
              Submit Form
            </.button>
            <.button
              variant="warning"
              is_loading={@loading_btn == "process"}
              phx-click="toggle_loading"
              phx-value-btn="process"
            >
              Process
            </.button>
            <.button
              variant="danger"
              is_loading={@loading_btn == "delete"}
              phx-click="toggle_loading"
              phx-value-btn="delete"
            >
              Delete Item
            </.button>
          </.button_group>
        </.card>
      </.column>
    </.grid>

    <%!-- Split Buttons --%>
    <.grid>
      <.column size="100" lg="1-2">
        <.card title_text="Split Buttons">
          <.paragraph class="mb-1">A primary action with a dropdown for secondary actions:</.paragraph>
          <.button_group>
            <.split_button label="Save" variant="primary" on_click="split_action">
              <:item on_click="split_action" action="save-draft">Save as Draft</:item>
              <:item on_click="split_action" action="save-close">Save & Close</:item>
            </.split_button>

            <.split_button label="Export" variant="primary" on_click="split_action">
              <:item on_click="split_action" action="export-csv">Export as CSV</:item>
              <:item on_click="split_action" action="export-pdf">Export as PDF</:item>
              <:item is_danger on_click="split_action" action="delete-all">Delete All</:item>
            </.split_button>

            <.split_button label="Delete" variant="danger" on_click="split_action">
              <:item is_danger on_click="split_action" action="delete-permanent">Delete Permanently</:item>
              <:item on_click="split_action" action="move-trash">Move to Trash</:item>
            </.split_button>
          </.button_group>
        </.card>
      </.column>

      <.column size="100" lg="1-2">
        <.card title_text="Split Button Variants">
          <.paragraph class="mb-1">Upward placement and custom icons:</.paragraph>
          <.button_group>
            <.split_button label="Upload" variant="primary" placement="top-end">
              <:item>Upload File</:item>
              <:item>Upload Folder</:item>
            </.split_button>

            <.split_button label="Share" variant="secondary">
              <:item>Share via Email</:item>
              <:item>Share via Link</:item>
            </.split_button>
          </.button_group>

          <.paragraph class="mb-1 mt-2">Different sizes:</.paragraph>
          <.button_group>
            <.split_button label="Small" variant="primary" size="sm">
              <:item>Option A</:item>
              <:item>Option B</:item>
            </.split_button>

            <.split_button label="Default" variant="primary">
              <:item>Option A</:item>
              <:item>Option B</:item>
            </.split_button>

            <.split_button label="Large" variant="primary" size="lg">
              <:item>Option A</:item>
              <:item>Option B</:item>
            </.split_button>
          </.button_group>
        </.card>
      </.column>
    </.grid>

    <%!-- Usage Guide --%>
    <.card title_text="Usage Guide">
      <.heading level={4}>Ripple Effect</.heading>
      <.paragraph>
        Add <code>pa-btn--ripple</code> class and <code>data-ripple</code> attribute to any button for click animation feedback.
      </.paragraph>

      <.heading level={4}>Loading States</.heading>
      <.paragraph>
        Use <code>pa-btn--loading</code> class to show spinner. JavaScript can toggle this class during async operations.
      </.paragraph>

      <.heading level={4}>Best Practices</.heading>
      <.basic_list>
        <li><strong>Fast Sites:</strong> Always show loading feedback, even for quick operations (200-500ms minimum)</li>
        <li><strong>User Confidence:</strong> Ripple effects confirm button clicks were registered</li>
        <li><strong>Prevent Double-clicks:</strong> Disable buttons during loading to prevent duplicate submissions</li>
        <li><strong>Accessibility:</strong> Loading states are announced to screen readers</li>
      </.basic_list>
    </.card>

    <%!-- CSS Classes Reference --%>
    <.card title_text="CSS Classes Reference">
      <.heading level={4}>Button Base</.heading>
      <.basic_list spacing="compact">
        <li><code>pa-btn</code> - Base button styling</li>
      </.basic_list>

      <.heading level={4} class="mt-4">Button Variants (Colors)</.heading>
      <.basic_list spacing="compact">
        <li><code>pa-btn--primary</code> - Primary accent color</li>
        <li><code>pa-btn--secondary</code> - Secondary/neutral color</li>
        <li><code>pa-btn--success</code> - Success/green color</li>
        <li><code>pa-btn--warning</code> - Warning/yellow color</li>
        <li><code>pa-btn--danger</code> - Danger/red color</li>
        <li><code>pa-btn--info</code> - Info/blue color</li>
        <li><code>pa-btn--light</code> - Light background</li>
        <li><code>pa-btn--dark</code> - Dark background</li>
      </.basic_list>

      <.heading level={4} class="mt-4">Outline Variants</.heading>
      <.basic_list spacing="compact">
        <li><code>pa-btn--outline-primary</code> - Outline primary</li>
        <li><code>pa-btn--outline-secondary</code> - Outline secondary</li>
        <li><code>pa-btn--outline-success</code> - Outline success</li>
        <li><code>pa-btn--outline-warning</code> - Outline warning</li>
        <li><code>pa-btn--outline-danger</code> - Outline danger</li>
        <li><code>pa-btn--outline-info</code> - Outline info</li>
      </.basic_list>

      <.heading level={4} class="mt-4">Button Sizes</.heading>
      <.basic_list spacing="compact">
        <li><code>pa-btn--xs</code> - Extra small button</li>
        <li><code>pa-btn--sm</code> - Small button</li>
        <li><code>pa-btn--lg</code> - Large button</li>
        <li><code>pa-btn--xl</code> - Extra large button</li>
      </.basic_list>

      <.heading level={4} class="mt-4">Button States & Modifiers</.heading>
      <.basic_list spacing="compact">
        <li><code>pa-btn--loading</code> - Loading state with spinner</li>
        <li><code>pa-btn--ripple</code> - Enable ripple click effect</li>
        <li><code>pa-btn--block</code> - Full width block button</li>
        <li><code>pa-btn--icon-only</code> - Square icon-only button</li>
      </.basic_list>

      <.heading level={4} class="mt-4">Content Alignment</.heading>
      <.basic_list spacing="compact">
        <li><code>pa-btn--align-start</code> - Inline-start align content (RTL: right)</li>
        <li><code>pa-btn--align-end</code> - Inline-end align content (RTL: left)</li>
        <li><code>pa-btn--align-center</code> - Center-align content</li>
        <li><code>pa-btn--align-justify</code> - Space-between content</li>
      </.basic_list>

      <.heading level={4} class="mt-4">Button Elements</.heading>
      <.basic_list spacing="compact">
        <li><code>pa-btn__icon</code> - Icon container with fixed width</li>
        <li><code>pa-btn__spinner</code> - Loading spinner element</li>
      </.basic_list>

      <.heading level={4} class="mt-4">Button Groups</.heading>
      <.basic_list spacing="compact">
        <li><code>pa-btn-group</code> - Container for grouped buttons</li>
        <li><code>pa-btn-group--vertical</code> - Vertical stacking</li>
        <li><code>pa-btn-group--nowrap</code> - Prevent wrapping</li>
      </.basic_list>

      <.heading level={4} class="mt-4">Button Group Alignment (vertical only)</.heading>
      <.basic_list spacing="compact">
        <li><code>pa-btn-group--center</code> - Center-align buttons</li>
        <li><code>pa-btn-group--end</code> - End-align buttons</li>
        <li><code>pa-btn-group--stretch</code> - Full width buttons</li>
      </.basic_list>

      <.heading level={4} class="mt-4">Responsive Button Groups</.heading>
      <.basic_list spacing="compact">
        <li><code>pa-btn-group--sm-vertical</code> - Vertical at 576px+</li>
        <li><code>pa-btn-group--sm-horizontal</code> - Horizontal at 576px+</li>
        <li><code>pa-btn-group--md-vertical</code> - Vertical at 768px+</li>
        <li><code>pa-btn-group--md-horizontal</code> - Horizontal at 768px+</li>
        <li><code>pa-btn-group--lg-vertical</code> - Vertical at 992px+</li>
        <li><code>pa-btn-group--lg-horizontal</code> - Horizontal at 992px+</li>
        <li><code>pa-btn-group--xl-vertical</code> - Vertical at 1200px+</li>
        <li><code>pa-btn-group--xl-horizontal</code> - Horizontal at 1200px+</li>
      </.basic_list>
    </.card>
    """
  end
end
