defmodule DemoWeb.Live.BadgesLive do
  use DemoWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, page_title: "Badges")}
  end

  def render(assigns) do
    ~H"""
    <h1 class="pa-page-title">Badges</h1>
    <p class="pa-page-subtitle">Badges, labels, and composite badges for status display.</p>

    <%!-- Basic Badges --%>
    <.grid>
      <.column size="50">
        <.card title_text="Basic Badges">
          <div style="display: flex; gap: 8px; flex-wrap: wrap;">
            <.badge>Default</.badge>
            <.badge variant="primary">Primary</.badge>
            <.badge variant="secondary">Secondary</.badge>
            <.badge variant="success">Success</.badge>
            <.badge variant="warning">Warning</.badge>
            <.badge variant="danger">Danger</.badge>
            <.badge variant="info">Info</.badge>
            <.badge variant="light">Light</.badge>
            <.badge variant="dark">Dark</.badge>
          </div>
        </.card>
      </.column>
      <.column size="50">
        <.card title_text="Small Badges">
          <div style="display: flex; gap: 8px; flex-wrap: wrap;">
            <.badge size="sm">Default</.badge>
            <.badge variant="primary" size="sm">Primary</.badge>
            <.badge variant="secondary" size="sm">Secondary</.badge>
            <.badge variant="success" size="sm">Success</.badge>
            <.badge variant="warning" size="sm">Warning</.badge>
            <.badge variant="danger" size="sm">Danger</.badge>
            <.badge variant="info" size="sm">Info</.badge>
          </div>
        </.card>
      </.column>
    </.grid>

    <%!-- Pill Badges --%>
    <.grid>
      <.column size="50">
        <.card title_text="Pill Badges">
          <div style="display: flex; gap: 8px; flex-wrap: wrap;">
            <.badge variant="primary" is_pill>Primary</.badge>
            <.badge variant="secondary" is_pill>Secondary</.badge>
            <.badge variant="success" is_pill>Success</.badge>
            <.badge variant="warning" is_pill>Warning</.badge>
            <.badge variant="danger" is_pill>Danger</.badge>
            <.badge variant="info" is_pill>Info</.badge>
          </div>
        </.card>
      </.column>
      <.column size="50">
        <.card title_text="Small Pill Badges">
          <div style="display: flex; gap: 8px; flex-wrap: wrap;">
            <.badge variant="primary" is_pill size="sm">Primary</.badge>
            <.badge variant="secondary" is_pill size="sm">Secondary</.badge>
            <.badge variant="success" is_pill size="sm">Success</.badge>
            <.badge variant="warning" is_pill size="sm">Warning</.badge>
            <.badge variant="danger" is_pill size="sm">Danger</.badge>
            <.badge variant="info" is_pill size="sm">Info</.badge>
          </div>
        </.card>
      </.column>
    </.grid>

    <%!-- Badges with Icons --%>
    <.card title_text="Badges with Icons">
      <div style="display: flex; gap: 8px; flex-wrap: wrap;">
        <.badge variant="success"><i class="fa-solid fa-check"></i> Approved</.badge>
        <.badge variant="danger"><i class="fa-solid fa-xmark"></i> Rejected</.badge>
        <.badge variant="warning"><i class="fa-solid fa-exclamation"></i> Pending</.badge>
        <.badge variant="info"><i class="fa-solid fa-info"></i> Info</.badge>
        <.badge variant="primary"><i class="fa-solid fa-star"></i> Featured</.badge>
        <.badge variant="secondary"><i class="fa-solid fa-clock"></i> Scheduled</.badge>
      </div>
    </.card>

    <%!-- Labels --%>
    <.grid>
      <.column size="50">
        <.card title_text="Labels">
          <div style="display: flex; gap: 8px; flex-wrap: wrap;">
            <.label variant="primary">Frontend</.label>
            <.label variant="success">React</.label>
            <.label variant="info">TypeScript</.label>
            <.label variant="danger">Bug Fix</.label>
            <.label variant="warning">Enhancement</.label>
            <.label variant="secondary">Documentation</.label>
          </div>
        </.card>
      </.column>
      <.column size="50">
        <.card title_text="Outline Labels">
          <div style="display: flex; gap: 8px; flex-wrap: wrap;">
            <.label variant="primary" is_outline>Frontend</.label>
            <.label variant="success" is_outline>React</.label>
            <.label variant="info" is_outline>TypeScript</.label>
            <.label variant="danger" is_outline>Bug Fix</.label>
            <.label variant="warning" is_outline>Enhancement</.label>
            <.label variant="secondary" is_outline>Documentation</.label>
          </div>
        </.card>
      </.column>
    </.grid>

    <%!-- Composite Badges --%>
    <.card title_text="Composite Badges">
      <div style="display: flex; gap: 8px; flex-wrap: wrap;">
        <.composite_badge label="Category" count="Frontend" variant="primary" />
        <.composite_badge label="Status" count="Active" variant="success" />
        <.composite_badge label="Priority" count="High" variant="warning" />
        <.composite_badge label="Type" count="Bug" variant="danger" />
        <.composite_badge label="Version" count="v2.1.0" variant="info" />
      </div>
    </.card>

    <%!-- Badge Group --%>
    <.card title_text="Badge Groups">
      <.badge_group>
        <.badge variant="primary">React</.badge>
        <.badge variant="success">TypeScript</.badge>
        <.badge variant="info">Node.js</.badge>
        <.badge variant="warning">Python</.badge>
        <.badge variant="danger">Rust</.badge>
        <.badge variant="secondary">Go</.badge>
        <.badge variant="dark">Elixir</.badge>
      </.badge_group>
    </.card>
    """
  end
end
