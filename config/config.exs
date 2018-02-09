# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :badging, ecto_repos: [Badging.Repo]

# Configures the endpoint
config :badging, Badging.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "RIPmOBOcJv1G3D8N/s6dEhnincUTrS8nYJE8UwgJfhYjkTsighk7mPV1ODOEYDv6",
  render_errors: [view: Badging.ErrorView, accepts: ~w(json)]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
