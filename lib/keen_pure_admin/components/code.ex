defmodule KPureAdmin.Components.Code do
  @moduledoc """
  Code display components for Pure Admin. (Phase 2)
  """
  use Phoenix.Component

  import KPureAdmin.Helpers

  @doc "Renders inline code."
  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def code(assigns) do
    ~H"""
    <code class={@class} {@rest}><%= render_slot(@inner_block) %></code>
    """
  end

  @doc """
  Renders a code block with optional language and filename.

  ## Examples

      <.code_block language="elixir">
        def hello, do: "world"
      </.code_block>

      <.code_block language="javascript" filename="app.js">
        console.log("hello")
      </.code_block>
  """
  attr(:language, :string, default: nil, doc: "Programming language for syntax highlighting")
  attr(:filename, :string, default: nil, doc: "Optional filename shown in header")
  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def code_block(assigns) do
    ~H"""
    <div class={build_classes("pa-code-block-wrapper", [], @class)}>
      <div :if={@filename || @language} class="pa-code-block__header">
        <span :if={@filename} class="pa-code-block__filename"><%= @filename %></span>
        <span :if={@language && !@filename} class="pa-code-block__language"><%= @language %></span>
      </div>
      <pre class={build_classes("pa-code-block", [{"pa-code-block--#{@language}", @language != nil}])} {@rest}><code><%= render_slot(@inner_block) %></code></pre>
    </div>
    """
  end
end
