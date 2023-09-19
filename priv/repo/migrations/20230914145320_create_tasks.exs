defmodule TodoList.Repo.Migrations.CreateTasks do
  use Ecto.Migration

  def change do
    create table(:tasks) do
      add :title, :string, null: false
      add :description, :string, null: false
      add :user_id, references(:users, on_delete: :restrict), null: false
      add :priority, :string, null: false
      add :dead_line, :naive_datetime, null: false
      add :completed, :boolean, null: false
      add :documents, {:array, :string}

      timestamps()
    end

    create index(:tasks, [:title])
  end
end
