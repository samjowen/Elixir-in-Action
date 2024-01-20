defmodule TodoListTest do
  use ExUnit.Case

  test "it can instantate an empty TodoList" do
    new_todo = TodoList.new()
    assert new_todo == %{}
  end
end
