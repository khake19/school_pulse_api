defmodule SchoolPulseApi.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      SchoolPulseApiWeb.Telemetry,
      # Start the Ecto repository
      SchoolPulseApi.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: SchoolPulseApi.PubSub},
      # Start Finch
      {Finch, name: SchoolPulseApi.Finch},
      # Start the Endpoint (http/https)
      SchoolPulseApiWeb.Endpoint
      # Start a worker by calling: SchoolPulseApi.Worker.start_link(arg)
      # {SchoolPulseApi.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: SchoolPulseApi.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    SchoolPulseApiWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
