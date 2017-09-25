# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :json_api_example,
  ecto_repos: [JsonApiExample.Repo]

# Configures the endpoint
config :json_api_example, JsonApiExampleWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "aH881a5GGYvXfytC4EluMq2zTjzMk8qQ97ACekB0IvVuxcktgbKkfzBqmd4xzf1V",
  render_errors: [view: JsonApiExampleWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: JsonApiExample.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
