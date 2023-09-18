defmodule TodoList.TaskListFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TodoList.TaskList` context.
  """

  @doc """
  Generate a unique task user_uuid.
  """
  def unique_task_user_uuid do
    raise "implement the logic to generate a unique task user_uuid"
  end

  @doc """
  Generate a task.
  """
  def task_fixture(attrs \\ %{}) do
    {:ok, task} =
      attrs
      |> Enum.into(%{
        priority: "some priority",
        description: "some description",
        title: "some title",
        user_uuid: unique_task_user_uuid(),
        dead_line: ~N[2023-09-13 14:53:00]
      })
      |> TodoList.TaskList.create_task()

    task
  end

  @doc """
  Generate a comment.
  """
  def comment_fixture(attrs \\ %{}) do
    {:ok, comment} =
      attrs
      |> Enum.into(%{
        comment: "some comment"
      })
      |> TodoList.TaskList.create_comment()

    comment
  end
end
