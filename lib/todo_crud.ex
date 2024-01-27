defmodule TodoList do
  @moduledoc """
  This module provides functionality for managing a todo list.
  """
  defstruct auto_id: 1, entries: %{}

  def new(entries \\ []) do
    Enum.reduce(entries, %TodoList{}, fn entry, todo_acc ->
      add_entry(todo_acc, entry)
    end)
  end

  def add_entry(todo_list, entry) do
    entry = Map.put(entry, :id, todo_list.auto_id)

    new_entries = [entry | todo_list.entries]

    # todo_list variable updates the rest of the struct that matches,
    # we then add the new_entries and also increment the auto_id.
    %TodoList{
      todo_list
      | entries: new_entries,
        auto_id: todo_list.auto_id + 1
    }
  end

  def entries(todo_list, date) do
    todo_list.entries
    |> Map.filter(fn {key, _value} -> key == date end)
    |> Enum.map(fn {_key, value} -> value end)
  end

  def update_entry(todo_list, entry_id, updater_function) do
    case Map.fetch(todo_list, entry_id) do
      :error ->
        todo_list

      {:ok, old_entry} ->
        new_entry = updater_function.(old_entry)
        # Will simply replace the old one because the key exists.
        new_entries = Map.put(todo_list.entries, entry_id, new_entry)

        # Reinitialise and return a struct of the same shape as todo_list, except replace the old entries with new_entries
        %TodoList{todo_list | entries: new_entries}
    end
  end

  def parse_csv(file_path) do
    file_path
    |> File.stream!()
    |> Stream.map(&String.trim/1)
  end

  def convert_csv_line_to_entry(csv_line) do
    line_list =
      csv_line
      |> String.replace("/", "-")
      |> String.split(",")

    [date_string, title_string] = line_list
    {:ok, date} = Date.from_iso8601(date_string)
    %{date: date, title: title_string}
  end

  def parse_stream_into_list_of_entries(stream) do
    stream
    |> Stream.map(&convert_csv_line_to_entry/1)
    |> Enum.to_list()
  end
end

# Implementations

defimpl String.Chars, for: TodoList do
  def to_string(_) do
    "Todo Implementation"
  end

  defimpl Collectable, for: TodoList do
    def into(original) do
      {original, &into_callback/2}
    end

    defp into_callback(todo_list, {:cont, entry}) do
      TodoList.add_entry(todo_list, entry)
    end

    defp into_callback(todo_list, :done) do
      todo_list
    end

    defp into_callback(_todo_list, :halt) do
      :ok
    end
  end
end
