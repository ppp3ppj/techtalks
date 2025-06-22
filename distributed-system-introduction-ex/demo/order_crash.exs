defmodule OrderProcessor do
  use GenServer

  # Client API
  def start_link(order) do
    GenServer.start_link(__MODULE__, order, name: via_tuple(order))
  end

  # Internal functions
  defp via_tuple(order), do: {:via, Registry, {OrderRegistry, order}}

  # Server Callbacks
  # Let it crash!
  def init("bad order"), do: raise("💥 Order failed!")

  def init(order) do
    IO.puts("✅ Order processed successfully: #{order}")
    {:ok, order}
  end
end

defmodule OrderSupervisor do
  use DynamicSupervisor

  def start_link(_arg) do
    DynamicSupervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  @impl true
  def init(_arg) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def start_order(order) do
    DynamicSupervisor.start_child(__MODULE__, {OrderProcessor, order})
  end
end

children = [
  {DynamicSupervisor, name: OrderSupervisor, strategy: :one_for_one},
  {Registry, keys: :unique, name: OrderRegistry}
]

Supervisor.start_link(children, strategy: :one_for_one)
OrderSupervisor.start_order("good order")
OrderSupervisor.start_order("bad order")  # This crashes but won't affect other processes
OrderSupervisor.start_order("another good order")
