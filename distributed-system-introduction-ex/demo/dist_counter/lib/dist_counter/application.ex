defmodule DistCounter.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    topologies = Application.get_env(:libcluster, :topologies) || []

    children = [
      {Cluster.Supervisor, [topologies, [name: RingCluster.ClusterSupervisor]]},
      # Starts a worker by calling: DistCounter.Worker.start_link(arg)
      # {DistCounter.Worker, arg}
      # {DeltaCrdt, [crdt: DeltaCrdt.AWLWWMap, name: DistCounter.Crdt, sync_interval: 50]}
      # {DistCounter.MyCrdt, []}

      # Start our CRDT GenServer
      #{DistCounter.MyCrdt, [crdt_name: {:global, :my_crdt}, sync_interval: 50]}
      DistCounter.MyCrdt
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: DistCounter.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
