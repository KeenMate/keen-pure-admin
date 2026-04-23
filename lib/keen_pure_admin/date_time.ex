defmodule PureAdmin.DateTime do
  @moduledoc """
  Date, time, and relative-time formatting with translation support.

  Works with `Date`, `Time`, `DateTime`, and `NaiveDateTime`. Month names,
  weekday names, and relative phrases all flow through
  `PureAdmin.Translations.t/2`, so apps that configure a translation callback
  automatically get localized output without any code changes.

  ## Quick use

      alias PureAdmin.DateTime, as: PADT

      PADT.format(~U[2026-04-23 16:29:22Z], :short_date)
      # => "2026-04-23"

      PADT.format(~U[2026-04-23 16:29:22Z], :long_date)
      # => "April 23, 2026"

      PADT.format(~U[2026-04-23 16:29:22Z], :short_date_time)
      # => "2026-04-23 16:29"

      PADT.format(~U[2026-04-23 16:29:22Z], :long_date_time)
      # => "April 23, 2026 at 16:29"

      PADT.format(~U[2026-04-23 16:29:22Z], :time)
      # => "16:29"

      PADT.relative(DateTime.add(DateTime.utc_now(), -300, :second))
      # => "5 minutes ago"

  ## Styles

  | Style                | Example                         |
  | -------------------- | ------------------------------- |
  | `:short_date`        | `2026-04-23`                    |
  | `:long_date`         | `April 23, 2026`                |
  | `:full_date`         | `Thursday, April 23, 2026`      |
  | `:time`              | `16:29`                         |
  | `:long_time`         | `16:29:22`                      |
  | `:short_date_time`   | `2026-04-23 16:29`              |
  | `:long_date_time`    | `April 23, 2026 at 16:29`       |
  | `:relative`          | `5 minutes ago`, `in 2 hours`   |

  You can also pass a raw `strftime` pattern string — it's piped through
  `Calendar.strftime/2` after month/weekday name substitution.

      PADT.format(dt, "%B %d, %Y")

  ## Relative time

  `relative/2` expresses how far `datetime` is from `now`:

  - ≤ 5 s  → `now`
  - < 1 m  → `%{count}s ago`
  - < 1 h  → `a minute ago`, `%{count} minutes ago`
  - < 1 d  → `an hour ago`, `%{count} hours ago`
  - < 2 d  → `yesterday`
  - < 1 w  → `%{count} days ago`
  - < 1 mo → `a week ago`, `%{count} weeks ago`
  - < 1 y  → `a month ago`, `%{count} months ago`
  - older  → `a year ago`, `%{count} years ago`

  Future times use `in %{duration}` (e.g. `in 3 hours`).

  Pass `:now` to stabilize tests:

      PADT.relative(event_at, now: ~U[2026-04-23 16:29:22Z])

  ## Translation keys

  All keys sit under `pureAdmin.datetime.*`. See `PureAdmin.Translations`
  module doc for how to wire a callback. Month names live under
  `pureAdmin.datetime.months.*`, weekday names under
  `pureAdmin.datetime.weekdays.*`, and relative phrases directly under
  `pureAdmin.datetime.*` (e.g. `pureAdmin.datetime.minutesAgo`).
  """

  alias PureAdmin.Translations

  @type formattable :: Date.t() | Time.t() | NaiveDateTime.t() | DateTime.t()
  @type style ::
          :short_date
          | :long_date
          | :full_date
          | :time
          | :long_time
          | :short_date_time
          | :long_date_time
          | :relative
          | String.t()

  @doc """
  Formats `datetime` as `style`.

  See the module doc for the list of styles and examples.
  """
  @spec format(formattable(), style()) :: String.t()
  def format(datetime, style \\ :short_date_time)

  def format(dt, :short_date), do: pattern(dt, "%Y-%m-%d")
  def format(dt, :time), do: pattern(dt, "%H:%M")
  def format(dt, :long_time), do: pattern(dt, "%H:%M:%S")
  def format(dt, :short_date_time), do: pattern(dt, "%Y-%m-%d %H:%M")

  def format(dt, :long_date) do
    day = day(dt)
    "#{month_name(month(dt))} #{day}, #{year(dt)}"
  end

  def format(dt, :full_date) do
    "#{weekday_name(weekday(dt))}, #{format(dt, :long_date)}"
  end

  def format(dt, :long_date_time) do
    "#{format(dt, :long_date)} #{Translations.t("pureAdmin.datetime.at")} #{format(dt, :time)}"
  end

  def format(dt, :relative), do: relative(dt)

  def format(dt, pattern) when is_binary(pattern), do: pattern(dt, pattern)

  @doc """
  Formats `datetime` as a relative phrase (e.g. `"5 minutes ago"`).

  Accepts `:now` option to override the reference time (useful in tests).
  """
  @spec relative(formattable(), keyword()) :: String.t()
  def relative(datetime, opts \\ []) do
    now = Keyword.get(opts, :now, DateTime.utc_now())
    diff_seconds = DateTime.diff(to_datetime(now), to_datetime(datetime))
    direction = if diff_seconds >= 0, do: :past, else: :future
    phrase_for(abs(diff_seconds), direction)
  end

  # ─── relative logic ───

  defp phrase_for(seconds, :past) when seconds <= 5, do: Translations.t("pureAdmin.datetime.now")
  defp phrase_for(seconds, :future) when seconds <= 5, do: Translations.t("pureAdmin.datetime.now")

  defp phrase_for(seconds, direction) do
    {key, params} = relative_bucket(seconds)

    case direction do
      :past -> Translations.t(key <> "Ago", params)
      :future -> Translations.t("pureAdmin.datetime.in", %{duration: Translations.t(key, params)})
    end
  end

  # Returns a {base_key, params} pair. `base_key <> "Ago"` is used for past,
  # `"pureAdmin.datetime.in"` wraps `base_key` for future.
  defp relative_bucket(seconds) when seconds < 60,
    do: {"pureAdmin.datetime.seconds", %{count: seconds}}

  defp relative_bucket(seconds) when seconds < 120,
    do: {"pureAdmin.datetime.minute", %{}}

  defp relative_bucket(seconds) when seconds < 3600,
    do: {"pureAdmin.datetime.minutes", %{count: div(seconds, 60)}}

  defp relative_bucket(seconds) when seconds < 7200,
    do: {"pureAdmin.datetime.hour", %{}}

  defp relative_bucket(seconds) when seconds < 86_400,
    do: {"pureAdmin.datetime.hours", %{count: div(seconds, 3600)}}

  defp relative_bucket(seconds) when seconds < 172_800,
    do: {"pureAdmin.datetime.yesterday", %{}}

  defp relative_bucket(seconds) when seconds < 604_800,
    do: {"pureAdmin.datetime.days", %{count: div(seconds, 86_400)}}

  defp relative_bucket(seconds) when seconds < 1_209_600,
    do: {"pureAdmin.datetime.week", %{}}

  defp relative_bucket(seconds) when seconds < 2_592_000,
    do: {"pureAdmin.datetime.weeks", %{count: div(seconds, 604_800)}}

  defp relative_bucket(seconds) when seconds < 5_184_000,
    do: {"pureAdmin.datetime.month", %{}}

  defp relative_bucket(seconds) when seconds < 31_536_000,
    do: {"pureAdmin.datetime.months", %{count: div(seconds, 2_592_000)}}

  defp relative_bucket(seconds) when seconds < 63_072_000,
    do: {"pureAdmin.datetime.year", %{}}

  defp relative_bucket(seconds),
    do: {"pureAdmin.datetime.years", %{count: div(seconds, 31_536_000)}}

  # ─── name lookups ───

  @month_keys %{
    1 => "january",
    2 => "february",
    3 => "march",
    4 => "april",
    5 => "may",
    6 => "june",
    7 => "july",
    8 => "august",
    9 => "september",
    10 => "october",
    11 => "november",
    12 => "december"
  }

  @weekday_keys %{
    1 => "monday",
    2 => "tuesday",
    3 => "wednesday",
    4 => "thursday",
    5 => "friday",
    6 => "saturday",
    7 => "sunday"
  }

  defp month_name(n), do: Translations.t("pureAdmin.datetime.months.#{@month_keys[n]}")
  defp weekday_name(n), do: Translations.t("pureAdmin.datetime.weekdays.#{@weekday_keys[n]}")

  # ─── strftime with translated names ───

  defp pattern(value, pattern) do
    # Calendar.strftime supports %A (weekday), %B (month) etc. via :preferred_datetime
    # option. We pass translated names so locales flow through.
    options = [
      month_names: fn n -> month_name(n) end,
      abbreviated_month_names: fn n -> month_name(n) |> String.slice(0, 3) end,
      day_of_week_names: fn n -> weekday_name(n) end,
      abbreviated_day_of_week_names: fn n -> weekday_name(n) |> String.slice(0, 3) end
    ]

    Calendar.strftime(to_strftime_input(value), pattern, options)
  end

  # ─── value accessors that handle all four types ───

  defp year(%DateTime{year: y}), do: y
  defp year(%NaiveDateTime{year: y}), do: y
  defp year(%Date{year: y}), do: y

  defp month(%DateTime{month: m}), do: m
  defp month(%NaiveDateTime{month: m}), do: m
  defp month(%Date{month: m}), do: m

  defp day(%DateTime{day: d}), do: d
  defp day(%NaiveDateTime{day: d}), do: d
  defp day(%Date{day: d}), do: d

  defp weekday(%Date{} = d), do: Date.day_of_week(d)
  defp weekday(%DateTime{} = dt), do: Date.day_of_week(DateTime.to_date(dt))
  defp weekday(%NaiveDateTime{} = n), do: Date.day_of_week(NaiveDateTime.to_date(n))

  # DateTime.diff requires both sides to be DateTime
  defp to_datetime(%DateTime{} = dt), do: dt
  defp to_datetime(%NaiveDateTime{} = n), do: DateTime.from_naive!(n, "Etc/UTC")

  defp to_datetime(%Date{} = d) do
    {:ok, ndt} = NaiveDateTime.new(d, ~T[00:00:00])
    DateTime.from_naive!(ndt, "Etc/UTC")
  end

  # Calendar.strftime accepts Date/Time/NaiveDateTime/DateTime directly
  defp to_strftime_input(value), do: value
end
