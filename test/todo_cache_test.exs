defmodule TodoCacheTest do
  use ExUnit.Case

  test "server_process" do
    {:ok, cache} = Todo.Cache.start()
    bob_pid = Todo.Cache.get_server(cache, "bob")
    assert bob_pid != Todo.Cache.get_server(cache, "alice")
    assert bob_pid == Todo.Cache.get_server(cache, "bob")
  end
end
