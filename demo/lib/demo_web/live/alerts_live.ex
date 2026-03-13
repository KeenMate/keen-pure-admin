defmodule DemoWeb.Live.AlertsLive do
  use DemoWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, page_title: "Alerts")}
  end

  def render(assigns) do
    ~H"""
    <h1 class="pa-page-title">Alerts</h1>
    <p class="pa-page-subtitle">
      Contextual feedback messages for typical user actions with flexible alert messages.
    </p>

    <%!-- Basic Alerts --%>
    <.card title_text="Basic Alerts">
      <div style="display: flex; flex-direction: column; gap: 12px;">
        <.alert variant="primary">This is a primary alert — check it out!</.alert>
        <.alert variant="secondary">This is a secondary alert — check it out!</.alert>
        <.alert variant="success">This is a success alert — check it out!</.alert>
        <.alert variant="danger">This is a danger alert — check it out!</.alert>
        <.alert variant="warning">This is a warning alert — check it out!</.alert>
        <.alert variant="info">This is an info alert — check it out!</.alert>
        <.alert variant="light">This is a light alert — check it out!</.alert>
        <.alert variant="dark">This is a dark alert — check it out!</.alert>
      </div>
    </.card>

    <%!-- Alerts with Icons --%>
    <.card title_text="Alerts with Icons">
      <div style="display: flex; flex-direction: column; gap: 12px;">
        <.alert variant="success">
          <:icon><i class="fa-solid fa-circle-check"></i></:icon>
          Operation completed successfully!
        </.alert>
        <.alert variant="danger">
          <:icon><i class="fa-solid fa-circle-exclamation"></i></:icon>
          An error occurred while processing your request.
        </.alert>
        <.alert variant="warning">
          <:icon><i class="fa-solid fa-triangle-exclamation"></i></:icon>
          Please review your input before continuing.
        </.alert>
        <.alert variant="info">
          <:icon><i class="fa-solid fa-circle-info"></i></:icon>
          A new software update is available for download.
        </.alert>
      </div>
    </.card>

    <%!-- Dismissible Alerts --%>
    <.card title_text="Dismissible Alerts">
      <div style="display: flex; flex-direction: column; gap: 12px;">
        <.alert id="dismiss-success" variant="success" is_dismissible>
          <:icon><i class="fa-solid fa-circle-check"></i></:icon>
          Your changes have been saved successfully!
        </.alert>
        <.alert id="dismiss-danger" variant="danger" is_dismissible>
          <:icon><i class="fa-solid fa-circle-exclamation"></i></:icon>
          Failed to delete the record. Please try again.
        </.alert>
        <.alert id="dismiss-warning" variant="warning" is_dismissible>
          <:icon><i class="fa-solid fa-triangle-exclamation"></i></:icon>
          Your session will expire in 5 minutes.
        </.alert>
        <.alert id="dismiss-info" variant="info" is_dismissible>
          <:icon><i class="fa-solid fa-circle-info"></i></:icon>
          New features are available. Check the changelog.
        </.alert>
      </div>
    </.card>

    <%!-- Alerts with Additional Content --%>
    <.grid>
      <.column size="50">
        <.card title_text="Alert with Rich Content">
          <.alert variant="success">
            <:heading>Well done!</:heading>
            <p>
              You have successfully completed the setup process. Your account is now active and ready to use.
            </p>
            <hr style="margin: 8px 0; opacity: 0.3;" />
            <p style="margin: 0;">Whenever you need to, be sure to check back for updates.</p>
          </.alert>
        </.card>
      </.column>
      <.column size="50">
        <.card title_text="Alert with Actions">
          <.alert variant="info">
            <:icon><i class="fa-solid fa-circle-info"></i></:icon>
            <:heading>System Update</:heading>
            <p>A new system update is available with the following improvements:</p>
            <ul style="margin: 8px 0; padding-left: 20px;">
              <li>Performance improvements</li>
              <li>Bug fixes</li>
              <li>New features</li>
            </ul>
            <:actions>
              <.button variant="info" size="sm">Update Now</.button>
              <.button variant="light" size="sm">Remind Me Later</.button>
            </:actions>
          </.alert>
        </.card>
      </.column>
    </.grid>

    <%!-- Outline Alerts --%>
    <.card title_text="Outline Alerts">
      <div style="display: flex; flex-direction: column; gap: 12px;">
        <.alert variant="primary" is_outline>This is an outline primary alert.</.alert>
        <.alert variant="success" is_outline>This is an outline success alert.</.alert>
        <.alert variant="danger" is_outline>This is an outline danger alert.</.alert>
        <.alert variant="warning" is_outline>This is an outline warning alert.</.alert>
        <.alert variant="info" is_outline>This is an outline info alert.</.alert>
      </div>
    </.card>

    <%!-- Compact Alerts --%>
    <.card title_text="Compact Alerts in Grid">
      <.grid>
        <.column size="33">
          <.alert variant="success" size="sm">
            <:icon><i class="fa-solid fa-check"></i></:icon>
            Saved
          </.alert>
        </.column>
        <.column size="33">
          <.alert variant="warning" size="sm">
            <:icon><i class="fa-solid fa-exclamation"></i></:icon>
            Pending
          </.alert>
        </.column>
        <.column size="33">
          <.alert variant="danger" size="sm">
            <:icon><i class="fa-solid fa-xmark"></i></:icon>
            Failed
          </.alert>
        </.column>
      </.grid>
    </.card>
    """
  end
end
