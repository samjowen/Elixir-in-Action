defmodule Concurrency.ForumThreadServer do
  def start() do
    Kernel.spawn(fn -> loop(:init) end)
  end

  defp loop(:init) do
    empty_thread = []
    loop(:loop, empty_thread)
  end

  defp loop(:loop, state) do
    new_thread =
      receive do
        message -> process_message(state, message)
      end

    loop(:loop, new_thread)
  end

  # Private Interface Methods

  defp process_message(current_thread_state, {:add_post, caller, post}) do
    add_post(caller, current_thread_state, post)
  end

  defp process_message(current_thread_state, {:get_posts, caller, current_thread_state}) do
    send(caller, {:thread, self(), get_thread(current_thread_state)})
  end

  def get_thread(state) do
    state
  end

  def add_post(caller, thread, post) do
    thread ++ %{caller => post}
  end

  # Public Interface Methods

  def reply_thread(thread_pid, post) do
    send(thread_pid, {:add_post, self(), post})
  end

  def get_posts(thread_pid) do
    receive do
      {:thread, _thread_pid, thread} ->
        thread

      _ ->
        IO.puts("Couldn't find thread number #{thread_pid}")
    end
  end
end
