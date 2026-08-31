defmodule DemoWeb.Live.FormsLiveTest do
  use DemoWeb.ConnCase

  import Phoenix.LiveViewTest

  test "GET /forms renders the page title", %{conn: conn} do
    {:ok, _view, html} = live(conn, ~p"/forms")
    assert html =~ "Complete set of form elements"
  end

  test "renders every showcase card", %{conn: conn} do
    {:ok, _view, html} = live(conn, ~p"/forms")

    for heading <- [
          "Input Sizes Reference",
          "User Profile",
          "Contact Information",
          "Quick Settings",
          "Compact Three Column Layout",
          "Input Groups",
          "Form States",
          "Input Sizes",
          "Checkboxes &amp; Radio Buttons",
          "Label Position",
          "Orientation",
          "Checkbox &amp; Radio Sizes",
          "Horizontal Form Layout"
        ] do
      assert html =~ heading
    end
  end

  test "renders form controls with pure-admin classes", %{conn: conn} do
    {:ok, _view, html} = live(conn, ~p"/forms")

    assert html =~ "pa-input"
    assert html =~ "pa-select"
    assert html =~ "pa-textarea"
    assert html =~ "pa-checkbox"
    assert html =~ "pa-radio"
    assert html =~ "pa-input-group"
    assert html =~ "pa-form-group--horizontal"
  end

  test "wires the input-sizes measurement and tri-state hooks", %{conn: conn} do
    {:ok, _view, html} = live(conn, ~p"/forms")

    assert html =~ ~s(phx-hook="MeasureFormSizes")
    assert html =~ ~s(phx-hook="FormsTristate")
    assert html =~ ~s(data-measure="input")
    assert html =~ ~s(data-measure="button")
  end
end
