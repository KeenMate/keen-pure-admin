defmodule PureAdmin.Config do
  @moduledoc """
  Application-level configuration for PureAdmin.

  Set in `config/config.exs`:

      config :keen_pure_admin,
        app_name: "My App",
        app_logo: "/images/logo.svg",
        app_version: "1.0.0",
        copyright: "© 2026 My Company",
        font_class: "pa-font-responsive",
        default_variant: "primary",
        toast_position: "top-right"

  Components like `navbar_brand/1` and `footer/1` read from this config
  automatically when no explicit content is provided.

  ## Available Keys

  | Key | Default | Used by |
  |-----|---------|---------|
  | `:app_name` | `"PureAdmin"` | `navbar_brand/1` |
  | `:app_logo` | `nil` | `navbar_brand/1` |
  | `:app_version` | `nil` | `footer/1` |
  | `:copyright` | `nil` | `footer/1` |
  | `:font_class` | `nil` | `root_html_attrs/0` |
  | `:default_variant` | `"primary"` | various components |
  | `:toast_position` | `"top-right"` | `toast_container/1` |
  """

  @defaults %{
    app_name: "PureAdmin",
    app_logo: nil,
    app_version: nil,
    copyright: nil,
    font_class: nil,
    default_variant: "primary",
    toast_position: "top-right"
  }

  @doc "Get a single config value with fallback to default."
  @spec get(atom(), any()) :: any()
  def get(key, default \\ nil) do
    app_default = Map.get(@defaults, key, default)
    Application.get_env(:keen_pure_admin, key, app_default)
  end

  @doc "Get the full merged config as a map."
  @spec all() :: map()
  def all do
    app_config = Application.get_all_env(:keen_pure_admin)
    Map.merge(@defaults, Map.new(app_config))
  end

  @doc "Get the app name."
  @spec app_name() :: String.t()
  def app_name, do: get(:app_name)

  @doc "Get the app logo URL."
  @spec app_logo() :: String.t() | nil
  def app_logo, do: get(:app_logo)

  @doc "Get the app version."
  @spec app_version() :: String.t() | nil
  def app_version, do: get(:app_version)

  @doc "Get the copyright text."
  @spec copyright() :: String.t() | nil
  def copyright, do: get(:copyright)

  @doc "Get the font class for the `<html>` element (e.g. `\"pa-font-responsive\"`)."
  @spec font_class() :: String.t() | nil
  def font_class, do: get(:font_class)

  @doc "Get the default component variant."
  @spec default_variant() :: String.t()
  def default_variant, do: get(:default_variant)

  @doc """
  Returns HTML attributes for the `<html>` element.

  Includes the `font_class` if configured. Use in your root layout:

      <html lang="en" {PureAdmin.Config.root_html_attrs()}>
  """
  @spec root_html_attrs() :: map()
  def root_html_attrs do
    case font_class() do
      nil -> %{}
      fc -> %{class: fc}
    end
  end
end
