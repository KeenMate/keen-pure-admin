defmodule DemoWeb.Live.AlertsLive do
  use DemoWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, page_title: "Alerts")}
  end

  def render(assigns) do
    ~H"""
    <.paragraph>Contextual feedback messages for typical user actions with flexible alert messages.</.paragraph>

    <%!-- Basic Alerts --%>
    <.card title_text="Basic Alerts">
      <.alert variant="primary">
        <strong>Primary!</strong> This is a primary alert — check it out!
      </.alert>
      <.alert variant="secondary">
        <strong>Secondary!</strong> This is a secondary alert — check it out!
      </.alert>
      <.alert variant="success">
        <strong>Success!</strong> This is a success alert — your operation completed successfully.
      </.alert>
      <.alert variant="danger">
        <strong>Danger!</strong> This is a danger alert — something went wrong!
      </.alert>
      <.alert variant="warning">
        <strong>Warning!</strong> This is a warning alert — please review before proceeding.
      </.alert>
      <.alert variant="info">
        <strong>Info!</strong> This is an info alert — here's some useful information.
      </.alert>
      <.alert variant="light">
        <strong>Light!</strong> This is a light alert — subtle but important.
      </.alert>
      <.alert variant="dark">
        <strong>Dark!</strong> This is a dark alert — for high contrast messaging.
      </.alert>
    </.card>

    <%!-- Alerts with Icons --%>
    <.card title_text="Alerts with Icons">
      <.alert variant="success">
        <:icon>✓</:icon>
        <strong>Success!</strong> Your changes have been saved successfully.
      </.alert>
      <.alert variant="danger">
        <:icon>⚠</:icon>
        <strong>Error!</strong> Unable to process your request. Please try again.
      </.alert>
      <.alert variant="warning">
        <:icon>!</:icon>
        <strong>Warning!</strong> Your session will expire in 5 minutes.
      </.alert>
      <.alert variant="info">
        <:icon>ⓘ</:icon>
        <strong>Information!</strong> New features are now available in your account.
      </.alert>
    </.card>

    <%!-- Dismissible Alerts --%>
    <.card title_text="Dismissible Alerts">
      <.alert id="dismiss-success" variant="success" is_dismissible>
        <strong>Well done!</strong> You successfully read this important alert message.
      </.alert>
      <.alert id="dismiss-danger" variant="danger" is_dismissible>
        <strong>Oh snap!</strong> Change a few things and try submitting again.
      </.alert>
      <.alert id="dismiss-warning" variant="warning" is_dismissible>
        <strong>Warning!</strong> Better check yourself, you're not looking too good.
      </.alert>
      <.alert id="dismiss-info" variant="info" is_dismissible>
        <strong>Heads up!</strong> This alert needs your attention, but it's not super important.
      </.alert>
    </.card>

    <%!-- Alerts with Additional Content --%>
    <.card title_text="Alerts with Additional Content">
      <.grid>
        <.column size="100" md="1-2">
          <.alert variant="success">
            <:heading>Success!</:heading>
            <.paragraph>
              Aww yeah, you successfully read this important alert message. This example text is
              going to run a bit longer so that you can see how spacing within an alert works with
              this kind of content.
            </.paragraph>
            <hr />
            <.paragraph class="mb-0">
              Whenever you need to, be sure to use margin utilities to keep things nice and tidy.
            </.paragraph>
          </.alert>
        </.column>

        <.column size="100" md="1-2">
          <.alert variant="info">
            <:heading>System Update</:heading>
            <.paragraph>A new version of the application is available. This update includes:</.paragraph>
            <.basic_list class="pa-alert__list">
              <li>Performance improvements</li>
              <li>Bug fixes</li>
              <li>New dashboard features</li>
            </.basic_list>
            <:actions>
              <.button variant="primary" size="sm">Update Now</.button>
              <.button variant="secondary" size="sm">Remind Me Later</.button>
            </:actions>
          </.alert>
        </.column>
      </.grid>
    </.card>

    <%!-- Outline Alerts --%>
    <.card title_text="Outline Alerts">
      <.alert is_outline variant="primary">
        <strong>Primary Outline!</strong> This is a primary outline alert.
      </.alert>
      <.alert is_outline variant="success">
        <strong>Success Outline!</strong> This is a success outline alert.
      </.alert>
      <.alert is_outline variant="danger">
        <strong>Danger Outline!</strong> This is a danger outline alert.
      </.alert>
      <.alert is_outline variant="warning">
        <strong>Warning Outline!</strong> This is a warning outline alert.
      </.alert>
      <.alert is_outline variant="info">
        <strong>Info Outline!</strong> This is an info outline alert.
      </.alert>
    </.card>

    <%!-- Compact Alerts in Grid --%>
    <.card title_text="Compact Alerts in Grid">
      <.grid>
        <.column size="100" md="1-3">
          <.alert size="sm" variant="success">
            <:icon>✓</:icon>
            Saved
          </.alert>
        </.column>
        <.column size="100" md="1-3">
          <.alert size="sm" variant="warning">
            <:icon>!</:icon>
            Pending
          </.alert>
        </.column>
        <.column size="100" md="1-3">
          <.alert size="sm" variant="danger">
            <:icon>×</:icon>
            Failed
          </.alert>
        </.column>
      </.grid>
    </.card>
    """
  end
end
