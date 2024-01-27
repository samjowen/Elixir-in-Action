defmodule DatabaseServer do
  # Start is the public interface of the function which callers of the server can use to start it up.
  @moduledoc false
  def start do
    connection = :rand.uniform(1000)
    spawn(fn -> loop(connection) end)
  end

  # Loop is a private function - initialised with defp - it is private because the caller doesn't need to know any implementation details for the server to work.
  defp loop(connection) do
    new_state =
      receive do
        {:run_query, from_pid, query_def} ->
          result = run_query(query_def, connection)
          send(from_pid, {:query_result, result})

        _ ->
          IO.puts("Unrecognised operation.")
      end

    loop(new_state)
  end

  # defp db_query(query_def) do
  #   Process.sleep(1000)
  #   IO.puts("Database query result: #{query_def}")
  # end

  defp run_query(query_def, connection) do
    Process.sleep(2000)
    "Connection number #{connection}: #{query_def} result"
  end

  # Interface functions

  # A public function that a caller can use to get the server to asynchronously make a query for them
  # the server won't be running this function. This is run in context of the caller.
  def run_async(server_pid, query_def) do
    send(server_pid, {:run_query, self(), query_def})
  end

  def get_result do
    receive do
      {:query_result, result} ->
        result
    after
      5000 -> {:error, :timeout}
    end
  end
end
