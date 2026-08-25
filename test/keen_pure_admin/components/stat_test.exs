defmodule PureAdmin.Components.StatTest do
  use PureAdmin.ComponentCase, async: true

  alias PureAdmin.Components.Stat

  describe "stat/1" do
    test "renders hero variant" do
      html =
        render_component(&Stat.stat/1, %{
          variant: "hero",
          color: nil,
          icon_variant: "primary",
          number: "$847,392",
          label_text: "Revenue",
          change_text: "+12.5%",
          change_direction: "positive",
          symbol_text: nil,
          value: nil,
          label: nil,
          trend: nil,
          trend_direction: nil,
          class: nil,
          icon: [],
          inner_block: []
        })

      assert_class(html, "pa-stat--hero")
      assert html =~ "$847,392"
      assert html =~ "Revenue"
      assert html =~ "+12.5%"
      assert_class(html, "pa-stat__change--positive")
    end

    test "renders square variant with color" do
      html =
        render_component(&Stat.stat/1, %{
          variant: "square",
          color: "warning",
          icon_variant: "primary",
          number: "78",
          label_text: "Capacity",
          change_text: nil,
          change_direction: nil,
          symbol_text: "%",
          value: nil,
          label: nil,
          trend: nil,
          trend_direction: nil,
          class: nil,
          icon: [],
          inner_block: []
        })

      assert_class(html, "pa-stat--square")
      assert_class(html, "pa-stat--warning")
      assert html =~ "78"
      assert html =~ "%"
      assert html =~ "Capacity"
    end

    test "color is suppressed on non-square stats (core only styles it compounded with --square)" do
      html =
        render_component(&Stat.stat/1, %{
          variant: "hero",
          color: "warning",
          icon_variant: "primary",
          number: "78",
          label_text: "Capacity",
          change_text: nil,
          change_direction: nil,
          symbol_text: nil,
          value: nil,
          label: nil,
          trend: nil,
          trend_direction: nil,
          class: nil,
          icon: [],
          inner_block: []
        })

      # .pa-stat--warning only exists as `.pa-stat--square.pa-stat--warning`, so a
      # hero stat must not emit the standalone (dead) colour class.
      refute_class(html, "pa-stat--warning")
    end

    test "renders negative change direction" do
      html =
        render_component(&Stat.stat/1, %{
          variant: "hero",
          color: nil,
          icon_variant: "primary",
          number: "3.47%",
          label_text: "Rate",
          change_text: "-2.1%",
          change_direction: "negative",
          symbol_text: nil,
          value: nil,
          label: nil,
          trend: nil,
          trend_direction: nil,
          class: nil,
          icon: [],
          inner_block: []
        })

      assert_class(html, "pa-stat__change--negative")
    end
  end
end
