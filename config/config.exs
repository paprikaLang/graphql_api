# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :graphql_api,
  ecto_repos: [GraphqlApi.Repo]

# Configures the endpoint
config :graphql_api, GraphqlApiWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "z79I7xf4QDcfPKn2yk7RTVk9pJtkOWJDrk9svyl2Gvs+J5BEIIBgY2sWGpt7gHmx",
  render_errors: [view: GraphqlApiWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: GraphqlApi.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
