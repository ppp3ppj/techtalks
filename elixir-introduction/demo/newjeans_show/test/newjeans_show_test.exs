defmodule NewjeansShowTest do
  use ExUnit.Case
  alias Newjeans.Member

  test "all NewJeans members are started under the supervisor" do
    sup = Process.whereis(NewjeansShow.Supervisor)
    children = Supervisor.which_children(sup)

    names = Enum.map(children, fn {id, _pid, _type, _mod} -> id end)

    assert :hanni in names
    assert :minji in names
    assert :danielle in names
    assert :haerin in names
    assert :hyein in names
  end

  test "crashed member is restarted automatically" do
    # Get origin PID
    [{:hanni, old_pid, :worker, _}] =
      Supervisor.which_children(Process.whereis(NewjeansShow.Supervisor))
      |> Enum.filter(fn {id, _, _, _} -> id == :hanni end)

    # Crash Hanni
    Member.crash("Hanni")

    # Wait for the restart
    Process.sleep(200)

    # Get new PID
    [{:hanni, new_pid, :worker, _}] =
      Supervisor.which_children(Process.whereis(NewjeansShow.Supervisor))
      |> Enum.filter(fn {id, _, _, _} -> id == :hanni end)

    refute old_pid == new_pid
    assert Process.alive?(new_pid)
  end
end
