defmodule Discuss.Router do
  use Discuss.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Discuss.Plugs.SetUser
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Discuss do
    pipe_through :browser # Use the default browser stack

    get "/", TopicController, :index

    resources "/topics", TopicController
    get "/topics/:id/comment", TopicController, :newcomment
    post "/topics/:id/commented", TopicController, :insertcomment
    get "/comments/delete/:id", TopicController, :deletecomment

    get "/auth/ok", AuthController, :aye

    get "/garbage", GarbageController, :index
    get "/garbage/:id/:name", GarbageController, :name
  end

  scope "/auth", Discuss do
    pipe_through :browser

    get "/signout", AuthController, :signout
    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
  end


  # Other scopes may use custom stacks.
  # scope "/api", Discuss do
  #   pipe_through :api
  # end
end
