defmodule DemoWeb.Icons do
  @moduledoc """
  Demo icon callback wired into `<.icon>` via `:keen_pure_admin, :icon_callback`.

  Pattern-matches on `name` to route through different rendering strategies:

    * `"lucide-X"` → `<img>` pointing at `/assets/icons/lucide/X.svg`
    * anything else → FA-style `<i class={name}>` (the library's default fallback)

  The Lucide SVGs ship `stroke="currentColor"` so they pick up the parent
  text color when embedded inline; via `<img>` that's lost — only sizing
  and the title/alt attrs come through. For full recoloring you'd inline
  the SVG (read at compile time or at request time).
  """
  use Phoenix.Component

  def render(%{name: "lucide-" <> file} = assigns) do
    assigns = assign(assigns, :file, file)

    ~H"""
    <img
      src={"/assets/icons/lucide/#{@file}.svg"}
      style={"width: #{@size_value}; height: #{@size_value};"}
      class={@class}
      alt={@aria_label || @file}
      title={@title}
    />
    """
  end

  def render(assigns) do
    ~H"""
    <i
      class={[@name, @class]}
      style={"font-size: #{@size_value}"}
      color={@color}
      title={@title}
      aria-label={@aria_label}
    ></i>
    """
  end
end
