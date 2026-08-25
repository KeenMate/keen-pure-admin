defmodule PureAdmin.Components.TypographyTest do
  use PureAdmin.ComponentCase, async: true

  alias PureAdmin.Components.Typography

  describe "heading/1" do
    test "renders h2 by default" do
      html =
        render_component(&Typography.heading/1, %{
          level: 2,
          class: nil,
          inner_block: [%{__slot__: :inner_block, inner_block: fn _, _ -> "Title" end}]
        })

      assert html =~ "<h2"
      assert html =~ "Title"
    end

    test "renders all heading levels" do
      for level <- 1..6 do
        html =
          render_component(&Typography.heading/1, %{
            level: level,
            class: nil,
            inner_block: [%{__slot__: :inner_block, inner_block: fn _, _ -> "H#{level}" end}]
          })

        assert html =~ "<h#{level}"
      end
    end

    test "accepts extra class" do
      html =
        render_component(&Typography.heading/1, %{
          level: 4,
          class: "mt-4",
          inner_block: [%{__slot__: :inner_block, inner_block: fn _, _ -> "Title" end}]
        })

      assert html =~ "mt-4"
    end
  end

  describe "text/1 variant maps to real classes" do
    defp render_text(variant) do
      render_component(&Typography.text/1, %{
        variant: variant,
        class: nil,
        rest: %{},
        inner_block: [%{__slot__: :inner_block, inner_block: fn _, _ -> "x" end}]
      })
    end

    test "friendly names resolve to existing pa-text--*/.text-* classes" do
      # muted/small are aliases; semantic colours route to .text-* utilities.
      assert_class(render_text("muted"), "pa-text--secondary")
      assert_class(render_text("small"), "pa-text--sm")
      assert_class(render_text("primary"), "pa-text--primary")
      assert_class(render_text("secondary"), "pa-text--secondary")
      assert_class(render_text("success"), "text-success")
      assert_class(render_text("danger"), "text-danger")
    end

    test "never emits the invented pa-text--{muted,small,success,danger} modifiers" do
      for {v, invented} <- [
            {"muted", "pa-text--muted"},
            {"small", "pa-text--small"},
            {"success", "pa-text--success"},
            {"danger", "pa-text--danger"}
          ] do
        refute_class(render_text(v), invented)
      end
    end
  end

  describe "pa_link/1" do
    test "emits bare pa-link with no invented variant modifier" do
      html =
        render_component(&Typography.pa_link/1, %{
          href: "/x",
          class: nil,
          rest: %{},
          inner_block: [%{__slot__: :inner_block, inner_block: fn _, _ -> "go" end}]
        })

      assert_class(html, "pa-link")
      refute html =~ "pa-link--"
    end
  end
end
