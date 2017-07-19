defmodule Discuss.AuthController do
  use Discuss.Web, :controller
  plug Ueberauth


  def callback(conn, params) do
    %{assigns: %{ueberauth_auth: auth}} = conn
    %{"provider" => provider} = params

    first_name = case auth.info.first_name do
      nil -> ""
      _ -> auth.info.first_name
    end
    last_name = case auth.info.last_name do
      nil -> ""
      _ -> auth.info.last_name
    end
    user_params = %{token: auth.credentials.token, email: auth.info.email, provider: provider, name: first_name <> last_name }
    changeset = Discuss.User.changeset(%Discuss.User{}, user_params)
    signin(conn, changeset)
  end

  defp insert_or_update_user(changeset) do
    case Repo.get_by(Discuss.User, email: changeset.changes.email) do
      nil ->
        Repo.insert(changeset)
      user ->
        {:ok, user}
    end
  end

  defp signin(conn, changeset) do
    case insert_or_update_user(changeset) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Welcome " <> user.email <> ".")
        |> put_session(:user_id, user.id)
        |> redirect(to: topic_path(conn, :index))
      {:error, _reason} ->
        conn
        |> put_flash(:error, "Something unexpected happened.")
        |> redirect(to: topic_path(conn, :index))
    end
  end

  def signout(conn, params) do
    conn = conn |> configure_session(drop: true)
    conn |> redirect(to: topic_path(conn, :index))
  end

end
