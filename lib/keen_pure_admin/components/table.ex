defmodule KPureAdmin.Components.Table do
  @moduledoc """
  Table components for Pure Admin.

  Provides `table/1`, `table_responsive/1`, and `table_container/1`.
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
  attr(:size, :string, default: nil, values: [nil, "xs", "sm", "lg", "xl"])
  attr(:class, :string, default: nil)
  attr(:rest, :global)

  slot :col, required: true, doc: "Column definitions" do
    attr(:label, :string, required: true)
    attr(:class, :string)
    attr(:col_class, :string, doc: "Class for th/td (e.g. col-auto)")
  end

  slot :action, doc: "Action column" do
    attr(:label, :string)
    attr(:class, :string)
  end

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
          <th :for={col <- @col} class={col[:col_class]}><%= col[:label] %></th>
          <th :for={action <- @action} class={action[:class] || "col-auto"}><%= action[:label] %></th>
        </tr>
      </thead>
      <tbody id={@id && "#{@id}-body"} phx-update={match?(%Phoenix.LiveView.LiveStream{}, @rows) && "stream"}>
        <tr :for={row <- @rows} id={@row_id && @row_id.(row)} phx-click={@row_click && @row_click.(row)}>
          <td
            :for={{col, _i} <- Enum.with_index(@col)}
            class={col[:class]}
          >
            <%= render_slot(col, @row_id && @row_id.(row) && elem(row, 1) || row) %>
          </td>
          <td :for={action <- @action} class={action[:class] || "col-auto"}>
            <div class="pa-btn-group">
              <%= render_slot(action, @row_id && @row_id.(row) && elem(row, 1) || row) %>
            </div>
          </td>
        </tr>
      </tbody>
    </table>
    """
  end

  defp table_classes(assigns) do
    effective_size = if assigns.is_compact && assigns.size == nil, do: "xs", else: assigns.size

    build_classes(
      "pa-table",
      [
        {"pa-table--striped", assigns.is_striped},
        {"pa-table--hover", assigns.is_hover},
        {"pa-table--bordered", assigns.is_bordered},
        {"pa-table--borderless", assigns.is_borderless},
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
  """
  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def table_container(assigns) do
    ~H"""
    <div class={build_classes("pa-table-container", [], @class)} {@rest}>
      <%= render_slot(@inner_block) %>
    </div>
    """
  end
end
