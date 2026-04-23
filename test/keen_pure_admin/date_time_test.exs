defmodule PureAdmin.DateTimeTest do
  use ExUnit.Case, async: false

  alias PureAdmin.DateTime, as: PADT

  @ref ~U[2026-04-23 16:29:22Z]

  describe "format/2 — styles" do
    test ":short_date" do
      assert PADT.format(@ref, :short_date) == "2026-04-23"
    end

    test ":long_date" do
      assert PADT.format(@ref, :long_date) == "April 23, 2026"
    end

    test ":full_date includes weekday" do
      assert PADT.format(@ref, :full_date) == "Thursday, April 23, 2026"
    end

    test ":time (HH:MM)" do
      assert PADT.format(@ref, :time) == "16:29"
    end

    test ":long_time (HH:MM:SS)" do
      assert PADT.format(@ref, :long_time) == "16:29:22"
    end

    test ":short_date_time" do
      assert PADT.format(@ref, :short_date_time) == "2026-04-23 16:29"
    end

    test ":long_date_time joins with translated connector" do
      assert PADT.format(@ref, :long_date_time) == "April 23, 2026 at 16:29"
    end

    test "custom strftime pattern" do
      assert PADT.format(@ref, "%Y/%m/%d") == "2026/04/23"
    end
  end

  describe "format/2 — accepts Date / NaiveDateTime / DateTime" do
    test "Date" do
      assert PADT.format(~D[2026-04-23], :long_date) == "April 23, 2026"
    end

    test "NaiveDateTime" do
      assert PADT.format(~N[2026-04-23 16:29:22], :short_date_time) == "2026-04-23 16:29"
    end
  end

  describe "relative/2" do
    test "<=5s is 'now'" do
      assert PADT.relative(@ref, now: @ref) == "now"
      assert PADT.relative(DateTime.add(@ref, -3, :second), now: @ref) == "now"
      assert PADT.relative(DateTime.add(@ref, 3, :second), now: @ref) == "now"
    end

    test "seconds ago" do
      assert PADT.relative(DateTime.add(@ref, -45, :second), now: @ref) == "45s ago"
    end

    test "a minute ago" do
      assert PADT.relative(DateTime.add(@ref, -90, :second), now: @ref) == "a minute ago"
    end

    test "multiple minutes ago" do
      assert PADT.relative(DateTime.add(@ref, -5 * 60, :second), now: @ref) == "5 minutes ago"
    end

    test "an hour ago" do
      assert PADT.relative(DateTime.add(@ref, -90 * 60, :second), now: @ref) == "an hour ago"
    end

    test "multiple hours ago" do
      assert PADT.relative(DateTime.add(@ref, -5 * 3600, :second), now: @ref) == "5 hours ago"
    end

    test "yesterday" do
      assert PADT.relative(DateTime.add(@ref, -30 * 3600, :second), now: @ref) == "yesterday"
    end

    test "days ago" do
      assert PADT.relative(DateTime.add(@ref, -3 * 86_400, :second), now: @ref) == "3 days ago"
    end

    test "a week ago" do
      assert PADT.relative(DateTime.add(@ref, -8 * 86_400, :second), now: @ref) == "a week ago"
    end

    test "months ago" do
      assert PADT.relative(DateTime.add(@ref, -90 * 86_400, :second), now: @ref) == "3 months ago"
    end

    test "a year ago" do
      assert PADT.relative(DateTime.add(@ref, -400 * 86_400, :second), now: @ref) == "a year ago"
    end

    test "years ago" do
      assert PADT.relative(DateTime.add(@ref, -3 * 365 * 86_400, :second), now: @ref) == "3 years ago"
    end

    test "future: 'in X'" do
      assert PADT.relative(DateTime.add(@ref, 5 * 60, :second), now: @ref) == "in 5 minutes"
      assert PADT.relative(DateTime.add(@ref, 2 * 3600, :second), now: @ref) == "in 2 hours"
    end
  end

  describe "translation integration" do
    test "custom callback overrides month names" do
      Application.put_env(:keen_pure_admin, :translate, fn key, params ->
        case key do
          "pureAdmin.datetime.months.april" -> "duben"
          "pureAdmin.datetime.at" -> "v"
          _ -> PureAdmin.Translations.default(key, params)
        end
      end)

      try do
        assert PADT.format(@ref, :long_date) == "duben 23, 2026"
        assert PADT.format(@ref, :long_date_time) == "duben 23, 2026 v 16:29"
      after
        Application.delete_env(:keen_pure_admin, :translate)
      end
    end

    test "relative phrases pull from translations" do
      Application.put_env(:keen_pure_admin, :translate, fn key, params ->
        case key do
          "pureAdmin.datetime.now" ->
            "právě teď"

          "pureAdmin.datetime.minutesAgo" ->
            PureAdmin.Translations.interpolate("před %{count} minutami", params)

          _ ->
            PureAdmin.Translations.default(key, params)
        end
      end)

      try do
        assert PADT.relative(@ref, now: @ref) == "právě teď"
        assert PADT.relative(DateTime.add(@ref, -300, :second), now: @ref) == "před 5 minutami"
      after
        Application.delete_env(:keen_pure_admin, :translate)
      end
    end
  end
end
