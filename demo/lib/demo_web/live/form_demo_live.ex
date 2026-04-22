defmodule DemoWeb.Live.FormDemoLive do
  use DemoWeb, :live_view

  alias Demo.FormCache
  alias PureAdmin.Components.Flash, as: PureFlash

  @empty_params %{
    "first_name" => "",
    "last_name" => "",
    "email" => "",
    "department" => "",
    "start_date" => "",
    "bio" => ""
  }

  @departments ["Engineering", "Marketing", "Sales", "Support", "Product"]

  @impl true
  def mount(_params, session, socket) do
    session_id = session["form_session_id"]

    entries =
      case session_id do
        nil -> []
        id -> FormCache.list(id)
      end

    {:ok,
     assign(socket,
       page_title: "Form Demo",
       session_id: session_id,
       entries: entries
     )
     |> assign_form(@empty_params, [])}
  end

  @impl true
  def handle_event("submit", %{"entry" => params}, socket) do
    params = Map.merge(@empty_params, Map.take(params, Map.keys(@empty_params)))

    case validate(params) do
      [] when is_binary(socket.assigns.session_id) ->
        entries = FormCache.put(socket.assigns.session_id, to_entry(params))

        {:noreply,
         socket
         |> assign(entries: entries)
         |> assign_form(@empty_params, [])
         |> PureFlash.push_flash("form-demo", "success", "Entry saved to session cache.",
           title: "Saved",
           duration: 3000
         )}

      [] ->
        {:noreply,
         PureFlash.push_flash(socket, "form-demo", "danger",
           "Session not initialised — reload the page and try again.",
           title: "Error"
         )}

      errors ->
        {:noreply,
         socket
         |> assign_form(params, errors)
         |> PureFlash.push_flash("form-demo", "danger", "Please fix the errors below.",
           title: "Validation failed"
         )}
    end
  end

  def handle_event("delete", %{"id" => id}, socket) do
    case Integer.parse(id) do
      {int_id, ""} when is_binary(socket.assigns.session_id) ->
        entries = FormCache.delete(socket.assigns.session_id, int_id)
        {:noreply, assign(socket, entries: entries)}

      _ ->
        {:noreply, socket}
    end
  end

  def handle_event("clear", _params, socket) do
    if socket.assigns.session_id, do: FormCache.clear(socket.assigns.session_id)

    {:noreply,
     socket
     |> assign(entries: [])
     |> PureFlash.push_flash("form-demo", "info", "All entries removed.", duration: 3000)}
  end

  # -- helpers --

  defp assign_form(socket, params, errors) do
    assign(socket, :form, to_form(params, as: :entry, errors: errors))
  end

  defp to_entry(params) do
    %{
      first_name: String.trim(params["first_name"]),
      last_name: String.trim(params["last_name"]),
      email: String.trim(params["email"]),
      department: params["department"],
      start_date: params["start_date"],
      bio: String.trim(params["bio"])
    }
  end

  defp validate(params) do
    []
    |> check_required(params, :first_name, "first name is required")
    |> check_required(params, :last_name, "last name is required")
    |> check_email(params)
    |> Enum.reverse()
  end

  defp check_required(errors, params, field, message) do
    if String.trim(params[to_string(field)] || "") == "" do
      [{field, {message, []}} | errors]
    else
      errors
    end
  end

  defp check_email(errors, params) do
    value = String.trim(params["email"] || "")

    cond do
      value == "" ->
        [{:email, {"email is required", []}} | errors]

      not (String.contains?(value, "@") and String.contains?(value, ".")) ->
        [{:email, {"enter a valid email address", []}} | errors]

      true ->
        errors
    end
  end

  defp field_error(field) do
    case field.errors do
      [{msg, _} | _] -> msg
      _ -> nil
    end
  end

  defp full_name(%{first_name: first, last_name: last}), do: String.trim("#{first} #{last}")

  defp format_time(%DateTime{} = dt) do
    dt
    |> DateTime.truncate(:second)
    |> Calendar.strftime("%Y-%m-%d %H:%M:%S UTC")
  end

  defp truncate(nil, _), do: ""
  defp truncate("", _), do: ""

  defp truncate(str, max) when is_binary(str) do
    if String.length(str) > max, do: String.slice(str, 0, max) <> "…", else: str
  end

  @impl true
  def render(assigns) do
    assigns = assign(assigns, :departments, @departments)

    ~H"""
    <.paragraph>
      Form submissions are written to a per-session ETS cache (<code>Demo.FormCache</code>)
      and rendered in the table below. Entries survive page refreshes and LiveView reconnects,
      but are evicted after 30 minutes of inactivity — so the cache clears itself once the
      browser session expires.
    </.paragraph>

    <.card title_text="New Entry" is_header_underlined>
      <.flash_container id="form-demo" />

      <.simple_form for={@form} phx-submit="submit">
        <.grid>
          <.column size="100" md="50">
            <.form_group validation={field_error(@form[:first_name]) && "error"}>
              <.form_label is_required>First Name</.form_label>
              <.input
                type="text"
                name={@form[:first_name].name}
                value={@form[:first_name].value}
                validation={field_error(@form[:first_name]) && "error"}
                placeholder="Jane"
              />
              <.form_help :if={msg = field_error(@form[:first_name])} variant="error">
                {msg}
              </.form_help>
            </.form_group>
          </.column>

          <.column size="100" md="50">
            <.form_group validation={field_error(@form[:last_name]) && "error"}>
              <.form_label is_required>Last Name</.form_label>
              <.input
                type="text"
                name={@form[:last_name].name}
                value={@form[:last_name].value}
                validation={field_error(@form[:last_name]) && "error"}
                placeholder="Doe"
              />
              <.form_help :if={msg = field_error(@form[:last_name])} variant="error">
                {msg}
              </.form_help>
            </.form_group>
          </.column>

          <.column size="100" md="50">
            <.form_group validation={field_error(@form[:email]) && "error"}>
              <.form_label is_required>Email</.form_label>
              <.input
                type="email"
                name={@form[:email].name}
                value={@form[:email].value}
                validation={field_error(@form[:email]) && "error"}
                placeholder="jane@example.com"
              />
              <.form_help :if={msg = field_error(@form[:email])} variant="error">
                {msg}
              </.form_help>
            </.form_group>
          </.column>

          <.column size="100" md="50">
            <.form_group>
              <.form_label>Department</.form_label>
              <.select
                name={@form[:department].name}
                value={@form[:department].value}
                prompt="Choose a department..."
                options={@departments}
              />
            </.form_group>
          </.column>

          <.column size="100" md="50">
            <.form_group>
              <.form_label>Start Date</.form_label>
              <.input
                type="date"
                name={@form[:start_date].name}
                value={@form[:start_date].value}
              />
            </.form_group>
          </.column>

          <.column size="100">
            <.form_group>
              <.form_label>Bio</.form_label>
              <.textarea
                name={@form[:bio].name}
                rows="3"
                value={@form[:bio].value}
                placeholder="A few words about this person..."
              />
            </.form_group>
          </.column>
        </.grid>

        <:actions>
          <.button type="reset" variant="secondary">Reset</.button>
          <.button type="submit" variant="primary">
            <i class="fa-solid fa-floppy-disk"></i> Save Entry
          </.button>
        </:actions>
      </.simple_form>
    </.card>

    <.card title_text="Stored Submissions" is_header_underlined>
      <:tools>
        <.badge variant="secondary">{length(@entries)} total</.badge>
        <.button
          :if={@entries != []}
          variant="danger"
          size="sm"
          phx-click="clear"
          data-confirm="Remove all stored submissions for this session?"
        >
          <i class="fa-solid fa-trash"></i> Clear All
        </.button>
      </:tools>

      <.callout :if={@entries == []} variant="info">
        No submissions yet. Fill in the form above and click <strong>Save Entry</strong>.
      </.callout>

      <.table :if={@entries != []} rows={@entries} is_striped is_hover is_responsive>
        <:col :let={e} label="Name">{full_name(e)}</:col>
        <:col :let={e} label="Email">
          <a href={"mailto:" <> e.email} class="pa-link">{e.email}</a>
        </:col>
        <:col :let={e} label="Department">
          <.badge :if={e.department != ""} variant="info">{e.department}</.badge>
          <span :if={e.department == ""} class="text-muted">—</span>
        </:col>
        <:col :let={e} label="Start Date">
          <span :if={e.start_date == ""} class="text-muted">—</span>
          <span :if={e.start_date != ""}>{e.start_date}</span>
        </:col>
        <:col :let={e} label="Bio" class="col-auto">
          <span :if={e.bio == ""} class="text-muted">—</span>
          <span :if={e.bio != ""} title={e.bio}>{truncate(e.bio, 60)}</span>
        </:col>
        <:col :let={e} label="Submitted">
          <small class="text-muted">{format_time(e.inserted_at)}</small>
        </:col>
        <:action :let={e}>
          <.button
            variant="danger"
            size="xs"
            phx-click="delete"
            phx-value-id={e.id}
            data-confirm="Remove this submission?"
          >
            <i class="fa-solid fa-xmark"></i>
          </.button>
        </:action>
      </.table>
    </.card>

    <.card title_text="How it works">
      <.basic_list>
        <li>
          Each browser session gets a random <code>form_session_id</code> planted in the
          Phoenix session cookie by <code>DemoWeb.SessionPlug</code>.
        </li>
        <li>
          <code>Demo.FormCache</code> stores submissions in a named ETS table keyed by that id.
          Reads refresh a sliding 30-minute TTL; <code>Demo.FormCache.Sweeper</code> ticks once a
          minute and evicts inactive rows so expired sessions leave no trace.
        </li>
        <li>
          The server-side cache outlives LiveView reconnects and hard refreshes, but is dropped
          on application restart — exactly what a demo needs.
        </li>
      </.basic_list>
    </.card>
    """
  end
end
