defmodule Jwb.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      JwbWeb.Telemetry,
      Jwb.Repo,
      {DNSCluster, query: Application.get_env(:jwb, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Jwb.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Jwb.Finch},
      # Start a worker by calling: Jwb.Worker.start_link(arg)
      # {Jwb.Worker, arg},
      # Start to serve requests, typically the last entry
      JwbWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Jwb.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    JwbWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
