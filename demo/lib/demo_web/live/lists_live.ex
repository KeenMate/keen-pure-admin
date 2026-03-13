defmodule DemoWeb.Live.ListsLive do
  use DemoWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, page_title: "Lists")}
  end

  def render(assigns) do
    ~H"""
    <h1 class="pa-page-title">Lists</h1>
    <p class="pa-page-subtitle">Various list styles for displaying collections of items.</p>

    <.grid>
      <.column size="33">
        <.card title_text="Basic List">
          <.list>
            <.list_item>First item</.list_item>
            <.list_item>Second item</.list_item>
            <.list_item>Third item</.list_item>
            <.list_item>Fourth item</.list_item>
          </.list>
        </.card>
      </.column>
      <.column size="33">
        <.card title_text="Bordered List">
          <.list is_bordered>
            <.list_item>First item</.list_item>
            <.list_item>Second item</.list_item>
            <.list_item>Third item</.list_item>
            <.list_item>Fourth item</.list_item>
          </.list>
        </.card>
      </.column>
      <.column size="33">
        <.card title_text="List with Icons">
          <.list is_bordered>
            <.list_item>
              <i class="fa-solid fa-check" style="color: var(--pa-success); margin-right: 8px;"></i>
              Completed task
            </.list_item>
            <.list_item>
              <i class="fa-solid fa-clock" style="color: var(--pa-warning); margin-right: 8px;"></i>
              Pending review
            </.list_item>
            <.list_item>
              <i class="fa-solid fa-xmark" style="color: var(--pa-danger); margin-right: 8px;"></i>
              Failed build
            </.list_item>
            <.list_item>
              <i class="fa-solid fa-info" style="color: var(--pa-info); margin-right: 8px;"></i>
              Information
            </.list_item>
          </.list>
        </.card>
      </.column>
    </.grid>

    <.card title_text="List with Actions">
      <.list is_bordered>
        <.list_item>
          <div style="display: flex; justify-content: space-between; align-items: center; width: 100%;">
            <span>Project Alpha</span>
            <.badge variant="success" size="sm">Active</.badge>
          </div>
        </.list_item>
        <.list_item>
          <div style="display: flex; justify-content: space-between; align-items: center; width: 100%;">
            <span>Project Beta</span>
            <.badge variant="warning" size="sm">In Progress</.badge>
          </div>
        </.list_item>
        <.list_item>
          <div style="display: flex; justify-content: space-between; align-items: center; width: 100%;">
            <span>Project Gamma</span>
            <.badge variant="secondary" size="sm">Archived</.badge>
          </div>
        </.list_item>
      </.list>
    </.card>
    """
  end
end
