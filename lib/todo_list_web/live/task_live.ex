defmodule TodoListWeb.TaskLive do
  alias TodoList.TaskList
  use TodoListWeb, :live_view
  require Logger

  @task_topic "task_topic"

  @impl true
  def mount(%{"task_id" => task_id}, _session, socket) do
    if connected?(socket), do: TodoListWeb.Endpoint.subscribe(@task_topic)

    try do
        default_assigns = %{
        task: TodoList.TaskList.get_task!(String.to_integer(task_id)),
        create_comment: Phoenix.Component.to_form(TaskList.create_comment_changeset(%{}))
      }

      {:ok, assign(socket, default_assigns)}
    rescue
      Ecto.NoResultsError ->
        {:ok, push_navigate(socket, to: ~p"/tasks")}
    end
  end

  @impl true
  def handle_event("create_comment", %{"comment" => comment}, socket) do
    case TodoList.TaskList.create_comment(comment) do
      {:error, message} ->
        {:noreply, socket |> put_flash(:error, inspect(message))}

      {:ok, _} ->
        new_assigns = %{
          task: TodoList.TaskList.get_task!(socket.assigns.task.id),
          create_comment: Phoenix.Component.to_form(TaskList.create_comment_changeset(%{}))
        }

        socket = assign(socket, new_assigns)
        TodoListWeb.Endpoint.broadcast(@task_topic, "task_commented", socket.assigns)

        {:noreply, socket}
    end
  end

  @impl true
  def handle_event(event, params, socket) do
    Logger.error("unrecognised event: #{event} with params: #{inspect(params)}")
    {:noreply, socket}
  end

  @impl true
  def handle_info(%{event: "task_commented", payload: %{task: task}}, socket) do
    {:noreply, assign(socket, task: task)}
  end
end
