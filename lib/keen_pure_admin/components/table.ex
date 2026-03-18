defmodule KPureAdmin.Components.Table do
  @moduledoc """
  Table components for Pure Admin.

  Provides `table/1`, `table_responsive/1`, `table_container/1`, and `table_card/1`.
  """
  use Phoenix.Component

  import KPureAdmin.Helpers

  @doc """
  Renders a data table with Pure Admin BEM classes.

  Accepts rows and column definitions via slots, following Phoenix conventions.

  ## Examples

      <.table rows={@users} is_striped is_hover>
        <:col :let={user} label="Name"><%= user.name %></:col>
        <:col :let={user} label="Email"><%= user.email %></:col>
        <:action :let={user}>
          <.button variant="primary" size="xs">Edit</.button>
        </:action>
      </.table>
  """
  attr(:id, :string, default: nil)
  attr(:rows, :list, required: true, doc: "List of row data")
  attr(:row_id, :any, default: nil, doc: "Function to generate row id from row data")
  attr(:row_click, :any, default: nil, doc: "JS command for row click")
  attr(:is_striped, :boolean, default: false, doc: "Alternating row colors")
  attr(:is_hover, :boolean, default: false, doc: "Hover effect on rows")
  attr(:is_bordered, :boolean, default: false, doc: "Full cell borders on all sides")
  attr(:is_borderless, :boolean, default: false, doc: "Remove all cell borders")
  attr(:is_compact, :boolean, default: false, doc: "Compact table (reduced padding)")
  attr(:is_responsive, :boolean, default: false, doc: "Wrap in responsive scrolling container")
  attr(:is_responsive_grid, :boolean, default: false, doc: "CSS Grid responsive collapse on mobile")
  attr(:size, :string, default: nil, values: [nil, "xs", "sm", "lg", "xl"])
  attr(:class, :string, default: nil)
  attr(:rest, :global)

  slot :col, required: true, doc: "Column definitions" do
    attr(:label, :string, required: true)
    attr(:class, :string)
    attr(:col_class, :string, doc: "Class for th/td (e.g. col-auto)")
    attr(:align, :string, doc: "Text alignment (start, center, end)")
  end

  slot :action, doc: "Action column" do
    attr(:label, :string)
    attr(:class, :string)
  end

  slot(:foot, doc: "Table footer rows (tfoot content)")

  def table(assigns) do
    assigns =
      with %{rows: %Phoenix.LiveView.LiveStream{}} <- assigns do
        assign(assigns, row_id: assigns.row_id || fn {id, _item} -> id end)
      end

    ~H"""
    <%= if @is_responsive do %>
      <div class="pa-table-responsive">
        <.table_inner {assigns} />
      </div>
    <% else %>
      <.table_inner {assigns} />
    <% end %>
    """
  end

  defp table_inner(assigns) do
    ~H"""
    <table id={@id} class={table_classes(assigns)} {@rest}>
      <thead>
        <tr>
          <th :for={action <- @action} class={action[:class] || "col-auto"}><%= action[:label] %></th>
          <th :for={col <- @col} class={col_header_class(col)}><%= col[:label] %></th>
        </tr>
      </thead>
      <tbody id={@id && "#{@id}-body"} phx-update={match?(%Phoenix.LiveView.LiveStream{}, @rows) && "stream"}>
        <tr :for={row <- @rows} id={@row_id && @row_id.(row)} phx-click={@row_click && @row_click.(row)}>
          <td :for={action <- @action} class={action[:class] || "col-auto"}>
            <div class="pa-btn-group">
              <%= render_slot(action, @row_id && @row_id.(row) && elem(row, 1) || row) %>
            </div>
          </td>
          <td :for={col <- @col} class={col_cell_class(col)}>
            <%= render_slot(col, @row_id && @row_id.(row) && elem(row, 1) || row) %>
          </td>
        </tr>
      </tbody>
      <tfoot :if={@foot != []}>
        <%= render_slot(@foot) %>
      </tfoot>
    </table>
    """
  end

  defp col_header_class(col) do
    classes = [col[:col_class], align_class(col[:align])]
    case Enum.reject(classes, &is_nil/1) do
      [] -> nil
      parts -> Enum.join(parts, " ")
    end
  end

  defp col_cell_class(col) do
    classes = [col[:class], align_class(col[:align])]
    case Enum.reject(classes, &is_nil/1) do
      [] -> nil
      parts -> Enum.join(parts, " ")
    end
  end

  defp align_class("end"), do: "text-end"
  defp align_class("center"), do: "text-center"
  defp align_class("start"), do: "text-start"
  defp align_class(_), do: nil

  defp table_classes(assigns) do
    effective_size = if assigns.is_compact && assigns.size == nil, do: "xs", else: assigns.size

    build_classes(
      "pa-table",
      [
        {"pa-table--striped", assigns.is_striped},
        {"pa-table--hover", assigns.is_hover},
        {"pa-table--bordered", assigns.is_bordered},
        {"pa-table--borderless", assigns.is_borderless},
        {"pa-table--responsive", assigns.is_responsive},
        {"pa-table--responsive-grid", assigns.is_responsive_grid},
        {"pa-table--#{effective_size}", effective_size != nil}
      ],
      assigns.class
    )
  end

  @doc """
  Wraps a table in a responsive scrolling container.

  ## Examples

      <.table_responsive>
        <.table rows={@data}>...</.table>
      </.table_responsive>
  """
  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def table_responsive(assigns) do
    ~H"""
    <div class={build_classes("pa-table-responsive", [], @class)} {@rest}>
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  @doc """
  Wraps a table in a bordered container with scroll support.

  ## Examples

      <.table_container>
        <.table rows={@data}>...</.table>
      </.table_container>

      <.table_container is_panel title_text="Users">
        <:actions><.button size="sm">Export</.button></:actions>
        <.table rows={@data}>...</.table>
      </.table_container>
  """
  attr(:is_panel, :boolean, default: false, doc: "Card-like panel styling with shadow")
  attr(:title_text, :string, default: nil, doc: "Header title (panel mode only)")
  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:header, doc: "Custom header content (overrides title_text)")
  slot(:actions, doc: "Header action buttons (panel mode only)")
  slot(:inner_block, required: true)

  def table_container(assigns) do
    has_header = assigns.header != [] || assigns.title_text != nil || assigns.actions != []

    assigns = assign(assigns, :has_header, has_header)

    ~H"""
    <div class={build_classes("pa-table-container", [{"pa-table-container--panel", @is_panel}], @class)} {@rest}>
      <div :if={@is_panel && @has_header} class="pa-table-container__header">
        <%= if @header != [] do %>
          <%= render_slot(@header) %>
        <% else %>
          <h3 :if={@title_text} class="pa-table-container__title"><%= @title_text %></h3>
        <% end %>
        <div :if={@actions != []} class="pa-table-container__actions">
          <%= render_slot(@actions) %>
        </div>
      </div>
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  # -- table_card/1 --

  @doc """
  Renders a card wrapper for tables with header, footer, and color variants.

  ## Examples

      <.table_card title_text="Recent Orders">
        <.table rows={@orders}>
          <:col :let={o} label="Order"><%= o.id %></:col>
          <:col :let={o} label="Total"><%= o.total %></:col>
        </.table>
      </.table_card>

      <.table_card title_text="Sales" variant="primary" is_scrollable>
        <:actions><.button size="sm">Export</.button></:actions>
        <.table rows={@data}>...</.table>
        <:footer><.pager page={@page} total_pages={@total_pages} /></:footer>
      </.table_card>
  """
  attr(:title_text, :string, default: nil, doc: "Card title")
  attr(:variant, :string, default: nil,
    values: [nil, "primary", "success", "warning", "danger"],
    doc: "Semantic color variant for header accent")
  attr(:color, :string, default: nil, doc: "Theme color 1-9")
  attr(:is_scrollable, :boolean, default: false, doc: "Horizontal scrolling for wide tables")
  attr(:is_plain, :boolean, default: false, doc: "Remove card styling (border, shadow, background)")
  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:header, doc: "Custom header content (overrides title_text)")
  slot(:actions, doc: "Header action buttons")
  slot(:inner_block, required: true)
  slot(:footer, doc: "Footer content (e.g. pagination)")

  def table_card(assigns) do
    has_header = assigns.header != [] || assigns.title_text != nil || assigns.actions != []

    assigns = assign(assigns, :has_header, has_header)

    ~H"""
    <div class={build_classes("pa-table-card", [
      {"pa-table-card--#{@variant}", @variant != nil},
      {"pa-table-card--color-#{@color}", @color != nil},
      {"pa-table-card--plain", @is_plain}
    ], @class)} {@rest}>
      <div :if={@has_header} class="pa-table-card__header">
        <%= if @header != [] do %>
          <%= render_slot(@header) %>
        <% else %>
          <h3 :if={@title_text}><%= @title_text %></h3>
        <% end %>
        <div :if={@actions != []} class="pa-table-card__actions">
          <%= render_slot(@actions) %>
        </div>
      </div>
      <div class={build_classes("pa-table-card__body", [{"pa-table-card__body--scrollable", @is_scrollable}])}>
        <%= render_slot(@inner_block) %>
      </div>
      <div :if={@footer != []} class="pa-table-card__footer">
        <%= render_slot(@footer) %>
      </div>
    </div>
    """
  end
end
