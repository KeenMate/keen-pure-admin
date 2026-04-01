defmodule PureAdmin.MixProject do
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
      name: "PureAdmin",
      description: "Phoenix LiveView component library for business admin applications. " <>
        "Drop-in CoreComponents replacement with 35+ components, 14 JS hooks, " <>
        "multi-step command palette, flash system, i18n, and theme management. " <>
        "Built on pureadmin.io — a standalone BEM CSS framework with no Tailwind or daisyUI dependency.",
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
          PureAdmin.Components.Layout,
          PureAdmin.Components.Navigation,
          PureAdmin.Components.Profile,
          PureAdmin.Components.SettingsPanel,
          PureAdmin.Components.Grid
        ],
        "UI Components": [
          PureAdmin.Components.Button,
          PureAdmin.Components.Badge,
          PureAdmin.Components.Alert,
          PureAdmin.Components.Callout,
          PureAdmin.Components.Card,
          PureAdmin.Components.Modal,
          PureAdmin.Components.Popconfirm,
          PureAdmin.Components.Toast,
          PureAdmin.Components.Tooltip,
          PureAdmin.Components.Loader,
          PureAdmin.Components.Stat,
          PureAdmin.Components.Code,
          PureAdmin.Components.Typography
        ],
        "Data & Tables": [
          PureAdmin.Components.Table,
          PureAdmin.Components.Comparison,
          PureAdmin.Components.DataDisplay,
          PureAdmin.Components.DataViz,
          PureAdmin.Components.FilterCard,
          PureAdmin.Components.Pager
        ],
        "Forms & Inputs": [
          PureAdmin.Components.Form,
          PureAdmin.Components.CheckboxList
        ],
        "Lists & Timeline": [
          PureAdmin.Components.List,
          PureAdmin.Components.Timeline
        ],
        "Live Components": ~r/PureAdmin\.Live\./,
        "Helpers & Config": [
          PureAdmin.Components,
          PureAdmin.Helpers,
          PureAdmin.Config,
          PureAdmin.Types
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
