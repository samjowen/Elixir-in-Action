defmodule Todo.Cache do
  @moduledoc false
  use GenServer

  require Logger

  @impl GenServer
  @spec init(any()) :: {:ok, %{}}
  def init(_) do
    IO.puts("Starting Todo Cache...")
    Todo.Database.start_link()
    {:ok, %{}}
  end

  @impl GenServer
  def handle_call({:server_process, name}, _from, todo_servers) do
    case Map.fetch(todo_servers, name) do
      {:ok, todo_server} ->
        {:reply, todo_server, todo_servers}

      :error ->
        {:ok, new_server} = Todo.Server.start_link(name)
        {:reply, new_server, Map.put(todo_servers, name, new_server)}
    end
  end

  def start_link(_init_arg) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  @spec get_server(atom() | pid() | {atom(), any()} | {:via, atom(), any()}, any()) :: any()
  def get_server(pid, name) do
    GenServer.call(pid, {:server_process, name})
  end
end
