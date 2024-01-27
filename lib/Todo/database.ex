defmodule Todo.Database do
  use GenServer

  @db_folder "./persist"

  def start do
    GenServer.start(__MODULE__, nil, name: __MODULE__)
  end

  @spec store(any(), any()) :: any()
  def store(key, data) do
    {:ok, worker_pid} = choose_worker(key)
    Todo.DatabaseWorker.store(worker_pid, key, data)
  end

  def get(key) do
    {:ok, worker_pid} = choose_worker(key)
    Todo.DatabaseWorker.get(worker_pid, key)
  end

  @impl GenServer
  def handle_call({:choose_worker, key}, _from, state) do
    {:reply, choose_worker(key, state), state}
  end

  @spec choose_worker(any(), map()) :: {:ok, pid()} | {:error, String.t()}
  defp choose_worker(db_key, worker_map) do
    worker_key = :erlang.phash2(db_key, map_size(worker_map))

    case Map.get(worker_map, worker_key) do
      nil -> {:error, "No worker found for key #{db_key}"}
      pid -> {:ok, pid}
    end
  end

  def choose_worker(key) do
    GenServer.call(__MODULE__, {:choose_worker, key})
  end

  def start_workers() do
    Enum.reduce(0..2, %{}, fn index, acc ->
      {:ok, worker_pid} = Todo.DatabaseWorker.start(@db_folder)
      Map.put(acc, index, worker_pid)
    end)
  end

  @impl GenServer
  @spec init(any()) :: {:ok, any()}
  def init(_) do
    File.mkdir_p!(@db_folder)

    {:ok, start_workers()}
  end
end
