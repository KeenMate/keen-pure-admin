defmodule PureAdmin.Components.Faicon do
  @moduledoc """
  Font Awesome icon wrapper.

  Renders an `<i>` element with Font Awesome classes. Requires the Font Awesome
  stylesheet to be loaded (CDN or local) — this component contributes no styling
  of its own.

  ## Usage

      <.faicon name="rocket" />
      <.faicon name="user-plus" variant="solid" class="text-color-2" />
      <.faicon name="github" variant="brands" />
      <.faicon name="rocket" size="2rem" />

  Pass `name` without the `fa-` prefix. The component prepends `fa-` and the
  variant prefix (`fa-solid`, `fa-regular`, `fa-light`, `fa-brands`).

  ## Sizing

  The `size` attr is a CSS length (e.g. `"1.5rem"`, `"24px"`) applied as
  inline `font-size`. When omitted it falls back to
  `PureAdmin.Config.icon_size/0` (default `"1.25rem"`).
  """
  use Phoenix.Component

  attr(:name, :string,
    required: true,
    doc: "FA icon name without the `fa-` prefix (e.g. \"rocket\")."
  )

  attr(:variant, :string,
    default: "solid",
    values: ~w(solid regular light brands),
    doc: "FA variant — controls which font face is used."
  )

  attr(:class, :string,
    default: nil,
    doc: "Additional classes for color, hover state, etc. For sizing prefer the `size` attr."
  )

  attr(:color, :string, default: nil, doc: "Color value (passes through to the `<i>` element).")

  attr(:size, :string,
    default: nil,
    doc: "CSS length for `font-size`. Defaults to `PureAdmin.Config.icon_size/0`."
  )

  attr(:fill, :string, default: nil, doc: "Pass-through (irrelevant to FA but accepted for API symmetry).")
  attr(:stroke, :string, default: nil, doc: "Pass-through (irrelevant to FA but accepted for API symmetry).")
  attr(:title, :string, default: nil, doc: "Tooltip title.")

  attr(:aria_label, :string,
    default: nil,
    doc: "Accessibility label — emits as `aria-label` in HTML."
  )

  def faicon(assigns) do
    assigns = assign(assigns, :size_value, assigns[:size] || PureAdmin.Config.icon_size())

    ~H"""
    <i
      class={["fa-#{@variant}", "fa-#{@name}", @class]}
      style={"font-size: #{@size_value}"}
      color={@color}
      title={@title}
      aria-label={@aria_label}
    ></i>
    """
  end
end
