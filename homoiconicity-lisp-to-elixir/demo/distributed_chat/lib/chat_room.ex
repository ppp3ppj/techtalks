defmodule ChatRoom do
  use GenServer

  # API

  def start_link(name) do
    GenServer.start_link(__MODULE__, %{}, name: {:global, name})
  end

  def join(room, user, pid \\ self()) do
    GenServer.call({:global, room}, {:join, user, pid})
  end

  def send_message(room, from, msg) do
    GenServer.cast({:global, room}, {:message, from, msg})
  end

  # Server

  def init(_) do
    {:ok, %{users: %{}}}
  end

  def handle_call({:join, user, pid}, _from, state) do
    Process.monitor(pid)
    send(pid, {:chat, "system", "Welcome to the chat!"})
    new_users = Map.put(state.users, user, pid)
    {:reply, :ok, %{state | users: new_users}}
  end

  def handle_cast({:message, from, msg}, state) do
    Enum.each(state.users, fn {_user, pid} ->
      send(pid, {:chat, from, msg})
    end)
    {:noreply, state}
  end

  def handle_info({:DOWN, _ref, :process, pid, _}, state) do
    new_users = Enum.reject(state.users, fn {_u, p} -> p == pid end) |> Enum.into(%{})
    {:noreply, %{state | users: new_users}}
  end
end
