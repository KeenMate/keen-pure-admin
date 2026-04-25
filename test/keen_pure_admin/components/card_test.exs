defmodule PureAdmin.Components.CardTest do
  use PureAdmin.ComponentCase, async: true

  alias PureAdmin.Components.Card

  defp default_assigns(overrides \\ %{}) do
    Map.merge(
      %{
        variant: nil,
        live_state: nil,
        is_ghost: false,
        has_padding: true,
        title_text: nil,
        description_text: nil,
        subtitle_text: nil,
        is_header_underlined: false,
        header_underline_color: nil,
        has_inline_tabs: false,
        header_wrap: false,
        header_class: nil,
        class: nil,
        header: [],
        title: [],
        title_icon: [],
        description: [],
        tools: [],
        meta: [],
        tabs: [],
        footer: [],
        actions: [],
        inner_block: [%{__slot__: :inner_block, inner_block: fn _, _ -> "Content" end}]
      },
      overrides
    )
  end

  describe "card/1" do
    test "renders simple card" do
      html = render_component(&Card.card/1, default_assigns())

      assert_class(html, "pa-card")
      assert_class(html, "pa-card__body")
      assert html =~ "Content"
      refute html =~ "pa-card__header"
    end

    test "renders card with variant" do
      html = render_component(&Card.card/1, default_assigns(%{variant: "primary"}))

      assert_class(html, "pa-card--primary")
    end

    test "renders card with no-padding body" do
      html = render_component(&Card.card/1, default_assigns(%{has_padding: false}))

      assert_class(html, "pa-card__body--no-padding")
    end

    test "renders card with title_text" do
      html = render_component(&Card.card/1, default_assigns(%{title_text: "My Title"}))

      assert html =~ "pa-card__header"
      assert html =~ "My Title"
      assert html =~ "<h3>"
    end

    test "renders ghost card" do
      html = render_component(&Card.card/1, default_assigns(%{is_ghost: true}))

      assert_class(html, "pa-card--ghost")
    end

    test "renders card with header underline" do
      html =
        render_component(
          &Card.card/1,
          default_assigns(%{
            title_text: "Test",
            is_header_underlined: true,
            header_underline_color: "success"
          })
        )

      assert html =~ "pa-card__header--underlined"
      assert html =~ "pa-card__header--underline-success"
    end
  end
end
