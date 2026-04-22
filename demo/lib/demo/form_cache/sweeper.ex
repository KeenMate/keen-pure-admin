defmodule Demo.FormCache.Sweeper do
  @moduledoc """
  Periodically evicts expired rows from `Demo.FormCache`.

  The interval is independent of the TTL: the sweeper ticks every minute
  and the cache itself lazily evicts on read, so an occasional miss here
  never surfaces stale data in the UI.
  """
  use GenServer

  @interval_ms :timer.minutes(1)

  def start_link(opts), do: GenServer.start_link(__MODULE__, opts, name: __MODULE__)

  @impl true
  def init(_opts) do
    schedule()
    {:ok, %{}}
  end

  @impl true
  def handle_info(:sweep, state) do
    Demo.FormCache.sweep()
    schedule()
    {:noreply, state}
  end

  defp schedule, do: Process.send_after(self(), :sweep, @interval_ms)
end
