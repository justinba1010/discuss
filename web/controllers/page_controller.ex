defmodule Discuss.PageController do
  use Discuss.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def abc(conn, _params) do
    render conn, "abc.html"
  end
end
