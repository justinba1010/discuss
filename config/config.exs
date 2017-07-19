# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :discuss,
  ecto_repos: [Discuss.Repo]

# Configures the endpoint
config :discuss, Discuss.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "gJPPVmtLiYZHTwEhCOZxb3xG+7d3zd486mB1MVBjwijDSUWAE+vs893tmho/bu6U",
  render_errors: [view: Discuss.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Discuss.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

config :ueberauth, Ueberauth,
  providers: [
    github: {Ueberauth.Strategy.Github, [] },
    facebook: {Ueberauth.Strategy.Facebook, []}
  ]

config :ueberauth, Ueberauth.Strategy.Github.OAuth,
  client_id: "6f3a1652567cb42e9c45",
  client_secret: "496a99df54435c0dac709fb9fa968b3c38de8216"

config :ueberauth, Ueberauth.Strategy.Facebook.OAuth,
  client_id: 127042884568011,
  client_secret: "f699f7245fbefaeda485c2f40f6fdb2b"
