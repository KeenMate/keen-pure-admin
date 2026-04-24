defmodule PureAdmin.Components.Layout do
  @moduledoc """
  Layout components for Pure Admin.

  Provides the full page structure: navbar, layout wrapper, sidebar, main content, and footer.
  """
  use Phoenix.Component

  alias Phoenix.LiveView.JS
  alias PureAdmin.Config
  import PureAdmin.Helpers

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
          <.navbar_profile_btn name="John Doe" phx-click={toggle_profile_panel()} />
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
  attr(:target, :string, default: "sidebar", doc: "ID of the sidebar element to toggle")
  attr(:class, :string, default: nil)
  attr(:rest, :global)

  def navbar_burger(assigns) do
    ~H"""
    <button
      class={build_classes("pa-header__burger burger-menu", [], @class)}
      phx-click={toggle_sidebar(@target)}
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
  Renders the brand/logo section in the navbar.

  ## Examples

      <.navbar_brand>My App</.navbar_brand>

      <.navbar_brand logo="/images/logo.svg">My App</.navbar_brand>
  """
  attr(:logo, :string, default: nil, doc: "Logo image URL (falls back to config :app_logo)")
  attr(:logo_alt, :string, default: "", doc: "Logo alt text")
  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:inner_block, doc: "Brand content (falls back to config :app_name)")

  def navbar_brand(assigns) do
    assigns =
      assigns
      |> assign_new(:_logo, fn -> assigns.logo || Config.app_logo() end)
      |> assign_new(:_name, fn -> Config.app_name() end)

    ~H"""
    <div class={build_classes("pa-header__brand", [], @class)} {@rest}>
      <img :if={@_logo} src={@_logo} alt={@logo_alt} class="pa-header__logo" />
      <%= if @inner_block != [] do %>
        <%= render_slot(@inner_block) %>
      <% else %>
        <h1>{@_name}</h1>
      <% end %>
    </div>
    """
  end

  @doc """
  Renders a navigation link group in the navbar.

  ## Examples

      <.navbar_nav>
        <.navbar_nav_item href="/">Dashboard</.navbar_nav_item>
        <.navbar_nav_item href="/settings">Settings</.navbar_nav_item>
      </.navbar_nav>

      <.navbar_nav position="end">
        <.navbar_nav_item href="/help">Help</.navbar_nav_item>
      </.navbar_nav>
  """
  attr(:position, :string, default: "start", values: ["start", "end"], doc: "Nav position variant")
  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def navbar_nav(assigns) do
    ~H"""
    <nav class={build_classes("pa-header__nav", [{"pa-header__nav--end", @position == "end"}, {"pa-header__nav--start", @position == "start"}], @class)} {@rest}>
      <ul>
        <%= render_slot(@inner_block) %>
      </ul>
    </nav>
    """
  end

  @doc """
  Renders a navigation item within `navbar_nav`.

  ## Examples

      <.navbar_nav_item href="/dashboard">Dashboard</.navbar_nav_item>

      <.navbar_nav_item has_dropdown>
        Products
        <:dropdown>
          <.navbar_dropdown>
            <.navbar_nav_item href="/products">All</.navbar_nav_item>
          </.navbar_dropdown>
        </:dropdown>
      </.navbar_nav_item>
  """
  attr(:href, :string, default: "#")
  attr(:has_dropdown, :boolean, default: false, doc: "Whether this item has a dropdown submenu")
  attr(:class, :string, default: nil)
  attr(:rest, :global, include: ~w(navigate patch))
  slot(:inner_block, required: true)
  slot(:dropdown, doc: "Dropdown submenu content (use with has_dropdown)")

  def navbar_nav_item(assigns) do
    ~H"""
    <li class={navbar_nav_item_classes(assigns)}>
      <a href={safe_url(@href)} class={if @has_dropdown, do: "pa-header__nav-link"} {@rest}>
        <%= render_slot(@inner_block) %>
      </a>
      <%= for dropdown <- @dropdown do %>
        <%= render_slot(dropdown) %>
      <% end %>
    </li>
    """
  end

  defp navbar_nav_item_classes(assigns) do
    build_classes(
      "",
      [
        {"pa-header__nav-item", assigns.has_dropdown},
        {"pa-header__nav-item--has-dropdown", assigns.has_dropdown}
      ],
      assigns.class
    )
  end

  @doc """
  Renders a dropdown menu for a `navbar_nav_item`.

  ## Examples

      <.navbar_dropdown>
        <.navbar_nav_item href="/products">All Products</.navbar_nav_item>
        <.navbar_nav_item href="/categories">Categories</.navbar_nav_item>
      </.navbar_dropdown>
  """
  attr(:is_level2, :boolean, default: false, doc: "Second-level nested dropdown")
  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def navbar_dropdown(assigns) do
    ~H"""
    <ul
      class={build_classes("pa-header__dropdown", [{"pa-header__dropdown--level2", @is_level2}], @class)}
      {@rest}
    >
      <%= render_slot(@inner_block) %>
    </ul>
    """
  end

  @doc """
  Renders the page title in the navbar center section.

  ## Examples

      <.navbar_title>Dashboard</.navbar_title>
  """
  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def navbar_title(assigns) do
    ~H"""
    <div class={build_classes("pa-header__title", [], @class)} {@rest}>
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  @doc """
  Renders the search widget in the navbar.

  Typically opens a command palette on click.

  ## Examples

      <.navbar_search />

      <.navbar_search placeholder="Search..." phx-click={show_command_palette()} />
  """
  attr(:placeholder, :string, default: "Search...")
  attr(:size, :string, default: nil, values: [nil, "xs", "sm", "md", "lg", "xl"])
  attr(:class, :string, default: nil)
  attr(:rest, :global)

  def navbar_search(assigns) do
    ~H"""
    <div class={build_classes("pa-header__search", [], nil)}>
      <div
        class={build_classes("pa-navbar-search", [{"pa-navbar-search--#{@size}", @size != nil}], @class)}
        role="button"
        tabindex="0"
        aria-label="Open search"
        {@rest}
      >
        <span class="pa-navbar-search__icon"><i class="fa-solid fa-magnifying-glass"></i></span>
        <span class="pa-navbar-search__placeholder"><%= @placeholder %></span>
        <span class="pa-navbar-search__shortcut">
          <kbd>Ctrl</kbd>
          <kbd>K</kbd>
        </span>
      </div>
    </div>
    """
  end

  @doc """
  Renders the profile button in the navbar.

  ## Examples

      <.navbar_profile_btn name="John Doe" />

      <.navbar_profile_btn name="John Doe" phx-click={toggle_profile_panel()}>
        <:icon><img src="/avatar.jpg" /></:icon>
      </.navbar_profile_btn>
  """
  attr(:name, :string, default: nil, doc: "User display name")
  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:icon, doc: "Custom icon/avatar content")

  def navbar_profile_btn(assigns) do
    ~H"""
    <button
      class={build_classes("pa-header__profile-btn", [], @class)}
      aria-label="User profile"
      {@rest}
    >
      <span :if={@icon != []} class="pa-btn__icon">
        <%= for icon <- @icon do %>
          <%= render_slot(icon) %>
        <% end %>
      </span>
      <span :if={@icon == []} class="pa-btn__icon"><i class="fa-solid fa-user"></i></span>
      <span :if={@name} class="pa-header__profile-name"><%= @name %></span>
    </button>
    """
  end

  @doc """
  Renders a notifications bell button with dropdown panel.

  ## Examples

      <.notifications count={3}>
        <.notification_item variant="primary" icon="fa-solid fa-file-pen">
          <:title>New task assigned</:title>
          <:text>Review the Q4 report by end of week</:text>
          <:time>2 minutes ago</:time>
        </.notification_item>
      </.notifications>
  """
  attr(:id, :string, default: "notifications")
  attr(:count, :integer, default: nil, doc: "Badge count (nil = no badge)")
  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:inner_block, doc: "Notification items")
  slot(:footer_, doc: "Footer content (e.g. 'View all' link)")

  def notifications(assigns) do
    ~H"""
    <div id={@id} class={build_classes("pa-notifications", [], @class)} {@rest}>
      <button
        class="pa-notifications__btn"
        phx-click={toggle_notifications(@id)}
        aria-label="Notifications"
      >
        <span class="pa-notifications__icon"><i class="fa-solid fa-bell"></i></span>
        <span :if={@count && @count > 0} class="pa-notifications__badge"><%= @count %></span>
      </button>

      <div id={"#{@id}-panel"} class="pa-notifications__panel" style="display: none;">
        <div class="pa-notifications__header">
          <h3>Notifications</h3>
        </div>
        <ul :if={@inner_block != []} class="pa-notifications__list">
          <%= render_slot(@inner_block) %>
        </ul>
        <div :if={@footer_ != []} class="pa-notifications__footer">
          <%= for footer_ <- @footer_ do %>
            <%= render_slot(footer_) %>
          <% end %>
        </div>
      </div>
    </div>
    """
  end

  @doc """
  Renders a single notification item within `notifications`.

  ## Examples

      <.notification_item variant="success" icon="fa-solid fa-check">
        <:title>Build completed</:title>
        <:text>Production deployment finished</:text>
        <:time>15 minutes ago</:time>
      </.notification_item>
  """
  attr(:variant, :string,
    default: nil,
    values: [nil, "primary", "secondary", "success", "warning", "danger", "info"]
  )

  attr(:icon, :string, default: nil, doc: "Icon class (e.g. 'fa-solid fa-check')")
  attr(:is_unread, :boolean, default: false)
  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:title, doc: "Notification title")
  slot(:text, doc: "Notification body text")
  slot(:time, doc: "Timestamp text")

  def notification_item(assigns) do
    ~H"""
    <li
      class={build_classes("pa-notifications__item", [{"pa-notifications__item--unread", @is_unread}], @class)}
      {@rest}
    >
      <div class={build_classes("pa-notifications__icon-wrapper", [{"pa-notifications__icon-wrapper--#{@variant}", @variant != nil}])}>
        <i :if={@icon} class={@icon}></i>
      </div>
      <div class="pa-notifications__content">
        <h4 :if={@title != []}>
          <%= for title <- @title do %>
            <%= render_slot(title) %>
          <% end %>
        </h4>
        <p :if={@text != []}>
          <%= for text <- @text do %>
            <%= render_slot(text) %>
          <% end %>
        </p>
        <span :if={@time != []} class="pa-notifications__time">
          <%= for time <- @time do %>
            <%= render_slot(time) %>
          <% end %>
        </span>
      </div>
    </li>
    """
  end

  @doc "JS command to toggle the notifications panel."
  @spec toggle_notifications(String.t()) :: JS.t()
  def toggle_notifications(id \\ "notifications") do
    JS.toggle(to: "##{id}-panel", display: "block")
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
  attr(:id, :string, default: nil)
  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def layout(assigns) do
    ~H"""
    <div id={@id} class={build_classes("pa-layout", [], @class)} {@rest}>
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
      phx-hook="PureAdminSidebar"
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
        href={safe_url(@href)}
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
  attr(:id, :string, default: nil)
  attr(:icon, :string, default: nil)
  attr(:label, :string, required: true)
  attr(:is_open, :boolean, default: false)
  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def sidebar_submenu(assigns) do
    assigns =
      assign_new(assigns, :submenu_id, fn ->
        assigns[:id] || "submenu-#{System.unique_integer([:positive])}"
      end)

    ~H"""
    <li
      class={build_classes("pa-sidebar__item", [{"pa-sidebar__item--open", @is_open}], @class)}
      phx-hook="PureAdminSidebarSubmenu"
      id={"#{@submenu_id}-wrapper"}
      data-has-active-page={to_string(@is_open)}
    >
      <button
        class="pa-sidebar__toggle"
        phx-click={toggle_submenu(@submenu_id)}
        {@rest}
      >
        <span :if={@icon} class="pa-sidebar__icon"><i class={@icon}></i></span>
        <span class="pa-sidebar__label"><%= @label %></span>
        <span class="pa-sidebar__chevron">&#8250;</span>
      </button>
      <ul id={@submenu_id} class={build_classes("pa-sidebar__submenu", [{"pa-sidebar__submenu--open", @is_open}])}>
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

  When no slots are provided, auto-populates from config:
  - `:start` falls back to `config :copyright`
  - `:end_` falls back to `config :app_version`

  ## Examples

      <%!-- Minimal: reads from config --%>
      <.footer />

      <%!-- Explicit content --%>
      <.footer>
        <:start>&copy; 2026 My App</:start>
        <:end_>v1.0.0</:end_>
      </.footer>
  """
  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:start, doc: "Left section (falls back to config :copyright)")
  slot(:center, doc: "Center section")
  slot(:end_, doc: "Right section (falls back to config :app_version)")

  def footer(assigns) do
    assigns =
      assigns
      |> assign_new(:_copyright, fn -> Config.copyright() end)
      |> assign_new(:_version, fn -> Config.app_version() end)

    ~H"""
    <footer class={build_classes("pa-layout__footer", [], @class)} {@rest}>
      <%= if @start != [] do %>
        <div class="pa-footer__start">
          <%= for start <- @start do %>
            <%= render_slot(start) %>
          <% end %>
        </div>
      <% else %>
        <div :if={@_copyright} class="pa-footer__start">
          <span>{@_copyright}</span>
        </div>
      <% end %>
      <div :if={@center != []} class="pa-footer__center">
        <%= for center <- @center do %>
          <%= render_slot(center) %>
        <% end %>
      </div>
      <%= if @end_ != [] do %>
        <div class="pa-footer__end">
          <%= for end_ <- @end_ do %>
            <%= render_slot(end_) %>
          <% end %>
        </div>
      <% else %>
        <div :if={@_version} class="pa-footer__end">
          <span>v{@_version}</span>
        </div>
      <% end %>
    </footer>
    """
  end

  @doc """
  Renders a content section with optional heading.

  ## Examples

      <.section title_text="My Section">
        Section content here.
      </.section>
  """
  attr(:title_text, :string, default: nil, doc: "Section heading text (renders as h3)")
  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def section(assigns) do
    ~H"""
    <div class={build_classes("pa-section", [], @class)} {@rest}>
      <h3 :if={@title_text} class="pa-section-title"><%= @title_text %></h3>
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

  @doc """
  Renders a hidden input containing the page context as JSON.

  JS hooks read this synchronously via `getPageContext()` instead of
  fetching from APIs. CSP-safe (no inline scripts with data).

  ## Examples

      <.page_context />

      <.page_context extra={%{"user" => %{"id" => 1}}} />
  """
  attr(:extra, :map, default: %{}, doc: "Additional context to merge (from app assigns)")
  attr(:rest, :global)

  def page_context(assigns) do
    context =
      PureAdmin.PageContext.build(assigns)
      |> Map.merge(assigns.extra)

    assigns = assign(assigns, :context_json, Jason.encode!(context))

    ~H"""
    <input type="hidden" id="pa-page-context" value={@context_json} {@rest} />
    """
  end

  @doc """
  Inline script that reads persisted UI preferences from localStorage and
  applies the corresponding classes before the page paints, preventing a
  flash of unstyled content.

  `default_mode` is the mode used on first visit, when localStorage has no
  `theme-mode` entry yet. Must be `"light"`, `"dark"`, or `"auto"`. `"auto"`
  resolves to light/dark via `prefers-color-scheme` at runtime.

  ## Examples

      <.fouc_prevention_script />
      <.fouc_prevention_script default_mode="auto" />
  """
  attr(:default_mode, :string, default: "light", values: ~w(light dark auto))

  def fouc_prevention_script(assigns) do
    ~H"""
    <script data-default-mode={@default_mode}>
      (function(){
        var b=document.body,h=document.documentElement;
        var s=document.currentScript;
        var dm=(s&&s.getAttribute('data-default-mode'))||'light';
        var m=localStorage.getItem('theme-mode')||dm;
        if(m==='dark')b.classList.add('pa-mode-dark');
        else if(m==='auto'&&window.matchMedia('(prefers-color-scheme:dark)').matches)b.classList.add('pa-mode-dark');
        else b.classList.add('pa-mode-light');
        var fs=localStorage.getItem('font-size');
        if(fs&&fs!=='default')h.classList.add('font-size-'+fs);
        var ff=localStorage.getItem('font-family');
        if(ff&&ff!=='default')b.classList.add('font-family-'+ff);
        var cw=localStorage.getItem('container-width');
        if(cw&&cw!=='fluid')b.classList.add('pa-container-'+cw);
        if(localStorage.getItem('sidebar-mode')==='sticky')b.classList.add('pa-layout--sticky');
        var isMobile=window.innerWidth<=768;
        if(!isMobile){if(localStorage.getItem('sidebar-hidden')==='true'){b.classList.add('sidebar-hidden')}else{var bm=document.querySelector('.burger-menu');if(bm)bm.classList.add('active')}}
        var cv=localStorage.getItem('color-variant');
        if(cv)b.classList.add('pa-color-'+cv);
        if(localStorage.getItem('compact-mode')==='true')b.classList.add('compact-mode');
        if(localStorage.getItem('rtl-mode')==='true')h.setAttribute('dir','rtl');
        var ss=localStorage.getItem('pa-sidebar-submenus');
        if(ss){try{var sm=JSON.parse(ss);var r=[];for(var id in sm){if(sm[id]){
        r.push('#'+id+'-wrapper>.pa-sidebar__submenu{display:block}');
        r.push('#'+id+'-wrapper>.pa-sidebar__chevron,#'+id+'-wrapper .pa-sidebar__chevron{transform:rotate(90deg)}');
        }}if(r.length){var st=document.createElement('style');st.id='pa-submenu-preload';st.textContent=r.join('');document.head.appendChild(st)}}catch(e){}}
      })();
    </script>
    """
  end

  @doc "JS command to toggle the sidebar visibility."
  @spec toggle_sidebar(String.t()) :: JS.t()
  def toggle_sidebar(id \\ "sidebar") do
    %JS{}
    |> JS.dispatch("pa:toggle_sidebar", to: "##{id}")
  end

  @doc "JS command to toggle a submenu open/closed."
  @spec toggle_submenu(String.t()) :: JS.t()
  def toggle_submenu(submenu_id) do
    %JS{}
    |> JS.toggle_class("pa-sidebar__item--open", to: {:closest, ".pa-sidebar__item"})
    |> JS.toggle_class("pa-sidebar__submenu--open", to: "##{submenu_id}")
  end
end
