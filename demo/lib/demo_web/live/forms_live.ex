defmodule DemoWeb.Live.FormsLive do
  use DemoWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, page_title: "Forms")}
  end

  def render(assigns) do
    ~H"""
    <h1 class="pa-page-title">Forms</h1>
    <p class="pa-page-subtitle">
      Complete set of form elements with various styles and states for data input.
    </p>

    <%!-- User Profile Form --%>
    <.card title_text="Profile Form">
      <:tools>
        <.button variant="secondary" size="sm">Cancel</.button>
        <.button variant="primary" size="sm">Save</.button>
      </:tools>
      <.grid>
        <.column size="50">
          <.form_group label="First Name">
            <.input type="text" placeholder="Enter first name" value="John" />
          </.form_group>
        </.column>
        <.column size="50">
          <.form_group label="Last Name">
            <.input type="text" placeholder="Enter last name" value="Doe" />
          </.form_group>
        </.column>
        <.column size="50">
          <.form_group label="Email">
            <.input type="email" placeholder="Enter email" value="john@example.com" />
          </.form_group>
        </.column>
        <.column size="50">
          <.form_group label="Phone">
            <.input type="text" placeholder="Enter phone number" />
          </.form_group>
        </.column>
        <.column size="50">
          <.form_group label="Department">
            <.select options={["Engineering", "Marketing", "Sales", "Support"]} />
          </.form_group>
        </.column>
        <.column size="50">
          <.form_group label="Start Date">
            <.input type="date" />
          </.form_group>
        </.column>
        <.column size="100">
          <.form_group label="Bio">
            <.textarea placeholder="Tell us about yourself..." rows="3" />
          </.form_group>
        </.column>
      </.grid>
    </.card>

    <%!-- Input Groups --%>
    <.card title_text="Input Groups">
      <.grid>
        <.column size="50">
          <.form_group label="Username">
            <.input_group>
              <:prepend>@</:prepend>
              <.input type="text" placeholder="username" />
            </.input_group>
          </.form_group>
        </.column>
        <.column size="50">
          <.form_group label="Amount">
            <.input_group>
              <:prepend>$</:prepend>
              <.input type="text" placeholder="0.00" />
              <:append>USD</:append>
            </.input_group>
          </.form_group>
        </.column>
        <.column size="50">
          <.form_group label="Search">
            <.input_group>
              <.input type="text" placeholder="Search..." />
              <:append>
                <.button variant="primary" size="sm">Search</.button>
              </:append>
            </.input_group>
          </.form_group>
        </.column>
        <.column size="50">
          <.form_group label="Website">
            <.input_group>
              <:prepend>https://</:prepend>
              <.input type="text" placeholder="example" />
              <:append>.com</:append>
            </.input_group>
          </.form_group>
        </.column>
      </.grid>
    </.card>

    <%!-- Form States --%>
    <.card title_text="Input States">
      <.grid>
        <.column size="20">
          <.form_group label="Disabled">
            <.input type="text" placeholder="Disabled" disabled />
          </.form_group>
        </.column>
        <.column size="20">
          <.form_group label="Readonly">
            <.input type="text" value="Read only value" readonly />
          </.form_group>
        </.column>
        <.column size="20">
          <.form_group label="With Help Text">
            <.input type="text" placeholder="Username" />
            <.form_help>Must be 3-20 characters long</.form_help>
          </.form_group>
        </.column>
        <.column size="20">
          <.form_group label="With Error">
            <.input type="text" placeholder="Required field" is_error />
            <.form_help variant="error">This field is required</.form_help>
          </.form_group>
        </.column>
        <.column size="20">
          <.form_group label="With Success">
            <.input type="text" value="Valid input" is_success />
            <.form_help variant="success">Looks good!</.form_help>
          </.form_group>
        </.column>
      </.grid>
    </.card>

    <%!-- Input Sizes --%>
    <.card title_text="Input Sizes">
      <div style="display: flex; flex-direction: column; gap: 12px; max-width: 400px;">
        <.form_group label="Extra Small">
          <.input type="text" placeholder="XS input" size="xs" />
        </.form_group>
        <.form_group label="Small">
          <.input type="text" placeholder="SM input" size="sm" />
        </.form_group>
        <.form_group label="Default">
          <.input type="text" placeholder="Default input" />
        </.form_group>
        <.form_group label="Large">
          <.input type="text" placeholder="LG input" size="lg" />
        </.form_group>
        <.form_group label="Extra Large">
          <.input type="text" placeholder="XL input" size="xl" />
        </.form_group>
      </div>
    </.card>

    <%!-- Checkboxes and Radios --%>
    <.grid>
      <.column size="50">
        <.card title_text="Checkboxes & Radios">
          <.checkbox_group>
            <.checkbox label="Option 1" checked />
            <.checkbox label="Option 2" />
            <.checkbox label="Option 3 (disabled)" disabled />
          </.checkbox_group>
        </.card>
      </.column>
      <.column size="50">
        <.card title_text="Checkboxes & Radios">
          <.radio_group>
            <.radio name="choice" label="Choice A" value="a" checked />
            <.radio name="choice" label="Choice B" value="b" />
            <.radio name="choice" label="Choice C (disabled)" value="c" disabled />
          </.radio_group>
        </.card>
      </.column>
    </.grid>

    <%!-- Select --%>
    <.card title_text="Select Inputs">
      <.grid>
        <.column size="33">
          <.form_group label="Standard Select">
            <.select options={["Option 1", "Option 2", "Option 3"]} />
          </.form_group>
        </.column>
        <.column size="33">
          <.form_group label="Disabled Select">
            <.select options={["Cannot change"]} disabled />
          </.form_group>
        </.column>
        <.column size="33">
          <.form_group label="With Placeholder">
            <.select options={["", "Red", "Green", "Blue"]} prompt="Choose a color..." />
          </.form_group>
        </.column>
      </.grid>
    </.card>

    <%!-- Compact Three Column Layout --%>
    <.card title_text="Compact Form Layout">
      <.grid>
        <.column size="33">
          <.form_group label="First Name">
            <.input type="text" placeholder="First Name" size="sm" />
          </.form_group>
        </.column>
        <.column size="33">
          <.form_group label="Last Name">
            <.input type="text" placeholder="Last Name" size="sm" />
          </.form_group>
        </.column>
        <.column size="33">
          <.form_group label="Email">
            <.input type="email" placeholder="Email" size="sm" />
          </.form_group>
        </.column>
        <.column size="33">
          <.form_group label="Phone">
            <.input type="text" placeholder="Phone" size="sm" />
          </.form_group>
        </.column>
        <.column size="33">
          <.form_group label="Country">
            <.select options={["USA", "UK", "Germany", "France", "Czech Republic"]} size="sm" />
          </.form_group>
        </.column>
        <.column size="33">
          <.form_group label="ZIP Code">
            <.input type="text" placeholder="ZIP" size="sm" />
          </.form_group>
        </.column>
      </.grid>
    </.card>
    """
  end
end
