defmodule Demo.FormCache do
  @moduledoc """
  In-memory per-session store for the Phoenix/LiveView form demo.

  Entries live in a lazily-created named ETS table keyed by `session_id`
  and are evicted after a period of inactivity so the table does not
  outlive the user's session. Each row carries a `last_access_ms`
  monotonic timestamp that is refreshed on every read or write
  (sliding expiration). `Demo.FormCache.Sweeper` periodically purges
  rows that exceed the TTL, and reads also evict lazily so stale rows
  never leak into the UI even if the sweeper is late.

  Not durable: cleared on application restart.
  """

  @table :demo_form_submissions

  # 30 minutes of inactivity before a session's submissions are dropped.
  @ttl_ms 30 * 60 * 1000

  @doc false
  def ttl_ms, do: @ttl_ms

  @doc false
  def table_name, do: @table

  @doc "Returns submissions for the given session, newest first."
  @spec list(String.t()) :: [map()]
  def list(session_id) when is_binary(session_id) do
    case fetch(session_id) do
      {entries, _} -> entries
      nil -> []
    end
  end

  @doc "Prepends a new submission and returns the updated list."
  @spec put(String.t(), map()) :: [map()]
  def put(session_id, entry) when is_binary(session_id) and is_map(entry) do
    entry =
      entry
      |> Map.put_new(:inserted_at, DateTime.utc_now())
      |> Map.put_new(:id, System.unique_integer([:positive, :monotonic]))

    current =
      case fetch(session_id) do
        {entries, _} -> entries
        nil -> []
      end

    updated = [entry | current]
    :ets.insert(table(), {session_id, updated, now_ms()})
    updated
  end

  @doc "Removes a single submission by id."
  @spec delete(String.t(), integer()) :: [map()]
  def delete(session_id, id) when is_binary(session_id) and is_integer(id) do
    updated =
      case fetch(session_id) do
        {entries, _} -> Enum.reject(entries, &(&1.id == id))
        nil -> []
      end

    :ets.insert(table(), {session_id, updated, now_ms()})
    updated
  end

  @doc "Clears all submissions for the given session."
  @spec clear(String.t()) :: :ok
  def clear(session_id) when is_binary(session_id) do
    :ets.delete(table(), session_id)
    :ok
  end

  @doc """
  Evicts rows that have been inactive for longer than `ttl_ms`.
  Called by `Demo.FormCache.Sweeper` on a timer.
  """
  @spec sweep() :: non_neg_integer()
  def sweep do
    cutoff = now_ms() - @ttl_ms
    # {_session_id, _entries, last_access_ms} — delete where last_access_ms < cutoff
    match_spec = [
      {{:"$1", :"$2", :"$3"}, [{:<, :"$3", cutoff}], [true]}
    ]

    :ets.select_delete(table(), match_spec)
  end

  # -- internal --

  # Reads a row and refreshes its last-access timestamp.
  # Returns `nil` if the row is missing or expired (expired rows are evicted).
  defp fetch(session_id) do
    case :ets.lookup(table(), session_id) do
      [{^session_id, entries, last_access}] ->
        if now_ms() - last_access > @ttl_ms do
          :ets.delete(table(), session_id)
          nil
        else
          :ets.update_element(table(), session_id, {3, now_ms()})
          {entries, last_access}
        end

      [] ->
        nil
    end
  end

  defp now_ms, do: System.monotonic_time(:millisecond)

  defp table do
    case :ets.whereis(@table) do
      :undefined ->
        try do
          :ets.new(@table, [:set, :public, :named_table, read_concurrency: true])
        rescue
          ArgumentError -> :ets.whereis(@table)
        end

      ref ->
        ref
    end
  end
end
