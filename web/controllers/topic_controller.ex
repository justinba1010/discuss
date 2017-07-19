defmodule Discuss.TopicController do
  use Discuss.Web, :controller

  plug Discuss.Plugs.RequireAuth when action in [:new, :create, :edit, :update, :createcomment, :insertcomment]
  plug :check_topic_owner when action in [:update, :edit, :delete]
  plug :check_comment_owner when action in [:deletecomment]

  def new(conn, params) do
    changeset = Discuss.Topic.changeset(%Discuss.Topic{}, %{})

    render conn, "new.html", changeset: changeset
  end

  def create(conn, %{"topic" => topic}) do
    changeset = conn.assigns[:user]
    |> build_assoc(:topics)
    |> Discuss.Topic.changeset(topic)

    case Repo.insert(changeset) do
      {:ok, post} ->
        conn
        |> put_flash(:info, "Topic Created!")
        |> redirect(to: topic_path(conn, :index))
      {:error, changeset} ->
        conn
        |> put_flash(:error, "Cannot be blank!")
        |> render "new.html", changeset: changeset
    end
  end

  def show(conn, %{"id" => topic_id}) do
    topic = Repo.get!(Discuss.Topic, topic_id)
    query = from c in "comments", where: c.topic_id == ^(String.to_integer(topic_id)), select: [:content, :id]
    comments = Repo.all(query)
    render conn, "show.html", topic: topic, comments: comments
  end

  def index(conn, _params) do
    IO.inspect(conn.assigns)
    query = from(topic in Discuss.Topic, order_by: topic.id)
    render conn, "index.html", topics: Repo.all(query)
  end

  def edit(conn, %{"id" => id}) do
    topic = Repo.get(Discuss.Topic, id)
    changeset = Discuss.Topic.changeset(topic)
    render conn, "edit.html", changeset: changeset, topic: topic
  end

  def update(conn, params) do
    %{"id" => id, "topic" => topic} = params


    changeset =
      Discuss.Topic
      |> Repo.get(id)
      |> Discuss.Topic.changeset(topic)
    IO.inspect(changeset)
    case Repo.update(changeset) do
      {:ok, _topic} ->
        conn
        |> put_flash(:info, "Topic Updated!")
        |> redirect(to: topic_path(conn, :index))
      {:error, changeset} ->
        newchangeset = Discuss.Topic |> Repo.get(id) |> Discuss.Topic.changeset
        conn
        |> put_flash(:error, "Topic Cannot Be Blank.")
        |> render "edit.html", changeset: newchangeset, topic: Repo.get(Discuss.Topic, id)
    end

    redirect(conn, to: topic_path(conn, :index))
  end

  def delete(conn, %{"id" => id}) do
    Repo.get!(Discuss.Topic, id) |> Repo.delete!

    conn
    |> put_flash(:info, "Topic Deleted!")
    |> redirect(to: topic_path(conn, :index))
  end

  def check_topic_owner(conn, _params) do
    %{params: %{"id" => topic_id}} = conn
    if Repo.get(Discuss.Topic, topic_id).user_id == conn.assigns.user.id do
      conn
    else
      conn
      |> put_flash(:error, "You're trying to modify a post you do not own!")
      |> redirect(to: topic_path(conn, :index))
      |> halt()
    end
  end
  def check_comment_owner(conn, _params) do
    conn
  end

  def newcomment(conn, %{"id" => topic_id}) do
    topic = Repo.get_by!(Discuss.Topic, id: topic_id)
    changeset = %Discuss.Comment{} |> Discuss.Comment.changeset
    IO.inspect(changeset)
    render conn, "new_comment.html", changeset: changeset, topic_id: topic_id
  end

  def insertcomment(conn, %{"id" => topic_id, "comment" => comment} = params) do
    topic = Repo.get_by(Discuss.Topic, id: topic_id)
    user = conn.assigns.user
    changeset = %Discuss.Comment{} |> Discuss.Comment.changeset(comment) |> Ecto.Changeset.put_assoc(:user, user) |> Ecto.Changeset.put_assoc(:topic, topic)
    IO.inspect(changeset)
    case Repo.insert(changeset) do
      {:ok, comment} -> conn |> put_flash(:info, "Congrats") |> redirect(to: topic_path(conn, :show, topic_id))
      {:error, changeset} -> conn |> put_flash(:error, "Didn't work...") |> redirect(to: topic_path(conn, :show, topic_id))
    end
  end

  def deletecomment(conn, %{"id" => comment_id}) do
    if comment = Repo.get(Discuss.Comment, comment_id) do
      Repo.delete!(comment)
      redirect(conn, to: topic_path(conn, :show, comment.topic_id))
    end
    redirect(conn, to: topic_path(conn, :index))
  end
end
