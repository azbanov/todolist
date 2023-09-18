defmodule TodoListWeb.PageController do
  use TodoListWeb, :controller

  def home(conn, _params) do
    if conn.assigns.current_user do
      redirect(conn, to: ~p"/tasks")
    else
      redirect(conn, to: ~p"/users/log_in")
    end
  end
end
