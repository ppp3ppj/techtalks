defmodule OrderProcessor do
  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def init(state) do
    IO.puts("🛒 OrderProcessor started")
    schedule_order()
    {:ok, state}
  end

  def handle_info(:process_order, state) do
    if :rand.uniform(10) == 1 do
      IO.puts("❌ OrderProcessor crashed!")
      exit(:random_crash)
    end

    IO.puts("✅ Order processed!")
    schedule_order()
    {:noreply, state}
  end

  defp schedule_order do
    Process.send_after(self(), :process_order, 2000)
  end
end

defmodule PaymentProcessor do
  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def init(state) do
    IO.puts("💳 PaymentProcessor started")
    schedule_payment()
    {:ok, state}
  end

  def handle_info(:process_payment, state) do
    if :rand.uniform(10) == 1 do
      IO.puts("❌ PaymentProcessor crashed!")
      exit(:random_crash)
    end

    IO.puts("✅ Payment processed!")
    schedule_payment()
    {:noreply, state}
  end

  defp schedule_payment do
    Process.send_after(self(), :process_payment, 3000)
  end
end

defmodule DeliveryTracker do
  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def init(state) do
    IO.puts("🚗 DeliveryTracker started")
    schedule_tracking()
    {:ok, state}
  end

  def handle_info(:track_delivery, state) do
    if :rand.uniform(10) == 1 do
      IO.puts("❌ DeliveryTracker crashed!")
      exit(:random_crash)
    end

    IO.puts("✅ Delivery updated!")
    schedule_tracking()
    {:noreply, state}
  end

  defp schedule_tracking do
    Process.send_after(self(), :track_delivery, 5000)
  end
end

defmodule FoodSup do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    children = [
      {OrderProcessor, []},
      {PaymentProcessor, []},
      {DeliveryTracker, []}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end

# Start the system
FoodSup.start_link()
:timer.sleep(20_000)

