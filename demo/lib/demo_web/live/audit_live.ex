defmodule DemoWeb.Live.AuditLive do
  @moduledoc """
  Scratch structural-audit page (route `/audit`). Overwrite `render/1` to render
  ONE component every documented way, then dump the live DOM with
  `pure-admin/scripts/dump-keen.mjs` and diff the full tree against the core
  snippet. Reset to this placeholder between passes. Not a real demo page.
  """
  use DemoWeb, :live_view

  def mount(_params, _session, socket), do: {:ok, assign(socket, page_title: "AUDIT")}

  def render(assigns) do
    ~H"""
    <div id="audit-root">
      <p>Scratch audit route — overwrite <code>AuditLive.render/1</code> with the component under test.</p>
    </div>
    """
  end
end
