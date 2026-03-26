defmodule PureAdmin.Components.TableTest do
  use PureAdmin.ComponentCase, async: true

  alias PureAdmin.Components.Table

  describe "table/1" do
    test "renders basic table" do
      html =
        render_component(&Table.table/1, %{
          id: nil,
          rows: [%{name: "John", email: "john@example.com"}],
          row_id: nil,
          row_click: nil,
          is_striped: false,
          size: nil,
          class: nil,
          col: [
            %{
              __slot__: :col,
              label: "Name",
              class: nil,
              col_class: nil,
              inner_block: fn _assigns, row -> row.name end
            },
            %{
              __slot__: :col,
              label: "Email",
              class: nil,
              col_class: nil,
              inner_block: fn _assigns, row -> row.email end
            }
          ],
          action: []
        })

      assert_class(html, "pa-table")
      assert html =~ "Name"
      assert html =~ "Email"
      assert html =~ "John"
      assert html =~ "john@example.com"
    end

    test "renders striped table with size" do
      html =
        render_component(&Table.table/1, %{
          id: nil,
          rows: [],
          row_id: nil,
          row_click: nil,
          is_striped: true,
          size: "xs",
          class: nil,
          col: [
            %{
              __slot__: :col,
              label: "Col",
              class: nil,
              col_class: nil,
              inner_block: fn _, _ -> "" end
            }
          ],
          action: []
        })

      assert_class(html, "pa-table--striped")
      assert_class(html, "pa-table--xs")
    end
  end

  describe "table_responsive/1" do
    test "renders responsive wrapper" do
      html =
        render_component(&Table.table_responsive/1, %{
          class: nil,
          inner_block: [%{__slot__: :inner_block, inner_block: fn _, _ -> "table" end}]
        })

      assert_class(html, "pa-table-responsive")
    end
  end
end
