defmodule RingCluster.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    topologies = Application.get_env(:libcluster, :topologies) || []

    children = [
      {Cluster.Supervisor, [topologies, [name: RingCluster.ClusterSupervisor]]},
      # Starts a worker by calling: RingCluster.Worker.start_link(arg)
      # {RingCluster.Worker, arg}
      {RingCluster.RingNode, next_node()}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: RingCluster.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp next_node() do
    case Node.self() |> Atom.to_string() do
      "node1@pppammpz" -> :node1@pppammpz
      "node2@pppammpz" -> :node2@pppammpz
      "node3@pppammpz" -> :node3@pppammpz
      _ -> :node1@pppammpz
    end
  end
end
