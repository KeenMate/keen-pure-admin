defmodule DemoWeb.ThemePlug do
  @moduledoc """
  Serves Pure Admin themes with on-demand downloading from pureadmin.io.

  Each theme is extracted as a full directory (CSS, fonts, assets) so that
  relative paths in the CSS work correctly.

  Routes handled:
  - GET /themes/:name/* — serves theme files (CSS, fonts, assets). Downloads on-demand if missing
  - GET /api/themes/manifests — returns all available theme manifests as JSON
  - GET /api/themes/:name/manifest — returns a single theme's manifest

  Directory structure per theme:
    themes/{name}/dist/{name}.css   — main stylesheet
    themes/{name}/assets/fonts/...  — bundled fonts
    themes/{name}/theme.json        — manifest

  Uses Erlang's built-in :httpc and :zip — no external tools needed.
  Failed downloads are negatively cached for 10 minutes.
  """
  @behaviour Plug

  require Logger

  @pureadmin_api "https://pureadmin.io"
  @failed_ttl_ms 10 * 60 * 1000
  @slug_pattern ~r/^[a-z0-9-]+$/

  # MIME types for theme assets
  @mime_types %{
    ".css" => "text/css; charset=utf-8",
    ".woff2" => "font/woff2",
    ".woff" => "font/woff",
    ".ttf" => "font/ttf",
    ".eot" => "application/vnd.ms-fontobject",
    ".svg" => "image/svg+xml",
    ".json" => "application/json",
    ".png" => "image/png",
    ".jpg" => "image/jpeg",
    ".gif" => "image/gif"
  }

  @impl true
  def init(opts), do: opts

  @impl true
  def call(%Plug.Conn{method: "GET"} = conn, _opts) do
    Logger.debug("ThemePlug called: #{inspect(conn.path_info)}")

    case conn.path_info do
      ["themes", name | rest] when rest != [] ->
        serve_theme_file(conn, name, Path.join(rest))

      ["api", "themes", "manifests"] ->
        serve_all_manifests(conn)

      ["api", "themes", name, "manifest"] ->
        serve_single_manifest(conn, name)

      _ ->
        conn
    end
  end

  def call(conn, _opts), do: conn

  # -- Theme file serving --

  defp serve_theme_file(conn, name, file_path) do
    if not Regex.match?(@slug_pattern, name) or not safe_path?(file_path) do
      Logger.debug("ThemePlug: rejected name=#{name} path=#{file_path}")
      conn
    else
      case find_or_download_theme(name) do
        nil ->
          Logger.warning("ThemePlug: theme \"#{name}\" not available")
          conn

        theme_dir ->
          full_path = Path.join(theme_dir, file_path)
          Logger.debug("ThemePlug: serving #{full_path} (exists: #{File.regular?(full_path)})")
          serve_static_file(conn, full_path)
      end
    end
  end

  defp find_or_download_theme(name) do
    case find_theme_dir(name) do
      nil ->
        if recently_failed?(name) do
          nil
        else
          case download_theme(name) do
            :ok -> find_theme_dir(name)
            :error -> nil
          end
        end

      dir ->
        dir
    end
  end

  defp safe_path?(path) do
    not String.contains?(path, "..") and not String.starts_with?(path, "/")
  end

  defp serve_static_file(conn, path) do
    if File.regular?(path) do
      ext = Path.extname(path)
      content_type = Map.get(@mime_types, ext, "application/octet-stream")

      conn
      |> Plug.Conn.put_resp_header("content-type", content_type)
      |> Plug.Conn.put_resp_header("cache-control", "public, max-age=120")
      |> Plug.Conn.send_file(200, path)
      |> Plug.Conn.halt()
    else
      conn
    end
  end

  # Find theme directory in priv or cache (must contain css/{name}.css)
  defp find_theme_dir(name) do
    priv_path = Path.join(priv_themes_dir(), name)
    cache_path = Path.join(themes_dir(), name)

    cond do
      valid_theme_dir?(priv_path, name) -> priv_path
      valid_theme_dir?(cache_path, name) -> cache_path
      true -> nil
    end
  end

  defp valid_theme_dir?(path, name) do
    File.dir?(path) and File.regular?(Path.join([path, "css", "#{name}.css"]))
  end

  # -- Manifests API --

  defp serve_all_manifests(conn) do
    manifests = load_all_manifests()

    conn
    |> Plug.Conn.put_resp_content_type("application/json")
    |> Plug.Conn.put_resp_header("cache-control", "public, max-age=300")
    |> Plug.Conn.send_resp(200, Jason.encode!(manifests))
    |> Plug.Conn.halt()
  end

  defp serve_single_manifest(conn, name) do
    if Regex.match?(@slug_pattern, name) do
      case load_manifest(name) do
        {:ok, manifest} ->
          conn
          |> Plug.Conn.put_resp_content_type("application/json")
          |> Plug.Conn.put_resp_header("cache-control", "public, max-age=300")
          |> Plug.Conn.send_resp(200, Jason.encode!(manifest))
          |> Plug.Conn.halt()

        :error ->
          conn
          |> Plug.Conn.put_resp_content_type("application/json")
          |> Plug.Conn.send_resp(404, Jason.encode!(%{error: "Theme \"#{name}\" not found"}))
          |> Plug.Conn.halt()
      end
    else
      conn
    end
  end

  defp load_all_manifests do
    [priv_themes_dir(), themes_dir()]
    |> Enum.reduce(%{}, fn dir, acc ->
      case File.ls(dir) do
        {:ok, entries} ->
          Enum.reduce(entries, acc, fn entry, inner_acc ->
            manifest_path = Path.join([dir, entry, "theme.json"])

            if File.regular?(manifest_path) and Regex.match?(@slug_pattern, entry) do
              case read_json(manifest_path) do
                {:ok, manifest} -> Map.put(inner_acc, entry, manifest)
                _ -> inner_acc
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

  defp load_manifest(name) do
    case find_theme_dir(name) do
      nil ->
        case download_theme(name) do
          :ok ->
            case find_theme_dir(name) do
              nil -> :error
              dir -> read_json(Path.join(dir, "theme.json"))
            end

          :error ->
            :error
        end

      dir ->
        read_json(Path.join(dir, "theme.json"))
    end
  end

  defp read_json(path) do
    case File.read(path) do
      {:ok, content} ->
        case Jason.decode(content) do
          {:ok, data} -> {:ok, data}
          _ -> :error
        end

      _ ->
        :error
    end
  end

  # -- Download & extract --

  defp download_theme(name) do
    Logger.info("Theme \"#{name}\" not found locally, downloading from #{@pureadmin_api}...")
    ensure_httpc()

    url = ~c"#{@pureadmin_api}/api/themes/#{name}/download"

    case :httpc.request(:get, {url, []}, [ssl: ssl_opts()], body_format: :binary) do
      {:ok, {{_, 200, _}, _headers, body}} ->
        extract_theme(name, body)

      {:ok, {{_, status, _}, _, _}} ->
        Logger.warning("Download failed for \"#{name}\": HTTP #{status}")
        mark_failed(name)
        :error

      {:error, reason} ->
        Logger.error("Failed to download theme \"#{name}\": #{inspect(reason)}")
        mark_failed(name)
        :error
    end
  end

  defp extract_theme(name, zip_body) do
    theme_path = Path.join(themes_dir(), name)

    case :zip.unzip(zip_body, [:memory]) do
      {:ok, files} ->
        File.mkdir_p!(theme_path)

        for {file_path, content} <- files do
          dest = Path.join(theme_path, to_string(file_path))
          File.mkdir_p!(Path.dirname(dest))
          File.write!(dest, content)
        end

        # Fetch manifest from API if not in zip
        manifest_path = Path.join(theme_path, "theme.json")

        unless File.exists?(manifest_path) do
          case fetch_manifest_from_api(name) do
            nil -> :ok
            content -> File.write!(manifest_path, content)
          end
        end

        Logger.info("Theme \"#{name}\" downloaded and extracted to #{theme_path}")
        :ok

      {:error, reason} ->
        Logger.error("Failed to unzip theme \"#{name}\": #{inspect(reason)}")
        mark_failed(name)
        :error
    end
  end

  defp fetch_manifest_from_api(name) do
    url = ~c"#{@pureadmin_api}/api/themes/#{name}"

    case :httpc.request(:get, {url, []}, [ssl: ssl_opts()], body_format: :binary) do
      {:ok, {{_, 200, _}, _headers, body}} ->
        case Jason.decode(body) do
          {:ok, %{"theme" => theme}} -> Jason.encode!(theme)
          {:ok, manifest} -> Jason.encode!(manifest)
          _ -> nil
        end

      _ ->
        nil
    end
  rescue
    _ -> nil
  end

  defp ensure_httpc do
    :inets.start()
    :ssl.start()
  end

  defp ssl_opts do
    [
      verify: :verify_peer,
      cacerts: :public_key.cacerts_get(),
      depth: 3,
      customize_hostname_check: [
        match_fun: :public_key.pkix_verify_hostname_match_fun(:https)
      ]
    ]
  end

  # -- Paths --

  defp priv_themes_dir do
    Application.app_dir(:demo, "priv/static/themes")
  end

  defp themes_dir, do: Path.join(System.tmp_dir!(), "pure-admin-themes")

  # -- Negative cache (ETS) --

  defp failed_table do
    case :ets.whereis(:theme_download_failures) do
      :undefined ->
        :ets.new(:theme_download_failures, [:set, :public, :named_table])

      ref ->
        ref
    end
  end

  defp mark_failed(name) do
    :ets.insert(failed_table(), {name, System.monotonic_time(:millisecond)})
  end

  defp recently_failed?(name) do
    case :ets.lookup(failed_table(), name) do
      [{^name, failed_at}] ->
        System.monotonic_time(:millisecond) - failed_at < @failed_ttl_ms

      [] ->
        false
    end
  rescue
    ArgumentError -> false
  end
end
