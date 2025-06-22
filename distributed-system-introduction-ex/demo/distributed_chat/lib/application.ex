defmodule DistributedChat.Application do

  use Application

  def start(_type, _args) do
    ChatRoom.start_link(:room)
    {:ok, self()}
  end
end
