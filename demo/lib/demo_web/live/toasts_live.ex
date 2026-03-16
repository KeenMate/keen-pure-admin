defmodule DemoWeb.Live.ToastsLive do
  use DemoWeb, :live_view

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
      toasts: [],
      toast_counter: 0
    )}
  end

  def handle_event("add_toast", params, socket) do
    variant = params["variant"] || "info"
    position = params["position"] || "top-end"
    duration = String.to_integer(params["duration"] || "5000")
    title = params["title"] || @toast_messages[variant].title
    message = params["message"] || @toast_messages[variant].message

    id = "toast-#{socket.assigns.toast_counter}"

    toast = %{
      id: id,
      variant: variant,
      title: title,
      message: message,
      position: position
    }

    toasts = socket.assigns.toasts ++ [toast]

    socket = assign(socket, toasts: toasts, toast_counter: socket.assigns.toast_counter + 1)

    # Auto-dismiss after duration (unless persistent)
    if duration > 0 do
      Process.send_after(self(), {:dismiss_toast, id}, duration)
    end

    {:noreply, socket}
  end

  def handle_event("dismiss_toast", %{"id" => id}, socket) do
    toasts = Enum.reject(socket.assigns.toasts, &(&1.id == id))
    {:noreply, assign(socket, :toasts, toasts)}
  end

  def handle_event("show_multiple", _params, socket) do
    base_id = socket.assigns.toast_counter

    new_toasts = [
      %{id: "toast-#{base_id}", variant: "success", title: "First Toast", message: "This is the first notification", position: "top-end"},
      %{id: "toast-#{base_id + 1}", variant: "warning", title: "Second Toast", message: "This is the second notification", position: "top-end"},
      %{id: "toast-#{base_id + 2}", variant: "info", title: "Third Toast", message: "This is the third notification", position: "top-end"}
    ]

    toasts = socket.assigns.toasts ++ new_toasts

    for t <- new_toasts do
      Process.send_after(self(), {:dismiss_toast, t.id}, 5000)
    end

    {:noreply, assign(socket, toasts: toasts, toast_counter: base_id + 3)}
  end

  def handle_info({:dismiss_toast, id}, socket) do
    toasts = Enum.reject(socket.assigns.toasts, &(&1.id == id))
    {:noreply, assign(socket, :toasts, toasts)}
  end

  defp toasts_for(toasts, position) do
    Enum.filter(toasts, &(&1.position == position))
  end

  def render(assigns) do
    ~H"""
    <.paragraph>Temporary notification messages that auto-dismiss with smooth animations.</.paragraph>

    <%!-- Toast Containers for each position --%>
    <.toast_container :if={toasts_for(@toasts, "top-end") != []} position="top-end">
      <.toast :for={t <- toasts_for(@toasts, "top-end")} id={t.id} variant={t.variant} title_text={t.title} message_text={t.message} on_close="dismiss_toast" />
    </.toast_container>
    <.toast_container :if={toasts_for(@toasts, "top-center") != []} position="top-center">
      <.toast :for={t <- toasts_for(@toasts, "top-center")} id={t.id} variant={t.variant} title_text={t.title} message_text={t.message} on_close="dismiss_toast" />
    </.toast_container>
    <.toast_container :if={toasts_for(@toasts, "top-start") != []} position="top-start">
      <.toast :for={t <- toasts_for(@toasts, "top-start")} id={t.id} variant={t.variant} title_text={t.title} message_text={t.message} on_close="dismiss_toast" />
    </.toast_container>
    <.toast_container :if={toasts_for(@toasts, "bottom-end") != []} position="bottom-end">
      <.toast :for={t <- toasts_for(@toasts, "bottom-end")} id={t.id} variant={t.variant} title_text={t.title} message_text={t.message} on_close="dismiss_toast" />
    </.toast_container>
    <.toast_container :if={toasts_for(@toasts, "bottom-center") != []} position="bottom-center">
      <.toast :for={t <- toasts_for(@toasts, "bottom-center")} id={t.id} variant={t.variant} title_text={t.title} message_text={t.message} on_close="dismiss_toast" />
    </.toast_container>
    <.toast_container :if={toasts_for(@toasts, "bottom-start") != []} position="bottom-start">
      <.toast :for={t <- toasts_for(@toasts, "bottom-start")} id={t.id} variant={t.variant} title_text={t.title} message_text={t.message} on_close="dismiss_toast" />
    </.toast_container>

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
          <.button variant="danger" is_block phx-click="add_toast" phx-value-variant="danger" phx-value-duration="0" phx-value-title="Critical Error" phx-value-message="Critical error detected! This message will remain until you acknowledge it.">
            Critical Error
          </.button>
        </.column>
        <.column size="100" md="1-3">
          <.button variant="info" is_block phx-click="add_toast" phx-value-variant="info" phx-value-duration="0" phx-value-title="Important Info" phx-value-message="Important information that you should read carefully before dismissing.">
            Important Info
          </.button>
        </.column>
      </.grid>
      <.paragraph class="pa-text--secondary mt-4">
        These toasts stay visible until manually dismissed by clicking the close button
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
    """
  end
end
