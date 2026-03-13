defmodule KPureAdmin.Components.ButtonTest do
  use KPureAdmin.ComponentCase, async: true

  alias KPureAdmin.Components.Button

  describe "button/1" do
    test "renders default primary button" do
      html =
        render_component(&Button.button/1, %{
          variant: "primary",
          size: nil,
          is_outline: false,
          is_block: false,
          is_loading: false,
          is_icon_only: false,
          is_ripple: false,
          align: nil,
          type: "button",
          class: nil,
          icon: [],
          inner_block: [%{__slot__: :inner_block, inner_block: fn _, _ -> "Click me" end}]
        })

      assert_class(html, "pa-btn")
      assert_class(html, "pa-btn--primary")
      assert html =~ "Click me"
    end

    test "renders outline variant" do
      html =
        render_component(&Button.button/1, %{
          variant: "danger",
          size: "sm",
          is_outline: true,
          is_block: false,
          is_loading: false,
          is_icon_only: false,
          is_ripple: false,
          align: nil,
          type: "button",
          class: nil,
          icon: [],
          inner_block: [%{__slot__: :inner_block, inner_block: fn _, _ -> "Delete" end}]
        })

      assert_class(html, "pa-btn--outline-danger")
      assert_class(html, "pa-btn--sm")
    end

    test "renders block and loading states" do
      html =
        render_component(&Button.button/1, %{
          variant: "primary",
          size: nil,
          is_outline: false,
          is_block: true,
          is_loading: true,
          is_icon_only: false,
          is_ripple: false,
          align: nil,
          type: "submit",
          class: "extra",
          icon: [],
          inner_block: [%{__slot__: :inner_block, inner_block: fn _, _ -> "Save" end}]
        })

      assert_class(html, "pa-btn--block")
      assert_class(html, "pa-btn--loading")
      assert_class(html, "pa-btn__spinner")
      assert_class(html, "extra")
      assert html =~ ~s(type="submit")
    end
  end

  describe "button_group/1" do
    test "renders horizontal group" do
      html =
        render_component(&Button.button_group/1, %{
          is_vertical: false,
          align: nil,
          is_nowrap: false,
          class: nil,
          inner_block: [%{__slot__: :inner_block, inner_block: fn _, _ -> "buttons" end}]
        })

      assert_class(html, "pa-btn-group")
      refute_class(html, "pa-btn-group--vertical")
    end

    test "renders vertical group with alignment" do
      html =
        render_component(&Button.button_group/1, %{
          is_vertical: true,
          align: "stretch",
          is_nowrap: false,
          class: nil,
          inner_block: [%{__slot__: :inner_block, inner_block: fn _, _ -> "buttons" end}]
        })

      assert_class(html, "pa-btn-group--vertical")
      assert_class(html, "pa-btn-group--stretch")
    end
  end
end
