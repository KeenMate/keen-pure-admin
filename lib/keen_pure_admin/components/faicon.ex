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

  Pass `name` without the `fa-` prefix. The component prepends `fa-` and the
  variant prefix (`fa-solid`, `fa-regular`, `fa-light`, `fa-brands`).
  """
  use Phoenix.Component

  attr :name, :string, required: true,
    doc: "FA icon name without the `fa-` prefix (e.g. \"rocket\")."

  attr :variant, :string, default: "solid", values: ~w(solid regular light brands),
    doc: "FA variant — controls which font face is used."

  attr :class, :string, default: nil,
    doc: "Additional classes for size, color, etc."

  attr :color, :string, default: nil, doc: "Color value (passes through to the `<i>` element)."
  attr :size, :string, default: nil, doc: "Size value (passes through to the `<i>` element)."
  attr :fill, :string, default: nil, doc: "Pass-through (irrelevant to FA but accepted for API symmetry)."
  attr :stroke, :string, default: nil, doc: "Pass-through (irrelevant to FA but accepted for API symmetry)."
  attr :title, :string, default: nil, doc: "Tooltip title."

  attr :aria_label, :string, default: nil,
    doc: "Accessibility label — emits as `aria-label` in HTML."

  def faicon(assigns) do
    ~H"""
    <i
      class={["fa-#{@variant}", "fa-#{@name}", @class]}
      color={@color}
      size={@size}
      fill={@fill}
      stroke={@stroke}
      title={@title}
      aria-label={@aria_label}
    ></i>
    """
  end
end
