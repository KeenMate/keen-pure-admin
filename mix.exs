defmodule KPureAdmin.MixProject do
  use Mix.Project

  @version "1.0.0-rc.1"
  @source_url "https://github.com/KeenMate/keen-pure-admin"

  def project do
    [
      app: :keen_pure_admin,
      version: @version,
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases(),
      elixirc_paths: elixirc_paths(Mix.env()),
      name: "KPureAdmin",
      description: "Phoenix LiveView component library for the Pure Admin CSS framework",
      package: package(),
      docs: docs(),
      source_url: @source_url,
      dialyzer: [plt_add_apps: [:mix]]
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp deps do
    [
      {:phoenix_live_view, "~> 1.0"},
      {:nimble_options, "~> 1.0"},
      {:jason, "~> 1.4"},
      {:ex_doc, "~> 0.34", only: :dev, runtime: false},
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.4", only: [:dev, :test], runtime: false},
      {:floki, "~> 0.36", only: :test}
    ]
  end

  defp package do
    [
      name: "keen_pure_admin",
      licenses: ["MIT"],
      links: %{"GitHub" => @source_url},
      files: ~w(lib docs .formatter.exs mix.exs README.md LICENSE CHANGELOG.md)
    ]
  end

  defp docs do
    [
      main: "readme",
      source_ref: "v#{@version}",
      logo: nil,
      extras: [
        "README.md",
        "docs/getting-started.md",
        "docs/js-hooks.md",
        "docs/theming.md",
        "CHANGELOG.md",
        "LICENSE"
      ],
      groups_for_extras: [
        Guides: [
          "docs/getting-started.md",
          "docs/js-hooks.md",
          "docs/theming.md"
        ]
      ],
      groups_for_modules: [
        "Layout & Navigation": [
          KPureAdmin.Components.Layout,
          KPureAdmin.Components.Navigation,
          KPureAdmin.Components.Profile,
          KPureAdmin.Components.SettingsPanel,
          KPureAdmin.Components.Grid
        ],
        "UI Components": [
          KPureAdmin.Components.Button,
          KPureAdmin.Components.Badge,
          KPureAdmin.Components.Alert,
          KPureAdmin.Components.Callout,
          KPureAdmin.Components.Card,
          KPureAdmin.Components.Modal,
          KPureAdmin.Components.Popconfirm,
          KPureAdmin.Components.Toast,
          KPureAdmin.Components.Tooltip,
          KPureAdmin.Components.Loader,
          KPureAdmin.Components.Stat,
          KPureAdmin.Components.Code,
          KPureAdmin.Components.Typography
        ],
        "Data & Tables": [
          KPureAdmin.Components.Table,
          KPureAdmin.Components.Comparison,
          KPureAdmin.Components.DataDisplay,
          KPureAdmin.Components.DataViz,
          KPureAdmin.Components.FilterCard,
          KPureAdmin.Components.Pager
        ],
        "Forms & Inputs": [
          KPureAdmin.Components.Form,
          KPureAdmin.Components.CheckboxList
        ],
        "Lists & Timeline": [
          KPureAdmin.Components.List,
          KPureAdmin.Components.Timeline
        ],
        "Live Components": ~r/KPureAdmin\.Live\./,
        "Helpers & Config": [
          KPureAdmin.Components,
          KPureAdmin.Helpers,
          KPureAdmin.Config,
          KPureAdmin.Types
        ]
      ]
    ]
  end

  defp aliases do
    [
      quality: ["format --check-formatted", "credo --strict", "dialyzer"]
    ]
  end
end
