defmodule PureAdmin.Components.KpiDetail do
  @moduledoc """
  Shared types + helpers for KPI hover detail popovers.

  Mirrors `kpi-detail.ts` from `@keenmate/svelte-pure-admin`. Used by every
  KPI tile / row module (`kpi_tile/1`, `kpi_strip_row/1`, `kpi_sparkline_row/1`,
  `kpi_bento_tile/1`, `kpi_hero_main/1`, `kpi_hero_side/1`, `kpi_gauge/1`,
  `kpi_editorial_tile/1`) to build the canonical popover body from typed
  props — Current / Previous / Δ absolute / Δ percent / Target — without
  forcing consumers to hand-author `<dl>` markup.

  The detail popover itself is rendered by `PureAdmin.Components.Kpi.kpi_detail/1`.
  This module supplies the row data + sentiment colour mapping.
  """

  @typedoc """
  Sentiment class for a popover `<dd>`. Maps to the matching `.pos` / `.neg` /
  `.warn` rule inside `.pa-kpi-detail` (upstream `_kpi-base.scss`).
  """
  @type sentiment :: :pos | :neg | :warn | nil

  @typedoc """
  A single popover row: `dt`/`dd` pair with optional sentiment colour on the
  `<dd>`.
  """
  @type row :: %{
          required(:label_text) => String.t(),
          required(:value_text) => String.t(),
          optional(:sentiment) => sentiment()
        }

  @typedoc """
  Delta / sentiment modifier names used across KPI components. Covers every
  variant scale upstream emits: strip / editorial (`up-strong` / `down-strong`),
  sparkline / terminal (`very-positive` / `very-negative`), gauge (`warning`).
  """
  @type delta_variant ::
          String.t()

  @doc """
  Map a delta variant modifier name onto the popover sentiment class.

  Returns `nil` when the variant has no sentiment mapping (e.g. `"neutral"`).

  ## Examples

      iex> KpiDetail.delta_to_sentiment("positive")
      :pos

      iex> KpiDetail.delta_to_sentiment("very_negative")
      :neg

      iex> KpiDetail.delta_to_sentiment("warning")
      :warn

      iex> KpiDetail.delta_to_sentiment("neutral")
      nil
  """
  @spec delta_to_sentiment(delta_variant() | nil) :: sentiment()
  def delta_to_sentiment(nil), do: nil
  def delta_to_sentiment(v) when v in ["positive", "up_strong", "up-strong", "very_positive", "very-positive"], do: :pos

  def delta_to_sentiment(v) when v in ["negative", "down_strong", "down-strong", "very_negative", "very-negative"],
    do: :neg

  def delta_to_sentiment("warning"), do: :warn
  def delta_to_sentiment(_), do: nil

  @doc """
  Build the canonical detail-popover rows from a tile / row's typed props.

  Row order is Current → Previous → Δ absolute → Δ percent → Target. Each
  row is skipped when its source field is `nil`.

  Accepts a keyword list (or map) with optional fields:

    * `:prefix_text` — currency / scale prefix shown before the Current value
    * `:value_text` — Current numeric value
    * `:unit_text` — unit suffix shown after the Current value
    * `:previous_value_text` — bare previous value (e.g. `"84.2%"`)
    * `:delta_absolute_text` — absolute delta (e.g. `"+4.4pp"`)
    * `:delta_absolute_sentiment` — sentiment override for the Δ absolute row
    * `:delta_text` — Δ percent (e.g. `"+5.2%"`)
    * `:delta_sentiment` — sentiment for the Δ percent row
    * `:target_text` — target value (e.g. `"90.0%"`)

  ## Examples

      iex> KpiDetail.build_auto_rows(
      ...>   value_text: "88.6",
      ...>   unit_text: "%",
      ...>   previous_value_text: "84.2%",
      ...>   delta_text: "+5.2%",
      ...>   delta_sentiment: :pos,
      ...>   target_text: "90.0%"
      ...> )
      [
        %{label_text: "Current", value_text: "88.6%"},
        %{label_text: "Previous", value_text: "84.2%"},
        %{label_text: "Δ percent", value_text: "+5.2%", sentiment: :pos},
        %{label_text: "Target", value_text: "90.0%"}
      ]
  """
  @spec build_auto_rows(keyword() | map()) :: [row()]
  def build_auto_rows(opts) when is_list(opts), do: build_auto_rows(Map.new(opts))

  def build_auto_rows(opts) when is_map(opts) do
    []
    |> maybe_current(opts)
    |> maybe_previous(opts)
    |> maybe_delta_absolute(opts)
    |> maybe_delta_percent(opts)
    |> maybe_target(opts)
    |> Enum.reverse()
  end

  defp maybe_current(rows, opts) do
    value = Map.get(opts, :value_text)
    prefix = Map.get(opts, :prefix_text)
    unit = Map.get(opts, :unit_text)

    if value != nil or prefix != nil or unit != nil do
      [%{label_text: "Current", value_text: "#{prefix}#{value}#{unit}"} | rows]
    else
      rows
    end
  end

  defp maybe_previous(rows, %{previous_value_text: text}) when is_binary(text),
    do: [%{label_text: "Previous", value_text: text} | rows]

  defp maybe_previous(rows, _), do: rows

  defp maybe_delta_absolute(rows, %{delta_absolute_text: text} = opts) when is_binary(text) do
    sentiment = Map.get(opts, :delta_absolute_sentiment) || Map.get(opts, :delta_sentiment)
    [%{label_text: "Δ absolute", value_text: text, sentiment: sentiment} | rows]
  end

  defp maybe_delta_absolute(rows, _), do: rows

  defp maybe_delta_percent(rows, %{delta_text: text} = opts) when is_binary(text) do
    [%{label_text: "Δ percent", value_text: text, sentiment: Map.get(opts, :delta_sentiment)} | rows]
  end

  defp maybe_delta_percent(rows, _), do: rows

  defp maybe_target(rows, %{target_text: text}) when is_binary(text),
    do: [%{label_text: "Target", value_text: text} | rows]

  defp maybe_target(rows, _), do: rows

  @doc """
  Convert an underscored sentiment / variant atom or string to the kebab-case
  CSS modifier name upstream emits (`very_positive` → `very-positive`).
  """
  @spec dasherize(String.t() | atom() | nil) :: String.t() | nil
  def dasherize(nil), do: nil
  def dasherize(value) when is_atom(value), do: dasherize(Atom.to_string(value))
  def dasherize(value) when is_binary(value), do: String.replace(value, "_", "-")

  @doc """
  CSS class for a `<dd>` cell given a sentiment.
  """
  @spec sentiment_class(sentiment()) :: String.t() | nil
  def sentiment_class(:pos), do: "pos"
  def sentiment_class(:neg), do: "neg"
  def sentiment_class(:warn), do: "warn"
  def sentiment_class(_), do: nil
end
