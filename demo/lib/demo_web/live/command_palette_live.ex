defmodule DemoWeb.Live.CommandPaletteLive do
  use DemoWeb, :live_view

  @page_size 8

  @products [
    %{id: "p1", title: "MacBook Pro 16\"", meta: "Electronics · $2,499", icon: "💻", badge: "In Stock"},
    %{id: "p2", title: "iPhone 15 Pro", meta: "Electronics · $999", icon: "📱", badge: "In Stock"},
    %{id: "p3", title: "AirPods Pro", meta: "Electronics · $249", icon: "🎧", badge: "Low Stock"},
    %{id: "p4", title: "iPad Air", meta: "Electronics · $599", icon: "📱", badge: "In Stock"},
    %{id: "p5", title: "Apple Watch Ultra", meta: "Electronics · $799", icon: "⌚", badge: "In Stock"},
    %{id: "p6", title: "Magic Keyboard", meta: "Accessories · $299", icon: "⌨️", badge: "In Stock"},
    %{id: "p7", title: "Studio Display", meta: "Electronics · $1,599", icon: "🖥️", badge: "Pre-order"},
    %{id: "p8", title: "HomePod mini", meta: "Electronics · $99", icon: "🔊", badge: "In Stock"},
    %{id: "p9", title: "AirTag 4 Pack", meta: "Accessories · $99", icon: "📍", badge: "In Stock"},
    %{id: "p10", title: "MagSafe Charger", meta: "Accessories · $39", icon: "🔌", badge: "In Stock"}
  ]

  @orders [
    %{id: "o1", title: "Order #10421", meta: "John Doe · 3 items · $3,747", icon: "📦", badge: "Shipped"},
    %{id: "o2", title: "Order #10422", meta: "Jane Smith · 1 item · $999", icon: "📦", badge: "Processing"},
    %{id: "o3", title: "Order #10423", meta: "Bob Wilson · 2 items · $348", icon: "📦", badge: "Delivered"},
    %{id: "o4", title: "Order #10424", meta: "Alice Brown · 1 item · $2,499", icon: "📦", badge: "Pending"},
    %{id: "o5", title: "Order #10425", meta: "Charlie Davis · 5 items · $1,235", icon: "📦", badge: "Shipped"},
    %{id: "o6", title: "Order #10426", meta: "Diana Evans · 2 items · $698", icon: "📦", badge: "Delivered"},
    %{id: "o7", title: "Order #10427", meta: "Frank Garcia · 1 item · $599", icon: "📦", badge: "Processing"},
    %{id: "o8", title: "Order #10428", meta: "Grace Hall · 3 items · $447", icon: "📦", badge: "Shipped"},
    %{id: "o9", title: "Order #10429", meta: "Henry Irving · 1 item · $799", icon: "📦", badge: "Pending"},
    %{id: "o10", title: "Order #10430", meta: "Ivy Johnson · 4 items · $1,836", icon: "📦", badge: "Delivered"}
  ]

  @users [
    %{id: "u1", title: "John Doe", meta: "john@example.com · Admin", icon: "👤", badge: "Active"},
    %{id: "u2", title: "Jane Smith", meta: "jane@example.com · Editor", icon: "👤", badge: "Active"},
    %{id: "u3", title: "Bob Wilson", meta: "bob@example.com · Viewer", icon: "👤", badge: "Inactive"},
    %{id: "u4", title: "Alice Brown", meta: "alice@example.com · Admin", icon: "👤", badge: "Active"},
    %{id: "u5", title: "Charlie Davis", meta: "charlie@example.com · Editor", icon: "👤", badge: "Active"},
    %{id: "u6", title: "Diana Evans", meta: "diana@example.com · Viewer", icon: "👤", badge: "Active"},
    %{id: "u7", title: "Frank Garcia", meta: "frank@example.com · Editor", icon: "👤", badge: "Inactive"},
    %{id: "u8", title: "Grace Hall", meta: "grace@example.com · Admin", icon: "👤", badge: "Active"},
    %{id: "u9", title: "Henry Irving", meta: "henry@example.com · Viewer", icon: "👤", badge: "Active"},
    %{id: "u10", title: "Ivy Johnson", meta: "ivy@example.com · Editor", icon: "👤", badge: "Active"}
  ]

  @invoices [
    %{id: "i1", title: "INV-2024-001", meta: "John Doe · $3,747.00", icon: "🧾", badge: "Paid"},
    %{id: "i2", title: "INV-2024-002", meta: "Jane Smith · $999.00", icon: "🧾", badge: "Pending"},
    %{id: "i3", title: "INV-2024-003", meta: "Bob Wilson · $348.00", icon: "🧾", badge: "Paid"},
    %{id: "i4", title: "INV-2024-004", meta: "Alice Brown · $2,499.00", icon: "🧾", badge: "Overdue"},
    %{id: "i5", title: "INV-2024-005", meta: "Charlie Davis · $1,235.00", icon: "🧾", badge: "Paid"},
    %{id: "i6", title: "INV-2024-006", meta: "Diana Evans · $698.00", icon: "🧾", badge: "Pending"},
    %{id: "i7", title: "INV-2024-007", meta: "Frank Garcia · $599.00", icon: "🧾", badge: "Paid"},
    %{id: "i8", title: "INV-2024-008", meta: "Grace Hall · $447.00", icon: "🧾", badge: "Paid"},
    %{id: "i9", title: "INV-2024-009", meta: "Henry Irving · $799.00", icon: "🧾", badge: "Overdue"},
    %{id: "i10", title: "INV-2024-010", meta: "Ivy Johnson · $1,836.00", icon: "🧾", badge: "Pending"}
  ]

  @shortcuts [
    %{key: "Ctrl+K / ⌘K", action: "Toggle command palette"},
    %{key: "↑ ↓", action: "Navigate results"},
    %{key: "← →", action: "Previous / next page"},
    %{key: "Enter", action: "Select active item"},
    %{key: "Esc", action: "Close palette"}
  ]

  @prefixes [
    %{prefix: "/p", context: "Products", example: "/p macbook"},
    %{prefix: "/o", context: "Orders", example: "/o shipped"},
    %{prefix: "/u", context: "Users", example: "/u admin"},
    %{prefix: "/i", context: "Invoices", example: "/i overdue"}
  ]

  def mount(_params, _session, socket) do
    {:ok,
     assign(socket,
       page_title: "Command Palette",
       cp_open: false,
       cp_query: "",
       cp_results: [],
       cp_context: nil,
       cp_page: 1,
       cp_total_pages: 1,
       cp_total_results: 0,
       cp_active_index: -1,
       cp_loading: false,
       shortcuts: @shortcuts,
       prefixes: @prefixes
     )}
  end

  def render(assigns) do
    ~H"""
    <.paragraph>macOS Spotlight-style command palette for quick navigation and search. Press <kbd>Ctrl+K</kbd> or <kbd>⌘K</kbd> to open.</.paragraph>

    <.grid>
      <.column size="100" lg="1-2">
        <%!-- Quick Start --%>
        <.card title_text="Quick Start" class="mb-4">
          <.paragraph class="mb-3">
            Open the command palette using the button below or the keyboard shortcut.
          </.paragraph>
          <div class="mb-4">
            <.button variant="primary" size="lg" is_block phx-click="command_palette_toggle">
              <:icon><i class="fa-solid fa-magnifying-glass"></i></:icon>
              Open Command Palette (Ctrl+K)
            </.button>
          </div>
          <.alert variant="primary" class="mb-4">
            <strong>Try it now!</strong> Click the button above or press <kbd>Ctrl+K</kbd> (Windows/Linux) or <kbd>⌘K</kbd> (Mac).
          </.alert>
          <h4 class="mb-2">Keyboard Shortcuts</h4>
          <.table rows={@shortcuts} size="sm">
            <:col :let={row} label="Key"><kbd>{row.key}</kbd></:col>
            <:col :let={row} label="Action">{row.action}</:col>
          </.table>
        </.card>

        <%!-- Context Switching --%>
        <.card title_text="Context Switching" class="mb-4">
          <.paragraph class="mb-3">Use prefix shortcuts to search within a specific category:</.paragraph>
          <.table rows={@prefixes} size="sm">
            <:col :let={row} label="Prefix"><code>{row.prefix}</code></:col>
            <:col :let={row} label="Context">{row.context}</:col>
            <:col :let={row} label="Example"><code>{row.example}</code></:col>
          </.table>
          <.alert variant="success" class="mt-3">
            <strong>Pro tip:</strong> When you type a context prefix, a label appears confirming the active context.
          </.alert>
        </.card>
      </.column>

      <.column size="100" lg="1-2">
        <%!-- Features --%>
        <.card title_text="Features" class="mb-4">
          <ul>
            <li><strong>Lightning fast</strong> — instant search with server-side filtering</li>
            <li><strong>Context-aware</strong> — switch between products, orders, users, and invoices</li>
            <li><strong>Keyboard navigation</strong> — full keyboard control with arrow keys</li>
            <li><strong>Smart search</strong> — fuzzy matching across title, meta, and badges</li>
            <li><strong>Pagination</strong> — navigate through pages with ← → keys</li>
            <li><strong>Themeable</strong> — adapts to your selected theme automatically</li>
          </ul>
        </.card>

        <%!-- Search Examples --%>
        <.card title_text="Search Examples" class="mb-4">
          <.paragraph class="mb-3">Click a button to open the palette with a pre-filled query:</.paragraph>

          <h4 class="mb-2">Products</h4>
          <div class="mb-3" style="display: flex; gap: 8px; flex-wrap: wrap;">
            <.button variant="secondary" size="sm" phx-click="open_palette_with_query" phx-value-query="/p macbook">/p macbook</.button>
            <.button variant="secondary" size="sm" phx-click="open_palette_with_query" phx-value-query="/p iphone">/p iphone</.button>
            <.button variant="secondary" size="sm" phx-click="open_palette_with_query" phx-value-query="/p airpods">/p airpods</.button>
          </div>

          <h4 class="mb-2">Orders</h4>
          <div class="mb-3" style="display: flex; gap: 8px; flex-wrap: wrap;">
            <.button variant="secondary" size="sm" phx-click="open_palette_with_query" phx-value-query="/o shipped">/o shipped</.button>
            <.button variant="secondary" size="sm" phx-click="open_palette_with_query" phx-value-query="/o pending">/o pending</.button>
          </div>

          <h4 class="mb-2">Users</h4>
          <div class="mb-3" style="display: flex; gap: 8px; flex-wrap: wrap;">
            <.button variant="secondary" size="sm" phx-click="open_palette_with_query" phx-value-query="/u john">/u john</.button>
            <.button variant="secondary" size="sm" phx-click="open_palette_with_query" phx-value-query="/u admin">/u admin</.button>
          </div>

          <h4 class="mb-2">Invoices</h4>
          <div style="display: flex; gap: 8px; flex-wrap: wrap;">
            <.button variant="secondary" size="sm" phx-click="open_palette_with_query" phx-value-query="/i overdue">/i overdue</.button>
            <.button variant="secondary" size="sm" phx-click="open_palette_with_query" phx-value-query="/i unpaid">/i unpaid</.button>
          </div>
        </.card>

        <%!-- Implementation --%>
        <.card title_text="Implementation" class="mb-4">
          <.paragraph class="mb-3">The command palette is a function component driven by LiveView assigns:</.paragraph>
          <.basic_list>
            <li>Component: <code>command_palette/1</code></li>
            <li>JS Hook: <code>PureAdminCommandPalette</code></li>
            <li>Styles: <code>pa-command-palette</code> BEM classes</li>
          </.basic_list>
          <.alert variant="warning" class="mt-3">
            <strong>Note:</strong> This demo uses dummy data. In a real application, connect the search to your backend.
          </.alert>
        </.card>
      </.column>
    </.grid>

    <.command_palette
      id="cmd-palette"
      is_open={@cp_open}
      query={@cp_query}
      results={@cp_results}
      context={@cp_context}
      page={@cp_page}
      total_pages={@cp_total_pages}
      total_results={@cp_total_results}
      active_index={@cp_active_index}
      is_loading={@cp_loading}
    />
    """
  end

  def handle_event("command_palette_toggle", _params, socket) do
    if socket.assigns.cp_open do
      {:noreply, close_palette(socket)}
    else
      {:noreply, open_palette(socket)}
    end
  end

  def handle_event("command_palette_close", _params, socket) do
    {:noreply, close_palette(socket)}
  end

  def handle_event("command_palette_search", %{"query" => query}, socket) do
    {:noreply, do_search(socket, query)}
  end

  def handle_event("command_palette_navigate", %{"direction" => direction}, socket) do
    results = socket.assigns.cp_results
    active = socket.assigns.cp_active_index
    count = length(results)

    new_index =
      case direction do
        "up" -> if active <= 0, do: count - 1, else: active - 1
        "down" -> if active >= count - 1, do: 0, else: active + 1
        _ -> active
      end

    {:noreply, assign(socket, cp_active_index: new_index)}
  end

  def handle_event("command_palette_page", %{"direction" => direction}, socket) do
    page = socket.assigns.cp_page
    total = socket.assigns.cp_total_pages

    new_page =
      case direction do
        "prev" -> max(1, page - 1)
        "next" -> min(total, page + 1)
        _ -> page
      end

    if new_page != page do
      {:noreply, do_search_page(socket, socket.assigns.cp_query, new_page)}
    else
      {:noreply, socket}
    end
  end

  def handle_event("command_palette_select", params, socket) do
    index = if params["index"], do: String.to_integer(params["index"]), else: socket.assigns.cp_active_index
    results = socket.assigns.cp_results

    if index >= 0 and index < length(results) do
      item = Enum.at(results, index)

      socket =
        socket
        |> close_palette()
        |> put_flash(:info, "Selected: #{item.title}")

      {:noreply, socket}
    else
      {:noreply, socket}
    end
  end

  def handle_event("open_palette_with_query", %{"query" => query}, socket) do
    socket =
      socket
      |> open_palette()
      |> do_search(query)

    {:noreply, socket}
  end

  defp open_palette(socket), do: assign(socket, cp_open: true)

  defp close_palette(socket) do
    assign(socket,
      cp_open: false,
      cp_query: "",
      cp_results: [],
      cp_context: nil,
      cp_page: 1,
      cp_total_pages: 1,
      cp_total_results: 0,
      cp_active_index: -1,
      cp_loading: false
    )
  end

  defp do_search(socket, query), do: do_search_page(socket, query, 1)

  defp do_search_page(socket, query, page) do
    {context, search_term, data} = parse_query(query)

    filtered =
      if search_term == "" do
        data
      else
        term = String.downcase(search_term)
        Enum.filter(data, fn item ->
          String.contains?(String.downcase(item.title), term) or
            String.contains?(String.downcase(item[:meta] || ""), term) or
            String.contains?(String.downcase(item[:badge] || ""), term)
        end)
      end

    total = length(filtered)
    total_pages = max(1, ceil(total / @page_size))
    page = min(page, total_pages)

    results =
      filtered
      |> Enum.drop((page - 1) * @page_size)
      |> Enum.take(@page_size)

    assign(socket,
      cp_query: query,
      cp_results: results,
      cp_context: context,
      cp_page: page,
      cp_total_pages: total_pages,
      cp_total_results: total,
      cp_active_index: if(results != [], do: 0, else: -1)
    )
  end

  defp parse_query(query) do
    cond do
      String.starts_with?(query, "/p ") or query == "/p" ->
        {"Searching in Products", String.trim_leading(query, "/p") |> String.trim(), @products}
      String.starts_with?(query, "/o ") or query == "/o" ->
        {"Searching in Orders", String.trim_leading(query, "/o") |> String.trim(), @orders}
      String.starts_with?(query, "/u ") or query == "/u" ->
        {"Searching in Users", String.trim_leading(query, "/u") |> String.trim(), @users}
      String.starts_with?(query, "/i ") or query == "/i" ->
        {"Searching in Invoices", String.trim_leading(query, "/i") |> String.trim(), @invoices}
      true ->
        {nil, query, @products ++ @orders ++ @users ++ @invoices}
    end
  end
end
