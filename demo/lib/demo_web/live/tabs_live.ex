defmodule DemoWeb.Live.TabsLive do
  use DemoWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, page_title: "Tabs")}
  end

  def render(assigns) do
    ~H"""
    <h1 class="pa-page-title">Tabs</h1>
    <p class="pa-page-subtitle">Tab navigation for organizing content into sections.</p>

    <%!-- Basic Tabs --%>
    <.card title_text="Basic Tabs">
      <.tabs id="basic-tabs">
        <.tab_item target="basic-1" is_active>Tab 1</.tab_item>
        <.tab_item target="basic-2">Tab 2</.tab_item>
        <.tab_item target="basic-3">Tab 3</.tab_item>
      </.tabs>
      <.tabs_content>
        <.tab_panel id="basic-1" is_active>
          <h4>Tab 1 Content</h4>
          <p>
            This is the content for the first tab. Tabs are a great way to organize related content into sections.
          </p>
        </.tab_panel>
        <.tab_panel id="basic-2">
          <h4>Tab 2 Content</h4>
          <p>
            This is the content for the second tab. Each tab panel can contain any type of content.
          </p>
        </.tab_panel>
        <.tab_panel id="basic-3">
          <h4>Tab 3 Content</h4>
          <p>
            This is the content for the third tab. Click on the tabs above to switch between panels.
          </p>
        </.tab_panel>
      </.tabs_content>
    </.card>

    <%!-- Tab Variants --%>
    <.grid>
      <.column size="50">
        <.card title_text="Pill Tabs">
          <.tabs id="pill-tabs" style="pills">
            <.tab_item target="pill-1" is_active>Home</.tab_item>
            <.tab_item target="pill-2">Profile</.tab_item>
            <.tab_item target="pill-3">Settings</.tab_item>
          </.tabs>
          <.tabs_content>
            <.tab_panel id="pill-1" is_active>Home content with pill-style tabs.</.tab_panel>
            <.tab_panel id="pill-2">Profile content.</.tab_panel>
            <.tab_panel id="pill-3">Settings content.</.tab_panel>
          </.tabs_content>
        </.card>
      </.column>
      <.column size="50">
        <.card title_text="Boxed Tabs">
          <.tabs id="boxed-tabs" style="boxed">
            <.tab_item target="boxed-1" is_active>Overview</.tab_item>
            <.tab_item target="boxed-2">Details</.tab_item>
            <.tab_item target="boxed-3">History</.tab_item>
          </.tabs>
          <.tabs_content>
            <.tab_panel id="boxed-1" is_active>Overview content with boxed-style tabs.</.tab_panel>
            <.tab_panel id="boxed-2">Details content.</.tab_panel>
            <.tab_panel id="boxed-3">History content.</.tab_panel>
          </.tabs_content>
        </.card>
      </.column>
    </.grid>

    <%!-- Vertical Tabs --%>
    <.card title_text="Vertical Tabs">
      <.tabs_vertical_layout>
        <.tabs id="vertical-tabs" style="vertical">
          <.tab_item target="vert-1" is_active>General</.tab_item>
          <.tab_item target="vert-2">Security</.tab_item>
          <.tab_item target="vert-3">Notifications</.tab_item>
          <.tab_item target="vert-4">Integrations</.tab_item>
        </.tabs>
        <.tabs_content>
          <.tab_panel id="vert-1" is_active>
            <h4>General Settings</h4>
            <p>
              Configure your general application settings here. This includes display name, language, timezone, and other preferences.
            </p>
          </.tab_panel>
          <.tab_panel id="vert-2">
            <h4>Security Settings</h4>
            <p>
              Manage your security settings including password, two-factor authentication, and session management.
            </p>
          </.tab_panel>
          <.tab_panel id="vert-3">
            <h4>Notification Preferences</h4>
            <p>
              Control which notifications you receive and how they are delivered (email, push, in-app).
            </p>
          </.tab_panel>
          <.tab_panel id="vert-4">
            <h4>Integrations</h4>
            <p>Connect and manage third-party integrations like Slack, GitHub, and Jira.</p>
          </.tab_panel>
        </.tabs_content>
      </.tabs_vertical_layout>
    </.card>

    <%!-- Tabs with Border Top --%>
    <.card title_text="Border Top Tabs">
      <.tabs id="border-tabs" style="border-top">
        <.tab_item target="bt-1" is_active>Dashboard</.tab_item>
        <.tab_item target="bt-2">Analytics</.tab_item>
        <.tab_item target="bt-3">Reports</.tab_item>
      </.tabs>
      <.tabs_content>
        <.tab_panel id="bt-1" is_active>Dashboard content with border-top style tabs.</.tab_panel>
        <.tab_panel id="bt-2">Analytics data and charts would go here.</.tab_panel>
        <.tab_panel id="bt-3">Reports listing and generation options.</.tab_panel>
      </.tabs_content>
    </.card>
    """
  end
end
