defmodule Todo.Cache do
  use GenServer

  @spec init(any()) :: {:ok, %{}}
  def init(_) do
    # Use an empty Map as the default state
    Process.register(self(), __MODULE__)
    {:ok, %{}}
  end

  # If the server exists, give it to the caller, if not, make it.
  def handle_call({:server_process, name}, _from, todo_servers) do
    case Map.fetch(todo_servers, name) do
      {:ok, todo_server} ->
        {:reply, todo_server, todo_servers}

      :error ->
        {:ok, new_server} = Todo.Server.start()
        {:reply, Map.put(todo_servers, name, new_server)}
    end
  end

  @spec start() :: :ignore | {:error, any()} | {:ok, pid()}
  def start() do
    GenServer.start(__MODULE__, nil, name: __MODULE__)
  end

  @spec get_server(any()) :: any()
  def get_server(name) do
    GenServer.call(__MODULE__, {:server_process, name})
  end
end
