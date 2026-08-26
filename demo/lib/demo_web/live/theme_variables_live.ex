defmodule DemoWeb.Live.ThemeVariablesLive do
  use DemoWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, page_title: "Theme Variables")}
  end

  def render(assigns) do
    ~H"""
    <.paragraph class="mb-6">CSS custom properties that control the entire Pure Admin appearance. Override these in your theme to customize everything.</.paragraph>

    <.card title_text="Core Colors">
      <.table rows={[
        %{var: "--accent-color", desc: "Primary accent color used for interactive elements, links, active states"},
        %{var: "--accent-color-hover", desc: "Accent hover state"},
        %{var: "--accent-color-active", desc: "Accent active/pressed state"},
        %{var: "--base-text-color", desc: "Default body text color"},
        %{var: "--base-text-color-2", desc: "Secondary/muted text color"},
        %{var: "--base-bg-color", desc: "Page background"},
        %{var: "--base-bg-color-2", desc: "Alternate background (cards, panels)"},
        %{var: "--base-border-color", desc: "Default border color"}
      ]} is_striped>
        <:col :let={row} label="Variable"><code>{row.var}</code></:col>
        <:col :let={row} label="Description">{row.desc}</:col>
      </.table>
    </.card>

    <.card title_text="Semantic State Colors">
      <.table rows={[
        %{var: "--base-success-color", desc: "Success/positive actions and states"},
        %{var: "--base-warning-color", desc: "Warning/caution states"},
        %{var: "--base-danger-color", desc: "Danger/error/destructive states"},
        %{var: "--base-info-color", desc: "Informational states"},
        %{var: "--base-primary-color", desc: "Primary brand color"},
        %{var: "--base-secondary-color", desc: "Secondary/neutral color"}
      ]} is_striped>
        <:col :let={row} label="Variable"><code>{row.var}</code></:col>
        <:col :let={row} label="Description">{row.desc}</:col>
      </.table>
    </.card>

    <.card title_text="Theme Color Slots (1-9)">
      <:description>Nine customizable color slots for branding. Each slot auto-generates contrasting text.</:description>
      <.table rows={[
        %{var: "--base-color-1", desc: "Theme color 1 (used by pa-card--color-1, etc.)"},
        %{var: "--base-color-2", desc: "Theme color 2"},
        %{var: "--base-color-3", desc: "Theme color 3"},
        %{var: "--base-color-4", desc: "Theme color 4"},
        %{var: "--base-color-5", desc: "Theme color 5"},
        %{var: "--base-color-6", desc: "Theme color 6"},
        %{var: "--base-color-7", desc: "Theme color 7"},
        %{var: "--base-color-8", desc: "Theme color 8"},
        %{var: "--base-color-9", desc: "Theme color 9"}
      ]} is_striped>
        <:col :let={row} label="Variable"><code>{row.var}</code></:col>
        <:col :let={row} label="Description">{row.desc}</:col>
      </.table>
    </.card>

    <.card title_text="Layout & Structure">
      <.table rows={[
        %{var: "--pa-header-bg", desc: "Navbar background"},
        %{var: "--pa-header-text", desc: "Navbar text color"},
        %{var: "--pa-sidebar-bg", desc: "Sidebar background"},
        %{var: "--pa-sidebar-text", desc: "Sidebar text color"},
        %{var: "--pa-sidebar-width", desc: "Sidebar width (default: 26rem)"},
        %{var: "--pa-sidebar-collapsed-width", desc: "Sidebar icon-only width"},
        %{var: "--pa-footer-bg", desc: "Footer background"},
        %{var: "--pa-footer-text", desc: "Footer text color"},
        %{var: "--pa-bg-light", desc: "Subtle tinted background for panels"}
      ]} is_striped>
        <:col :let={row} label="Variable"><code>{row.var}</code></:col>
        <:col :let={row} label="Description">{row.desc}</:col>
      </.table>
    </.card>

    <.card title_text="Typography">
      <.table rows={[
        %{var: "--base-font-family", desc: "Default font stack"},
        %{var: "--base-font-size", desc: "Root font size (default: 10px for rem scaling)"},
        %{var: "--base-line-height", desc: "Default line height"},
        %{var: "--heading-font-family", desc: "Heading font (falls back to base)"}
      ]} is_striped>
        <:col :let={row} label="Variable"><code>{row.var}</code></:col>
        <:col :let={row} label="Description">{row.desc}</:col>
      </.table>
    </.card>

    <.card title_text="Spacing Scale">
      <.table rows={[
        %{var: "--spacing-xs", value: "0.4rem", desc: "Extra small"},
        %{var: "--spacing-sm", value: "0.8rem", desc: "Small"},
        %{var: "--spacing-base", value: "1.6rem", desc: "Base (default)"},
        %{var: "--spacing-lg", value: "2.4rem", desc: "Large"},
        %{var: "--spacing-xl", value: "3.2rem", desc: "Extra large"},
        %{var: "--spacing-2xl", value: "4.8rem", desc: "2X large"}
      ]} is_striped>
        <:col :let={row} label="Variable"><code>{row.var}</code></:col>
        <:col :let={row} label="Default">{row.value}</:col>
        <:col :let={row} label="Description">{row.desc}</:col>
      </.table>
    </.card>

    <.card title_text="Component Variables">
      <.table rows={[
        %{var: "--pa-card-bg", desc: "Card background"},
        %{var: "--pa-card-border", desc: "Card border color"},
        %{var: "--pa-card-shadow", desc: "Card box shadow"},
        %{var: "--pa-card-radius", desc: "Card border radius"},
        %{var: "--pa-input-bg", desc: "Input background"},
        %{var: "--pa-input-border", desc: "Input border color"},
        %{var: "--pa-input-focus-border", desc: "Input focus border color"},
        %{var: "--pa-table-border", desc: "Table border color"},
        %{var: "--pa-table-stripe-bg", desc: "Table striped row background"},
        %{var: "--pa-table-hover-bg", desc: "Table hover row background"},
        %{var: "--pa-modal-bg", desc: "Modal backdrop color"},
        %{var: "--pa-tooltip-bg", desc: "Tooltip background"},
        %{var: "--pa-tooltip-text", desc: "Tooltip text color"}
      ]} is_striped>
        <:col :let={row} label="Variable"><code>{row.var}</code></:col>
        <:col :let={row} label="Description">{row.desc}</:col>
      </.table>
    </.card>

    <.callout variant="info">
      <:title>Overriding Variables</:title>
      Create a custom theme by overriding these variables in your CSS. Use <code>:root</code> for global overrides or scope to <code>.pc-mode-light</code> / <code>.pc-mode-dark</code> for mode-specific values.
    </.callout>
    """
  end
end
