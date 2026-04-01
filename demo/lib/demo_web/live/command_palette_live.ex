defmodule DemoWeb.Live.CommandPaletteLive do
  use DemoWeb, :live_view

  @page_size 8

  # -- Demo data --

  @products [
    %{id: "p1", title: "MacBook Pro 16\"", subtitle: "Electronics · $2,499", icon: "💻", badge: "In Stock"},
    %{id: "p2", title: "iPhone 15 Pro", subtitle: "Electronics · $999", icon: "📱", badge: "In Stock"},
    %{id: "p3", title: "AirPods Pro", subtitle: "Electronics · $249", icon: "🎧", badge: "Low Stock"},
    %{id: "p4", title: "iPad Air", subtitle: "Electronics · $599", icon: "📱", badge: "In Stock"},
    %{id: "p5", title: "Apple Watch Ultra", subtitle: "Electronics · $799", icon: "⌚", badge: "In Stock"},
    %{id: "p6", title: "Magic Keyboard", subtitle: "Accessories · $299", icon: "⌨️", badge: "In Stock"},
    %{id: "p7", title: "Studio Display", subtitle: "Electronics · $1,599", icon: "🖥️", badge: "Pre-order"},
    %{id: "p8", title: "HomePod mini", subtitle: "Electronics · $99", icon: "🔊", badge: "In Stock"},
    %{id: "p9", title: "AirTag 4 Pack", subtitle: "Accessories · $99", icon: "📍", badge: "In Stock"},
    %{id: "p10", title: "MagSafe Charger", subtitle: "Accessories · $39", icon: "🔌", badge: "In Stock"}
  ]

  @orders [
    %{id: "o1", title: "Order #10421", subtitle: "John Doe · 3 items · $3,747", icon: "📦", badge: "Shipped"},
    %{id: "o2", title: "Order #10422", subtitle: "Jane Smith · 1 item · $999", icon: "📦", badge: "Processing"},
    %{id: "o3", title: "Order #10423", subtitle: "Bob Wilson · 2 items · $348", icon: "📦", badge: "Delivered"},
    %{id: "o4", title: "Order #10424", subtitle: "Alice Brown · 1 item · $2,499", icon: "📦", badge: "Pending"},
    %{id: "o5", title: "Order #10425", subtitle: "Charlie Davis · 5 items · $1,235", icon: "📦", badge: "Shipped"},
    %{id: "o6", title: "Order #10426", subtitle: "Diana Evans · 2 items · $698", icon: "📦", badge: "Delivered"},
    %{id: "o7", title: "Order #10427", subtitle: "Frank Garcia · 1 item · $599", icon: "📦", badge: "Processing"},
    %{id: "o8", title: "Order #10428", subtitle: "Grace Hall · 3 items · $447", icon: "📦", badge: "Shipped"},
    %{id: "o9", title: "Order #10429", subtitle: "Henry Irving · 1 item · $799", icon: "📦", badge: "Pending"},
    %{id: "o10", title: "Order #10430", subtitle: "Ivy Johnson · 4 items · $1,836", icon: "📦", badge: "Delivered"}
  ]

  @users [
    %{id: "u1", title: "John Doe", subtitle: "john@example.com · Admin", icon: "👤", badge: "Active"},
    %{id: "u2", title: "Jane Smith", subtitle: "jane@example.com · Editor", icon: "👤", badge: "Active"},
    %{id: "u3", title: "Bob Wilson", subtitle: "bob@example.com · Viewer", icon: "👤", badge: "Inactive"},
    %{id: "u4", title: "Alice Brown", subtitle: "alice@example.com · Admin", icon: "👤", badge: "Active"},
    %{id: "u5", title: "Charlie Davis", subtitle: "charlie@example.com · Editor", icon: "👤", badge: "Active"},
    %{id: "u6", title: "Diana Evans", subtitle: "diana@example.com · Viewer", icon: "👤", badge: "Active"},
    %{id: "u7", title: "Frank Garcia", subtitle: "frank@example.com · Editor", icon: "👤", badge: "Inactive"},
    %{id: "u8", title: "Grace Hall", subtitle: "grace@example.com · Admin", icon: "👤", badge: "Active"},
    %{id: "u9", title: "Henry Irving", subtitle: "henry@example.com · Viewer", icon: "👤", badge: "Active"},
    %{id: "u10", title: "Ivy Johnson", subtitle: "ivy@example.com · Editor", icon: "👤", badge: "Active"}
  ]

  @invoices [
    %{id: "i1", title: "INV-2024-001", subtitle: "John Doe · $3,747.00", icon: "🧾", badge: "Paid"},
    %{id: "i2", title: "INV-2024-002", subtitle: "Jane Smith · $999.00", icon: "🧾", badge: "Pending"},
    %{id: "i3", title: "INV-2024-003", subtitle: "Bob Wilson · $348.00", icon: "🧾", badge: "Paid"},
    %{id: "i4", title: "INV-2024-004", subtitle: "Alice Brown · $2,499.00", icon: "🧾", badge: "Overdue"},
    %{id: "i5", title: "INV-2024-005", subtitle: "Charlie Davis · $1,235.00", icon: "🧾", badge: "Paid"},
    %{id: "i6", title: "INV-2024-006", subtitle: "Diana Evans · $698.00", icon: "🧾", badge: "Pending"},
    %{id: "i7", title: "INV-2024-007", subtitle: "Frank Garcia · $599.00", icon: "🧾", badge: "Paid"},
    %{id: "i8", title: "INV-2024-008", subtitle: "Grace Hall · $447.00", icon: "🧾", badge: "Paid"},
    %{id: "i9", title: "INV-2024-009", subtitle: "Henry Irving · $799.00", icon: "🧾", badge: "Overdue"},
    %{id: "i10", title: "INV-2024-010", subtitle: "Ivy Johnson · $1,836.00", icon: "🧾", badge: "Pending"}
  ]

  # -- Commands --

  @commands [
    %{
      id: "deploy",
      shortcut: "/deploy",
      aliases: ["/d"],
      hotkey: "Alt+D",
      name: "Deploy to Environment",
      description: "Deploy a branch to an environment",
      icon: "🚀",
      steps: [
        %{id: "environment", prompt: " in ", placeholder: "Select environment..."},
        %{id: "branch", prompt: " branch ", placeholder: "Select or type branch...", free_text: true}
      ]
    },
    %{
      id: "assign",
      shortcut: "/assign",
      aliases: ["/a"],
      hotkey: "Alt+A",
      name: "Assign to User",
      description: "Assign an item to a team member",
      icon: "👤",
      steps: [
        %{id: "item", prompt: " ", placeholder: "Select item..."},
        %{id: "user", prompt: " to ", placeholder: "Select user..."}
      ]
    },
    %{
      id: "go",
      shortcut: "/go",
      aliases: ["/g", "/nav"],
      hotkey: "Alt+G",
      name: "Go to Page",
      description: "Navigate to a page",
      icon: "🧭",
      steps: [
        %{id: "page", prompt: " ", placeholder: "Type page name...", free_text: true}
      ]
    },
    %{
      id: "theme",
      shortcut: "/theme",
      aliases: ["/t"],
      hotkey: "Alt+T",
      name: "Switch Theme",
      description: "Change the visual theme",
      icon: "🎨",
      steps: [
        %{id: "theme", prompt: " ", placeholder: "Select theme..."}
      ]
    }
  ]

  # -- Contexts --

  @contexts [
    %{id: "products", shortcut: ":products", aliases: [":p"], name: "Products", description: "Search products", icon: "📦"},
    %{id: "orders", shortcut: ":orders", aliases: [":o"], name: "Orders", description: "Search orders", icon: "📋"},
    %{id: "users", shortcut: ":users", aliases: [":u"], name: "Users", description: "Search users", icon: "👥"},
    %{id: "invoices", shortcut: ":invoices", aliases: [":i"], name: "Invoices", description: "Search invoices", icon: "🧾"}
  ]

  def mount(_params, _session, socket) do
    {:ok,
     assign(socket,
       page_title: "Command Palette",
       cp_open: false,
       cp_mode: "idle",
       cp_query: "",
       cp_results: [],
       cp_active_index: -1,
       cp_loading: false,
       cp_commands: @commands,
       cp_contexts: @contexts,
       cp_current_command: nil,
       cp_current_step: nil,
       cp_step_index: 0,
       cp_total_steps: 0,
       cp_selections: [],
       cp_preview: nil,
       cp_current_context: nil,
       cp_page: 1,
       cp_total_pages: 1,
       cp_total_results: 0,
       cp_display: "inline",
       cp_input_text: ""
     )}
  end

  def render(assigns) do
    ~H"""
    <.paragraph>
      macOS Spotlight-style command palette with multi-step commands and scoped search.
      Press <kbd>Ctrl+K</kbd> or <kbd>⌘K</kbd> to open.
    </.paragraph>

    <.grid>
      <.column size="100" lg="1-2">
        <.card title_text="Quick Start" class="mb-4">
          <.paragraph class="mb-3">
            Open the command palette and try the different modes:
          </.paragraph>
          <div class="mb-4">
            <.button variant="primary" size="lg" is_block phx-click="cp:toggle">
              <:icon><i class="fa-solid fa-magnifying-glass"></i></:icon>
              Open Command Palette (Ctrl+K)
            </.button>
          </div>

          <div class="mb-3" style="display: flex; gap: 8px; align-items: center;">
            <span>Display style:</span>
            <.button size="sm" variant={if @cp_display == "inline", do: "primary", else: "secondary"} phx-click="set_display" phx-value-display="inline">Inline</.button>
            <.button size="sm" variant={if @cp_display == "tokens", do: "primary", else: "secondary"} phx-click="set_display" phx-value-display="tokens">Tokens</.button>
          </div>

          <.heading level={4} class="mb-2">Modes</.heading>
          <.table rows={[
            %{prefix: "/", mode: "Commands", description: "Multi-step action wizards"},
            %{prefix: ":", mode: "Search", description: "Scoped entity search"},
            %{prefix: "(none)", mode: "Global", description: "Search everything"}
          ]} size="sm">
            <:col :let={row} label="Prefix"><code>{row.prefix}</code></:col>
            <:col :let={row} label="Mode">{row.mode}</:col>
            <:col :let={row} label="Description">{row.description}</:col>
          </.table>
        </.card>

        <.card title_text="Commands (/)" class="mb-4">
          <.paragraph class="mb-3">Type <code>/</code> to see available commands:</.paragraph>
          <.table rows={@cp_commands} size="sm">
            <:col :let={cmd} label="Shortcut"><code>{cmd.shortcut}</code></:col>
            <:col :let={cmd} label="Name">{cmd.name}</:col>
            <:col :let={cmd} label="Steps">{length(cmd.steps)} steps</:col>
          </.table>

          <.heading level={4} class="mt-3 mb-2">Try it</.heading>
          <div style="display: flex; gap: 8px; flex-wrap: wrap;">
            <.button variant="secondary" size="sm" phx-click="open_with_query" phx-value-query="/">/  (list all)</.button>
            <.button variant="secondary" size="sm" phx-click="open_with_query" phx-value-query="/deploy">/deploy</.button>
            <.button variant="secondary" size="sm" phx-click="open_with_query" phx-value-query="/go">/go</.button>
          </div>
        </.card>
      </.column>

      <.column size="100" lg="1-2">
        <.card title_text="Search Contexts (:)" class="mb-4">
          <.paragraph class="mb-3">Type <code>:</code> to see search contexts:</.paragraph>
          <.table rows={@cp_contexts} size="sm">
            <:col :let={ctx} label="Shortcut"><code>{ctx.shortcut}</code></:col>
            <:col :let={ctx} label="Context">{ctx.name}</:col>
          </.table>

          <.heading level={4} class="mt-3 mb-2">Try it</.heading>
          <div style="display: flex; gap: 8px; flex-wrap: wrap;">
            <.button variant="secondary" size="sm" phx-click="open_with_query" phx-value-query=":">:  (list all)</.button>
            <.button variant="secondary" size="sm" phx-click="open_with_query" phx-value-query=":p macbook">:p macbook</.button>
            <.button variant="secondary" size="sm" phx-click="open_with_query" phx-value-query=":o shipped">:o shipped</.button>
            <.button variant="secondary" size="sm" phx-click="open_with_query" phx-value-query=":u admin">:u admin</.button>
          </div>
        </.card>

        <.card title_text="Global Search" class="mb-4">
          <.paragraph class="mb-3">Just type without a prefix to search everything:</.paragraph>
          <div style="display: flex; gap: 8px; flex-wrap: wrap;">
            <.button variant="secondary" size="sm" phx-click="open_with_query" phx-value-query="john">john</.button>
            <.button variant="secondary" size="sm" phx-click="open_with_query" phx-value-query="shipped">shipped</.button>
            <.button variant="secondary" size="sm" phx-click="open_with_query" phx-value-query="macbook">macbook</.button>
          </div>
        </.card>

        <.card title_text="Keyboard Shortcuts" class="mb-4">
          <.table rows={[
            %{key: "Ctrl+K / ⌘K", action: "Toggle command palette"},
            %{key: "↑ ↓", action: "Navigate results"},
            %{key: "← →", action: "Previous / next page (search modes)"},
            %{key: "Enter / Tab", action: "Select item or confirm free text"},
            %{key: "Backspace (at start)", action: "Go back to previous step"},
            %{key: "Esc", action: "Back (in step/context) or close"}
          ]} size="sm">
            <:col :let={row} label="Key"><kbd>{row.key}</kbd></:col>
            <:col :let={row} label="Action">{row.action}</:col>
          </.table>
        </.card>
      </.column>
    </.grid>

    <.command_palette
      id="cmd-palette"
      is_open={@cp_open}
      mode={@cp_mode}
      display={@cp_display}
      query={@cp_query}
      input_text={@cp_input_text}
      results={@cp_results}
      commands={@cp_commands}
      contexts={@cp_contexts}
      active_index={@cp_active_index}
      is_loading={@cp_loading}
      current_command={@cp_current_command}
      current_step={@cp_current_step}
      current_step_index={@cp_step_index}
      total_steps={@cp_total_steps}
      selections={@cp_selections}
      preview={@cp_preview}
      current_context={@cp_current_context}
      page={@cp_page}
      total_pages={@cp_total_pages}
      total_results={@cp_total_results}
    />
    """
  end

  # -- Event handlers --

  def handle_event("cp:toggle", _params, socket) do
    if socket.assigns.cp_open do
      {:noreply, close_palette(socket)}
    else
      {:noreply, open_palette(socket)}
    end
  end

  def handle_event("cp:close", _params, socket) do
    {:noreply, close_palette(socket)}
  end

  def handle_event("cp:input", %{"query" => query}, socket) do
    {:noreply, process_input(socket, query)}
  end

  def handle_event("cp:navigate", %{"direction" => direction}, socket) do
    count = length(socket.assigns.cp_results)
    active = socket.assigns.cp_active_index

    new_index =
      case direction do
        "up" -> if active <= 0, do: count - 1, else: active - 1
        "down" -> if active >= count - 1, do: 0, else: active + 1
        _ -> active
      end

    {:noreply, assign(socket, cp_active_index: new_index)}
  end

  def handle_event("cp:page", %{"direction" => direction}, socket) do
    page = socket.assigns.cp_page
    total = socket.assigns.cp_total_pages

    new_page =
      case direction do
        "prev" -> max(1, page - 1)
        "next" -> min(total, page + 1)
        _ -> page
      end

    if new_page != page do
      {:noreply, do_search_page(socket, new_page)}
    else
      {:noreply, socket}
    end
  end

  def handle_event("cp:select", %{"index" => index_str}, socket) do
    index =
      case index_str do
        i when is_integer(i) -> i
        s when is_binary(s) -> String.to_integer(s)
      end

    # If -1 (Enter without clicking), use active_index
    index = if index == -1, do: socket.assigns.cp_active_index, else: index
    handle_select(socket, index)
  end

  def handle_event("cp:step_back", _params, socket) do
    {:noreply, step_back(socket)}
  end

  def handle_event("cp:home_select", %{"type" => "command", "shortcut" => shortcut}, socket) do
    command = find_command(socket.assigns.cp_commands, shortcut)

    if command do
      socket = if !socket.assigns.cp_open, do: open_palette(socket), else: socket
      {:noreply, enter_command(socket, command)}
    else
      {:noreply, socket}
    end
  end

  def handle_event("cp:home_select", %{"type" => "context", "shortcut" => shortcut}, socket) do
    context = find_context(socket.assigns.cp_contexts, shortcut)

    if context do
      socket = if !socket.assigns.cp_open, do: open_palette(socket), else: socket
      {:noreply, enter_context_search(socket, context, "")}
    else
      {:noreply, socket}
    end
  end

  def handle_event("cp:hotkey", %{"key" => key}, socket) do
    command =
      Enum.find(socket.assigns.cp_commands, fn cmd ->
        case cmd[:hotkey] do
          nil -> false
          hotkey ->
            parts = String.split(String.downcase(hotkey), "+")
            List.last(parts) == key
        end
      end)

    if command do
      socket =
        socket
        |> (fn s -> if !s.assigns.cp_open, do: open_palette(s), else: s end).()
        |> enter_command(command)

      {:noreply, socket}
    else
      {:noreply, socket}
    end
  end

  def handle_event("set_display", %{"display" => display}, socket) do
    {:noreply, assign(socket, cp_display: display)}
  end

  def handle_event("open_with_query", %{"query" => query}, socket) do
    socket =
      socket
      |> open_palette()
      |> process_input(query)

    {:noreply, socket}
  end

  # Command completion callback
  def handle_info({:command_complete, cmd_id, selections}, socket) do
    sel_str = selections |> Enum.map(fn s -> "#{s.step_id}=#{s.label}" end) |> Enum.join(", ")

    socket =
      socket
      |> close_palette()
      |> PureAdmin.Components.Toast.push_toast(
        "success",
        "Command Executed",
        "#{cmd_id}: #{sel_str}",
        duration: 5000
      )

    {:noreply, socket}
  end

  # -- State machine --

  defp open_palette(socket) do
    socket
    |> assign(cp_open: true, cp_mode: "idle", cp_query: "", cp_results: [], cp_active_index: -1)
    |> push_event("cp:focus", %{})
  end

  defp close_palette(socket) do
    assign(socket,
      cp_open: false,
      cp_mode: "idle",
      cp_query: "",
      cp_results: [],
      cp_active_index: -1,
      cp_loading: false,
      cp_current_command: nil,
      cp_current_step: nil,
      cp_step_index: 0,
      cp_total_steps: 0,
      cp_selections: [],
      cp_preview: nil,
      cp_current_context: nil,
      cp_page: 1,
      cp_total_pages: 1,
      cp_total_results: 0
    )
  end

  defp process_input(socket, query) do
    cond do
      # Already in command step — query is just the step's search text
      socket.assigns.cp_mode == "command_step" ->
        filter_step_options(socket, query)

      # Already in context search — query is just the search text
      socket.assigns.cp_mode == "context_search" ->
        do_context_search(socket, query)

      # Command mode: starts with /
      String.starts_with?(query, "/") ->
        handle_command_input(socket, query)

      # Context mode: starts with :
      String.starts_with?(query, ":") ->
        handle_context_input(socket, query)

      # Global search
      query == "" ->
        assign(socket, cp_mode: "idle", cp_query: "", cp_results: [], cp_active_index: -1)

      true ->
        do_global_search(socket, query)
    end
  end

  # -- Command handling --

  defp handle_command_input(socket, query) do
    commands = socket.assigns.cp_commands

    # Check for exact match with space (entering command)
    parts = String.split(query, " ", parts: 2)
    cmd_part = hd(parts)

    matched_command =
      if length(parts) > 1 do
        find_command(commands, cmd_part)
      end

    if matched_command do
      enter_command(socket, matched_command)
    else
      # Filter command list
      filtered =
        if query == "/" do
          commands
        else
          filter_items(commands, String.trim_leading(query, "/"), fn cmd ->
            [cmd.shortcut, cmd.name | cmd[:aliases] || []]
          end)
        end

      # Add shortcut display
      results = Enum.map(filtered, fn cmd -> Map.put(cmd, :shortcut, cmd.shortcut) end)

      assign(socket,
        cp_mode: "command_list",
        cp_query: query,
        cp_results: results,
        cp_active_index: if(results != [], do: 0, else: -1)
      )
    end
  end

  defp find_command(commands, input) do
    Enum.find(commands, fn cmd ->
      input == cmd.shortcut or input in (cmd[:aliases] || [])
    end)
  end

  defp enter_command(socket, command) do
    steps = command[:steps] || []

    if steps == [] do
      # Instant command — no steps
      send(self(), {:command_complete, command.id, []})
      socket
    else
      step = hd(steps)
      options = get_step_options(command.id, step.id, "", [])

      # Build inline text: "/assign " (command shortcut + space)
      inline_text = command.shortcut <> (step[:prompt] || " ")

      socket
      |> assign(
        cp_mode: "command_step",
        cp_query: "",
        cp_current_command: command,
        cp_current_step: step,
        cp_step_index: 0,
        cp_total_steps: length(steps),
        cp_selections: [],
        cp_results: options,
        cp_active_index: if(options != [], do: 0, else: -1),
        cp_preview: nil,
        cp_input_text: inline_text
      )
      |> push_reset_input(inline_text)
    end
  end

  defp filter_step_options(socket, query) do
    command = socket.assigns.cp_current_command
    step = socket.assigns.cp_current_step
    selections = socket.assigns.cp_selections
    display = socket.assigns.cp_display

    # In inline mode, query is the full text — extract just the step portion
    search_query =
      if display == "inline" do
        prefix = build_inline_text(command, selections, step)
        if String.starts_with?(query, prefix) do
          String.slice(query, String.length(prefix)..-1//1)
        else
          query
        end
      else
        query
      end

    options = get_step_options(command.id, step.id, search_query, selections)

    socket
    |> assign(
      cp_query: search_query,
      cp_input_text: query,
      cp_results: options,
      cp_active_index: if(options != [], do: 0, else: -1)
    )
  end

  defp advance_step(socket, selected_option) do
    command = socket.assigns.cp_current_command
    step = socket.assigns.cp_current_step
    step_index = socket.assigns.cp_step_index
    selections = socket.assigns.cp_selections
    steps = command[:steps] || []

    label = selected_option[:label] || selected_option[:title] || to_string(selected_option[:value])

    new_selection = %{
      step_id: step.id,
      label: label,
      value: selected_option[:value] || label,
      prompt: step[:prompt]
    }

    new_selections = selections ++ [new_selection]
    next_index = step_index + 1

    if next_index >= length(steps) do
      # All steps complete
      send(self(), {:command_complete, command.id, new_selections})
      socket
    else
      next_step = Enum.at(steps, next_index)
      options = get_step_options(command.id, next_step.id, "", new_selections)

      # Build inline text: "/assign iPad Air to "
      inline_text = build_inline_text(command, new_selections, next_step)

      socket
      |> assign(
        cp_step_index: next_index,
        cp_current_step: next_step,
        cp_selections: new_selections,
        cp_query: "",
        cp_results: options,
        cp_active_index: if(options != [], do: 0, else: -1),
        cp_preview: build_preview(command, new_selections),
        cp_input_text: inline_text
      )
      |> push_reset_input(inline_text)
    end
  end

  defp step_back(socket) do
    mode = socket.assigns.cp_mode

    case mode do
      "command_step" ->
        step_index = socket.assigns.cp_step_index

        if step_index == 0 do
          # Back to command list
          socket
          |> assign(
            cp_mode: "command_list",
            cp_query: "/",
            cp_results: Enum.map(socket.assigns.cp_commands, &Map.put(&1, :shortcut, &1.shortcut)),
            cp_active_index: 0,
            cp_current_command: nil,
            cp_current_step: nil,
            cp_step_index: 0,
            cp_selections: [],
            cp_preview: nil,
            cp_input_text: "/"
          )
          |> push_reset_input("/")
        else
          # Back to previous step
          command = socket.assigns.cp_current_command
          steps = command[:steps] || []
          prev_index = step_index - 1
          prev_step = Enum.at(steps, prev_index)
          prev_selections = Enum.take(socket.assigns.cp_selections, prev_index)
          options = get_step_options(command.id, prev_step.id, "", prev_selections)

          inline_text = build_inline_text(command, prev_selections, prev_step)

          socket
          |> assign(
            cp_step_index: prev_index,
            cp_current_step: prev_step,
            cp_selections: prev_selections,
            cp_query: "",
            cp_results: options,
            cp_active_index: if(options != [], do: 0, else: -1),
            cp_preview: build_preview(command, prev_selections),
            cp_input_text: inline_text
          )
          |> push_reset_input(inline_text)
        end

      "context_search" ->
        # Back to context list
        assign(socket,
          cp_mode: "context_list",
          cp_query: ":",
          cp_results: Enum.map(socket.assigns.cp_contexts, &Map.put(&1, :shortcut, &1.shortcut)),
          cp_active_index: 0,
          cp_current_context: nil,
          cp_page: 1,
          cp_total_pages: 1,
          cp_total_results: 0
        )
        |> push_event("cp:reset_input", %{value: ":"})

      _ ->
        close_palette(socket)
    end
  end

  # -- Context handling --

  defp handle_context_input(socket, query) do
    contexts = socket.assigns.cp_contexts

    parts = String.split(query, " ", parts: 2)
    ctx_part = hd(parts)

    matched_context =
      if length(parts) > 1 do
        find_context(contexts, ctx_part)
      end

    if matched_context do
      search_query = Enum.at(parts, 1) || ""
      enter_context_search(socket, matched_context, search_query)
    else
      filtered =
        if query == ":" do
          contexts
        else
          filter_items(contexts, String.trim_leading(query, ":"), fn ctx ->
            [ctx.shortcut, ctx.name | ctx[:aliases] || []]
          end)
        end

      results = Enum.map(filtered, fn ctx -> Map.put(ctx, :shortcut, ctx.shortcut) end)

      assign(socket,
        cp_mode: "context_list",
        cp_query: query,
        cp_results: results,
        cp_active_index: if(results != [], do: 0, else: -1)
      )
    end
  end

  defp find_context(contexts, input) do
    Enum.find(contexts, fn ctx ->
      input == ctx.shortcut or input in (ctx[:aliases] || [])
    end)
  end

  defp enter_context_search(socket, context, query) do
    data = get_context_data(context.id)
    do_search(socket, data, query)
    |> assign(
      cp_mode: "context_search",
      cp_current_context: context,
      cp_query: query
    )
    |> push_event("cp:reset_input", %{value: query})
  end

  defp do_context_search(socket, query) do
    context = socket.assigns.cp_current_context
    data = get_context_data(context.id)
    do_search(socket, data, query)
    |> assign(cp_query: query)
  end

  # -- Global search --

  defp do_global_search(socket, query) do
    q = String.downcase(String.trim(query))

    # Include matching commands
    cmd_results =
      socket.assigns.cp_commands
      |> Enum.filter(fn cmd ->
        String.contains?(String.downcase(cmd.name), q) or
          String.contains?(String.downcase(cmd.shortcut), q) or
          Enum.any?(cmd[:aliases] || [], &String.contains?(String.downcase(&1), q))
      end)
      |> Enum.map(fn cmd ->
        %{id: "cmd-#{cmd.id}", title: cmd.name, subtitle: cmd.description, icon: cmd.icon,
          badge: cmd.shortcut, _type: "command", _shortcut: cmd.shortcut}
      end)

    # Include matching contexts
    ctx_results =
      socket.assigns.cp_contexts
      |> Enum.filter(fn ctx ->
        String.contains?(String.downcase(ctx.name), q) or
          String.contains?(String.downcase(ctx.shortcut), q) or
          Enum.any?(ctx[:aliases] || [], &String.contains?(String.downcase(&1), q))
      end)
      |> Enum.map(fn ctx ->
        %{id: "ctx-#{ctx.id}", title: ctx.name, subtitle: ctx.description, icon: ctx.icon,
          badge: ctx.shortcut, _type: "context", _shortcut: ctx.shortcut}
      end)

    # Data results
    all_data = @products ++ @orders ++ @users ++ @invoices
    data_results =
      if q == "" do
        all_data
      else
        Enum.filter(all_data, fn item ->
          String.contains?(String.downcase(item[:title] || ""), q) or
            String.contains?(String.downcase(item[:subtitle] || item[:meta] || ""), q) or
            String.contains?(String.downcase(item[:badge] || ""), q)
        end)
      end

    combined = cmd_results ++ ctx_results ++ data_results
    total = length(combined)
    total_pages = max(1, ceil(total / @page_size))
    results = Enum.take(combined, @page_size)

    assign(socket,
      cp_mode: "global_search",
      cp_query: query,
      cp_results: results,
      cp_page: 1,
      cp_total_pages: total_pages,
      cp_total_results: total,
      cp_active_index: if(results != [], do: 0, else: -1)
    )
  end

  # -- Selection handling --

  defp handle_select(socket, index) do
    results = socket.assigns.cp_results
    mode = socket.assigns.cp_mode

    if index >= 0 and index < length(results) do
      item = Enum.at(results, index)

      case mode do
        "command_list" ->
          command = find_command(socket.assigns.cp_commands, item[:shortcut])
          if command, do: {:noreply, enter_command(socket, command)}, else: {:noreply, socket}

        "command_step" ->
          step = socket.assigns.cp_current_step

          if item do
            {:noreply, advance_step(socket, item)}
          else
            # Free text
            if step[:free_text] do
              query = socket.assigns.cp_query
              {:noreply, advance_step(socket, %{label: query, value: query})}
            else
              {:noreply, socket}
            end
          end

        "context_list" ->
          context = find_context(socket.assigns.cp_contexts, item[:shortcut])
          if context, do: {:noreply, enter_context_search(socket, context, "")}, else: {:noreply, socket}

        "context_search" ->
          {:noreply,
           socket
           |> close_palette()
           |> PureAdmin.Components.Toast.push_toast("info", "Selected", "#{item[:title]}", duration: 3000)}

        "global_search" ->
          cond do
            item[:_type] == "command" ->
              command = find_command(socket.assigns.cp_commands, item[:_shortcut])
              if command, do: {:noreply, enter_command(socket, command)}, else: {:noreply, socket}

            item[:_type] == "context" ->
              context = find_context(socket.assigns.cp_contexts, item[:_shortcut])
              if context, do: {:noreply, enter_context_search(socket, context, "")}, else: {:noreply, socket}

            true ->
              {:noreply,
               socket
               |> close_palette()
               |> PureAdmin.Components.Toast.push_toast("info", "Selected", "#{item[:title]}", duration: 3000)}
          end

        _ ->
          {:noreply, socket}
      end
    else
      # No item selected — check for free text in command step
      if mode == "command_step" do
        step = socket.assigns.cp_current_step

        if step[:free_text] do
          query = socket.assigns.cp_query
          {:noreply, advance_step(socket, %{label: query, value: query})}
        else
          {:noreply, socket}
        end
      else
        {:noreply, socket}
      end
    end
  end

  # -- Helpers --

  defp do_search(socket, data, query) do
    term = String.trim(query)

    filtered =
      if term == "" do
        data
      else
        t = String.downcase(term)

        Enum.filter(data, fn item ->
          String.contains?(String.downcase(item[:title] || ""), t) or
            String.contains?(String.downcase(item[:subtitle] || item[:meta] || ""), t) or
            String.contains?(String.downcase(item[:badge] || ""), t)
        end)
      end

    total = length(filtered)
    total_pages = max(1, ceil(total / @page_size))
    results = Enum.take(filtered, @page_size)

    assign(socket,
      cp_results: results,
      cp_page: 1,
      cp_total_pages: total_pages,
      cp_total_results: total,
      cp_active_index: if(results != [], do: 0, else: -1)
    )
  end

  defp do_search_page(socket, page) do
    context = socket.assigns.cp_current_context
    query = socket.assigns.cp_query
    mode = socket.assigns.cp_mode

    data =
      case mode do
        "context_search" when context != nil -> get_context_data(context.id)
        "global_search" -> @products ++ @orders ++ @users ++ @invoices
        _ -> []
      end

    term = String.trim(query)

    filtered =
      if term == "" do
        data
      else
        t = String.downcase(term)

        Enum.filter(data, fn item ->
          String.contains?(String.downcase(item[:title] || ""), t) or
            String.contains?(String.downcase(item[:subtitle] || item[:meta] || ""), t) or
            String.contains?(String.downcase(item[:badge] || ""), t)
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
      cp_page: page,
      cp_total_pages: total_pages,
      cp_total_results: total,
      cp_results: results,
      cp_active_index: if(results != [], do: 0, else: -1)
    )
  end

  defp filter_items(items, query, get_searchable_fn) do
    if query == "" do
      items
    else
      q = String.downcase(query)

      Enum.filter(items, fn item ->
        get_searchable_fn.(item)
        |> Enum.any?(fn field -> String.contains?(String.downcase(field || ""), q) end)
      end)
    end
  end

  defp get_context_data("products"), do: @products
  defp get_context_data("orders"), do: @orders
  defp get_context_data("users"), do: @users
  defp get_context_data("invoices"), do: @invoices
  defp get_context_data(_), do: []

  defp get_step_options("deploy", "environment", query, _selections) do
    [
      %{id: "prod", label: "Production", description: "Live servers", icon: "🔴", value: "production"},
      %{id: "staging", label: "Staging", description: "Pre-production", icon: "🟡", value: "staging"},
      %{id: "dev", label: "Development", description: "Dev servers", icon: "🟢", value: "development"}
    ]
    |> filter_options(query)
  end

  defp get_step_options("deploy", "branch", query, _selections) do
    [
      %{id: "main", label: "main", description: "Default branch", icon: "🌿", value: "main"},
      %{id: "develop", label: "develop", description: "Development branch", icon: "🌱", value: "develop"},
      %{id: "feature", label: "feature/new-ui", description: "Feature branch", icon: "🔧", value: "feature/new-ui"}
    ]
    |> filter_options(query)
  end

  defp get_step_options("assign", "item", query, _selections) do
    @products
    |> Enum.map(fn p -> %{id: p.id, label: p.title, description: p.subtitle, icon: p.icon, value: p.id} end)
    |> filter_options(query)
  end

  defp get_step_options("assign", "user", query, _selections) do
    @users
    |> Enum.map(fn u -> %{id: u.id, label: u.title, description: u.subtitle, icon: u.icon, value: u.id} end)
    |> filter_options(query)
  end

  defp get_step_options("go", "page", query, _selections) do
    [
      %{id: "dashboard", label: "Dashboard", code: "01", icon: "📊", value: "/"},
      %{id: "forms", label: "Forms", code: "10", icon: "📝", value: "/forms"},
      %{id: "buttons", label: "Buttons", code: "20", icon: "🔘", value: "/components/buttons"},
      %{id: "inputs", label: "Inputs", code: "21", icon: "✏️", value: "/components/inputs"},
      %{id: "cards", label: "Cards", code: "22", icon: "🃏", value: "/components/cards"},
      %{id: "tables", label: "Tables", code: "23", icon: "📊", value: "/tables/standard"},
      %{id: "alerts", label: "Alerts", code: "24", icon: "⚠️", value: "/components/alerts"},
      %{id: "toasts", label: "Toasts", code: "25", icon: "🔔", value: "/components/toasts"},
      %{id: "modals", label: "Modals", code: "26", icon: "🔳", value: "/components/modals"},
      %{id: "tabs", label: "Tabs", code: "27", icon: "📑", value: "/components/tabs"},
      %{id: "badges", label: "Badges", code: "28", icon: "🏷️", value: "/components/badges"},
      %{id: "tooltips", label: "Tooltips", code: "29", icon: "💬", value: "/components/tooltips"},
      %{id: "command-palette", label: "Command Palette", code: "30", icon: "🔍", value: "/components/command-palette"},
      %{id: "colors", label: "Colors", code: "12", icon: "🌈", value: "/design/colors"},
      %{id: "theme-vars", label: "Theme Variables", code: "11", icon: "🎨", value: "/design/theme-variables"}
    ]
    |> filter_options(query)
  end

  defp get_step_options("theme", "theme", query, _selections) do
    [
      %{id: "audi", label: "Audi", description: "Premium dark theme", icon: "🔴", value: "audi"},
      %{id: "dark", label: "Dark", description: "Clean dark theme", icon: "🌑", value: "dark"},
      %{id: "express", label: "Express", description: "Blue professional theme", icon: "🔵", value: "express"},
      %{id: "corporate", label: "Corporate", description: "Business theme", icon: "🏢", value: "corporate"},
      %{id: "minimal", label: "Minimal", description: "Clean minimal theme", icon: "⚪", value: "minimal"}
    ]
    |> filter_options(query)
  end

  defp get_step_options(_, _, _, _), do: []

  defp filter_options(options, query) do
    q = String.trim(query) |> String.downcase()

    if q == "" do
      options
    else
      Enum.filter(options, fn opt ->
        String.contains?(String.downcase(opt[:label] || ""), q) or
          String.contains?(String.downcase(opt[:description] || ""), q) or
          (opt[:code] || "") == q
      end)
    end
  end

  defp build_preview(command, selections) do
    if selections == [] do
      nil
    else
      parts =
        Enum.map(selections, fn s -> s.label end)
        |> Enum.join(" → ")

      "#{command.name}: #{parts}"
    end
  end

  # Build the full inline text for the input: "/assign iPad Air to "
  defp build_inline_text(command, selections, current_step) do
    base = command.shortcut

    text =
      Enum.reduce(selections, base, fn sel, acc ->
        acc <> (sel[:prompt] || " ") <> sel[:label]
      end)

    # Add current step's prompt
    text <> (current_step[:prompt] || " ")
  end

  # Push reset_input with the right value based on display mode
  defp push_reset_input(socket, inline_value) do
    if socket.assigns.cp_display == "inline" do
      push_event(socket, "cp:reset_input", %{value: inline_value})
    else
      push_event(socket, "cp:reset_input", %{value: ""})
    end
  end
end
