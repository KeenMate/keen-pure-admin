defmodule DemoWeb.Live.PagersLive do
  use DemoWeb, :live_view

  @total_items 250
  @per_page 25

  def mount(_params, _session, socket) do
    {:ok, assign(socket,
      page_title: "Pagers",
      page: 1,
      total_pages: ceil(@total_items / @per_page),
      loaded_items: @per_page,
      total_items: @total_items,
      load_more_loading: false
    )}
  end

  def handle_event("prev_page", _params, socket) do
    {:noreply, assign(socket, :page, max(socket.assigns.page - 1, 1))}
  end

  def handle_event("next_page", _params, socket) do
    {:noreply, assign(socket, :page, min(socket.assigns.page + 1, socket.assigns.total_pages))}
  end

  def handle_event("first_page", _params, socket) do
    {:noreply, assign(socket, :page, 1)}
  end

  def handle_event("last_page", _params, socket) do
    {:noreply, assign(socket, :page, socket.assigns.total_pages)}
  end

  def handle_event("go_to_page", %{"page" => page}, socket) do
    page = String.to_integer(page)
    page = max(1, min(page, socket.assigns.total_pages))
    {:noreply, assign(socket, :page, page)}
  end

  def handle_event("load_more", _params, socket) do
    Process.send_after(self(), :load_more_done, 1500)
    {:noreply, assign(socket, :load_more_loading, true)}
  end

  def handle_info(:load_more_done, socket) do
    new_loaded = min(socket.assigns.loaded_items + @per_page, @total_items)
    {:noreply, assign(socket, loaded_items: new_loaded, load_more_loading: false)}
  end

  def render(assigns) do
    ~H"""
    <.paragraph>Pagination controls and load more buttons for navigating through data.</.paragraph>

    <%!-- Basic Pager --%>
    <.card title_text="Basic Pager">
      <.paragraph class="mb-4">Default centered pager with page input and navigation buttons.</.paragraph>
      <.pager page={@page} total_pages={@total_pages} on_previous="prev_page" on_next="next_page" on_page_change="go_to_page" />
    </.card>

    <%!-- Pager with First/Last --%>
    <.card title_text="Pager with First/Last Buttons">
      <.paragraph class="mb-4">Extended navigation with first and last page buttons.</.paragraph>
      <.pager page={@page} total_pages={@total_pages} on_previous="prev_page" on_next="next_page" on_first="first_page" on_last="last_page" on_page_change="go_to_page" />
    </.card>

    <%!-- Pager Alignment --%>
    <.card title_text="Pager Alignment">
      <.heading level={4}>Start Aligned</.heading>
      <.pager page={@page} total_pages={@total_pages} align="start" on_previous="prev_page" on_next="next_page" on_page_change="go_to_page" />

      <.heading level={4} class="mt-6">Center Aligned (Default)</.heading>
      <.pager page={@page} total_pages={@total_pages} on_previous="prev_page" on_next="next_page" on_page_change="go_to_page" />

      <.heading level={4} class="mt-6">End Aligned with Custom Info</.heading>
      <.pager page={@page} total_pages={@total_pages} align="end" info_text={"Showing #{(@page - 1) * 25 + 1}-#{min(@page * 25, @total_items)} of #{@total_items}"} on_previous="prev_page" on_next="next_page" />
    </.card>

    <%!-- Load More --%>
    <.card title_text="Load More Button">
      <.grid>
        <.column size="100" md="1-3">
          <.heading level={4}>Default</.heading>
          <.load_more phx-click="load_more" count={"#{@loaded_items} of #{@total_items}"} is_loading={@load_more_loading} />
        </.column>
        <.column size="100" md="1-3">
          <.heading level={4}>Start Aligned</.heading>
          <.load_more align="start" phx-click="load_more">Show More Items</.load_more>
        </.column>
        <.column size="100" md="1-3">
          <.heading level={4}>End Aligned</.heading>
          <.load_more align="end" phx-click="load_more">Load Previous</.load_more>
        </.column>
      </.grid>
    </.card>

    <%!-- Pager in Card Footer --%>
    <.card title_text="Pager in Card Footer">
      <.paragraph>The pager removes its top/bottom margins when it's the first or last child in a card body, for clean alignment.</.paragraph>
      <.pager page={@page} total_pages={@total_pages} on_previous="prev_page" on_next="next_page" on_page_change="go_to_page" />
    </.card>

    <%!-- CSS Classes Reference --%>
    <.card title_text="CSS Classes Reference">
      <.heading level={4}>Pager</.heading>
      <.basic_list spacing="compact">
        <li><code>pa-pager</code> - Pager container (centered by default)</li>
        <li><code>pa-pager--start</code> - Start-aligned</li>
        <li><code>pa-pager--center</code> - Center-aligned</li>
        <li><code>pa-pager--end</code> - End-aligned</li>
        <li><code>pa-pager__container</code> - Inner flex container</li>
        <li><code>pa-pager__controls</code> - Navigation buttons group</li>
        <li><code>pa-pager__info</code> - Page info section</li>
        <li><code>pa-pager__input</code> - Page number input</li>
        <li><code>pa-pager__text</code> - Info text</li>
      </.basic_list>

      <.heading level={4} class="mt-4">Load More</.heading>
      <.basic_list spacing="compact">
        <li><code>pa-load-more</code> - Load more container (centered by default)</li>
        <li><code>pa-load-more--start</code> - Start-aligned</li>
        <li><code>pa-load-more--end</code> - End-aligned</li>
        <li><code>pa-load-more__button</code> - Button element</li>
        <li><code>pa-load-more__button--loading</code> - Loading state</li>
        <li><code>pa-load-more__spinner</code> - Loading spinner</li>
        <li><code>pa-load-more__text</code> - Button text</li>
        <li><code>pa-load-more__count</code> - Count text</li>
      </.basic_list>
    </.card>
    """
  end
end
