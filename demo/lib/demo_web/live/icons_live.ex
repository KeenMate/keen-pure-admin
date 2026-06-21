defmodule DemoWeb.Live.IconsLive do
  use DemoWeb, :live_view

  # Heroicons shipped in PureAdmin.Components.Heroicon (the 25 curated outline icons).
  # Listed here so the showcase grid stays in sync with what the module actually supports.
  @heroicons ~w(
    rocket-launch chart-bar briefcase user-group cog-6-tooth
    user arrow-right-on-rectangle plus user-plus arrow-down-tray
    pencil trash shopping-cart bookmark paint-brush
    chart-bar-square home list-bullet view-columns pencil-square
    lock-closed bell swatch squares-2x2 book-open
  )

  def mount(_params, _session, socket) do
    # `maybe_nil` is used in the "Empty / nil" example so Phoenix.Component
    # can't static-check it as a literal nil (which would warn against the
    # `required: true` attr declaration even though the runtime handles it).
    {:ok, assign(socket, page_title: "Icons", heroicons: @heroicons, maybe_nil: nil)}
  end

  def render(assigns) do
    ~H"""
    <.paragraph>
      Three components for icons: <.code>&lt;.icon&gt;</.code> (smart dispatcher),
      <.code>&lt;.faicon&gt;</.code> (Font Awesome wrapper), and
      <.code>&lt;.heroicon&gt;</.code> (inline-SVG Heroicons). All share the same
      attribute surface: <.code>name</.code>, <.code>class</.code>,
      <.code>color</.code>, <.code>size</.code>, <.code>variant</.code>,
      <.code>fill</.code>, <.code>stroke</.code>, <.code>title</.code>,
      <.code>aria_label</.code>.
    </.paragraph>

    <%!-- ── <.icon> dispatcher ─────────────────────────────────────────── --%>
    <.card title_text="<.icon> — smart dispatcher">
      <.paragraph class="mb-4">
        Routes by name prefix: <.code>"hero-X"</.code> → inline SVG via
        <.code>&lt;.heroicon&gt;</.code>; anything else → <.code>&lt;i class&gt;</.code>
        (works for Font Awesome, Bootstrap Icons, Lucide-font, etc.).
      </.paragraph>

      <.grid>
        <.column size="100" md="1-3">
          <.heading level={4}>Heroicons branch</.heading>
          <.code_block language="heex"><.icon name="hero-rocket-launch" /></.code_block>
          <div class="mt-2 flex gap-3 items-center">
            <.icon name="hero-rocket-launch" />
            <.icon name="hero-bell" />
            <.icon name="hero-cog-6-tooth" />
          </div>
        </.column>
        <.column size="100" md="1-3">
          <.heading level={4}>FA / class-based branch</.heading>
          <.code_block language="heex"><.icon name="fa-solid fa-rocket" /></.code_block>
          <div class="mt-2 flex gap-3 items-center">
            <.icon name="fa-solid fa-rocket" />
            <.icon name="fa-solid fa-bell" />
            <.icon name="fa-solid fa-cog" />
          </div>
        </.column>
        <.column size="100" md="1-3">
          <.heading level={4}>Empty / nil</.heading>
          <.code_block language="heex"><.icon name={@maybe_nil} /></.code_block>
          <div class="mt-2">
            <.icon name={@maybe_nil} />
            <.paragraph class="text-color-2 mt-2">
              Renders nothing — useful when the icon is data-driven and may be absent.
            </.paragraph>
          </div>
        </.column>
      </.grid>
    </.card>

    <%!-- ── <.heroicon> direct use ─────────────────────────────────────── --%>
    <.card title_text="<.heroicon> — all 25 curated icons">
      <.paragraph class="mb-4">
        Outline variants from <.pa_link href="https://heroicons.com" target="_blank">heroicons.com</.pa_link>,
        embedded as inline SVG with <.code>stroke="currentColor"</.code> so they
        inherit the parent text color.
      </.paragraph>

      <div class="grid gap-3" style="grid-template-columns: repeat(auto-fill, minmax(140px, 1fr));">
        <div :for={name <- @heroicons} class="flex flex-col items-center gap-1 p-3 border rounded">
          <.heroicon name={name} class="size-6" />
          <code class="text-xs text-color-2">{name}</code>
        </div>
      </div>
    </.card>

    <%!-- ── <.faicon> direct use ──────────────────────────────────────── --%>
    <.card title_text="<.faicon> — Font Awesome wrapper">
      <.paragraph class="mb-4">
        Decomposes name + variant so callers don't have to remember the
        <.code>fa-solid</.code> / <.code>fa-regular</.code> / <.code>fa-light</.code> /
        <.code>fa-brands</.code> class prefixes. Requires Font Awesome CSS to be
        loaded.
      </.paragraph>

      <.grid>
        <.column size="100" md="1-3">
          <.heading level={4}>Solid (default)</.heading>
          <.code_block language="heex"><.faicon name="rocket" /></.code_block>
          <div class="mt-2 flex gap-3 items-center">
            <.faicon name="rocket" />
            <.faicon name="user" />
            <.faicon name="bell" />
          </div>
        </.column>
        <.column size="100" md="1-3">
          <.heading level={4}>Regular</.heading>
          <.code_block language="heex"><.faicon name="bell" variant="regular" /></.code_block>
          <div class="mt-2 flex gap-3 items-center">
            <.faicon name="bell" variant="regular" />
            <.faicon name="heart" variant="regular" />
            <.faicon name="star" variant="regular" />
          </div>
        </.column>
        <.column size="100" md="1-3">
          <.heading level={4}>Brands</.heading>
          <.code_block language="heex"><.faicon name="github" variant="brands" /></.code_block>
          <div class="mt-2 flex gap-3 items-center">
            <.faicon name="github" variant="brands" />
            <.faicon name="elixir" variant="brands" />
            <.faicon name="phoenix-framework" variant="brands" />
          </div>
        </.column>
      </.grid>
    </.card>

    <%!-- ── Pass-through attrs ────────────────────────────────────────── --%>
    <.card title_text="Pass-through attrs (color, size, fill, stroke, title, aria_label)">
      <.paragraph class="mb-4">
        Every named attr declared on the component flows through to the
        rendered element. Phoenix.Component validates each at compile time —
        a typo at the call site becomes a warning instead of a silently
        dropped attribute.
      </.paragraph>

      <.heading level={4}>Title (tooltip) and aria_label</.heading>
      <.code_block language="heex"><.heroicon name="bell" title="Notifications" aria_label="Notifications" /></.code_block>
      <div class="mt-2">
        <.heroicon name="bell" title="Notifications" aria_label="Notifications" />
      </div>

      <.heading level={4} class="mt-4">Stroke override</.heading>
      <.code_block language="heex"><.heroicon name="bookmark" stroke="red" /></.code_block>
      <div class="mt-2 flex gap-3 items-center">
        <.heroicon name="bookmark" />
        <.heroicon name="bookmark" stroke="red" />
        <.heroicon name="bookmark" stroke="green" />
      </div>

      <.heading level={4} class="mt-4">Fill override</.heading>
      <.code_block language="heex"><.heroicon name="bookmark" fill="currentColor" /></.code_block>
      <div class="mt-2 flex gap-3 items-center">
        <.heroicon name="bookmark" fill="currentColor" />
        <.heroicon name="bookmark" fill="lightblue" stroke="blue" />
      </div>
    </.card>

    <%!-- ── String-attr dispatcher pattern ────────────────────────────── --%>
    <.card title_text="Why <.icon> exists — the string-attr pattern">
      <.paragraph class="mb-4">
        Library chrome components like <.code>&lt;.sidebar_item&gt;</.code>,
        <.code>&lt;.button&gt;</.code>, <.code>&lt;.flash&gt;</.code>, and
        <.code>&lt;.profile_nav_item&gt;</.code> take a single <.code>icon</.code>
        string and don't know whether it's an FA class or a heroicon name. They
        delegate the decision to <.code>&lt;.icon&gt;</.code>.
      </.paragraph>

      <.code_block language="heex"><.sidebar_item label="Dashboard" icon="hero-chart-bar-square" href="/" />
      <.sidebar_item label="Profile" icon="fa-solid fa-user" href="/profile" /></.code_block>

      <.paragraph class="mt-4">
        Both calls work because <.code>&lt;.sidebar_item&gt;</.code> renders
        <.code>&lt;.icon name=&#123;@icon&#125; /&gt;</.code> internally — heroicons go
        through the SVG branch, FA strings through the <.code>&lt;i class&gt;</.code> branch.
      </.paragraph>
    </.card>

    <%!-- ── When to use which ─────────────────────────────────────────── --%>
    <.card title_text="When to use which component">
      <.table is_compact rows={[
        %{component: "<.icon>", when: "You have a string and don't know its type (e.g. attr-driven, config-driven). Used internally by library chrome."},
        %{component: "<.faicon>", when: "Direct FA use with explicit variant control. Cleanest when you know it's FA."},
        %{component: "<.heroicon>", when: "Direct Heroicon use, no name-prefix ceremony. Cleanest when you know it's a heroicon."}
      ]}>
        <:col :let={row} label="Component"><.code>{row.component}</.code></:col>
        <:col :let={row} label="When">{row.when}</:col>
      </.table>
    </.card>
    """
  end
end
