defmodule KPureAdmin.Components.Typography do
  @moduledoc """
  Typography components for Pure Admin. (Phase 2)
  """
  use Phoenix.Component

  import KPureAdmin.Helpers

  @doc "Renders a heading (h1-h6)."
  attr(:level, :any, default: 2, doc: "Heading level (1-6), accepts integer or string")
  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def heading(assigns) do
    level = if is_binary(assigns.level), do: assigns.level, else: "#{assigns.level}"
    assigns = assign(assigns, :tag, "h#{level}")

    ~H"""
    <.dynamic_tag name={@tag} class={build_classes("pa-heading", [], @class)} {@rest}>
      <%= render_slot(@inner_block) %>
    </.dynamic_tag>
    """
  end

  @doc "Renders a paragraph."
  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def paragraph(assigns) do
    ~H"""
    <p class={build_classes("pa-paragraph", [], @class)} {@rest}>
      <%= render_slot(@inner_block) %>
    </p>
    """
  end

  @doc "Renders a text span."
  attr(:variant, :string,
    default: nil,
    values: [nil, "muted", "small", "primary", "success", "danger", "warning", "info"]
  )

  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def text(assigns) do
    ~H"""
    <span class={build_classes("pa-text", [{"pa-text--#{@variant}", @variant != nil}], @class)} {@rest}>
      <%= render_slot(@inner_block) %>
    </span>
    """
  end

  @doc "Renders a styled link."
  attr(:href, :string, default: "#")
  attr(:variant, :string, default: nil, values: [nil, "primary", "secondary", "muted"])
  attr(:class, :string, default: nil)
  attr(:rest, :global, include: ~w(navigate patch target))
  slot(:inner_block, required: true)

  def pa_link(assigns) do
    ~H"""
    <a
      href={@href}
      class={build_classes("pa-link", [{"pa-link--#{@variant}", @variant != nil}], @class)}
      {@rest}
    >
      <%= render_slot(@inner_block) %>
    </a>
    """
  end
end
