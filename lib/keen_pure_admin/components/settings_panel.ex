defmodule KPureAdmin.Components.SettingsPanel do
  @moduledoc """
  Settings panel component for Pure Admin.

  Provides runtime-configurable settings for theme, color variant, mode,
  layout width, sidebar behavior, display options, and font preferences.
  Theme/variant/mode selectors are populated dynamically from `/api/themes/manifests`.
  All settings persist to localStorage via the `PureAdminSettings` JS hook.

  ## Examples

      <.settings_panel />

      <.settings_panel default_theme="audi" />
  """
  use Phoenix.Component

  import KPureAdmin.Helpers

  @doc """
  Renders the floating settings panel.

  Theme, color variant, and mode selectors are populated dynamically
  by the JS hook from `/api/themes/manifests`. All other controls use
  `data-setting` attributes bound to localStorage.
  """
  attr(:id, :string, default: "settingsPanel")
  attr(:default_theme, :string, default: nil)
  attr(:class, :string, default: nil)
  attr(:rest, :global)

  def settings_panel(assigns) do
    ~H"""
    <div
      id={@id}
      class={build_classes("pa-settings-panel", [], @class)}
      phx-hook="PureAdminSettings"
      data-default-theme={@default_theme}
      {@rest}
    >
      <button class="pa-settings-panel__toggle" type="button" aria-label="Settings">
        ⚙
      </button>

      <div class="pa-settings-panel__content">
        <h3 class="pa-settings-panel__title">Settings</h3>

        <%!-- Theme (populated dynamically from manifests) --%>
        <div class="pa-settings-panel__section">
          <label class="pa-settings-panel__label" for={"#{@id}-theme"}>Theme</label>
          <select id={"#{@id}-theme"} class="pa-settings-panel__select" data-setting="theme">
            <option value="">Loading...</option>
          </select>
        </div>

        <%!-- Color Variant (shown/hidden dynamically based on manifest) --%>
        <div class="pa-settings-panel__section" data-section="color-variant" style="display: none;">
          <label class="pa-settings-panel__label" for={"#{@id}-color-variant"}>Color Variant</label>
          <select
            id={"#{@id}-color-variant"}
            class="pa-settings-panel__select"
            data-setting="color-variant"
          >
          </select>
        </div>

        <%!-- Theme Mode (shown/hidden dynamically based on manifest) --%>
        <div class="pa-settings-panel__section" data-section="theme-mode" style="display: none;">
          <label class="pa-settings-panel__label" for={"#{@id}-theme-mode"}>Mode</label>
          <select
            id={"#{@id}-theme-mode"}
            class="pa-settings-panel__select"
            data-setting="theme-mode"
          >
          </select>
        </div>

        <%!-- Container Width --%>
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

        <%!-- Sidebar Mode --%>
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

        <%!-- Sidebar Behavior --%>
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

        <%!-- Sidebar Options --%>
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

        <%!-- Display Options --%>
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

        <%!-- Profile Panel --%>
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

        <%!-- Font Size --%>
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

        <%!-- Font Family --%>
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

        <%!-- Reset Button --%>
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
