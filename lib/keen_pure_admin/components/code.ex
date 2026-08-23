defmodule PureAdmin.Components.Code do
  @moduledoc """
  Code display components for Pure Admin.

  Wraps pure-admin's `pa-code` (naked `<pre>`) and `pa-code-block` (headered
  form with filename + body) markup. See `snippets/code.html` in the
  pure-admin core repo for the canonical class structure.
  """
  use Phoenix.Component

  # Language accents that pure-admin actually ships an accent-color border
  # for. Anything outside this set renders with no left-border color.
  @supported_languages ~w(javascript json html css bash sql python)

  # Common aliases — map editor / hex-doc language names to the closest
  # pure-admin accent. HEEx is HTML-with-templating, so it gets the html
  # accent; ts/jsx fold into javascript; sh/zsh into bash; etc.
  @language_aliases %{
    "js" => "javascript",
    "ts" => "javascript",
    "typescript" => "javascript",
    "jsx" => "javascript",
    "tsx" => "javascript",
    "heex" => "html",
    "eex" => "html",
    "xml" => "html",
    "svg" => "html",
    "scss" => "css",
    "sass" => "css",
    "less" => "css",
    "sh" => "bash",
    "shell" => "bash",
    "zsh" => "bash",
    "py" => "python"
  }

  @doc "Renders inline code."
  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def code(assigns) do
    ~H"""
    <code class={@class} {@rest}>{render_slot(@inner_block)}</code>
    """
  end

  @doc """
  Renders a code block.

  Two layouts depending on whether `filename` is set:

  - Without filename: emits a bare `<pre class="pa-code …">` — matches
    pure-admin's basic snippet.
  - With filename: emits the full `<div class="pa-code-block">` →
    `__header` (with `__title`) → `__body` > `<pre class="pa-code">`
    structure.

  ## Language accents

  Pure-admin ships colored left-border accents for a fixed set of languages:
  `javascript`, `json`, `html`, `css`, `bash`, `sql`, `python`. Common aliases
  map to the closest supported variant (`heex`/`eex` → `html`, `ts`/`jsx` →
  `javascript`, `sh`/`zsh` → `bash`, `py` → `python`). Languages without a
  defined accent (e.g. `elixir`, `ruby`) render with no border color.

  ## Examples

      <.code_block language="elixir">
        def hello, do: "world"
      </.code_block>

      <.code_block language="javascript" filename="app.js">
        console.log("hello")
      </.code_block>

      <.code_block language="bash" is_compact>
        $ mix deps.get
      </.code_block>
  """
  attr(:language, :string,
    default: nil,
    doc:
      "Language hint. Pure-admin ships accents for: javascript, json, html, css, bash, sql, python. Aliases like heex/eex/ts/sh map to the closest supported variant; unsupported languages render with no accent."
  )

  attr(:filename, :string,
    default: nil,
    doc: "Filename shown in the header. Triggers the headered `.pa-code-block` form."
  )

  attr(:copy_text, :string,
    default: nil,
    doc:
      "When set, renders a canonical `📋 Copy` button in the `__header` (matching `snippets/code.html`), wired to keen's global `[data-pa-copy]` clipboard delegator to copy this exact string. Also triggers the headered `.pa-code-block` form (so copy works without a filename). A LiveView wrapper can't read the slot's rendered text server-side, so the copy source is passed explicitly here."
  )

  attr(:is_compact, :boolean, default: false, doc: "Smaller padding and font size.")
  attr(:is_numbered, :boolean, default: false, doc: "Line-number gutter on the inline-start side.")
  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def code_block(assigns) do
    assigns = assign(assigns, :resolved_language, resolve_language(assigns.language))

    ~H"""
    <div :if={@filename || @copy_text} class={["pa-code-block", @class]} {@rest}>
      <div class="pa-code-block__header">
        <span :if={@filename} class="pa-code-block__title">{@filename}</span>
        <button
          :if={@copy_text}
          type="button"
          class="pa-btn pa-btn--xs pa-btn--secondary"
          data-pa-copy
          data-copy-value={@copy_text}
        >
          <span class="pa-btn__icon"><i class="fa-solid fa-copy" aria-hidden="true"></i></span>
          Copy
        </button>
      </div>
      <div class="pa-code-block__body">
        <pre class={pre_classes(@resolved_language, @is_compact, @is_numbered, nil)}>{render_slot(@inner_block)}</pre>
      </div>
    </div>
    <pre :if={!(@filename || @copy_text)} class={pre_classes(@resolved_language, @is_compact, @is_numbered, @class)} {@rest}>{render_slot(@inner_block)}</pre>
    """
  end

  defp resolve_language(nil), do: nil

  defp resolve_language(lang) when is_binary(lang) do
    normalized = String.downcase(lang)

    cond do
      normalized in @supported_languages -> normalized
      Map.has_key?(@language_aliases, normalized) -> @language_aliases[normalized]
      true -> nil
    end
  end

  defp pre_classes(lang, compact, numbered, extra) do
    [
      "pa-code",
      lang && "pa-code--#{lang}",
      compact && "pa-code--compact",
      numbered && "pa-code--numbered",
      extra
    ]
  end
end
