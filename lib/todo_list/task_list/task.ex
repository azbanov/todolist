defmodule TodoList.TaskList.Task do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tasks" do
    field :priority, Ecto.Enum, values: [:Low, :Medium, :High]
    field :description, :string
    field :title, :string
    field :dead_line, :naive_datetime
    field :completed, :boolean, default: false
    field :documents, {:array, :string}

    belongs_to :user, TodoList.Accounts.User
    has_many :comments, TodoList.TaskList.Comment

    timestamps()
  end

  @doc false
  def changeset(task, attrs) do
    task
    |> cast(attrs, [:title, :description, :user_id, :priority, :dead_line, :completed, :documents])
    |> validate_required([:title, :description, :user_id, :priority, :dead_line, :completed])
  end

  @doc false
  def create_changeset(attrs) do
    %__MODULE__{}
    |> cast(attrs, [:title, :description, :user_id, :priority, :dead_line, :completed, :documents])
    |> validate_required([:title, :description, :user_id, :priority, :dead_line, :completed])
  end
end
