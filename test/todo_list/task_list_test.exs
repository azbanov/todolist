defmodule TodoList.TaskListTest do
  use TodoList.DataCase

  alias TodoList.TaskList

  describe "tasks" do
    alias TodoList.TaskList.Task

    import TodoList.TaskListFixtures

    @invalid_attrs %{priority: nil, description: nil, title: nil, user_uuid: nil, dead_line: nil}

    test "list_tasks/0 returns all tasks" do
      task = task_fixture()
      assert TaskList.list_tasks() == [task]
    end

    test "get_task!/1 returns the task with given id" do
      task = task_fixture()
      assert TaskList.get_task!(task.id) == task
    end

    test "create_task/1 with valid data creates a task" do
      valid_attrs = %{priority: "High", description: "some description", title: "some title", user_id: 1, dead_line: ~N[2023-09-13 14:53:00]}

      assert {:ok, %Task{} = task} = TaskList.create_task(valid_attrs)
      assert task.priority == "High"
      assert task.description == "some description"
      assert task.title == "some title"
      assert task.user_id == 1
      assert task.dead_line == ~N[2023-09-13 14:53:00]
    end

    test "create_task/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = TaskList.create_task(@invalid_attrs)
    end

    test "update_task/2 with valid data updates the task" do
      task = task_fixture()
      update_attrs = %{priority: "Low", description: "some updated description", title: "some updated title", user_uuid: "7488a646-e31f-11e4-aace-600308960668", dead_line: ~N[2023-09-14 14:53:00]}

      assert {:ok, %Task{} = task} = TaskList.update_task(task, update_attrs)
      assert task.priority == "Low"
      assert task.description == "some updated description"
      assert task.title == "some updated title"
      assert task.user_uuid == "7488a646-e31f-11e4-aace-600308960668"
      assert task.dead_line == ~N[2023-09-14 14:53:00]
    end

    test "update_task/2 with invalid data returns error changeset" do
      task = task_fixture()
      assert {:error, %Ecto.Changeset{}} = TaskList.update_task(task, @invalid_attrs)
      assert task == TaskList.get_task!(task.id)
    end

    test "delete_task/1 deletes the task" do
      task = task_fixture()
      assert {:ok, %Task{}} = TaskList.delete_task(task)
      assert_raise Ecto.NoResultsError, fn -> TaskList.get_task!(task.id) end
    end

    test "change_task/1 returns a task changeset" do
      task = task_fixture()
      assert %Ecto.Changeset{} = TaskList.change_task(task)
    end
  end

  describe "comments" do
    alias TodoList.TaskList.Comment

    import TodoList.TaskListFixtures

    @invalid_attrs %{comment: nil}

    test "create_comment/1 with valid data creates a comment" do
      valid_attrs = %{comment: "some comment", task_id: 1, user_id: 1}

      assert {:ok, %Comment{} = comment} = TaskList.create_comment(valid_attrs)
      assert comment.comment == "some comment"
    end

    test "create_comment/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = TaskList.create_comment(@invalid_attrs)
    end

    test "change_comment/1 returns a comment changeset" do
      comment = comment_fixture()
      assert %Ecto.Changeset{} = TaskList.change_comment(comment)
    end
  end
end
