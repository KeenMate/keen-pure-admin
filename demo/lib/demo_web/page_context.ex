defmodule DemoWeb.PageContext do
  @moduledoc """
  Page context providers for the demo app.
  """

  @doc """
  Provides theme manifests from cached theme directories.
  """
  def theme_manifests(_assigns) do
    manifests =
      load_manifests()
      |> Map.new(fn {id, manifest} -> {id, slim_manifest(manifest)} end)

    %{"themeManifests" => manifests}
  end

  # Only keep fields the settings panel JS actually uses
  defp slim_manifest(manifest) do
    %{
      "name" => manifest["name"],
      "colorVariants" => slim_color_variants(manifest["colorVariants"]),
      "variantCssClass" => manifest["variantCssClass"],
      "modeCssClass" => manifest["modeCssClass"],
      "fonts" => slim_fonts(manifest["fonts"])
    }
    |> Enum.reject(fn {_, v} -> is_nil(v) end)
    |> Map.new()
  end

  defp slim_color_variants(nil), do: nil
  defp slim_color_variants(variants) when is_list(variants) do
    Enum.map(variants, fn v ->
      %{
        "id" => v["id"],
        "name" => v["name"],
        "description" => v["description"],
        "file" => v["file"],
        "modes" => slim_modes(v["modes"])
      }
      |> Enum.reject(fn {_, val} -> is_nil(val) end)
      |> Map.new()
    end)
  end
  defp slim_color_variants(_), do: nil

  defp slim_modes(nil), do: nil
  defp slim_modes(modes) when is_list(modes) do
    Enum.map(modes, fn m ->
      Map.take(m, ["id", "name", "default"])
    end)
  end
  defp slim_modes(_), do: nil

  defp slim_fonts(nil), do: nil
  defp slim_fonts(fonts) when is_map(fonts), do: Map.take(fonts, ["family"])
  defp slim_fonts(_), do: nil

  defp load_manifests do
    dirs = [priv_themes_dir(), themes_dir()]

    Enum.reduce(dirs, %{}, fn dir, acc ->
      case File.ls(dir) do
        {:ok, entries} ->
          Enum.reduce(entries, acc, fn entry, inner_acc ->
            manifest_path = Path.join([dir, entry, "theme.json"])

            if File.regular?(manifest_path) and Regex.match?(~r/^[a-z0-9-]+$/, entry) do
              case File.read(manifest_path) do
                {:ok, content} ->
                  case Jason.decode(content) do
                    {:ok, manifest} -> Map.put(inner_acc, entry, manifest)
                    _ -> inner_acc
                  end

                _ ->
                  inner_acc
              end
            else
              inner_acc
            end
          end)

        _ ->
          acc
      end
    end)
  end

  defp priv_themes_dir do
    Application.app_dir(:demo, "priv/static/themes")
  end

  defp themes_dir, do: Path.join(System.tmp_dir!(), "pure-admin-themes")
end
