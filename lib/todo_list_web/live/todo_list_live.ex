defmodule TodoListWeb.TodoListLive do
  use TodoListWeb, :live_view

  require Logger

  alias TodoList.TaskList

  @todo_list_topic "todo_list"

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: TodoListWeb.Endpoint.subscribe(@todo_list_topic)

    default_assigns = %{
      tasks: TaskList.list_tasks,
      edit_form: Phoenix.Component.to_form(TaskList.create_changeset(%{})),
      create_form: Phoenix.Component.to_form(TaskList.create_changeset(%{})),
      filter_form: Phoenix.Component.to_form(%{})
    }
    {:ok, socket
      |> assign(default_assigns)
      |> allow_upload(:documents, accept: ~w(.pdf .doc .docx), max_entries: 5)}
  end

  def user_opts() do
    for user <- TodoList.Accounts.get_users!() do
      [key: user.email, value: user.id]
    end
  end

  def open_edit_modal(task_id) do
    %JS{}
    |> JS.push("open_edit_modal", value: %{task_id: task_id})
    |> TodoListWeb.CoreComponents.show_modal("edit_modal")
  end

  def open_create_modal() do
    %JS{}
    |> JS.push("open_create_modal")
    |> TodoListWeb.CoreComponents.show_modal("create_modal")
  end

  @impl true
  def handle_event("open_edit_modal", %{"task_id" => task_id}, socket) do
    task = get_task(socket.assigns.tasks, task_id)

    new_assigns = %{
      edit_form: Phoenix.Component.to_form(TaskList.change_task(task, %{}))
    }

    {:noreply, assign(socket, new_assigns)}
  end

  @impl true
  def handle_event("edit_task", %{"task" => %{"id" => id} = params}, socket) do
    task = get_task(socket.assigns.tasks, String.to_integer(id))

    case TaskList.update_task(task, params) do
      {:error, message} ->
        {:noreply, socket |> put_flash(:error, inspect(message))}

      {:ok, _} ->
        new_assigns = %{
          tasks: TaskList.list_tasks(),
          edit_form: Phoenix.Component.to_form(TaskList.create_changeset(%{}))
        }

        socket =
          socket
          |> assign(new_assigns)
          |> push_event("close_modal", %{to: "#close_modal_btn_edit_modal"})

        TodoListWeb.Endpoint.broadcast(@todo_list_topic, "tasks_updated", socket.assigns)

        {:noreply, socket}
    end
  end

  @impl true
  def handle_event("delete_task", %{"task_id" => task_id}, socket) do
    task = get_task(socket.assigns.tasks, String.to_integer(task_id))

    case TaskList.delete_task(task) do
      {:error, message} ->
        {:noreply, socket |> put_flash(:error, inspect(message))}

      {:ok, _} ->
        socket = assign(socket, tasks: TaskList.list_tasks())
        TodoListWeb.Endpoint.broadcast(@todo_list_topic, "tasks_updated", socket.assigns)

        {:noreply, socket}
    end
  end

  def handle_event("open_create_modal", _, socket) do
    new_assigns = %{
      create_form: Phoenix.Component.to_form(TaskList.create_changeset(%{}))
    }

    {:noreply, assign(socket, new_assigns)}
  end

  def handle_event("create_task", %{"task" => task}, socket) do
    uploaded_docs = handle_documents(socket)

    task = Map.put(task, "documents", uploaded_docs)

    case TaskList.create_task(task) do
      {:error, message} ->
        {:noreply, socket |> put_flash(:error, inspect(message))}

      {:ok, _} ->
        new_assigns = %{
          tasks: TaskList.list_tasks()
        }

        socket =
          socket
          |> assign(new_assigns)
          |> push_event("close_modal", %{to: "#close_modal_btn_create_modal"})

        TodoListWeb.Endpoint.broadcast(@todo_list_topic, "tasks_updated", socket.assigns)

        {:noreply, socket}
    end
  end

  @impl true
  def handle_event("validate", %{"task" => task_params}, socket) do
    changeset =
      Phoenix.Component.to_form(TaskList.create_changeset(task_params))
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :create_form, to_form(changeset))}
  end

  @impl true
  def handle_event("cancel_upload", %{"ref" => ref}, socket) do
    {:noreply, cancel_upload(socket, :documents, ref)}
  end

  def handle_event("filter_by_priority", %{"priority" => "All"}, socket) do
    tasks = TaskList.list_tasks()
    {:noreply, assign(socket, tasks: tasks)}
  end

  def handle_event("filter_by_priority", %{"priority" => priority}, socket) do
    tasks = TaskList.lists_tasks_by_priority(priority)
    {:noreply, assign(socket, tasks: tasks)}
  end

  @impl true
  def handle_event(event, params, socket) do
    Logger.error("unrecognised event: #{event} with params: #{inspect(params)}")
    {:noreply, socket}
  end

  @impl true
  def handle_info(%{event: "tasks_updated", payload: %{tasks: tasks}}, socket) do
    {:noreply, assign(socket, tasks: tasks)}
  end

  defp get_task(tasks, task_id) do
    Enum.find(tasks, &(&1.id == task_id))
  end

  defp handle_documents(socket) do
    consume_uploaded_entries(socket, :documents, fn %{path: path}, entry ->
      dest = Path.join([:code.priv_dir(:todo_list), "static", "uploads", entry.client_name])
      File.cp!(path, dest)
      {:ok, ~p"/uploads/#{Path.basename(dest)}"}
    end)
  end
end
