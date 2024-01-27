defmodule TodoListTest do
  use ExUnit.Case

  test "it can instantate an empty TodoList" do
    new_todo = TodoList.new()
    assert new_todo == %{}
  end

  test "it can add a new entry" do
    my_assertion = %{~D[2024-01-22] => ["shower"]}
    assert my_assertion == TodoList.add_entry(TodoList.new(), ~D[2024-01-22], "shower")
  end

  test "it can get entries for a date" do
    olistodo_list =
      TodoList.add_entry(TodoList.new(), ~D[2024-04-03], "guitar")

    result_of_function = TodoList.entries(olistodo_list, ~D[2024-04-03])
    assert result_of_function == ["guitar"]
  end
end
