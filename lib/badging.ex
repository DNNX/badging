defmodule Badging do
  use Application

  alias Badging.{Endpoint, SvgDownloaderSupervisor}

  @moduledoc """
  Badging is a typical Phoenix application, nothing overly interesting there.
  """

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    # Define workers and child supervisors to be supervised
    children = [
      repo_supervisor_spec(),
      endpoint_supervisor_spec(),
      svg_downloader_supervisor_spec()
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Badging.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp repo_supervisor_spec do
    Supervisor.Spec.supervisor(Badging.Repo, [])
  end

  defp endpoint_supervisor_spec do
    Supervisor.Spec.supervisor(Badging.Endpoint, [])
  end

  def svg_downloader_supervisor_spec do
    Supervisor.Spec.supervisor(Task.Supervisor, [
      [name: SvgDownloaderSupervisor, restart: :transient]
    ])
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    Endpoint.config_change(changed, removed)
    :ok
  end
end
