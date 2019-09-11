# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :phx_client,
  ecto_repos: [PhxClient.Repo]

# Configures the endpoint
config :phx_client, PhxClientWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "a/UHjedK5l5CuqO7GStXBtuze3TrwYMkuKUy136TJZMDc1JGQ+j2qTDmft8UMclP",
  render_errors: [view: PhxClientWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: PhxClient.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [signing_salt: "7+mE/z7lecWjqP0UqYxWONez1Z/k0mkN"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
