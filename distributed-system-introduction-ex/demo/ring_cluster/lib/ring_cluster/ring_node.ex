defmodule RingCluster.RingNode do
  use GenServer
  alias DeltaCrdt.AWLWWMap

  # Start the GenServer with next node and CRDT
  def start_link(next_node) do
    GenServer.start_link(__MODULE__, next_node, name: {:global, Node.self()})
  end

  def send_chat(start_node, message) do
    GenServer.cast({:global, start_node}, {:chat, message, []})
  end

  ## Server
  def init(next_node) do
    Process.flag(:trap_exit, true)

    # Start CRDT for chat history
    {:ok, crdt} = DeltaCrdt.start_link(AWLWWMap, name: {:global, {:chat_crdt, Node.self()}})

    {:ok, %{next_node: next_node, crdt: crdt}}
  end

  def handle_cast({:chat, message, visited_nodes}, %{next_node: next, crdt: crdt} = state) do
    visited_nodes = [Node.self() | visited_nodes]

    # Add message to CRDT (v0.6.5)
    timestamp = :os.system_time(:millisecond)
    DeltaCrdt.put(crdt, :add, [{{Node.self(), timestamp}, message}], :infinity)

    IO.puts("💬 Node #{Node.self()} received message: #{message}")

    # Forward if ring not completed
    if length(visited_nodes) < 3 do
      GenServer.cast({:global, next}, {:chat, message, visited_nodes})
    else
      # Read full CRDT map
      chat_data = DeltaCrdt.to_map(crdt)
      IO.puts("✅ Ring complete. Chat history so far:")

      for {{node, ts}, msg} <- Enum.sort(chat_data, fn {_, t1}, {_, t2} -> t1 < t2 end) do
        IO.puts("   #{node}: #{msg}")
      end
    end

    {:noreply, state}
  end

  def handle_info({:EXIT, pid, reason}, state) do
    IO.puts("⚠️ Node #{inspect(pid)} exited: #{reason}")
    {:noreply, state}
  end
end
