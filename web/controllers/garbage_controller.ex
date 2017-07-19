defmodule Discuss.GarbageController do
  use Discuss.Web, :controller

  def index(conn, params) do
    IO.puts("++++")
    IO.inspect(conn)
    IO.puts("----")
    IO.inspect(params)
    IO.puts("++++")
    render conn, "index.html"
  end
  def name(conn, %{"id" => id, "name" => name, "g" => g} = params) do
    g = g |> String.to_integer
    name(conn, params, g)
  end
  def name(conn, %{"id" => id, "name" => name}, g \\ 0) do
    id = id |> String.to_integer
    g = case g do
      0 -> id
      _ -> g
    end
    id = id + 1 |> Integer.to_string
    render conn, "garbage.html", link: id, name: name, g: g
  end

end
