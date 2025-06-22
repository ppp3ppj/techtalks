defmodule UserClient do
  def start(user, room) do
    spawn(fn ->
      ChatRoom.join(room, user)
      spawn(fn -> input_loop(user, room) end)
      receive_loop(user)
    end)
  end

  defp input_loop(user, room) do
    input = IO.gets("[#{user}]> ")

    if input != nil do
      ChatRoom.send_message(room, user, String.trim(input))
      input_loop(user, room)
    end
  end

  defp receive_loop(user) do
    receive do
      {:chat, from, msg} ->
        IO.puts("[#{user}] #{from}: #{msg}")
        receive_loop(user)
    end
  end
end
