defmodule Badging do
  use Application

  alias Badging.Endpoint

  @moduledoc """
  Badging is a typical Phoenix application, nothing overly interesting there.
  """

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec

    # Define workers and child supervisors to be supervised
    children = [
      supervisor(Badging.Repo, []),
      supervisor(Badging.Endpoint, []),
      supervisor(
        Task.Supervisor,
        [[name: Badging.SvgDownloaderSupervisor, restart: :transient]]
      )
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Badging.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    Endpoint.config_change(changed, removed)
    :ok
  end
end
