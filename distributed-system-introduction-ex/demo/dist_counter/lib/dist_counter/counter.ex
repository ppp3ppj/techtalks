defmodule DistCounter.MyCrdt do
  use GenServer
  alias DeltaCrdt.AWLWWMap

  require Logger

  ## Public API

  # Start the CRDT GenServer
  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  # Increment the counter
  def increment() do
    GenServer.call(__MODULE__, :increment)
  end

  # Get current value
  def value() do
    GenServer.call(__MODULE__, :value)
  end

  # Add a custom key/value
  def put(val) do
    case val do
      x when is_number(x) and x >= 0 ->
        GenServer.cast(__MODULE__, {:put, x})

      _ ->
        Logger.debug(fn -> "[CounterCRDT] Value #{val} is not number please try put value again" end)
    end
  end

  # Get full map
  def to_map() do
    GenServer.call(__MODULE__, :to_map)
  end

  @doc """
  Returns the number of games currently stored in the CRDT.
  """
  @spec size :: non_neg_integer()
  def size do
    GenServer.call(__MODULE__, :size)
  catch
    :exit, _ -> 0
  end

  @doc """
  Notify the CRDT that shutdown is imminent
  """
  def prepare_for_shutdown do
    GenServer.cast(__MODULE__, :prepare_for_shutdown)
  end

  ## GenServer callbacks

  # Server (Private)

  @doc false
  def init(_) do
    {:ok, crdt} =
      DeltaCrdt.start_link(
        DeltaCrdt.AWLWWMap,
        name: Crdt,
        sync_interval: 300
      )

    # Register to receive messages when nodes enter and leave the cluster
    :net_kernel.monitor_nodes(true, node_type: :visible)

    # connect to the CRDTs on the other nodes
    update_neighbors()

    {:ok, :running}
  end

  # Handle the message received when a new node joins the cluster
  def handle_info({:nodeup, node, _node_type}, state) do
    Logger.debug(fn -> "[CounterCRDT] #{inspect(node)} - Up" end)
    update_neighbors()
    {:noreply, state}
  end

  # Handle the message received when a node leaves the cluster
  def handle_info({:nodedown, node, _node_type}, state) do
    Logger.debug(fn -> "[CounterCRDT] #{inspect(node)} - Down" end)
    update_neighbors()
    {:noreply, state}
  end

  @doc """
  Reset the current state of the CRDT
  """
  def clear do
    GenServer.cast(__MODULE__, :clear)
  end

  def handle_call(:increment, _from, state) do
    case DeltaCrdt.get(Crdt, :counter) do
      nil ->
        Logger.debug(fn -> "[CounterCRDT] Adding 1 to the CRDT current stage" end)
        DeltaCrdt.put(Crdt, :counter, 1)

      x when x > 0 ->
        Logger.debug(fn -> "[CounterCRDT] Adding #{x + 1} to the CRDT current stage" end)
        DeltaCrdt.put(Crdt, :counter, x + 1)
    end

    {:reply, :ok, state}
  end

  def handle_call(:value, _from, state) do
    val = Map.get(DeltaCrdt.to_map(Crdt), :counter, 0)
    {:reply, val, state}
  end

  def handle_call(:to_map, _from, state) do
    {:reply, DeltaCrdt.to_map(Crdt), state}
  end

  def handle_cast({:put, val}, state) do
    DeltaCrdt.put(Crdt, :counter, val)
    {:noreply, state}
  end

  @doc false
  def handle_cast(:clear, state) do
    for {key, _} <- DeltaCrdt.to_map(Crdt) do
      DeltaCrdt.delete(Crdt, key)
    end

    {:noreply, state}
  end

  def handle_call(:size, _from, state) do
    size = Crdt |> DeltaCrdt.to_map() |> map_size()
    {:reply, size, state}
  end

  def handle_cast(:prepare_for_shutdown, _state) do
    {:noreply, :terminating}
  end

  @spec update_neighbors :: :ok
  defp update_neighbors do
    neighbors = for node <- Node.list(), do: {Crdt, node}
    Logger.debug(fn -> "[CounterCRDT] Setting neighbors to #{inspect(neighbors)}" end)
    DeltaCrdt.set_neighbours(Crdt, neighbors)
  end
end
