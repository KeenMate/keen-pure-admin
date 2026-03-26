defmodule PureAdmin.Components.TypographyTest do
  use PureAdmin.ComponentCase, async: true

  alias PureAdmin.Components.Typography

  describe "heading/1" do
    test "renders h2 by default" do
      html = render_component(&Typography.heading/1, %{
        level: 2, class: nil,
        inner_block: [%{__slot__: :inner_block, inner_block: fn _, _ -> "Title" end}]
      })

      assert html =~ "<h2"
      assert html =~ "Title"
    end

    test "renders all heading levels" do
      for level <- 1..6 do
        html = render_component(&Typography.heading/1, %{
          level: level, class: nil,
          inner_block: [%{__slot__: :inner_block, inner_block: fn _, _ -> "H#{level}" end}]
        })

        assert html =~ "<h#{level}"
      end
    end

    test "accepts extra class" do
      html = render_component(&Typography.heading/1, %{
        level: 4, class: "mt-4",
        inner_block: [%{__slot__: :inner_block, inner_block: fn _, _ -> "Title" end}]
      })

      assert html =~ "mt-4"
    end
  end
end
