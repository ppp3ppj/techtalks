defmodule Newjeans.Member do
  use GenServer

  def start_link(name) do
    GenServer.start_link(__MODULE__, name, name: via_tuple(name))
  end

  def via_tuple(name), do: {:via, Registry, {:member_registry, name}}

  @impl true
  def init(name) do
    IO.puts("#{name} is ready to perform! 🎤")
    {:ok, name}
  end

  def crash(name) do
    GenServer.cast(via_tuple(name), :boom)
  end

  @impl true
  def handle_cast(:boom, _state) do
    IO.puts("💥 Oops! Crashed!")
    raise "Dance mistake!"
  end
end
