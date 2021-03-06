use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :badging, Badging.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :badging, Badging.Repo,
  database: "badging_test",
  pool: Ecto.Adapters.SQL.Sandbox

config :badging, :token,
  read: "s3cr3t",
  write: "QEA&DPASS0DR"

config :badging, :downloader, Badging.StubbedDownloader
