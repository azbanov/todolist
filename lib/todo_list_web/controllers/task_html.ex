defmodule TodoListWeb.TaskHTML do
  use TodoListWeb, :html

  embed_templates "task_html/*"

  @doc """
  Renders a task form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def task_form(assigns)

  def user_opts(changeset) do
    existing_ids =
      changeset
      |> Ecto.Changeset.get_change(:user, [])
      |> Enum.map(& &1.data.id)

    for user <- TodoList.Accounts.get_users!() do
      [key: user.email, value: user.id, selected: user.id in existing_ids]
    end
  end
end
