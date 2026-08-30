defmodule PureAdmin.Components.CommandPaletteTest do
  use PureAdmin.ComponentCase, async: true

  alias PureAdmin.Components.CommandPalette

  describe "command_palette/1 size presets (rc15)" do
    test "no size keeps the default footprint (no size modifier)" do
      html = render_component(&CommandPalette.command_palette/1, %{id: "cp"})

      assert_class(html, "pa-command-palette")
      refute html =~ "pa-command-palette--sm"
      refute html =~ "pa-command-palette--lg"
      refute html =~ "pa-command-palette--xl"
    end

    test "size sets the matching preset modifier on the container" do
      for size <- ~w(sm lg xl) do
        html = render_component(&CommandPalette.command_palette/1, %{id: "cp", size: size})
        assert_class(html, "pa-command-palette--#{size}")
      end
    end
  end
end
