defmodule DemoWeb.Live.CalloutsLive do
  use DemoWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, page_title: "Callouts")}
  end

  def render(assigns) do
    ~H"""
    <h1 class="pa-page-title">Callouts</h1>
    <p class="pa-page-subtitle">Callout boxes for highlighting important information.</p>

    <.card title_text="Callout Variants">
      <div style="display: flex; flex-direction: column; gap: 16px;">
        <.callout variant="info" heading_text="Information">
          This is an informational callout. Use it to draw attention to helpful tips or additional context.
        </.callout>

        <.callout variant="success" heading_text="Success">
          This is a success callout. Great for positive feedback or confirming successful actions.
        </.callout>

        <.callout variant="warning" heading_text="Warning">
          This is a warning callout. Use it to alert users about potential issues or things to be careful about.
        </.callout>

        <.callout variant="danger" heading_text="Danger">
          This is a danger callout. Reserve it for critical information that requires immediate attention.
        </.callout>
      </div>
    </.card>

    <.card title_text="Callouts with Icons">
      <div style="display: flex; flex-direction: column; gap: 16px;">
        <.callout variant="info" heading_text="Tip">
          <:icon><i class="fa-solid fa-lightbulb"></i></:icon>
          When an icon is provided, the content is automatically wrapped and laid out alongside the icon.
        </.callout>

        <.callout variant="warning" heading_text="Caution">
          <:icon><i class="fa-solid fa-triangle-exclamation"></i></:icon>
          This callout uses an icon to draw additional attention to the warning message.
        </.callout>
      </div>
    </.card>

    <.card title_text="Callout Sizes">
      <div style="display: flex; flex-direction: column; gap: 16px;">
        <.callout variant="info" size="sm" heading_text="Small Callout">
          A compact callout for brief messages.
        </.callout>

        <.callout variant="info" heading_text="Default Callout">
          A standard-sized callout for regular messages.
        </.callout>

        <.callout variant="info" size="lg" heading_text="Large Callout">
          A larger callout for more prominent messages.
        </.callout>
      </div>
    </.card>

    <.card title_text="Callout Without Title">
      <.callout variant="info">
        A callout without a title can be used for simpler informational messages that don't need a heading.
      </.callout>
    </.card>
    """
  end
end
