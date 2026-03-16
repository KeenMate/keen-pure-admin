defmodule DemoWeb.Live.ToastsLive do
  use DemoWeb, :live_view

  # push_toast is not a component function, so it's not in `use KPureAdmin.Components`
  # Import it directly without conflicting with the bulk component import
  alias KPureAdmin.Components.Toast, as: PureToast

  @toast_messages %{
    "primary" => %{title: "Primary", message: "This is a primary toast notification."},
    "success" => %{title: "Success!", message: "Your action was completed successfully."},
    "danger" => %{title: "Error", message: "An error occurred. Please try again."},
    "warning" => %{title: "Warning", message: "Please review this warning message."},
    "info" => %{title: "Information", message: "Here is some useful information for you."}
  }

  def mount(_params, _session, socket) do
    {:ok, assign(socket,
      page_title: "Toasts",
      code_server: ~s"""
      # In your LiveView
      socket |> PureToast.push_toast("success", "Saved!", "Changes saved.")
      socket |> PureToast.push_toast("danger", "Error", "Failed.", duration: 0)
      socket |> PureToast.push_toast("info", "Note", "FYI", position: "bottom-end")\
      """,
      code_template: ~s'<.toast_container id="toasts" position="top-end" is_hook />'
    )}
  end

  def handle_event("add_toast", params, socket) do
    variant = params["variant"] || "info"
    position = params["position"] || "top-end"
    duration = String.to_integer(params["duration"] || "5000")
    title = params["title"] || @toast_messages[variant].title
    message = params["message"] || @toast_messages[variant].message

    {:noreply, PureToast.push_toast(socket, variant, title, message, duration: duration, position: position)}
  end

  def handle_event("show_multiple", _params, socket) do
    socket =
      socket
      |> PureToast.push_toast("success", "First Toast", "This is the first notification")
      |> PureToast.push_toast("warning", "Second Toast", "This is the second notification")
      |> PureToast.push_toast("info", "Third Toast", "This is the third notification")

    {:noreply, socket}
  end

  def render(assigns) do
    ~H"""
    <.paragraph>Temporary notification messages that auto-dismiss. Toasts are rendered client-side via JS hook — the server pushes events, no round-trips for display/dismiss.</.paragraph>

    <%!-- Toast containers for each position (hook-based, client-side rendering) --%>
    <.toast_container id="toasts-top-end" position="top-end" is_hook />
    <.toast_container id="toasts-top-center" position="top-center" is_hook />
    <.toast_container id="toasts-top-start" position="top-start" is_hook />
    <.toast_container id="toasts-bottom-end" position="bottom-end" is_hook />
    <.toast_container id="toasts-bottom-center" position="bottom-center" is_hook />
    <.toast_container id="toasts-bottom-start" position="bottom-start" is_hook />

    <%!-- Toast Positions --%>
    <.card title_text="Toast Positions">
      <.grid>
        <.column size="100" md="1-3">
          <.button variant="primary" is_block phx-click="add_toast" phx-value-position="top-end" phx-value-variant="success">
            Top End
          </.button>
        </.column>
        <.column size="100" md="1-3">
          <.button variant="primary" is_block phx-click="add_toast" phx-value-position="top-center" phx-value-variant="info">
            Top Center
          </.button>
        </.column>
        <.column size="100" md="1-3">
          <.button variant="primary" is_block phx-click="add_toast" phx-value-position="top-start" phx-value-variant="warning">
            Top Start
          </.button>
        </.column>
      </.grid>
      <.grid class="mt-4">
        <.column size="100" md="1-3">
          <.button variant="secondary" is_block phx-click="add_toast" phx-value-position="bottom-end" phx-value-variant="danger">
            Bottom End
          </.button>
        </.column>
        <.column size="100" md="1-3">
          <.button variant="secondary" is_block phx-click="add_toast" phx-value-position="bottom-center" phx-value-variant="primary">
            Bottom Center
          </.button>
        </.column>
        <.column size="100" md="1-3">
          <.button variant="secondary" is_block phx-click="add_toast" phx-value-position="bottom-start" phx-value-variant="success">
            Bottom Start
          </.button>
        </.column>
      </.grid>
    </.card>

    <%!-- Toast Variants --%>
    <.card title_text="Toast Variants">
      <.button_group>
        <.button variant="primary" phx-click="add_toast" phx-value-variant="primary">Primary</.button>
        <.button variant="success" phx-click="add_toast" phx-value-variant="success">Success</.button>
        <.button variant="danger" phx-click="add_toast" phx-value-variant="danger">Danger</.button>
        <.button variant="warning" phx-click="add_toast" phx-value-variant="warning">Warning</.button>
        <.button variant="info" phx-click="add_toast" phx-value-variant="info">Info</.button>
      </.button_group>
    </.card>

    <%!-- Persistent Toasts --%>
    <.card title_text="Persistent Toasts (Manual Dismiss Only)">
      <.grid>
        <.column size="100" md="1-3">
          <.button variant="warning" is_block phx-click="add_toast" phx-value-variant="warning" phx-value-duration="0" phx-value-title="Important Warning" phx-value-message="This requires your attention. Click close to dismiss.">
            Important Warning
          </.button>
        </.column>
        <.column size="100" md="1-3">
          <.button variant="danger" is_block phx-click="add_toast" phx-value-variant="danger" phx-value-duration="0" phx-value-title="Critical Error" phx-value-message="Critical error detected! Will remain until acknowledged.">
            Critical Error
          </.button>
        </.column>
        <.column size="100" md="1-3">
          <.button variant="info" is_block phx-click="add_toast" phx-value-variant="info" phx-value-duration="0" phx-value-title="Important Info" phx-value-message="Read carefully before dismissing.">
            Important Info
          </.button>
        </.column>
      </.grid>
      <.paragraph class="pa-text--secondary mt-4">
        These toasts stay visible until manually dismissed by clicking the close button (duration=0)
      </.paragraph>
    </.card>

    <%!-- Action Toasts --%>
    <.card title_text="Action Toasts">
      <.grid>
        <.column size="100" md="50">
          <.button variant="success" phx-click="add_toast" phx-value-variant="success" phx-value-title="Upload Complete" phx-value-message="File uploaded successfully!">
            Upload Success
          </.button>
        </.column>
        <.column size="100" md="50">
          <.button variant="danger" phx-click="add_toast" phx-value-variant="danger" phx-value-title="Save Failed" phx-value-message="Failed to save changes. Please try again.">
            Save Error
          </.button>
        </.column>
      </.grid>
    </.card>

    <%!-- Multiple Toasts --%>
    <.card title_text="Multiple Toasts (Stacking)">
      <.button variant="primary" phx-click="show_multiple">
        Show 3 Toasts
      </.button>
      <.paragraph class="pa-text--secondary mt-4">
        Toasts automatically stack vertically in the container
      </.paragraph>
    </.card>

    <%!-- How it works --%>
    <.card title_text="How It Works">
      <.callout variant="info" heading_text="Architecture">
        <.paragraph>Toasts use a <strong>push_event</strong> pattern — the server decides <em>when</em> to show a toast, the client JS hook handles <em>rendering</em> and <em>auto-dismiss</em>. No server round-trips for display or dismissal.</.paragraph>
      </.callout>

      <.heading level={4} class="mt-4">Server (LiveView)</.heading>
      <.code_block language="elixir"><%= @code_server %></.code_block>

      <.heading level={4} class="mt-4">Template</.heading>
      <.code_block language="heex"><%= @code_template %></.code_block>
    </.card>
    """
  end
end
