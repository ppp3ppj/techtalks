defmodule NewjeansShow.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  alias Newjeans.Member

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {Registry, keys: :unique, name: :member_registry},
      Supervisor.child_spec({Member, "Hanni"}, id: :hanni),
      Supervisor.child_spec({Member, "Minji"}, id: :minji),
      Supervisor.child_spec({Member, "Danielle"}, id: :danielle),
      Supervisor.child_spec({Member, "Haerin"}, id: :haerin),
      Supervisor.child_spec({Member, "Hyein"}, id: :hyein)
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: NewjeansShow.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
