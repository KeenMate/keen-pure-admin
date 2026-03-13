defmodule DemoWeb.Live.CardsLive do
  use DemoWeb, :live_view

  def mount(_params, _session, socket) do
    orders = [
      %{product: "Widget A", amount: "$99.00", status: "Paid", status_variant: "success"},
      %{product: "Widget B", amount: "$149.00", status: "Pending", status_variant: "warning"},
      %{product: "Widget C", amount: "$249.00", status: "Processing", status_variant: "info"}
    ]

    {:ok, assign(socket, page_title: "Cards", active_tab: "overview", orders: orders)}
  end

  def handle_event("switch_tab", %{"tab" => tab}, socket) do
    {:noreply, assign(socket, :active_tab, tab)}
  end

  def render(assigns) do
    ~H"""
    <h1 class="pa-page-title">Cards</h1>
    <p class="pa-page-subtitle">
      Flexible content containers for organizing and displaying information.
    </p>

    <%!-- Same Height Cards --%>
    <.card title_text="Same Height Cards">
      <.grid is_same_height>
        <.column size="33">
          <.card>Short content.</.card>
        </.column>
        <.column size="33">
          <.card>
            <p>This card has more content to demonstrate the same-height behavior.</p>
            <p>
              It includes multiple paragraphs of text to make it taller than the other cards in the same row.
            </p>
          </.card>
        </.column>
        <.column size="33">
          <.card>Medium length content here.</.card>
        </.column>
      </.grid>
    </.card>

    <%!-- Basic Cards --%>
    <.grid>
      <.column size="25">
        <.card>
          Simple card with just body content.
        </.card>
      </.column>
      <.column size="25">
        <.card>
          <:header>
            <h3>Card with Header</h3>
          </:header>
          Card body content with a header above.
        </.card>
      </.column>
      <.column size="25">
        <.card>
          Card body content with a footer below.
          <:footer>
            <.button variant="primary" size="sm">Action</.button>
          </:footer>
        </.card>
      </.column>
      <.column size="25">
        <.card title_text="Complete Card">
          <:tools>
            <.button variant="secondary" size="xs" is_icon_only title="Settings">
              <i class="fa-solid fa-gear"></i>
            </.button>
          </:tools>
          Complete card with title, tools, and footer.
          <:actions>
            <.button variant="primary" size="sm">Save</.button>
            <.button variant="secondary" size="sm">Cancel</.button>
          </:actions>
        </.card>
      </.column>
    </.grid>

    <%!-- Ghost Card --%>
    <.card title_text="Ghost Card">
      <.grid>
        <.column size="33">
          <.card is_ghost>
            Ghost card with no background, border, or shadow.
          </.card>
        </.column>
        <.column size="33">
          <.card>
            Normal card for comparison.
          </.card>
        </.column>
      </.grid>
    </.card>

    <%!-- Underlined Header Cards --%>
    <.card title_text="Header Underline Styles">
      <.grid>
        <.column size="25">
          <.card title_text="Default Underline" is_header_underlined>
            Card with default underlined header.
          </.card>
        </.column>
        <.column size="25">
          <.card title_text="Success Underline" is_header_underlined header_underline_color="success">
            Card with success-colored underline.
          </.card>
        </.column>
        <.column size="25">
          <.card title_text="Warning Underline" is_header_underlined header_underline_color="warning">
            Card with warning-colored underline.
          </.card>
        </.column>
        <.column size="25">
          <.card title_text="Danger Underline" is_header_underlined header_underline_color="danger">
            Card with danger-colored underline.
          </.card>
        </.column>
      </.grid>
    </.card>

    <%!-- Colored Cards --%>
    <.card title_text="Colored Cards">
      <.grid>
        <.column size="20">
          <.card variant="primary" title_text="Primary">Primary card content.</.card>
        </.column>
        <.column size="20">
          <.card variant="success" title_text="Success">Success card content.</.card>
        </.column>
        <.column size="20">
          <.card variant="warning" title_text="Warning">Warning card content.</.card>
        </.column>
        <.column size="20">
          <.card variant="danger" title_text="Danger">Danger card content.</.card>
        </.column>
        <.column size="20">
          <.card variant="info" title_text="Info">Info card content.</.card>
        </.column>
      </.grid>
    </.card>

    <%!-- Title with Description --%>
    <.card title_text="Card with Description" description_text="This is a description that provides additional context about the card content">
      Cards can have inline description text in the header that truncates with ellipsis.
    </.card>

    <%!-- Statistics Cards --%>
    <.card title_text="Statistics Cards">
      <.grid>
        <.column size="25">
          <.card variant="stat">
            <.stat number="1,234" label_text="Total Users">
              <:icon><i class="fa-solid fa-users"></i></:icon>
            </.stat>
          </.card>
        </.column>
        <.column size="25">
          <.card variant="stat">
            <.stat number="$45,678" label_text="Revenue" icon_variant="success">
              <:icon><i class="fa-solid fa-dollar-sign"></i></:icon>
            </.stat>
          </.card>
        </.column>
        <.column size="25">
          <.card variant="stat">
            <.stat number="567" label_text="Orders" icon_variant="warning">
              <:icon><i class="fa-solid fa-box"></i></:icon>
            </.stat>
          </.card>
        </.column>
        <.column size="25">
          <.card variant="stat">
            <.stat number="+12%" label_text="Growth"
              change_text="+12%" change_direction="positive" icon_variant="success">
              <:icon><i class="fa-solid fa-chart-line"></i></:icon>
            </.stat>
          </.card>
        </.column>
      </.grid>
    </.card>

    <%!-- Data Display Card --%>
    <.grid>
      <.column size="50">
        <.card has_padding={false} title_text="Recent Orders">
          <.table rows={@orders} size="xs">
            <:col :let={order} label="Product"><%= order.product %></:col>
            <:col :let={order} label="Amount"><%= order.amount %></:col>
            <:col :let={order} label="Status">
              <.badge variant={order.status_variant} size="sm"><%= order.status %></.badge>
            </:col>
          </.table>
        </.card>
      </.column>
      <.column size="50">
        <.card title_text="Card with Metadata" description_text="Last updated: 5 min ago">
          <:tools>
            <.button variant="secondary" size="xs">Refresh</.button>
          </:tools>
          Card content with metadata displayed in the header.
        </.card>
      </.column>
    </.grid>

    <%!-- Card with Tabs --%>
    <.card title_text="Card with Tabs" has_inline_tabs>
      <:tabs>
        <.card_tab is_active={@active_tab == "overview"} phx-click="switch_tab" phx-value-tab="overview">
          Overview
        </.card_tab>
        <.card_tab is_active={@active_tab == "details"} phx-click="switch_tab" phx-value-tab="details">
          Details
        </.card_tab>
        <.card_tab is_active={@active_tab == "settings"} phx-click="switch_tab" phx-value-tab="settings">
          Settings
        </.card_tab>
      </:tabs>
      <p :if={@active_tab == "overview"}>This is the overview tab content.</p>
      <p :if={@active_tab == "details"}>This is the details tab content with more information.</p>
      <p :if={@active_tab == "settings"}>This is the settings tab content for configuration.</p>
    </.card>
    """
  end
end
