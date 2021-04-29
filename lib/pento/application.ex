defmodule Pento.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      Pento.Repo,
      PentoWeb.Telemetry,
      {Phoenix.PubSub, name: Pento.PubSub},
      PentoWeb.Presence,
      PentoWeb.Endpoint
    ]

    opts = [strategy: :one_for_one, name: Pento.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    PentoWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
