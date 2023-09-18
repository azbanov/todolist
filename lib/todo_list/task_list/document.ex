defmodule TodoList.TaskList.Document do
  use Ecto.Schema
  import Ecto.Changeset

  schema "documents" do
    field :path, :string

    belongs_to :task, TodoList.TaskList.Task

    timestamps()
  end

  @doc false
  def changeset(document, attrs) do
    document
    |> cast(attrs, [:path, :task_id])
    |> validate_required([:path, :task_id])
  end
end
