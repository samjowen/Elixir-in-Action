defmodule KeyValueStoreGenServer do
  use GenServer

  # We have to supply our own init function which GenServer will use. This gives the initial state
  # of the GenServer.

  @impl GenServer
  def init(_) do
    # Has to be in the shape of {:ok, init_state}
    {:ok, %{}}
  end

  # Private

  @impl GenServer
  def handle_cast({:put, key, value}, state) do
    {:noreply, Map.put(state, key, value)}
  end

  @impl GenServer
  def handle_call({:get, key}, _from, state) do
    {:reply, Map.get(state, key), state}
  end

  # Public Functions

  def get(pid, key) do
    GenServer.call(pid, {:get, key})
  end

  def put(pid, key, value) do
    GenServer.call(pid, {:put, key, value})
  end
end
