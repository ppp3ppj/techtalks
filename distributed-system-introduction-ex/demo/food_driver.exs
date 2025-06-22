defmodule DeliveryDriver do
  use GenServer

  def start_link(driver) do
    GenServer.start_link(__MODULE__, %{driver: driver, last_order: nil}, name: driver)
  end

  def init(state) do
    Process.flag(:trap_exit, true)  # ✅ This prevents IEx from crashing
    IO.puts("🚗 #{state.driver} is ready to deliver orders!")

    # If last order exists, schedule retry
    {:ok, state, {:continue, :maybe_retry}}
  end

  def handle_continue(:maybe_retry, state) do
    if state.last_order do
      IO.puts("🔄 Retrying last order for #{state.driver}...")
      send(self(), :retry_order)
    end
    {:noreply, state}
  end

  def handle_call(:deliver_order, _from, state) do
    if :rand.uniform(5) == 1 do  # 💥 Simulate failure (20% chance)
      IO.puts("💥 #{state.driver} had a problem! Recovering...")
      {:reply, {:error, :failed}, %{state | last_order: :deliver_order}, {:continue, :maybe_retry}}
    else
      IO.puts("✅ #{state.driver} delivered the order successfully!")
      {:reply, :ok, %{state | last_order: :deliver_order}}
    end
  end

  def handle_info(:retry_order, state) do
    IO.puts("🔄 Retrying order for #{state.driver}...")

    # set state
    IO.puts("✅ #{state.driver} delivered the order successfully!")
    {:noreply, state}
  end
end

defmodule DeliverySupervisor do
  use Supervisor

  def start_link(_) do
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    children = [
      Supervisor.child_spec({DeliveryDriver, :driver_1}, id: :driver_1),
      Supervisor.child_spec({DeliveryDriver, :driver_2}, id: :driver_2)
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end

# Start the supervisor
{:ok, _sup} = DeliverySupervisor.start_link(:ok)

# Simulate orders
Process.sleep(1000)  # Wait for startup
IO.puts("🚚 Sending delivery orders...")

Enum.each(1..5, fn _ ->
  IO.puts("\n=== NEW ORDER ===")
  GenServer.call(:driver_1, :deliver_order)
  GenServer.call(:driver_2, :deliver_order)
  Process.sleep(2000)  # Wait before next order
end)
