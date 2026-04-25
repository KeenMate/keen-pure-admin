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

    test "drops pa-alert__content wrapper when no icon is supplied" do
      html =
        render_component(&Alert.alert/1, %{
          variant: "danger",
          heading_text: "Validation failed",
          inner_block: [%{__slot__: :inner_block, inner_block: fn _, _ -> "Fix the errors below." end}]
        })

      refute html =~ "pa-alert__content"
      assert html =~ ~s(<h4 class="pa-alert__heading">Validation failed</h4>)
    end

    test "wraps content in pa-alert__content when an icon is supplied" do
      html =
        render_component(&Alert.alert/1, %{
          variant: "info",
          heading_text: "Heads up",
          icon: [%{__slot__: :icon, inner_block: fn _, _ -> "i" end}],
          inner_block: [%{__slot__: :inner_block, inner_block: fn _, _ -> "Body." end}]
        })

      assert html =~ ~s(<div class="pa-alert__content">)
      assert html =~ "pa-alert__icon"
    end

    test "heading_size=lg adds pa-alert__heading--lg modifier" do
      html =
        render_component(&Alert.alert/1, %{
          variant: "info",
          heading_text: "Big news",
          heading_size: "lg",
          inner_block: [%{__slot__: :inner_block, inner_block: fn _, _ -> "Body." end}]
        })

      assert html =~ ~s(class="pa-alert__heading pa-alert__heading--lg")
    end

    test "is_multiline adds pa-alert--multiline modifier" do
      html =
        render_component(&Alert.alert/1, %{
          variant: "info",
          is_multiline: true,
          inner_block: [%{__slot__: :inner_block, inner_block: fn _, _ -> "Body." end}]
        })

      assert_class(html, "pa-alert--multiline")
    end
  end
end
