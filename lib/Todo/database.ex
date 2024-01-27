defmodule Todo.Database do
  use GenServer

  @db_folder "./persist"

  def start do
    GenServer.start(__MODULE__, nil, name: __MODULE__)
  end

  def store(key, data) do
    GenServer.cast(__MODULE__, {:store, key, data})
  end

  def get(key) do
    GenServer.call(__MODULE__, {:get, key})
  end

  @impl GenServer
  def handle_call({:get, key}, _from, state) do
    data = File.read(file_name(key))

    case data do
      {:ok, contents} ->
        :erlang.binary_to_term(contents)

      _ ->
        nil
    end

    {:reply, data, state}
  end

  @impl GenServer
  def handle_cast({:store, key, data}, state) do
    key
    |> file_name()
    |> File.write!(:erlang.term_to_binary(data))

    {:noreply, state}
  end

  defp file_name(key) do
    Path.join(@db_folder, to_string(key))
  end

  @spec choose_worker(any(), map()) :: {:ok, pid()} | {:error, String.t()}
  def choose_worker(db_key, worker_map) do
    worker_key = :erlang.phash2(db_key, map_size(worker_map))

    case Map.get(worker_map, worker_key) do
      nil -> {:error, "No worker found for key #{db_key}"}
      pid -> {:ok, pid}
    end
  end

  @impl GenServer
  @spec init(any()) :: {:ok, any()}
  def init(_) do
    File.mkdir_p!(@db_folder)

    workers =
      Enum.reduce(0..2, %{}, fn index, acc ->
        {:ok, worker_pid} = Todo.DatabaseWorker.start(@db_folder)
        Map.put(acc, index, worker_pid)
      end)

    {:ok, workers}
  end
end
