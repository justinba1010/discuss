defmodule Discuss.Plugs.RequireAuth do
  import Plug.Conn
  import Phoenix.Controller

  def init(_params) do
  end

  def call(conn, _params) do
    if conn.assigns[:user] do
      conn
    else
      conn
      |> put_flash(:error, "You're not signed in.")
      |> redirect(to: Discuss.Router.Helpers.topic_path(conn, :index))
      |> halt()
    end
  end
end
