defmodule Todo.DatabaseWorker do
  use GenServer

  # Public API

  def start(db_folder) do
    GenServer.start(__MODULE__, db_folder)
  end

  def store(worker_pid, key, data) do
    GenServer.cast(worker_pid, {:store, key, data})
  end

  def get(worker_pid, key) do
    GenServer.call(worker_pid, {:get, key})
  end

  # GenServer Implementation Functions

  @impl GenServer
  def handle_call({:get, key}, _from, db_folder) do
    data = File.read(file_name(key, db_folder))

    case data do
      {:ok, contents} ->
        :erlang.binary_to_term(contents)

      _ ->
        nil
    end

    {:reply, data, db_folder}
  end

  @impl GenServer
  def handle_cast({:store, key, data}, db_folder) do
    key
    |> file_name(db_folder)
    |> File.write!(:erlang.term_to_binary(data))

    {:noreply, db_folder}
  end

  defp file_name(key, db_folder) do
    Path.join(db_folder, to_string(key))
  end

  @impl GenServer
  def init(db_folder) do
    {:ok, db_folder}
  end
end
