defmodule DemoWeb.Live.LoadersLive do
  use DemoWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, page_title: "Loaders")}
  end

  def render(assigns) do
    ~H"""
    <h1 class="pa-page-title">Loaders</h1>
    <p class="pa-page-subtitle">Loading indicators and spinner components.</p>

    <.card title_text="Spinner Sizes">
      <div style="display: flex; gap: 24px; align-items: center;">
        <div style="text-align: center;">
          <.spinner size="sm" />
          <p style="margin-top: 8px; font-size: 0.875rem;">Small</p>
        </div>
        <div style="text-align: center;">
          <.spinner />
          <p style="margin-top: 8px; font-size: 0.875rem;">Default</p>
        </div>
        <div style="text-align: center;">
          <.spinner size="lg" />
          <p style="margin-top: 8px; font-size: 0.875rem;">Large</p>
        </div>
      </div>
    </.card>

    <.card title_text="Loader Overlay">
      <div style="position: relative; min-height: 200px; background: var(--pa-bg-light, #f5f5f5); border-radius: 4px;">
        <p style="padding: 16px;">This content is behind the loader overlay.</p>
        <.loader_overlay>Loading data...</.loader_overlay>
      </div>
    </.card>

    <.card title_text="Button Loading States">
      <div style="display: flex; gap: 8px; flex-wrap: wrap;">
        <.button variant="primary" is_loading>Saving...</.button>
        <.button variant="success" is_loading>Processing...</.button>
        <.button variant="danger" is_loading>Deleting...</.button>
      </div>
    </.card>
    """
  end
end
