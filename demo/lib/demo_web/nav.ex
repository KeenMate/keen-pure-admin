defmodule DemoWeb.Nav do
  @moduledoc """
  On-mount hook that assigns current_path for sidebar active state.
  """
  import Phoenix.LiveView
  import Phoenix.Component

  def on_mount(:default, _params, _session, socket) do
    {:cont,
     socket
     |> attach_hook(:set_current_path, :handle_params, fn _params, uri, socket ->
       path = URI.parse(uri).path
       {:cont, assign(socket, :current_path, path)}
     end)}
  end
end
