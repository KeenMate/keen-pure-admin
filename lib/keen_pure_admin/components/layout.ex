defmodule KPureAdmin.Components.Layout do
  @moduledoc """
  Layout components for Pure Admin.

  Provides the full page structure: navbar, layout wrapper, sidebar, main content, and footer.
  """
  use Phoenix.Component

  alias Phoenix.LiveView.JS
  import KPureAdmin.Helpers

  @doc """
  Renders the top navbar.

  ## Examples

      <.navbar>
        <:start>
          <.navbar_burger target="sidebar" />
          <div class="pa-header__brand"><h1>My App</h1></div>
        </:start>
        <:center>
          <div class="pa-header__title"><h2>Dashboard</h2></div>
        </:center>
        <:end_>
          <button class="pa-header__profile-btn">Profile</button>
        </:end_>
      </.navbar>
  """
  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:start, doc: "Left section: burger, brand, nav")
  slot(:center, doc: "Center section: page title")
  slot(:end_, doc: "Right section: nav, notifications, profile")

  def navbar(assigns) do
    ~H"""
    <nav class={build_classes("pa-navbar", [], @class)} {@rest}>
      <div class="pa-navbar__inner">
        <div :if={@start != []} class="pa-header__start">
          <%= for start <- @start do %>
            <%= render_slot(start) %>
          <% end %>
        </div>
        <div :if={@center != []} class="pa-header__center">
          <%= for center <- @center do %>
            <%= render_slot(center) %>
          <% end %>
        </div>
        <div :if={@end_ != []} class="pa-header__end">
          <%= for end_ <- @end_ do %>
            <%= render_slot(end_) %>
          <% end %>
        </div>
      </div>
    </nav>
    """
  end

  @doc """
  Renders the burger menu button for sidebar toggle.
  """
  attr(:class, :string, default: nil)
  attr(:rest, :global)

  def navbar_burger(assigns) do
    ~H"""
    <button
      class={build_classes("pa-header__burger burger-menu", [], @class)}
      phx-click={toggle_sidebar()}
      aria-label="Toggle sidebar"
      {@rest}
    >
      <span></span>
      <span></span>
      <span></span>
    </button>
    """
  end

  @doc """
  Renders the main layout container (below navbar).

  ## Examples

      <.layout>
        <.sidebar>...</.sidebar>
        <.main>...</.main>
        <.footer>...</.footer>
      </.layout>
  """
  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def layout(assigns) do
    ~H"""
    <div class={build_classes("pa-layout", [], @class)} {@rest}>
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  @doc """
  Renders the layout inner container (sidebar + content).
  """
  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def layout_inner(assigns) do
    ~H"""
    <div class={build_classes("pa-layout__inner", [], @class)} {@rest}>
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  @doc """
  Renders the layout content wrapper.
  """
  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def layout_content(assigns) do
    ~H"""
    <div class={build_classes("pa-layout__content", [], @class)} {@rest}>
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  @doc """
  Renders the sidebar navigation.

  ## Examples

      <.sidebar>
        <.sidebar_item href="/" icon="📊" label="Dashboard" is_active />
        <.sidebar_item href="/users" icon="👥" label="Users" />
      </.sidebar>
  """
  attr(:id, :string, default: "sidebar")
  attr(:is_sticky, :boolean, default: false)
  attr(:is_icon_collapse, :boolean, default: false)
  attr(:is_resizable, :boolean, default: false)
  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def sidebar(assigns) do
    ~H"""
    <aside
      id={@id}
      class={sidebar_classes(assigns)}
      {@rest}
    >
      <nav class="pa-sidebar__nav">
        <ul>
          <%= render_slot(@inner_block) %>
        </ul>
      </nav>
    </aside>
    """
  end

  defp sidebar_classes(assigns) do
    build_classes(
      "pa-layout__sidebar",
      [
        {"pa-layout__sidebar--sticky", assigns.is_sticky},
        {"pa-layout__sidebar--icon-collapse", assigns.is_icon_collapse},
        {"pa-layout__sidebar--resizable", assigns.is_resizable}
      ],
      assigns.class
    )
  end

  @doc """
  Renders a sidebar menu item (link).

  ## Examples

      <.sidebar_item href="/dashboard" icon="📊" label="Dashboard" is_active />
  """
  attr(:href, :string, default: "#")
  attr(:icon, :string, default: nil, doc: "Icon text, emoji, or HTML")
  attr(:label, :string, required: true)
  attr(:is_active, :boolean, default: false)
  attr(:class, :string, default: nil)
  attr(:rest, :global, include: ~w(phx-click navigate patch))

  def sidebar_item(assigns) do
    ~H"""
    <li class="pa-sidebar__item">
      <a
        href={@href}
        class={build_classes("pa-sidebar__link", [{"pa-sidebar__link--active", @is_active}], @class)}
        {@rest}
      >
        <span :if={@icon} class="pa-sidebar__icon"><i class={@icon}></i></span>
        <span class="pa-sidebar__label"><%= @label %></span>
      </a>
    </li>
    """
  end

  @doc """
  Renders a collapsible sidebar submenu item.

  ## Examples

      <.sidebar_submenu icon="📋" label="Tables">
        <.sidebar_item href="/tables" icon="📊" label="Standard" />
        <.sidebar_item href="/tables-lazy" icon="⚡" label="Lazy Loading" />
      </.sidebar_submenu>
  """
  attr(:icon, :string, default: nil)
  attr(:label, :string, required: true)
  attr(:is_open, :boolean, default: false)
  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def sidebar_submenu(assigns) do
    ~H"""
    <li class={build_classes("pa-sidebar__item", [{"pa-sidebar__item--open", @is_open}], @class)}>
      <button
        class="pa-sidebar__toggle"
        phx-click={toggle_submenu()}
        {@rest}
      >
        <span :if={@icon} class="pa-sidebar__icon"><i class={@icon}></i></span>
        <span class="pa-sidebar__label"><%= @label %></span>
        <span class="pa-sidebar__chevron">&#8250;</span>
      </button>
      <ul class={build_classes("pa-sidebar__submenu", [{"pa-sidebar__submenu--open", @is_open}])}>
        <%= render_slot(@inner_block) %>
      </ul>
    </li>
    """
  end

  @doc """
  Renders the main content area.
  """
  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def main(assigns) do
    ~H"""
    <main class={build_classes("pa-layout__main", [], @class)} {@rest}>
      <div class="pa-layout__main__inner">
        <%= render_slot(@inner_block) %>
      </div>
    </main>
    """
  end

  @doc """
  Renders the footer with three-section layout.

  ## Examples

      <.footer>
        <:start>&copy; 2026 My App</:start>
        <:end_>v1.0.0</:end_>
      </.footer>
  """
  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:start, doc: "Left section")
  slot(:center, doc: "Center section")
  slot(:end_, doc: "Right section")

  def footer(assigns) do
    ~H"""
    <footer class={build_classes("pa-layout__footer", [], @class)} {@rest}>
      <div :if={@start != []} class="pa-footer__start">
        <%= for start <- @start do %>
          <%= render_slot(start) %>
        <% end %>
      </div>
      <div :if={@center != []} class="pa-footer__center">
        <%= for center <- @center do %>
          <%= render_slot(center) %>
        <% end %>
      </div>
      <div :if={@end_ != []} class="pa-footer__end">
        <%= for end_ <- @end_ do %>
          <%= render_slot(end_) %>
        <% end %>
      </div>
    </footer>
    """
  end

  @doc """
  Renders a content section with optional heading.
  """
  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def section(assigns) do
    ~H"""
    <div class={build_classes("pa-section", [], @class)} {@rest}>
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  @doc """
  Renders a visual divider/separator.
  """
  attr(:class, :string, default: nil)
  attr(:rest, :global)

  def divider(assigns) do
    ~H"""
    <hr class={build_classes("pa-divider", [], @class)} {@rest} />
    """
  end

  @doc "JS command to toggle the sidebar visibility."
  @spec toggle_sidebar() :: JS.t()
  def toggle_sidebar do
    %JS{}
    |> JS.toggle_class("sidebar-hidden", to: "body")
    |> JS.toggle_class("active", to: ".burger-menu")
  end

  @doc "JS command to toggle a submenu open/closed."
  @spec toggle_submenu() :: JS.t()
  def toggle_submenu do
    %JS{}
    |> JS.toggle_class("pa-sidebar__item--open")
    |> JS.toggle_class("pa-sidebar__submenu--open", to: ".pa-sidebar__submenu")
  end
end
