defmodule KPureAdmin.Config do
  @moduledoc """
  Configuration for KPureAdmin components via NimbleOptions.

  Configuration can be set in `config/config.exs`:

      config :keen_pure_admin,
        default_variant: "primary",
        toast_position: "top-right"
  """

  @spec get(atom(), any()) :: any()
  def get(key, default \\ nil) do
    Application.get_env(:keen_pure_admin, key, default)
  end

  @spec default_variant() :: String.t()
  def default_variant, do: get(:default_variant, "primary")
end
