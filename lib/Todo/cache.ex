defmodule Todo.Cache do
  use GenServer

  def init(_) do
    # Use an empty Map as the default state
    Process.register(self(), __MODULE__)
    {:ok, %{}}
  end

  # If the server exists, give it to the caller, if not, make it.
  def handle_call({:server, name}, _from, state) do
    case Map.fetch(state, name) do
      {:ok, value} -> value
      :error -> {:reply, Map.put(state, name, Todo.Server.start())}
    end
  end

  @spec start() :: :ignore | {:error, any()} | {:ok, pid()}
  def start() do
    GenServer.start(__MODULE__, nil, name: __MODULE__)
  end

  def get_server(name) do
    GenServer.call(__MODULE__, {:server, name})
  end
end
