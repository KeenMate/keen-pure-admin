defmodule PureAdmin.Components.Kpi do
  @moduledoc """
  KPI showcase components for Pure Admin.

  Pure Admin v2.6.0 introduced a family of KPI indicator designs (Terminal
  grid, Sparkline list, Comparison gauges, Hero + supporting, Bento, Numeric
  strip, Editorial minimal). The framework ships them as page-level
  showcases sharing a common substrate of tile chrome, sentiment colours,
  a cursor-anchored detail popover, and sparkline tokens.

  This module provides the **substrate** — the parts every showcase reuses:

  - `kpi_tile/1` — base tile with id, label, value, prev row, status pill,
    chart slot, and detail popover slot.
  - `kpi_tile_detail/1` — popover content scaffold (title + label/value
    rows).

  Showcase-specific wrappers (terminal grid chrome, hero+supporting layout,
  etc.) are built on top of these primitives in dedicated components.

  ## Design principles

  Two constraints shape the API:

  1. **Pluggable chart rendering.** The `:chart` slot accepts any markup —
     inline SVG, a `<div phx-hook="...">` that a JS chart library mounts
     into, a Contex SVG, an ApexCharts container, etc. The framework does
     not pick a chart library; the consumer plugs in whatever they
     already use. A convenience `kpi_sparkline/1` is provided separately
     for the common SVG-polyline-with-end-dot pattern.
  2. **Labels are fully customisable.** Every textual element (id, label,
     status pill content, value, unit, prev row text, delta text, detail
     title and rows) is an attribute or slot. No English strings are
     hardcoded in the component. Consumers control all i18n at the call
     site.

  ## Sentiment vs. status

  Sentiment is *direction of change* (`very_positive | positive | neutral |
  negative | very_negative`) — applied to the value, delta, and sparkline
  direction. Status pill is *action urgency* (`warn | good | neutral` or
  any user-defined variant) — a separate axis. A tile can be
  `--very-negative` numerically (big drop) and `--good` pill-wise if the
  drop is expected, and vice versa.

  ## Detail popover hook

  When the `:detail` slot has content **and** an `id` is set on the tile,
  the component emits `phx-hook="PureAdminKpiTile"`. The hook mounts a
  cursor-anchored Floating UI popover that moves the detail element to
  `<body>` on init (to escape ancestor `overflow: hidden`), then updates
  position on `mousemove`. Without the hook the detail element renders
  inline and is invisible (`visibility: hidden`).

  Floating UI must be loaded globally as `window.FloatingUIDOM` (matches
  the existing tooltip/popover hooks).
  """
  use Phoenix.Component

  import PureAdmin.Helpers

  @sentiments [nil, "very_positive", "positive", "neutral", "negative", "very_negative"]
  @directions [nil, "up_strong", "up", "flat", "down", "down_strong"]

  # -- kpi_tile/1 --

  @doc """
  Renders a single KPI tile.

  ## Examples

      <.kpi_tile
        id_text="KPI.01 · 30d"
        label_text="Completion Rate"
        value_text="88.6"
        unit_text="%"
        spark_direction="up"
        prev_text="prev 84.2%"
        delta_text="▲ 5.2%"
        delta_sentiment="positive"
      >
        <:status variant="warn">WARN</:status>
        <:chart>
          <.kpi_sparkline points="0,18 12,16 24,17 36,12 48,15 60,9 72,11 84,7 96,5" dot_at={{96, 5}} />
        </:chart>
      </.kpi_tile>

      <.kpi_tile
        id="completion-rate-30d"
        id_text="KPI.01 · 30d"
        label_text="Completion Rate"
        value_text="88.6"
        unit_text="%"
        is_standalone
      >
        <:chart><!-- user-provided D3 / Apex / etc. --></:chart>
        <:detail>
          <.kpi_tile_detail title_text="Completion Rate · 30D">
            <:row label="Current" value="88.6%" />
            <:row label="Previous" value="84.2%" />
            <:row label="Δ absolute" value="+4.4pp" sentiment="positive" />
            <:row label="Target" value="90.0%" />
          </.kpi_tile_detail>
        </:detail>
      </.kpi_tile>

  ## Sentiment vs. spark direction

  - `value_sentiment` colours the number itself (rare — usually the focal
    number reads as plain text and the delta carries the sentiment).
  - `delta_sentiment` colours the delta text in the prev row.
  - `spark_direction` colours the entire sparkline via `currentColor`. Named
    by *sentiment of the change*, not by line shape — error rate dropping
    is `--up` (good), server temp climbing is `--down` (bad).
  """
  attr(:id, :string, default: nil, doc: "Required when `:detail` slot is used (hook needs an id)")
  attr(:id_text, :string, default: nil, doc: "Identifier shown in tile head (e.g. \"KPI.01 · 30d\")")
  attr(:label_text, :string, default: nil, doc: "Tile label (e.g. \"Completion Rate\")")
  attr(:value_text, :string, default: nil, doc: "Focal numeric value")
  attr(:unit_text, :string, default: nil, doc: "Unit suffix (\"%\", \"°C\", \"K\") — rendered after `value_text`")
  attr(:unit_prefix_text, :string, default: nil, doc: "Unit prefix (\"$\", \"¥\") — rendered before `value_text`")

  attr(:value_sentiment, :string,
    default: nil,
    values: @sentiments,
    doc: "Sentiment colour applied to the value `__num`"
  )

  attr(:spark_direction, :string,
    default: nil,
    values: @directions,
    doc: "Sentiment colour applied to the sparkline (via `currentColor`) — name by sentiment, not line shape"
  )

  attr(:prev_text, :string,
    default: nil,
    doc: "Left half of the prev row (e.g. \"prev 84.2%\") — full string, no prefix prepended"
  )

  attr(:delta_text, :string,
    default: nil,
    doc: "Right half of the prev row (e.g. \"▲ 5.2%\") — user provides the arrow"
  )

  attr(:delta_sentiment, :string,
    default: nil,
    values: @sentiments,
    doc: "Sentiment colour for the delta in the prev row"
  )

  attr(:is_standalone, :boolean,
    default: false,
    doc: "Add `--standalone` modifier when the tile lives directly inside a `.pa-col-*` outside a `.kpi-terminal__grid`"
  )

  attr(:class, :string, default: nil)
  attr(:rest, :global)

  slot :status, doc: "Status pill (e.g. WARN/GOOD/NEUTRAL). Slot content is the pill text — user-defined." do
    attr(:variant, :string,
      doc:
        "Pill variant — built-ins: \"warn\" (filled orange), \"good\" (text-only), \"neutral\" (filled grey). Any other string emits `kpi-tile__status--{variant}` for custom CSS."
    )
  end

  slot(:id_slot,
    doc: "Rich id content (alternative to `id_text`). Renders inside `.kpi-tile__id`."
  )

  slot(:label,
    doc: "Rich label content (alternative to `label_text`). Renders inside `.kpi-tile__label`."
  )

  slot(:value,
    doc:
      "Rich value content (alternative to `value_text` + `unit_text`). Renders inside the single `.kpi-tile__value` span. Use for custom number+symbol arrangements."
  )

  slot(:chart,
    doc:
      "Chart/sparkline area. Place any renderer here — inline SVG, a hook-mounted div, Contex SVG, ApexCharts container, etc. The framework does not pick a chart library."
  )

  slot(:detail,
    doc:
      "Hover detail popover content. Use `kpi_tile_detail/1` for the standard scaffold, or provide custom markup. Requires `id` on the tile and Floating UI loaded globally."
  )

  def kpi_tile(assigns) do
    assigns =
      assigns
      |> assign(:has_detail, assigns.detail != [])
      |> assign(:has_hook?, assigns.detail != [] and assigns.id != nil)

    ~H"""
    <div
      id={@id}
      class={tile_classes(assigns)}
      phx-hook={if @has_hook?, do: "PureAdminKpiTile"}
      {@rest}
    >
      <div :if={@id_text || @id_slot != [] || @status != []} class="kpi-tile__head">
        <span :if={@id_text || @id_slot != []} class="kpi-tile__id">
          <%= if @id_slot != [] do %>
            <%= render_slot(@id_slot) %>
          <% else %>
            <%= @id_text %>
          <% end %>
        </span>
        <span :for={s <- @status} class={status_classes(s)}>
          <%= render_slot(s) %>
        </span>
      </div>

      <div :if={@label_text || @label != []} class="kpi-tile__label">
        <%= if @label != [] do %>
          <%= render_slot(@label) %>
        <% else %>
          <%= @label_text %>
        <% end %>
      </div>

      <div :if={@value != [] || @value_text} class="kpi-tile__values">
        <span class={value_classes(@value_sentiment)}>
          <%= if @value != [] do %>
            <%= render_slot(@value) %>
          <% else %>
            <span :if={@unit_prefix_text} class="kpi-tile__unit"><%= @unit_prefix_text %></span>
            <span class="kpi-tile__num"><%= @value_text %></span>
            <span :if={@unit_text} class="kpi-tile__unit"><%= @unit_text %></span>
          <% end %>
        </span>
      </div>

      <div :if={@prev_text || @delta_text} class="kpi-tile__prev">
        <span><%= @prev_text %></span>
        <span :if={@delta_text} class={delta_classes(@delta_sentiment)}>
          <%= @delta_text %>
        </span>
      </div>

      <%= for c <- @chart do %>
        <%= render_slot(c) %>
      <% end %>

      <%= for d <- @detail do %>
        <%= render_slot(d) %>
      <% end %>
    </div>
    """
  end

  defp tile_classes(assigns) do
    dir = if assigns.spark_direction, do: dasherize(assigns.spark_direction)

    build_classes(
      "kpi-tile",
      [
        {"kpi-tile--#{dir}", dir != nil},
        {"kpi-tile--standalone", assigns.is_standalone}
      ],
      assigns.class
    )
  end

  defp status_classes(slot) do
    variant = Map.get(slot, :variant)

    build_classes("kpi-tile__status", [
      {"kpi-tile__status--#{variant}", variant != nil}
    ])
  end

  defp value_classes(sentiment) do
    sent = if sentiment, do: dasherize(sentiment)

    build_classes("kpi-tile__value", [
      {"kpi-tile__value--#{sent}", sent != nil}
    ])
  end

  defp delta_classes(sentiment) do
    sent = if sentiment, do: dasherize(sentiment)

    build_classes("kpi-tile__delta", [
      {"kpi-tile__delta--#{sent}", sent != nil}
    ])
  end

  # `very_positive` (attr value, snake_case) → `very-positive` (CSS modifier, kebab-case).
  defp dasherize(s) when is_binary(s), do: String.replace(s, "_", "-")

  # -- kpi_tile_detail/1 --

  @doc """
  Renders the standard detail-popover scaffold used by KPI tiles.

  Use as the `:detail` slot content of `kpi_tile/1`. The `kpi-tile__detail`
  root is plain markup; the parent tile's hook moves it to `<body>` and
  positions it under the cursor.

  ## Examples

      <:detail>
        <.kpi_tile_detail title_text="Completion Rate · 30D">
          <:row label="Current" value="88.6%" />
          <:row label="Previous" value="84.2%" />
          <:row label="Δ absolute" value="+4.4pp" sentiment="positive" />
          <:row label="Δ percent" value="+5.2%" sentiment="positive" />
          <:row label="Target" value="90.0%" />
        </.kpi_tile_detail>
      </:detail>

  Use the `:title` slot for rich title content, or omit both `title_text`
  and `:title` to render no header.

  ## Row sentiment

  Each `:row` accepts an optional `sentiment` attr (`positive | negative |
  neutral`). It maps to the `.pos` / `.neg` classes inside
  `.kpi-tile__detail` — three values rather than the five-step scale
  because the popover's job is summary, not nuance.
  """
  attr(:title_text, :string, default: nil)
  attr(:class, :string, default: nil)
  attr(:rest, :global)

  slot(:title, doc: "Rich title content (alternative to `title_text`)")

  slot :row, doc: "Label/value pair (rendered as `<dt>` + `<dd>`)" do
    attr(:label, :string, required: true)
    attr(:value, :string, required: true)
    attr(:sentiment, :string, values: ["positive", "negative", "neutral"])
  end

  def kpi_tile_detail(assigns) do
    ~H"""
    <div class={build_classes("kpi-tile__detail", [], @class)} role="tooltip" {@rest}>
      <div :if={@title_text || @title != []} class="kpi-tile__detail-title">
        <%= if @title != [] do %>
          <%= render_slot(@title) %>
        <% else %>
          <%= @title_text %>
        <% end %>
      </div>
      <dl :if={@row != []}>
        <%= for r <- @row do %>
          <dt><%= r.label %></dt>
          <dd class={row_value_class(Map.get(r, :sentiment))}><%= r.value %></dd>
        <% end %>
      </dl>
    </div>
    """
  end

  defp row_value_class(nil), do: nil
  defp row_value_class("positive"), do: "pos"
  defp row_value_class("negative"), do: "neg"
  defp row_value_class("neutral"), do: nil

  # -- kpi_sparkline/1 (convenience) --

  @doc """
  Convenience SVG sparkline matching the framework's default look.

  This is **one option** for the `:chart` slot of `kpi_tile/1` — consumers
  who already have a chart library (D3, ApexCharts, Vega-Lite, Contex,
  custom inline SVG, a LiveView hook target) should put that in the slot
  instead. This convenience exists so the simple cases don't need to wire
  up a charting library.

  Renders a `<polyline>` inside an SVG with `preserveAspectRatio="none"`
  so the line stretches to fill the container width. The framework's
  `--pa-chart-trendline-height` and `--pa-chart-trendline-stroke` tokens
  control height and stroke width.

  An optional trailing dot is rendered as an HTML `<span>` (not an SVG
  `<circle>`) so it stays circular under non-uniform SVG scaling. When
  `dot_at` is set, attach `phx-hook="PureAdminKpiSparkDot"` and pass an
  `id` (the hook converts the SVG circle to a CSS-pixel-sized span on
  mount). Without LiveView, the convenience emits a static `<circle>`
  which will appear oval if the SVG is wider than its viewBox; in that
  case write your own SVG.

  ## Examples

      <.kpi_sparkline points="0,18 12,16 24,17 36,12 48,15" />

      <.kpi_sparkline
        id="spark-1"
        points="0,18 12,16 24,17 36,12 48,15 60,9 72,11 84,7 96,5"
        dot_at={{96, 5}}
      />
  """
  attr(:id, :string, default: nil)
  attr(:points, :string, required: true, doc: "SVG polyline points string (e.g. \"0,18 12,16 24,17\")")
  attr(:view_box, :string, default: "0 0 100 24", doc: "SVG viewBox")
  attr(:dot_at, :any, default: nil, doc: "`{cx, cy}` tuple for the trailing dot; the hook converts to a CSS span")
  attr(:class, :string, default: nil)
  attr(:rest, :global)

  def kpi_sparkline(assigns) do
    {cx, cy} =
      case assigns.dot_at do
        {x, y} -> {x, y}
        _ -> {nil, nil}
      end

    assigns = assigns |> assign(:cx, cx) |> assign(:cy, cy)

    ~H"""
    <svg
      id={@id}
      class={build_classes("kpi-tile__spark", [], @class)}
      viewBox={@view_box}
      preserveAspectRatio="none"
      phx-hook={if @cx, do: "PureAdminKpiSparkDot"}
      {@rest}
    >
      <polyline points={@points} />
      <circle :if={@cx} cx={@cx} cy={@cy} r="2" />
    </svg>
    """
  end
end
