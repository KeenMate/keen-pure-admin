defmodule PureAdmin.Components.CalloutTest do
  use PureAdmin.ComponentCase, async: true

  alias PureAdmin.Components.Callout

  describe "callout/1" do
    test "renders with default variant" do
      html =
        render_component(&Callout.callout/1, %{
          variant: "info",
          size: nil,
          theme_color: nil,
          heading_text: nil,
          class: nil,
          icon: [],
          title: [],
          inner_block: [%{__slot__: :inner_block, inner_block: fn _, _ -> "Note" end}]
        })

      assert_class(html, "pa-callout")
      assert_class(html, "pa-callout--info")
      assert html =~ "Note"
    end

    test "renders all semantic variants" do
      for variant <- ~w(primary secondary info success warning danger) do
        html =
          render_component(&Callout.callout/1, %{
            variant: variant,
            size: nil,
            theme_color: nil,
            heading_text: nil,
            class: nil,
            icon: [],
            title: [],
            inner_block: [%{__slot__: :inner_block, inner_block: fn _, _ -> "text" end}]
          })

        assert_class(html, "pa-callout--#{variant}")
      end
    end

    test "renders theme color" do
      html =
        render_component(&Callout.callout/1, %{
          variant: "info",
          size: nil,
          theme_color: "3",
          heading_text: nil,
          class: nil,
          icon: [],
          title: [],
          inner_block: [%{__slot__: :inner_block, inner_block: fn _, _ -> "text" end}]
        })

      assert_class(html, "pa-callout--color-3")
      refute_class(html, "pa-callout--info")
    end

    test "renders sizes" do
      for size <- ~w(sm lg) do
        html =
          render_component(&Callout.callout/1, %{
            variant: "info",
            size: size,
            theme_color: nil,
            heading_text: nil,
            class: nil,
            icon: [],
            title: [],
            inner_block: [%{__slot__: :inner_block, inner_block: fn _, _ -> "text" end}]
          })

        assert_class(html, "pa-callout--#{size}")
      end
    end

    test "renders heading_text" do
      html =
        render_component(&Callout.callout/1, %{
          variant: "info",
          size: nil,
          theme_color: nil,
          heading_text: "Important",
          class: nil,
          icon: [],
          title: [],
          inner_block: [%{__slot__: :inner_block, inner_block: fn _, _ -> "text" end}]
        })

      assert html =~ "pa-callout__heading"
      assert html =~ "Important"
    end
  end
end
