defmodule DemoWeb.Live.TooltipsLive do
  use DemoWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, page_title: "Tooltips")}
  end

  def render(assigns) do
    ~H"""
    <.paragraph>CSS-only tooltips and click-triggered popovers for contextual information.</.paragraph>

    <.grid>
      <%!-- Left Column --%>
      <.column size="100" lg="1-2">
        <%!-- Tooltip Positions & Colors --%>
        <.card title_text="Tooltip Positions & Colors" class="mb-4">
          <.grid>
            <.column size="1-2" md="1-4" class="text-center mb-3 p-4">
              <.tooltip text="Tooltip on top">Top</.tooltip>
            </.column>
            <.column size="1-2" md="1-4" class="text-center mb-3 p-4">
              <.tooltip text="Tooltip on right" position="right">Right</.tooltip>
            </.column>
            <.column size="1-2" md="1-4" class="text-center mb-3 p-4">
              <.tooltip text="Tooltip on bottom" position="bottom">Bottom</.tooltip>
            </.column>
            <.column size="1-2" md="1-4" class="text-center mb-3 p-4">
              <.tooltip text="Tooltip on left" position="left">Left</.tooltip>
            </.column>
          </.grid>
          <hr class="my-3" />
          <.grid>
            <.column size="1-3" md="1-5" class="text-center mb-3 p-4">
              <.tooltip text="Default dark">Default</.tooltip>
            </.column>
            <.column size="1-3" md="1-5" class="text-center mb-3 p-4">
              <.tooltip text="Primary blue" variant="primary">Primary</.tooltip>
            </.column>
            <.column size="1-3" md="1-5" class="text-center mb-3 p-4">
              <.tooltip text="Success green" variant="success">Success</.tooltip>
            </.column>
            <.column size="1-2" md="1-5" class="text-center mb-3 p-4">
              <.tooltip text="Warning yellow" variant="warning">Warning</.tooltip>
            </.column>
            <.column size="1-2" md="1-5" class="text-center mb-3 p-4">
              <.tooltip text="Danger red" variant="danger">Danger</.tooltip>
            </.column>
          </.grid>
          <hr class="my-3" />
          <.paragraph class="text-sm mb-3">Theme colors (color-1 to color-9):</.paragraph>
          <.grid>
            <.column :for={i <- 1..9} class="text-center mb-3 p-2">
              <.tooltip text={"Color #{i}"} variant={"color-#{i}"}><%= i %></.tooltip>
            </.column>
          </.grid>
        </.card>

        <%!-- Buttons with Tooltips --%>
        <.card title_text="Buttons & Icon-Only" class="mb-4">
          <.paragraph class="mb-3 text-sm">Regular buttons:</.paragraph>
          <div class="text-center mb-4">
            <.button_group>
              <.tooltip text="Save your changes" position="left">
                <.button variant="primary" size="sm">
                  <:icon><i class="fa-solid fa-floppy-disk"></i></:icon>
                  Save
                </.button>
              </.tooltip>
              <.tooltip text="Cancel and go back" position="bottom">
                <.button variant="secondary" size="sm">
                  <:icon><i class="fa-solid fa-xmark"></i></:icon>
                  Cancel
                </.button>
              </.tooltip>
              <.tooltip text="Delete this item" position="bottom">
                <.button variant="danger" size="sm">
                  <:icon><i class="fa-solid fa-trash"></i></:icon>
                  Delete
                </.button>
              </.tooltip>
            </.button_group>
          </div>
          <.paragraph class="mb-3 text-sm">Icon-only buttons:</.paragraph>
          <div class="text-center">
            <.button_group>
              <.tooltip text="Edit" position="bottom">
                <.button variant="primary" size="sm" is_icon_only><i class="fa-solid fa-pen"></i></.button>
              </.tooltip>
              <.tooltip text="Copy" position="bottom">
                <.button variant="secondary" size="sm" is_icon_only><i class="fa-solid fa-copy"></i></.button>
              </.tooltip>
              <.tooltip text="Download" position="bottom">
                <.button variant="success" size="sm" is_icon_only><i class="fa-solid fa-download"></i></.button>
              </.tooltip>
              <.tooltip text="Settings" position="bottom">
                <.button variant="warning" size="sm" is_icon_only><i class="fa-solid fa-gear"></i></.button>
              </.tooltip>
              <.tooltip text="Delete" position="bottom">
                <.button variant="danger" size="sm" is_icon_only><i class="fa-solid fa-trash"></i></.button>
              </.tooltip>
              <.tooltip text="Info" position="bottom">
                <.button variant="info" size="sm" is_icon_only><i class="fa-solid fa-circle-info"></i></.button>
              </.tooltip>
            </.button_group>
          </div>
        </.card>

        <%!-- Multiline Tooltips --%>
        <.card title_text="Multiline Tooltips" class="mb-4">
          <.paragraph class="mb-3 text-sm">
            Use <code>multiline</code> prop for longer text (20rem width, left-aligned):
          </.paragraph>
          <div class="text-center">
            <.button_group>
              <.tooltip text="This button will save your changes to the database. Make sure you have reviewed all fields before clicking. Changes cannot be undone after saving." position="bottom" multiline>
                <.button variant="primary" size="sm">
                  <:icon><i class="fa-solid fa-floppy-disk"></i></:icon>
                  Save
                </.button>
              </.tooltip>
              <.tooltip text="This action will permanently delete the selected item and all associated data. This operation cannot be reversed. Please confirm you want to proceed." position="bottom" multiline>
                <.button variant="danger" size="sm">
                  <:icon><i class="fa-solid fa-trash"></i></:icon>
                  Delete
                </.button>
              </.tooltip>
            </.button_group>
          </div>
        </.card>

        <%!-- Inline Text Tooltips --%>
        <.card title_text="Inline Text Tooltips" class="mb-4">
          <.paragraph>
            Tooltips can explain <.tooltip text="Application Programming Interface" variant="primary" is_inline>API</.tooltip> terms,
            <.tooltip text="Cascading Style Sheets" variant="success" is_inline>CSS</.tooltip>, or
            <.tooltip text="HyperText Markup Language" variant="danger" is_inline>HTML</.tooltip> abbreviations.
          </.paragraph>
        </.card>
      </.column>

      <%!-- Right Column --%>
      <.column size="100" lg="1-2">
        <%!-- Popovers --%>
        <.card title_text="Popovers - Interactive Help" class="mb-4">
          <.paragraph class="mb-3 text-sm">
            Rich content with links, formatting. Click <strong>?</strong> to open:
          </.paragraph>
          <.grid>
            <.column size="1-2" md="1-4" class="mb-3 text-center p-2">
              <label class="text-sm">
                Basic
                <.popover title_text="Help" placement="bottom">
                  <.paragraph>Basic popover with <strong>bold</strong>, <em>italic</em>, and <a href="#">links</a>.</.paragraph>
                </.popover>
              </label>
            </.column>
            <.column size="1-2" md="1-4" class="mb-3 text-center p-2">
              <label class="text-sm">
                With List
                <.popover title_text="Options" placement="bottom">
                  <.paragraph>Select from:</.paragraph>
                  <.basic_list>
                    <li>Option A</li>
                    <li>Option B</li>
                    <li>Option C</li>
                  </.basic_list>
                </.popover>
              </label>
            </.column>
            <.column size="1-2" md="1-4" class="mb-3 text-center p-2">
              <label class="text-sm">
                Large
                <.popover title_text="Documentation" placement="bottom" size="lg">
                  <.paragraph>Use <code>size="lg"</code> prop for wider content (up to 28rem).</.paragraph>
                  <.paragraph>Perfect for detailed explanations and documentation.</.paragraph>
                </.popover>
              </label>
            </.column>
            <.column size="1-2" md="1-4" class="mb-3 text-center p-2">
              <label class="text-sm">
                Small
                <.popover title_text="Tip" placement="bottom" size="sm">
                  <.paragraph>Brief hints use <code>size="sm"</code>.</.paragraph>
                </.popover>
              </label>
            </.column>
          </.grid>
          <hr class="my-3" />
          <.paragraph class="mb-3 text-sm">Text alignment variants:</.paragraph>
          <.grid>
            <.column size="1-3" class="mb-3 text-center p-2">
              <label class="text-sm">
                Left (default)
                <.popover title_text="Left Aligned" placement="bottom">
                  <.paragraph>Default alignment is left.</.paragraph>
                  <.basic_list>
                    <li>Lists look natural</li>
                    <li>Easy to read</li>
                    <li>Best for content</li>
                  </.basic_list>
                </.popover>
              </label>
            </.column>
            <.column size="1-3" class="mb-3 text-center p-2">
              <label class="text-sm">
                Center
                <.popover title_text="Centered" placement="bottom" alignment="center">
                  <.paragraph>Use <code>alignment="center"</code> prop.</.paragraph>
                  <.paragraph>Good for short messages.</.paragraph>
                </.popover>
              </label>
            </.column>
            <.column size="1-3" class="mb-3 text-center p-2">
              <label class="text-sm">
                End
                <.popover title_text="End Aligned" placement="bottom" alignment="end">
                  <.paragraph>Use <code>alignment="end"</code> prop.</.paragraph>
                  <.paragraph>For RTL or special layouts.</.paragraph>
                </.popover>
              </label>
            </.column>
          </.grid>
        </.card>

        <%!-- Popover Positions --%>
        <.card title_text="Popover Positions" class="mb-4">
          <.grid>
            <.column size="1-2" md="1-4" class="text-center mb-3 p-4">
              <span class="text-sm">Top </span>
              <.popover title_text="Top">
                <.paragraph>Appears above trigger.</.paragraph>
              </.popover>
            </.column>
            <.column size="1-2" md="1-4" class="text-center mb-3 p-4">
              <span class="text-sm">Right </span>
              <.popover title_text="Right" placement="right">
                <.paragraph>Appears to the right.</.paragraph>
              </.popover>
            </.column>
            <.column size="1-2" md="1-4" class="text-center mb-3 p-4">
              <span class="text-sm">Bottom </span>
              <.popover title_text="Bottom" placement="bottom">
                <.paragraph>Appears below trigger.</.paragraph>
              </.popover>
            </.column>
            <.column size="1-2" md="1-4" class="text-center mb-3 p-4">
              <span class="text-sm">Left </span>
              <.popover title_text="Left" placement="left">
                <.paragraph>Appears to the left.</.paragraph>
              </.popover>
            </.column>
          </.grid>
        </.card>
      </.column>
    </.grid>
    """
  end
end
