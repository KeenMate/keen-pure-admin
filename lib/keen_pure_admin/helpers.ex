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

  @doc """
  Returns `url` if it uses a safe scheme, otherwise `fallback` (defaults to
  `"#"`). Phoenix's HEEx auto-escapes attribute *values* but does not
  validate URL schemes, so a `javascript:`/`data:`/`vbscript:` URL bound to
  `href=` will execute when clicked.

  Call this at the boundary where a URL could be user-controlled — e.g.
  favourite links, user profile bios, CMS-edited nav items — before passing
  the value to any `href=` attribute.

  Deny-list, not allow-list — the goal is to block the four URL schemes
  browsers will execute as script, not to second-guess which schemes your
  app supports. So `mailto:`, `tel:`, `sms:`, deep-link schemes like
  `slack://` / `intent://` / `myapp://`, and relative paths all pass
  through unchanged.

  Rejected schemes (returns `fallback`): `javascript:`, `data:`,
  `vbscript:`, `file:`. Leading whitespace and case variations
  (`JavaScript:`, `  javascript:`) are handled.

  ## Examples

      iex> PureAdmin.Helpers.safe_url("https://example.com")
      "https://example.com"

      iex> PureAdmin.Helpers.safe_url("/dashboard")
      "/dashboard"

      iex> PureAdmin.Helpers.safe_url("javascript:alert(1)")
      "#"

      iex> PureAdmin.Helpers.safe_url("JavaScript:alert(1)")
      "#"

      iex> PureAdmin.Helpers.safe_url("  javascript:alert(1)")
      "#"

      iex> PureAdmin.Helpers.safe_url("data:text/html,<script>...</script>")
      "#"

      iex> PureAdmin.Helpers.safe_url("mailto:jane@example.com")
      "mailto:jane@example.com"

      iex> PureAdmin.Helpers.safe_url("tel:+420123456")
      "tel:+420123456"

      iex> PureAdmin.Helpers.safe_url("slack://channel?team=T1&id=C1")
      "slack://channel?team=T1&id=C1"

      iex> PureAdmin.Helpers.safe_url(nil)
      "#"

      iex> PureAdmin.Helpers.safe_url("#section")
      "#section"

      iex> PureAdmin.Helpers.safe_url("javascript:alert(1)", "/")
      "/"
  """
  @spec safe_url(String.t() | nil, String.t()) :: String.t()
  def safe_url(url, fallback \\ "#")
  def safe_url(nil, fallback), do: fallback

  def safe_url(url, fallback) when is_binary(url) do
    trimmed = String.trim(url)

    cond do
      trimmed == "" -> fallback
      unsafe_scheme?(trimmed) -> fallback
      true -> trimmed
    end
  end

  def safe_url(_, fallback), do: fallback

  # Matches the opening of any URL scheme — `foo:`, including `javascript:`,
  # `data:`, etc. We then narrow to the disallowed set; anything scheme-less
  # (relative path, #fragment, ?query) passes through untouched.
  @unsafe_schemes ~w(javascript data vbscript file)

  defp unsafe_scheme?(url) do
    case Regex.run(~r/^([a-z][a-z0-9+.-]*):/i, url) do
      [_, scheme] -> String.downcase(scheme) in @unsafe_schemes
      _ -> false
    end
  end
end
