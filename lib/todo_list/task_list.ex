defmodule TodoList.TaskList do
  @moduledoc """
  The TaskList context.
  """

  import Ecto.Query, warn: false
  alias TodoList.Repo

  alias TodoList.TaskList.Task

  @doc """
  Returns the list of tasks.

  ## Examples

      iex> list_tasks()
      [%Task{}, ...]

  """
  def list_tasks do
    Task
    |> order_by(asc: :priority)
    |> Repo.all()
    |> Repo.preload(:user)
  end

  @doc """
  Returns the list of tasks by priority.

  ## Examples

      iex> list_tasks_by_priority(priority)
      [%Task{}, ...]

  """
  def lists_tasks_by_priority(priority) do
    query = from t in Task,
      where: t.priority == ^priority,
      order_by: [desc: t.inserted_at]

    Repo.all(query)
    |> Repo.preload(:user)
  end

  @doc """
  Gets a single task.

  Raises `Ecto.NoResultsError` if the Task does not exist.

  ## Examples

      iex> get_task!(123)
      %Task{}

      iex> get_task!(456)
      ** (Ecto.NoResultsError)

  """
  def get_task!(id), do: Repo.get!(Task, id) |> Repo.preload([:user, comments: [:user]])

  @doc """
  Creates a task.

  ## Examples

      iex> create_task(%{field: value})
      {:ok, %Task{}}

      iex> create_task(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_task(attrs \\ %{}) do
    %Task{}
    |> Task.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a task.

  ## Examples

      iex> update_task(task, %{field: new_value})
      {:ok, %Task{}}

      iex> update_task(task, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_task(%Task{} = task, attrs) do
    task
    |> Task.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a task.

  ## Examples

      iex> delete_task(task)
      {:ok, %Task{}}

      iex> delete_task(task)
      {:error, %Ecto.Changeset{}}

  """
  def delete_task(%Task{} = task) do
    Repo.delete(task)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking task changes.

  ## Examples

      iex> change_task(task)
      %Ecto.Changeset{data: %Task{}}

  """
  def change_task(%Task{} = task, attrs \\ %{}) do
    Task.changeset(task, attrs)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` with empty `%Task{}`

  ## Examples

      iex> create_changeset(attrs)
      %Ecto.Changeset({data: %Task{})
  """
  def create_changeset(attrs) do
    Task.create_changeset(attrs)
  end

  alias TodoList.TaskList.Comment

  @doc """
  Creates a comment.

  ## Examples

      iex> create_comment(%{field: value})
      {:ok, %Comment{}}

      iex> create_comment(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_comment(attrs \\ %{}) do
    %Comment{}
    |> Comment.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking comment changes.

  ## Examples

      iex> change_comment(comment)
      %Ecto.Changeset{data: %Comment{}}

  """
  def change_comment(%Comment{} = comment, attrs \\ %{}) do
    Comment.changeset(comment, attrs)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` with empty `%Comment{}`

  ## Examples

      iex> create_comment_changeset(attrs)
      %Ecto.Changeset({data: %Comment{})
  """
  def create_comment_changeset(attrs) do
    Comment.create_changeset(attrs)
  end
end
