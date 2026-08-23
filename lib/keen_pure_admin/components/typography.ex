defmodule PureAdmin.Components.Typography do
  @moduledoc """
  Typography components for Pure Admin. (Phase 2)
  """
  use Phoenix.Component

  import PureAdmin.Helpers

  @doc "Renders a heading (h1-h6)."
  attr(:level, :any,
    default: 2,
    values: [1, 2, 3, 4, 5, 6, "1", "2", "3", "4", "5", "6"],
    doc: "Heading level (1-6)"
  )

  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def heading(assigns) do
    level = if is_binary(assigns.level), do: assigns.level, else: "#{assigns.level}"
    assigns = assign(assigns, :tag, "h#{level}")

    # Core headings are bare semantic tags (`<h1>`..`<h6>`) with NO class — core
    # defines no `pa-heading` (see snippets/typography.html). Emit the tag
    # unclassed; callers add utilities via `class` (e.g. `pa-text--center`).
    ~H"""
    <.dynamic_tag tag_name={@tag} class={@class} {@rest}>
      <%= render_slot(@inner_block) %>
    </.dynamic_tag>
    """
  end

  @doc "Renders a paragraph."
  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def paragraph(assigns) do
    # Core's canonical paragraph is `<p class="pa-text">` (core defines no
    # `pa-paragraph`). Matches keen's own `text/1`, which also uses `pa-text`.
    ~H"""
    <p class={build_classes("pa-text", [], @class)} {@rest}>
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
      href={safe_url(@href)}
      class={build_classes("pa-link", [{"pa-link--#{@variant}", @variant != nil}], @class)}
      {@rest}
    >
      <%= render_slot(@inner_block) %>
    </a>
    """
  end
end
