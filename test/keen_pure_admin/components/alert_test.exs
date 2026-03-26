defmodule PureAdmin.Components.AlertTest do
  use PureAdmin.ComponentCase, async: true

  alias PureAdmin.Components.Alert

  describe "alert/1" do
    test "renders basic alert" do
      html =
        render_component(&Alert.alert/1, %{
          id: nil,
          variant: "success",
          size: nil,
          is_outline: false,
          is_dismissible: false,
          class: nil,
          icon: [],
          heading: [],
          actions: [],
          inner_block: [%{__slot__: :inner_block, inner_block: fn _, _ -> "Well done!" end}]
        })

      assert_class(html, "pa-alert")
      assert_class(html, "pa-alert--success")
      assert html =~ "Well done!"
    end

    test "renders outline alert" do
      html =
        render_component(&Alert.alert/1, %{
          id: nil,
          variant: "danger",
          size: nil,
          is_outline: true,
          is_dismissible: false,
          class: nil,
          icon: [],
          heading: [],
          actions: [],
          inner_block: [%{__slot__: :inner_block, inner_block: fn _, _ -> "Error" end}]
        })

      assert_class(html, "pa-alert--outline-danger")
    end

    test "renders dismissible alert with id" do
      html =
        render_component(&Alert.alert/1, %{
          id: "my-alert",
          variant: "warning",
          size: "sm",
          is_outline: false,
          is_dismissible: true,
          class: nil,
          icon: [],
          heading: [],
          actions: [],
          inner_block: [%{__slot__: :inner_block, inner_block: fn _, _ -> "Warning!" end}]
        })

      assert_class(html, "pa-alert--dismissible")
      assert_class(html, "pa-alert--sm")
      assert_class(html, "pa-alert__close")
      assert html =~ ~s(id="my-alert")
    end
  end
end
