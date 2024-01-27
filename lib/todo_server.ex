defmodule TodoServer do
  @moduledoc false
  def start do
    initial_state = TodoList.new()
    spawn(fn -> loop(:start, initial_state) end)
  end

  defp process_message(state, {:value, caller_pid}) do
    send(caller_pid, {:response, state})
  end

  defp process_message(state, {:add_entry, new_entry}) do
    TodoList.add_entry(state, new_entry)
  end

  # Better name would be nice for this fn
  defp loop(:start, initial_state) do
    # The first thing we want to do is register the process
    Process.register(self(), :todo_server)
    loop(:continue, initial_state)
  end

  defp loop(:continue, state) do
    new_state =
      receive do
        message -> process_message(state, message)
      end

    loop(:continue, new_state)
  end

  def get_todo_list(todo_server_pid) do
    send(todo_server_pid, {:value, self()})

    receive do
      {:response, state} ->
        state
    end
  end
end
