defmodule TodoList.TaskList.Comment do
  use Ecto.Schema
  import Ecto.Changeset

  schema "comments" do
    field :comment, :string

    belongs_to :user, TodoList.Accounts.User
    belongs_to :task, TodoList.TaskList.Task

    timestamps()
  end

  @doc false
  def changeset(comment, attrs) do
    comment
    |> cast(attrs, [:comment, :task_id, :user_id])
    |> validate_required([:comment, :task_id, :user_id])
  end

  def create_changeset(attrs) do
    %__MODULE__{}
    |> cast(attrs, [:comment, :task_id, :user_id])
    |> validate_required([:comment, :task_id, :user_id])
  end
end
