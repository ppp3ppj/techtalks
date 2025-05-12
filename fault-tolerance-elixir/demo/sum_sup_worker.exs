defmodule SumWorker do
  use GenServer

  def start_link(name) do
    GenServer.start_link(__MODULE__, %{}, name: name)
  end

  def calc_sum(worker_name, n), do: GenServer.call(worker_name, {:sum, n})

  def init(state) do
    {:ok, state}
  end

  def handle_call({:sum, 13}, _from, _state) do
    raise "Worker crashed because n == 13"
  end

  def handle_call({:sum, n}, _from, state) do
    sum = div(n * (n + 1), 2)
    {:reply, {:ok, sum}, state}
  end
end

defmodule SumSupervisor do
  use Supervisor

  def start_link(_) do
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    children = [
      Supervisor.child_spec({SumWorker, :worker1}, id: :worker1),
      Supervisor.child_spec({SumWorker, :worker2}, id: :worker2),
      Supervisor.child_spec({SumWorker, :worker3}, id: :worker3),
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end

{:ok, sup_pid} = SumSupervisor.start_link(:ok)
Supervisor.which_children(sup_pid)
SumWorker.calc_sum(:worker1, 5)

