defmodule Badging.Mixfile do
  use Mix.Project

  def project do
    [
      app: :badging,
      version: "0.0.1",
      elixir: "~> 1.8",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Badging, []},
      applications: [:phoenix, :cowboy, :logger, :gettext, :phoenix_ecto, :postgrex, :ecto_sql]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_), do: ["lib", "web"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.4.0"},
      {:phoenix_ecto, "~> 4.0"},
      {:postgrex, ">= 0.0.0"},
      {:gettext, "~> 0.16"},
      {:cowboy, "~> 2.6"},
      {:plug_cowboy, "~> 2.0"},
      {:cors_plug, "~> 2.0"},
      {:credo, github: "rrrene/credo", only: [:dev, :test]},
      {:ecto_sql, "~> 3.0"},
      {:jason, "~> 1.1.2"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"]
    ]
  end
end
