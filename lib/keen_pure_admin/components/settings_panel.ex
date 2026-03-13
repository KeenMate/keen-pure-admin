defmodule KPureAdmin.Components.SettingsPanel do
  @moduledoc """
  Settings panel component for Pure Admin.

  Provides runtime-configurable settings for theme mode, layout width,
  sidebar behavior, display options, and font preferences. All settings
  persist to localStorage and are applied via JavaScript (the `PureAdminSettings` hook).

  ## Examples

      <.settings_panel />

      <.settings_panel themes={[
        %{id: "audi", name: "Audi", css_path: "/themes/audi.css"},
        %{id: "bmw", name: "BMW", css_path: "/themes/bmw.css"}
      ]} />
  """
  use Phoenix.Component

  import KPureAdmin.Helpers

  @doc """
  Renders the floating settings panel.

  All controls use `data-setting` attributes. The JS hook binds change events
  and updates localStorage + DOM classes. No `phx-` events needed — purely client-side.
  """
  attr(:id, :string, default: "settingsPanel")
  attr(:themes, :list, default: [], doc: "List of theme maps: %{id, name, css_path}")
  attr(:default_theme, :string, default: nil)
  attr(:class, :string, default: nil)
  attr(:rest, :global)

  def settings_panel(assigns) do
    themes_json =
      case assigns.themes do
        [] -> nil
        themes -> Jason.encode!(themes)
      end

    assigns = assign(assigns, :themes_json, themes_json)

    ~H"""
    <div
      id={@id}
      class={build_classes("pa-settings-panel", [], @class)}
      phx-hook="PureAdminSettings"
      data-themes={@themes_json}
      data-default-theme={@default_theme}
      {@rest}
    >
      <button class="pa-settings-panel__toggle" type="button" aria-label="Settings">
        ⚙
      </button>

      <div class="pa-settings-panel__content">
        <h3 class="pa-settings-panel__title">Settings</h3>

        <!-- Theme -->
        <div :if={@themes != []} class="pa-settings-panel__section">
          <label class="pa-settings-panel__label" for={"#{@id}-theme"}>Theme</label>
          <select id={"#{@id}-theme"} class="pa-settings-panel__select" data-setting="theme">
            <option :for={theme <- @themes} value={theme.id}>{theme.name}</option>
          </select>
        </div>

        <!-- Theme Mode -->
        <div class="pa-settings-panel__section">
          <label class="pa-settings-panel__label" for={"#{@id}-theme-mode"}>Theme Mode</label>
          <select id={"#{@id}-theme-mode"} class="pa-settings-panel__select" data-setting="theme-mode">
            <option value="light">Light</option>
            <option value="dark">Dark</option>
            <option value="auto">Auto (System)</option>
          </select>
        </div>

        <!-- Container Width -->
        <div class="pa-settings-panel__section">
          <label class="pa-settings-panel__label" for={"#{@id}-container-width"}>Layout Width</label>
          <select
            id={"#{@id}-container-width"}
            class="pa-settings-panel__select"
            data-setting="container-width"
          >
            <option value="fluid">Fluid (Full Width)</option>
            <option value="sm">Small (768px)</option>
            <option value="md">Medium (1024px)</option>
            <option value="lg">Large (1280px)</option>
            <option value="xl">Extra Large (1600px)</option>
            <option value="2xl">2X Large (1920px)</option>
          </select>
        </div>

        <!-- Sidebar Mode -->
        <div class="pa-settings-panel__section">
          <label class="pa-settings-panel__label" for={"#{@id}-sidebar-mode"}>Sidebar Mode</label>
          <select
            id={"#{@id}-sidebar-mode"}
            class="pa-settings-panel__select"
            data-setting="sidebar-mode"
          >
            <option value="">Scrolls with Content</option>
            <option value="sticky">Fixed Position</option>
          </select>
        </div>

        <!-- Sidebar Behavior -->
        <div class="pa-settings-panel__section">
          <label class="pa-settings-panel__label" for={"#{@id}-sidebar-behavior"}>
            Sidebar Behavior
          </label>
          <select
            id={"#{@id}-sidebar-behavior"}
            class="pa-settings-panel__select"
            data-setting="sidebar-behavior"
          >
            <option value="hide">Hide Completely</option>
            <option value="icon-collapse">Show Icons Only</option>
          </select>
        </div>

        <!-- Sidebar Options -->
        <div class="pa-settings-panel__section">
          <span class="pa-settings-panel__label">Sidebar</span>
          <div class="pa-settings-panel__checkbox-group">
            <label class="pa-settings-panel__checkbox">
              <input type="checkbox" data-setting="sidebar-hidden" />
              <span>Collapsed</span>
            </label>
            <label class="pa-settings-panel__checkbox">
              <input type="checkbox" data-setting="sidebar-resizable" />
              <span>Resizable</span>
            </label>
          </div>
        </div>

        <!-- Display Options -->
        <div class="pa-settings-panel__section">
          <span class="pa-settings-panel__label">Display</span>
          <div class="pa-settings-panel__checkbox-group">
            <label class="pa-settings-panel__checkbox">
              <input type="checkbox" data-setting="compact-mode" />
              <span>Compact Mode</span>
            </label>
            <label class="pa-settings-panel__checkbox">
              <input type="checkbox" data-setting="rtl-mode" />
              <span>RTL Mode</span>
            </label>
          </div>
        </div>

        <!-- Profile Panel -->
        <div class="pa-settings-panel__section">
          <span class="pa-settings-panel__label">Profile Panel</span>
          <div class="pa-settings-panel__checkbox-group">
            <label class="pa-settings-panel__checkbox">
              <input type="checkbox" data-setting="profile-no-avatar" />
              <span>Hide Avatar</span>
            </label>
            <label class="pa-settings-panel__checkbox">
              <input type="checkbox" data-setting="profile-icon-only-tabs" />
              <span>Icon-Only Tabs</span>
            </label>
          </div>
        </div>

        <!-- Font Size -->
        <div class="pa-settings-panel__section">
          <label class="pa-settings-panel__label" for={"#{@id}-font-size"}>Font Size</label>
          <select id={"#{@id}-font-size"} class="pa-settings-panel__select" data-setting="font-size">
            <option value="small">Small (14px)</option>
            <option value="default">Default (16px)</option>
            <option value="large">Large (18px)</option>
            <option value="xlarge">Extra Large (20px)</option>
          </select>
          <small class="pa-settings-panel__hint">
            Body text size. All elements scale proportionally.
          </small>
        </div>

        <!-- Font Family -->
        <div class="pa-settings-panel__section">
          <label class="pa-settings-panel__label" for={"#{@id}-font-family"}>Font Family</label>
          <select
            id={"#{@id}-font-family"}
            class="pa-settings-panel__select"
            data-setting="font-family"
          >
            <option value="default">Theme Default</option>
            <option value="serif">Serif</option>
            <option value="mono">Monospace</option>
            <option value="cuprum">Cuprum</option>
            <option value="fira-sans-condensed">Fira Sans Condensed</option>
            <option value="manrope">Manrope</option>
            <option value="martel">Martel</option>
            <option value="maven-pro">Maven Pro</option>
            <option value="monda">Monda</option>
            <option value="play">Play</option>
            <option value="signika">Signika</option>
            <option value="yanone-kaffeesatz">Yanone Kaffeesatz</option>
          </select>
        </div>

        <!-- Reset Button -->
        <div class="pa-settings-panel__section">
          <button class="pa-btn pa-btn--secondary pa-btn--block" type="button" data-reset>
            Reset to Defaults
          </button>
        </div>
      </div>
    </div>
    """
  end
end
