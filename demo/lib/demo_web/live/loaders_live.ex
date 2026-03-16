defmodule DemoWeb.Live.LoadersLive do
  use DemoWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, page_title: "Loaders")}
  end

  def render(assigns) do
    ~H"""
    <.paragraph>Loading indicators and spinner components for async operations.</.paragraph>

    <%!-- Spinner Sizes --%>
    <.card title_text="Spinner Sizes" class="mb-6">
      <.grid>
        <.column size="100" md="1-4" class="text-center mb-4">
          <.spinner size="xs" />
          <.paragraph class="mt-2 text-secondary">.pa-spinner--xs<br />0.75rem</.paragraph>
        </.column>
        <.column size="100" md="1-4" class="text-center mb-4">
          <.spinner size="sm" />
          <.paragraph class="mt-2 text-secondary">.pa-spinner--sm<br />1rem</.paragraph>
        </.column>
        <.column size="100" md="1-4" class="text-center mb-4">
          <.spinner size="md" />
          <.paragraph class="mt-2 text-secondary">.pa-spinner--md<br />1.5rem</.paragraph>
        </.column>
        <.column size="100" md="1-4" class="text-center mb-4">
          <.spinner size="lg" />
          <.paragraph class="mt-2 text-secondary">.pa-spinner--lg<br />2rem</.paragraph>
        </.column>
        <.column size="100" md="1-4" class="text-center mb-4">
          <.spinner size="xl" />
          <.paragraph class="mt-2 text-secondary">.pa-spinner--xl<br />3rem</.paragraph>
        </.column>
        <.column size="100" md="1-4" class="text-center mb-4">
          <.spinner size="2xl" />
          <.paragraph class="mt-2 text-secondary">.pa-spinner--2xl<br />4rem</.paragraph>
        </.column>
      </.grid>
    </.card>

    <%!-- Spinner Colors --%>
    <.card title_text="Spinner Colors" class="mb-6">
      <.grid>
        <.column size="100" md="1-4" class="text-center mb-4">
          <.spinner size="lg" variant="primary" />
          <.paragraph class="mt-2 text-secondary">.pa-spinner--primary</.paragraph>
        </.column>
        <.column size="100" md="1-4" class="text-center mb-4">
          <.spinner size="lg" variant="secondary" />
          <.paragraph class="mt-2 text-secondary">.pa-spinner--secondary</.paragraph>
        </.column>
        <.column size="100" md="1-4" class="text-center mb-4">
          <.spinner size="lg" variant="success" />
          <.paragraph class="mt-2 text-secondary">.pa-spinner--success</.paragraph>
        </.column>
        <.column size="100" md="1-4" class="text-center mb-4">
          <.spinner size="lg" variant="danger" />
          <.paragraph class="mt-2 text-secondary">.pa-spinner--danger</.paragraph>
        </.column>
        <.column size="100" md="1-4" class="text-center mb-4">
          <.spinner size="lg" variant="warning" />
          <.paragraph class="mt-2 text-secondary">.pa-spinner--warning</.paragraph>
        </.column>
        <.column size="100" md="1-4" class="text-center mb-4">
          <.spinner size="lg" variant="info" />
          <.paragraph class="mt-2 text-secondary">.pa-spinner--info</.paragraph>
        </.column>
      </.grid>
    </.card>

    <%!-- Inline Spinners --%>
    <.card title_text="Inline Spinners" class="mb-6">
      <.paragraph class="mb-4">
        <.spinner size="xs" variant="primary" class="d-inline-block mr-2" />
        Loading inline content...
      </.paragraph>
      <.paragraph class="mb-4">
        <.spinner size="sm" variant="success" class="d-inline-block mr-2" />
        Processing your request...
      </.paragraph>
      <.paragraph>
        <.spinner size="sm" variant="info" class="d-inline-block mr-2" />
        Fetching data from server...
      </.paragraph>
    </.card>

    <%!-- Centered Loaders --%>
    <.card title_text="Centered Loaders" class="mb-6">
      <div class="h-20x position-relative border border-dashed rounded">
        <.loader_overlay>
          <.spinner size="xl" variant="primary" />
        </.loader_overlay>
      </div>
    </.card>

    <%!-- Loaders with Text --%>
    <.card title_text="Loaders with Text" class="mb-6">
      <.grid>
        <.column size="100" md="1-2" class="mb-4">
          <.loader_center class="h-15x border border-dashed rounded">
            <.spinner size="lg" variant="primary" />
            <.paragraph class="mt-4 text-secondary">Loading data...</.paragraph>
          </.loader_center>
        </.column>
        <.column size="100" md="1-2" class="mb-4">
          <.loader_center class="h-15x border border-dashed rounded">
            <.spinner size="lg" variant="success" />
            <.paragraph class="mt-4 text-secondary">Processing...</.paragraph>
          </.loader_center>
        </.column>
      </.grid>
    </.card>

    <%!-- Card Loading States --%>
    <.card title_text="Card Loading States" class="mb-6">
      <.grid>
        <.column size="100" md="1-3" class="mb-4">
          <.card>
            <:header><.heading level={4}>Loading Card</.heading></:header>
            <div class="h-15x position-relative">
              <.loader_overlay>
                <.spinner size="lg" variant="primary" />
              </.loader_overlay>
            </div>
          </.card>
        </.column>
        <.column size="100" md="1-3" class="mb-4">
          <.card>
            <:header><.heading level={4}>Loading with Text</.heading></:header>
            <.loader_center class="h-15x">
              <.spinner size="lg" variant="info" />
              <.paragraph class="mt-4 text-secondary">Fetching data...</.paragraph>
            </.loader_center>
          </.card>
        </.column>
        <.column size="100" md="1-3" class="mb-4">
          <.card>
            <:header><.heading level={4}>Loaded Content</.heading></:header>
            <.paragraph>Content has loaded successfully!</.paragraph>
            <.paragraph class="mt-2">This is what appears after the loader completes.</.paragraph>
          </.card>
        </.column>
      </.grid>
    </.card>

    <%!-- Loader Types --%>
    <.card title_text="Loader Types" class="mb-6">
      <.grid>
        <.column size="100" md="1-3" class="text-center mb-6">
          <.loader type="dots" size="lg" color="primary" />
          <.paragraph class="mt-2 text-secondary"><strong>Dots Loader</strong></.paragraph>
          <.paragraph class="mt-2"><code>.pa-loader-dots</code></.paragraph>
        </.column>
        <.column size="100" md="1-3" class="text-center mb-6">
          <.loader type="bars" size="lg" color="success" />
          <.paragraph class="mt-2 text-secondary"><strong>Bars Loader</strong></.paragraph>
          <.paragraph class="mt-2"><code>.pa-loader-bars</code></.paragraph>
        </.column>
        <.column size="100" md="1-3" class="text-center mb-6">
          <.loader type="pulse" size="lg" color="danger" />
          <.paragraph class="mt-2 text-secondary"><strong>Pulse Loader</strong></.paragraph>
          <.paragraph class="mt-2"><code>.pa-loader-pulse</code></.paragraph>
        </.column>
        <.column size="100" md="1-3" class="text-center mb-4">
          <.loader type="ring" size="lg" color="warning" />
          <.paragraph class="mt-2 text-secondary"><strong>Ring Loader</strong></.paragraph>
          <.paragraph class="mt-2"><code>.pa-loader-ring</code></.paragraph>
        </.column>
        <.column size="100" md="1-3" class="text-center mb-4">
          <.loader type="wave" size="lg" color="info" />
          <.paragraph class="mt-2 text-secondary"><strong>Wave Loader</strong></.paragraph>
          <.paragraph class="mt-2"><code>.pa-loader-wave</code></.paragraph>
        </.column>
        <.column size="100" md="1-3" class="text-center mb-4">
          <.spinner size="xl" class="text-secondary" />
          <.paragraph class="mt-2 text-secondary"><strong>Spinner</strong></.paragraph>
          <.paragraph class="mt-2"><code>.pa-spinner</code></.paragraph>
        </.column>
      </.grid>
    </.card>

    <%!-- Button Loading States --%>
    <.card title_text="Button Loading States" class="mb-6">
      <.button_group>
        <.button variant="primary" is_loading>Saving...</.button>
        <.button variant="success" is_loading>Processing...</.button>
        <.button variant="danger" is_loading>Deleting...</.button>
      </.button_group>
    </.card>
    """
  end
end
