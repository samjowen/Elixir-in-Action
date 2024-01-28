defmodule Todo.Cache do
  @moduledoc false
  use GenServer

  require Logger

  @impl GenServer
  @spec init(any()) :: {:ok, %{}}
  def init(_) do
    IO.puts("Starting Todo Cache...")
    # Todo.Database.start_link(nil)
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
    IO.puts("Starting Todo Cache...")
    DynamicSupervisor.start_link(__MODULE__, strategy: :one_for_one)
  end

  @spec get_server(atom() | pid() | {atom(), any()} | {:via, atom(), any()}, any()) :: any()
  def get_server(pid, name) do
    GenServer.call(pid, {:server_process, name})
  end

  def child_spec(_arg) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, []},
      type: :supervisor
    }
  end

  defp start_child(todo_list_name) do
    DynamicSupervisor.start_child(__MODULE__, {Todo.Server, todo_list_name})
  end
end
