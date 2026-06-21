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

  ## Renderer-tuning attrs

  Common per-icon options flow through to the underlying element via
  `@rest`. See the allowlist on the `:rest` attr below — extend by adding
  to the `:include` list if you need an attr that isn't there yet.

      <.icon name="hero-rocket-launch" color="red" size="lg" />
  """
  use Phoenix.Component
  import PureAdmin.Components.Heroicon

  attr :name, :string, required: true,
    doc: "Icon name. `\"hero-X\"` → Heroicons; anything else → FA-style `<i class>`. May be `nil` or empty at runtime — both render nothing."

  attr :class, :string, default: nil,
    doc: "Additional classes (size, color, etc.)."

  attr :color, :string, default: nil,
    doc: "Color value — CSS color or renderer-specific fragment."

  attr :size, :string, default: nil,
    doc: "Size value — typically a CSS class fragment like `size-4`."

  attr :variant, :string, default: nil,
    doc: "Renderer-specific variant (e.g. FA `solid`/`regular`/`light`/`brands`)."

  attr :fill, :string, default: nil, doc: "SVG fill color."
  attr :stroke, :string, default: nil, doc: "SVG stroke color."
  attr :title, :string, default: nil, doc: "Tooltip title."

  attr :aria_label, :string, default: nil,
    doc: "Accessibility label — emits as `aria-label` in HTML."

  def icon(%{name: nil} = assigns), do: ~H""
  def icon(%{name: ""} = assigns), do: ~H""

  def icon(%{name: "hero-" <> rest} = assigns) do
    assigns = assign(assigns, :hero_name, rest)

    ~H"""
    <.heroicon
      name={@hero_name}
      class={@class}
      color={@color}
      size={@size}
      variant={@variant}
      fill={@fill}
      stroke={@stroke}
      title={@title}
      aria_label={@aria_label}
    />
    """
  end

  def icon(%{name: name} = assigns) when is_binary(name) do
    ~H"""
    <i
      class={[@name, @class]}
      color={@color}
      size={@size}
      variant={@variant}
      fill={@fill}
      stroke={@stroke}
      title={@title}
      aria-label={@aria_label}
    ></i>
    """
  end
end
