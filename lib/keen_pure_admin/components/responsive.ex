defmodule PureAdmin.Components.Responsive do
  @moduledoc """
  Container-breakpoint helpers — a declarative wrapper over the Container
  Breakpoint engine (the `PureAdminContainerBreakpoint` hook /
  `container-breakpoint.js`).

  `breakpoint_container/1` measures **its own** inline width and names a mode from
  your thresholds; `breaker/1` wraps any block and declares which modes it appears
  in. The engine reflects the current mode onto the container as `[data-mode]` and
  toggles the shared `.d-none` on out-of-mode breakers — so a component adapts to
  the space it is *given*, not the viewport.

      <.breakpoint_container id="card" steps={%{compact: 0, comfy: 34, wide: 64}} initial="comfy" class="pa-card">
        <div class="pa-card__body">
          <p>Always visible.</p>
          <.breaker show="comfy wide"><p>Hidden only when cramped.</p></.breaker>
          <.breaker show="wide"><p>Only when there's room.</p></.breaker>
        </div>
      </.breakpoint_container>

  Call sites never write `data-pc-show` / `.d-none` by hand — `breaker/1` emits the
  attribute, and the container emits a scoped pre-paint `<style>` (keyed on
  `[data-mode]`) so out-of-mode blocks don't flash before the JS engine runs.

  Thresholds are in `unit` (rem by default; the root font is 10px, so `34` = 340px,
  `64` = 640px). Set `initial` to the mode a first paint should assume. For layout
  that changes with size (a two-up row, a grid) key CSS off the reflected
  `[data-mode]` rather than a viewport media query — that's the whole point.
  """
  use Phoenix.Component

  @doc """
  The measuring container. Wraps the `PureAdminContainerBreakpoint` hook and emits
  `data-pc-breakpoints` (+ optional `-unit` / `-initial`) plus a scoped FOUC guard.

  ## Attributes

    * `steps` — map of `mode => min-threshold`, e.g. `%{compact: 0, comfy: 34, wide: 64}`.
    * `initial` — the mode a first paint assumes before JS measures (recommended;
      makes the pre-paint guard active so nothing flashes).
    * `unit` — `"rem"` (default) or `"px"`.
  """
  attr(:id, :string, required: true, doc: "Stable id — the hook needs one; also scopes the pre-paint style.")
  attr(:steps, :map, required: true, doc: "mode => min-width threshold map")
  attr(:initial, :string, default: nil, doc: "Mode assumed before the first measure (recommended, FOUC-safe).")
  attr(:unit, :string, default: "rem", values: ["rem", "px"])
  attr(:tag, :string, default: "div")
  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def breakpoint_container(assigns) do
    assigns =
      assigns
      |> assign(:breakpoints_json, encode_steps(assigns.steps))
      |> assign(:fouc_style, fouc_style(assigns.id, assigns.steps))

    ~H"""
    <.dynamic_tag
      tag_name={@tag}
      id={@id}
      class={@class}
      phx-hook="PureAdminContainerBreakpoint"
      data-pc-breakpoints={@breakpoints_json}
      data-pc-breakpoint-initial={@initial}
      data-pc-breakpoint-unit={(@unit != "rem" && @unit) || nil}
      data-mode={@initial}
      {@rest}
    >
      {@fouc_style}
      <%= render_slot(@inner_block) %>
    </.dynamic_tag>
    """
  end

  @doc """
  A block that only appears in the listed modes. Emits `data-pc-show`; the engine
  hides it (adds `.d-none`) whenever the container isn't in one of those modes.

      <.breaker show="comfy wide">…</.breaker>
      <.breaker show="wide" tag="section" class="mt-2">…</.breaker>
  """
  attr(:show, :string, required: true, doc: ~s(Space-separated modes this block appears in, e.g. "comfy wide".))
  attr(:tag, :string, default: "div")
  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def breaker(assigns) do
    ~H"""
    <.dynamic_tag tag_name={@tag} data-pc-show={@show} class={@class} {@rest}>
      <%= render_slot(@inner_block) %>
    </.dynamic_tag>
    """
  end

  # Build the data-pc-breakpoints JSON (map keys may be atoms or strings).
  defp encode_steps(steps) do
    Jason.encode!(Map.new(steps, fn {k, v} -> {to_string(k), v} end))
  end

  # Pre-paint FOUC guard: for each mode, hide every breaker whose `data-pc-show`
  # list does NOT contain that mode WHILE the container is in that mode. Scoped to
  # the container id and keyed on `[data-mode]`, so it is correct both before JS
  # (the container renders `data-mode=initial`) and after (the engine updates
  # `[data-mode]` on resize). Harmless alongside the engine's own `.d-none`
  # toggling — both resolve to `display:none` for the same elements.
  defp fouc_style(id, steps) do
    rules =
      steps
      |> Enum.map_join("", fn {mode, _} ->
        m = to_string(mode)
        ~s|##{id}[data-mode="#{m}"] [data-pc-show]:not([data-pc-show~="#{m}"]){display:none!important}|
      end)

    Phoenix.HTML.raw("<style>#{rules}</style>")
  end
end
