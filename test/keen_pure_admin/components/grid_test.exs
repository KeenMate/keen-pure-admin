defmodule PureAdmin.Components.GridTest do
  use PureAdmin.ComponentCase, async: true

  alias PureAdmin.Components.Grid

  describe "grid/1" do
    test "renders basic row" do
      html =
        render_component(&Grid.grid/1, %{
          is_no_gutter: false,
          is_same_height: false,
          align: nil,
          valign: nil,
          class: nil,
          inner_block: [%{__slot__: :inner_block, inner_block: fn _, _ -> "columns" end}]
        })

      assert_class(html, "pa-row")
    end

    test "renders row with modifiers" do
      html =
        render_component(&Grid.grid/1, %{
          is_no_gutter: true,
          is_same_height: true,
          align: "center",
          valign: "middle",
          class: nil,
          inner_block: [%{__slot__: :inner_block, inner_block: fn _, _ -> "" end}]
        })

      assert_class(html, "pa-row--no-gutter")
      assert_class(html, "pa-row--same-height")
      assert_class(html, "pa-row--center")
      assert_class(html, "pa-row--middle")
    end
  end

  describe "column/1" do
    test "renders responsive column" do
      html =
        render_component(&Grid.column/1, %{
          size: "100",
          sm: nil,
          md: "50",
          lg: "1-3",
          xl: nil,
          offset: nil,
          class: nil,
          inner_block: [%{__slot__: :inner_block, inner_block: fn _, _ -> "content" end}]
        })

      assert_class(html, "pa-col-100")
      assert_class(html, "pa-col-md-50")
      assert_class(html, "pa-col-lg-1-3")
    end

    test "renders column with offset" do
      html =
        render_component(&Grid.column/1, %{
          size: "50",
          sm: nil,
          md: nil,
          lg: nil,
          xl: nil,
          offset: "25",
          class: nil,
          inner_block: [%{__slot__: :inner_block, inner_block: fn _, _ -> "" end}]
        })

      assert_class(html, "pa-col-50")
      assert_class(html, "pa-offset-25")
    end
  end
end
