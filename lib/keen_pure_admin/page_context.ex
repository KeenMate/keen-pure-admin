defmodule PureAdmin.PageContext do
  @moduledoc """
  Server-to-client page context system.

  Renders a JSON blob into a hidden input (`#pa-page-context`) that JS can read
  synchronously on page load — no API fetch needed. CSP-safe (no inline scripts
  with data).

  ## How it works

  1. The app registers context providers via config
  2. The library's `page_context/1` component renders the hidden input
  3. JS reads it via `getPageContext()` / `getContextValue(key)`

  ## Configuration

      # config/config.exs
      config :keen_pure_admin,
        page_context_providers: [
          &MyApp.PageContext.theme_manifests/1,
          &MyApp.PageContext.user_context/1
        ]

  Each provider is a function that receives the assigns map and returns
  a map to merge into the context.

  ## Provider Examples

      defmodule MyApp.PageContext do
        def theme_manifests(_assigns) do
          %{"themeManifests" => load_manifests()}
        end

        def user_context(assigns) do
          user = assigns[:current_user]
          %{"user" => %{"id" => user.id, "locale" => user.locale}}
        end
      end

  ## Standard Keys

  | Key | Type | Description |
  |-----|------|-------------|
  | `themeManifests` | object | Theme manifests (avoids `/api/themes/manifests` fetch) |
  | `version` | string | Context schema version |
  | `timestamp` | integer | Server render time (unix seconds) |
  | `user` | object | Current user (app-provided) |
  | `translations` | object | UI translations (app-provided) |
  | `locale` | string | Current locale (app-provided) |
  """

  @doc """
  Builds the page context map by calling all configured providers.

  Providers are functions `(assigns :: map()) -> map()` registered via:

      config :keen_pure_admin,
        page_context_providers: [&MyModule.provider/1]

  The base context includes `version` and `timestamp`. Provider results
  are merged on top (last provider wins on key conflicts).
  """
  @spec build(map()) :: map()
  def build(assigns \\ %{}) do
    providers = Application.get_env(:keen_pure_admin, :page_context_providers, [])

    base = %{
      "version" => "1.0",
      "timestamp" => System.system_time(:second)
    }

    Enum.reduce(providers, base, fn provider, acc ->
      case provider.(assigns) do
        result when is_map(result) -> Map.merge(acc, result)
        _ -> acc
      end
    end)
  end
end
