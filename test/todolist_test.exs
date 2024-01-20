defmodule TodoListTest do
  use ExUnit.Case

  test "it can instantate an empty TodoList" do
    new_todo = TodoList.new()
    assert new_todo == %{}
  end

  test "it can add a new entry" do
    my_assertion = %{~D[2024-01-22] => ["shower"]}
    assert my_assertion == TodoList.new() |> TodoList.add_entry(~D[2024-01-22], "shower")
  end
end
