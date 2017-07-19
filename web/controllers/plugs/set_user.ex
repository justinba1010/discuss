defmodule Discuss.Plugs.SetUser do
  import Plug.Conn
  import Phoenix.Controller
  alias Discuss.Repo
  alias Discuss.User

  def init(_params) do
    #Great place to do heavy computation
  end

  def call(conn, _params) do
    user_id = get_session(conn, :user_id)

    cond do
      user = user_id && Repo.get_by(User, id: user_id) ->
        assign(conn, :user, user)
      true ->
        assign(conn, :user, nil)
    end
  end
end
