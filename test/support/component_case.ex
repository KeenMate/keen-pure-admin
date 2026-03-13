defmodule KPureAdmin.ComponentCase do
  @moduledoc """
  Test case for KPureAdmin component tests.

  Provides helpers for rendering and asserting on component HTML output.

      use KPureAdmin.ComponentCase

      test "renders a button" do
        html = render_component(&KPureAdmin.Components.Button.button/1, variant: "primary") do
          "Click me"
        end

        assert html =~ "pa-btn"
        assert html =~ "pa-btn--primary"
      end
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      import Phoenix.LiveViewTest, only: [render_component: 2, render_component: 3]

      @doc """
      Asserts that the rendered HTML contains the given CSS class.
      """
      def assert_class(html, class) do
        assert html =~ class, "Expected HTML to contain class '#{class}', but it didn't.\n\nHTML:\n#{html}"
      end

      @doc """
      Refutes that the rendered HTML contains the given CSS class.
      """
      def refute_class(html, class) do
        refute html =~ class, "Expected HTML to NOT contain class '#{class}', but it did.\n\nHTML:\n#{html}"
      end
    end
  end
end
