defmodule DemoWeb.SessionPlug do
  @moduledoc """
  Ensures a stable `:form_session_id` exists in the Plug session.

  Used as the key for `Demo.FormCache`. Generated once per browser
  session; cleared automatically when the session cookie expires.
  """
  @behaviour Plug

  import Plug.Conn

  @key :form_session_id

  @impl true
  def init(opts), do: opts

  @impl true
  def call(conn, _opts) do
    case get_session(conn, @key) do
      nil -> put_session(conn, @key, generate_id())
      _id -> conn
    end
  end

  defp generate_id do
    16 |> :crypto.strong_rand_bytes() |> Base.url_encode64(padding: false)
  end
end
