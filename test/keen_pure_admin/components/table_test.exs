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

  describe "table/1 is_responsive" do
    test "emits the pa-table--responsive modifier and no phantom wrapper" do
      html =
        render_component(&Table.table/1, %{
          rows: [%{name: "A"}],
          is_responsive: true,
          col: [
            %{
              __slot__: :col,
              label: "Name",
              class: nil,
              col_class: nil,
              inner_block: fn _, row -> row.name end
            }
          ],
          action: []
        })

      assert_class(html, "pa-table--responsive")
      refute_class(html, "pa-table-responsive")
    end
  end

  describe "table_container/1" do
    test "bare container has no header (blessed card-less shape)" do
      html =
        render_component(&Table.table_container/1, %{
          inner_block: [%{__slot__: :inner_block, inner_block: fn _, _ -> "t" end}]
        })

      assert_class(html, "pa-table-container")
      refute_class(html, "pa-table-container--panel")
      refute_class(html, "pa-table-container__header")
    end

    test "is_panel still renders the deprecated (rc10) --panel shape" do
      html =
        render_component(&Table.table_container/1, %{
          is_panel: true,
          title_text: "Users",
          inner_block: [%{__slot__: :inner_block, inner_block: fn _, _ -> "t" end}]
        })

      assert_class(html, "pa-table-container--panel")
      assert_class(html, "pa-table-container__header")
    end
  end

  describe "table_card/1" do
    test "is_scrollable adds __body--scrollable for wide tables" do
      html =
        render_component(&Table.table_card/1, %{
          is_scrollable: true,
          inner_block: [%{__slot__: :inner_block, inner_block: fn _, _ -> "t" end}]
        })

      assert_class(html, "pa-table-card")
      assert_class(html, "pa-table-card__body--scrollable")
    end

    test "is_plain drops the card chrome" do
      html =
        render_component(&Table.table_card/1, %{
          is_plain: true,
          inner_block: [%{__slot__: :inner_block, inner_block: fn _, _ -> "t" end}]
        })

      assert_class(html, "pa-table-card--plain")
    end

    test "header uses a bare h3 (matches rc10 canonical, no radius classes)" do
      html =
        render_component(&Table.table_card/1, %{
          title_text: "Recent",
          inner_block: [%{__slot__: :inner_block, inner_block: fn _, _ -> "t" end}]
        })

      assert html =~ ~r{<div class="pa-table-card__header">\s*<h3>Recent</h3>}
    end
  end
end
