defmodule Todo.DatabaseWorker do
  @moduledoc false
  use GenServer

  # Public API

  def start_link({db_folder, worker_id}) do
    IO.puts("Starting Todo Database Worker #{worker_id}...")
    GenServer.start_link(__MODULE__, db_folder, name: via_tuple(worker_id))
  end

  def store(worker_id, key, data) do
    GenServer.cast(via_tuple(worker_id), {:store, key, data})
  end

  def get(worker_id, key) do
    GenServer.call(via_tuple(worker_id), {:get, key})
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

  defp via_tuple(worker_id) do
    Todo.ProcessRegistry.via_tuple({__MODULE__, worker_id})
  end
end
