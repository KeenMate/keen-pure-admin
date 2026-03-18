defmodule DemoWeb.Live.TablesSizingLive do
  use DemoWeb, :live_view

  @employees [
    %{name: "Tiger Nixon", position: "System Architect", office: "Edinburgh", age: 61},
    %{name: "Garrett Winters", position: "Accountant", office: "Tokyo", age: 63},
    %{name: "Ashton Cox", position: "Junior Technical Author", office: "San Francisco", age: 66}
  ]

  @sizes [
    %{size: "xs", class: "pa-table--xs", padding: "0.6rem 0.8rem", best_for: "Dense data grids, logs"},
    %{size: "Default", class: "pa-table", padding: "0.8rem 0.8rem", best_for: "Standard tables"},
    %{size: "SM", class: "pa-table--sm", padding: "0.8rem 1rem", best_for: "Slightly wider spacing"},
    %{size: "LG", class: "pa-table--lg", padding: "0.8rem 1.4rem", best_for: "Forms in tables"},
    %{size: "XL", class: "pa-table--xl", padding: "0.8rem 1.6rem", best_for: "Presentation tables"}
  ]

  def mount(_params, _session, socket) do
    {:ok, assign(socket,
      page_title: "Table Sizing",
      employees: @employees,
      sizes: @sizes
    )}
  end

  def render(assigns) do
    ~H"""
    <p>Table size variants synchronized with button/input sizes. Each variant provides enough space for buttons and inputs of the same size.</p>

    <%!-- XS Size --%>
    <.card>
      <:header>
        <h3>XS Size <.code>pa-table--xs</.code></h3>
      </:header>
      <p>Compact rows - fits button/input XS. Best for dense data grids.</p>
      <.table_container>
        <.table rows={@employees} size="xs">
          <:col :let={e} label="Name">{e.name}</:col>
          <:col :let={e} label="Position">{e.position}</:col>
          <:col :let={e} label="Office">{e.office}</:col>
          <:col :let={e} label="Age">{e.age}</:col>
          <:action :let={_e}>
            <.button variant="secondary" size="xs">Edit</.button>
            <.button variant="danger" size="xs">Delete</.button>
          </:action>
        </.table>
      </.table_container>
    </.card>

    <%!-- Default Size --%>
    <.card>
      <:header>
        <h3>Default Size <.code>pa-table</.code></h3>
      </:header>
      <p>Standard rows - fits button/input SM and default sizes.</p>
      <.table_container>
        <.table rows={@employees}>
          <:col :let={e} label="Name">{e.name}</:col>
          <:col :let={e} label="Position">{e.position}</:col>
          <:col :let={e} label="Office">{e.office}</:col>
          <:col :let={e} label="Age">{e.age}</:col>
          <:action :let={_e}>
            <.button variant="secondary" size="sm">Edit</.button>
            <.button variant="danger" size="sm">Delete</.button>
          </:action>
        </.table>
      </.table_container>
    </.card>

    <%!-- SM Size --%>
    <.card>
      <:header>
        <h3>SM Size <.code>pa-table--sm</.code></h3>
      </:header>
      <p>Slightly wider horizontal padding than default.</p>
      <.table_container>
        <.table rows={@employees} size="sm">
          <:col :let={e} label="Name">{e.name}</:col>
          <:col :let={e} label="Position">{e.position}</:col>
          <:col :let={e} label="Office">{e.office}</:col>
          <:col :let={e} label="Age">{e.age}</:col>
          <:action :let={_e}>
            <.button variant="secondary" size="sm">Edit</.button>
            <.button variant="danger" size="sm">Delete</.button>
          </:action>
        </.table>
      </.table_container>
    </.card>

    <%!-- LG Size --%>
    <.card>
      <:header>
        <h3>LG Size <.code>pa-table--lg</.code></h3>
      </:header>
      <p>Spacious rows - fits button/input LG. Good for forms in tables.</p>
      <.table_container>
        <.table rows={@employees} size="lg">
          <:col :let={e} label="Name">{e.name}</:col>
          <:col :let={e} label="Position">{e.position}</:col>
          <:col :let={e} label="Office">{e.office}</:col>
          <:col :let={e} label="Age">{e.age}</:col>
          <:action :let={_e}>
            <.button variant="secondary" size="lg">Edit</.button>
            <.button variant="danger" size="lg">Delete</.button>
          </:action>
        </.table>
      </.table_container>
    </.card>

    <%!-- XL Size --%>
    <.card>
      <:header>
        <h3>XL Size <.code>pa-table--xl</.code></h3>
      </:header>
      <p>Extra spacious rows - fits button/input XL. Best for presentation tables.</p>
      <.table_container>
        <.table rows={@employees} size="xl">
          <:col :let={e} label="Name">{e.name}</:col>
          <:col :let={e} label="Position">{e.position}</:col>
          <:col :let={e} label="Office">{e.office}</:col>
          <:col :let={e} label="Age">{e.age}</:col>
          <:action :let={_e}>
            <.button variant="secondary" size="xl">Edit</.button>
            <.button variant="danger" size="xl">Delete</.button>
          </:action>
        </.table>
      </.table_container>
    </.card>

    <%!-- Size Reference --%>
    <.card title_text="Size Reference">
      <.table rows={@sizes}>
        <:col :let={s} label="Size">{s.size}</:col>
        <:col :let={s} label="Class"><.code>{s.class}</.code></:col>
        <:col :let={s} label="Padding">{s.padding}</:col>
        <:col :let={s} label="Best for">{s.best_for}</:col>
      </.table>
    </.card>
    """
  end
end
