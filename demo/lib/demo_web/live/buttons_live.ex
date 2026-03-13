defmodule DemoWeb.Live.ButtonsLive do
  use DemoWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, page_title: "Buttons", loading_btn: nil)}
  end

  def handle_event("toggle_loading", %{"btn" => btn}, socket) do
    Process.send_after(self(), {:stop_loading, btn}, Enum.random(1000..3000))
    {:noreply, assign(socket, :loading_btn, btn)}
  end

  def handle_info({:stop_loading, _btn}, socket) do
    {:noreply, assign(socket, :loading_btn, nil)}
  end

  def render(assigns) do
    ~H"""
    <h1 class="pa-page-title">Buttons</h1>
    <p class="pa-page-subtitle">Various button styles and sizes for actions and navigation.</p>

    <%!-- Button Variants --%>
    <.card title_text="Button Variants">
      <div style="display: flex; gap: 8px; flex-wrap: wrap;">
        <.button variant="primary">Primary</.button>
        <.button variant="secondary">Secondary</.button>
        <.button variant="success">Success</.button>
        <.button variant="warning">Warning</.button>
        <.button variant="danger">Danger</.button>
        <.button variant="info">Info</.button>
        <.button variant="light">Light</.button>
        <.button variant="dark">Dark</.button>
      </div>
    </.card>

    <%!-- Button Sizes --%>
    <.card title_text="Button Sizes">
      <div style="display: flex; gap: 8px; align-items: center; flex-wrap: wrap;">
        <.button variant="primary" size="xs">Extra Small</.button>
        <.button variant="primary" size="sm">Small</.button>
        <.button variant="primary">Default</.button>
        <.button variant="primary" size="lg">Large</.button>
        <.button variant="primary" size="xl">Extra Large</.button>
      </div>
    </.card>

    <%!-- Outline Buttons --%>
    <.card title_text="Outline Buttons">
      <div style="display: flex; gap: 8px; flex-wrap: wrap;">
        <.button variant="primary" is_outline>Primary</.button>
        <.button variant="secondary" is_outline>Secondary</.button>
        <.button variant="success" is_outline>Success</.button>
        <.button variant="warning" is_outline>Warning</.button>
        <.button variant="danger" is_outline>Danger</.button>
        <.button variant="info" is_outline>Info</.button>
      </div>
    </.card>

    <%!-- Button States --%>
    <.card title_text="Button States">
      <div style="display: flex; gap: 8px; flex-wrap: wrap; align-items: center;">
        <.button variant="primary">Normal</.button>
        <.button variant="primary" disabled>Disabled</.button>
        <.button variant="primary" is_loading>Loading</.button>
      </div>
    </.card>

    <%!-- Block Buttons --%>
    <.card title_text="Block Buttons">
      <div style="display: flex; flex-direction: column; gap: 8px;">
        <.button variant="primary" is_block>Block Primary</.button>
        <.button variant="secondary" is_block>Block Secondary</.button>
      </div>
    </.card>

    <%!-- Button Groups --%>
    <.grid>
      <.column size="33">
        <.card title_text="Button Group - Horizontal">
          <.button_group>
            <.button variant="secondary">Left</.button>
            <.button variant="secondary">Center</.button>
            <.button variant="secondary">Right</.button>
          </.button_group>
        </.card>
      </.column>
      <.column size="33">
        <.card title_text="Button Group - Vertical">
          <.button_group is_vertical>
            <.button variant="secondary">Top</.button>
            <.button variant="secondary">Middle</.button>
            <.button variant="secondary">Bottom</.button>
          </.button_group>
        </.card>
      </.column>
      <.column size="33">
        <.card title_text="Button Group - No Wrap">
          <.button_group is_nowrap>
            <.button variant="primary">Save</.button>
            <.button variant="secondary">Cancel</.button>
            <.button variant="danger">Delete</.button>
          </.button_group>
        </.card>
      </.column>
    </.grid>

    <%!-- Icon Only Buttons --%>
    <.card title_text="Icon Only Buttons">
      <div style="display: flex; gap: 8px; align-items: center; flex-wrap: wrap;">
        <.button variant="primary" is_icon_only size="xs" title="Add">
          <i class="fa-solid fa-plus"></i>
        </.button>
        <.button variant="success" is_icon_only size="sm" title="Check">
          <i class="fa-solid fa-check"></i>
        </.button>
        <.button variant="info" is_icon_only title="Edit">
          <i class="fa-solid fa-pen"></i>
        </.button>
        <.button variant="warning" is_icon_only size="lg" title="Warning">
          <i class="fa-solid fa-triangle-exclamation"></i>
        </.button>
        <.button variant="danger" is_icon_only size="xl" title="Delete">
          <i class="fa-solid fa-trash"></i>
        </.button>
      </div>
    </.card>

    <%!-- Ripple Effect Buttons --%>
    <.card title_text="Ripple Effect Buttons">
      <div style="display: flex; gap: 8px; flex-wrap: wrap;">
        <.button variant="primary" is_ripple>Primary</.button>
        <.button variant="success" is_ripple>Success</.button>
        <.button variant="warning" is_ripple>Warning</.button>
        <.button variant="danger" is_ripple>Danger</.button>
      </div>
    </.card>

    <%!-- Loading State Buttons --%>
    <.card title_text="Loading State Buttons">
      <p style="margin-bottom: 12px; opacity: 0.7;">
        Click a button to simulate loading (1-3 second random delay)
      </p>
      <div style="display: flex; gap: 8px; flex-wrap: wrap;">
        <.button
          variant="primary"
          is_loading={@loading_btn == "save"}
          phx-click="toggle_loading"
          phx-value-btn="save"
        >
          Save Changes
        </.button>
        <.button
          variant="success"
          is_loading={@loading_btn == "submit"}
          phx-click="toggle_loading"
          phx-value-btn="submit"
        >
          Submit
        </.button>
        <.button
          variant="info"
          is_loading={@loading_btn == "upload"}
          phx-click="toggle_loading"
          phx-value-btn="upload"
        >
          Upload
        </.button>
      </div>
    </.card>

    <%!-- Text Alignment --%>
    <.card title_text="Button Text Alignment">
      <div style="display: flex; flex-direction: column; gap: 8px; max-width: 300px;">
        <.button variant="secondary" is_block align="start">
          <:icon><i class="fa-solid fa-arrow-left"></i></:icon>
          Align Start
        </.button>
        <.button variant="secondary" is_block align="end">
          Align End
          <:icon><i class="fa-solid fa-arrow-right"></i></:icon>
        </.button>
        <.button variant="secondary" is_block align="center">Align Center</.button>
        <.button variant="secondary" is_block align="justify">Align Justify</.button>
      </div>
    </.card>
    """
  end
end
