defmodule PureAdmin.Helpers do
  @moduledoc """
  BEM class builder utilities for Pure Admin components.

  All Pure Admin CSS classes follow BEM naming: `pa-{block}`, `pa-{block}--{modifier}`,
  `pa-{block}__{element}`.
  """

  @doc """
  Builds a CSS class string from a base class and a list of conditional modifiers.

  ## Examples

      iex> PureAdmin.Helpers.build_classes("pa-btn", [{"pa-btn--primary", true}, {"pa-btn--sm", false}])
      "pa-btn pa-btn--primary"

      iex> PureAdmin.Helpers.build_classes("pa-btn", [{"pa-btn--primary", true}], "extra-class")
      "pa-btn pa-btn--primary extra-class"
  """
  @spec build_classes(String.t(), [{String.t(), boolean()}], String.t() | nil) :: String.t()
  def build_classes(base, modifiers, extra \\ nil) do
    classes =
      [base | for({class, true} <- modifiers, do: class)]
      |> maybe_append(extra)
      |> Enum.join(" ")

    classes
  end

  @doc """
  Adds a BEM modifier class if the condition is truthy.

  ## Examples

      iex> PureAdmin.Helpers.maybe_modifier("pa-btn", "primary", "primary")
      "pa-btn--primary"

      iex> PureAdmin.Helpers.maybe_modifier("pa-btn", nil, nil)
      nil
  """
  @spec maybe_modifier(String.t(), String.t() | nil, any()) :: String.t() | nil
  def maybe_modifier(base, value, _condition \\ true)
  def maybe_modifier(_base, nil, _), do: nil
  def maybe_modifier(base, value, _), do: "#{base}--#{value}"

  defp maybe_append(list, nil), do: list
  defp maybe_append(list, ""), do: list
  defp maybe_append(list, extra), do: list ++ [extra]
end
