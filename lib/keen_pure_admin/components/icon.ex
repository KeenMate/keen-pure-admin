defmodule PureAdmin.Components.Icon do
  @moduledoc """
  Smart icon dispatcher — routes a string `name` to the right rendering
  strategy by inspecting its prefix.

  This component exists for the legacy `attr :icon, :string` pattern used by
  many of the library's chrome components (sidebar items, buttons, flash,
  profile nav items). Callers pass a single string and the renderer figures
  out whether it's a class-based icon font (Font Awesome, Bootstrap Icons,
  Lucide-font, etc.) or a Heroicon name.

  For direct usage, prefer the specialized components — they give you fuller
  control over per-set attributes (FA variant, heroicon size, etc.):

      <.faicon name="rocket" variant="solid" />
      <.heroicon name="rocket-launch" class="size-4" />

  ## Dispatch rules

  | Name pattern        | Rendered as                  |
  |---------------------|------------------------------|
  | `"hero-X"`          | `<.heroicon name="X">`       |
  | anything else       | `<i class={@name}>` (FA-style) |
  | `nil` / empty       | renders nothing              |

  ## Examples

      <.icon name="fa-solid fa-rocket" />        # → <i class="fa-solid fa-rocket">
      <.icon name="hero-rocket-launch" />        # → <.heroicon name="rocket-launch">
      <.icon name={nil} />                       # → nothing
  """
  use Phoenix.Component
  import PureAdmin.Components.Heroicon

  attr :name, :string, default: nil,
    doc: "Icon name. `\"hero-X\"` → Heroicons; anything else → FA-style `<i class>`."

  attr :class, :string, default: nil,
    doc: "Additional classes (size, color, etc.)."

  attr :rest, :global

  def icon(%{name: nil} = assigns), do: ~H""
  def icon(%{name: ""} = assigns), do: ~H""

  def icon(%{name: "hero-" <> rest} = assigns) do
    assigns = assign(assigns, :hero_name, rest)

    ~H"""
    <.heroicon name={@hero_name} class={@class} {@rest} />
    """
  end

  def icon(%{name: name} = assigns) when is_binary(name) do
    ~H"""
    <i class={[@name, @class]} {@rest}></i>
    """
  end
end
