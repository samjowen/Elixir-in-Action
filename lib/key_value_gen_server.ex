defmodule KeyValueStoreGenServer do
  @moduledoc false
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
  def handle_info({:uduplrlrss}, unchanged_state) do
    IO.puts("Cheat activated")
    # State is unchanged, we just print something to the console
    {:noreply, unchanged_state}
  end

  @impl GenServer
  def handle_cast({:put, key, value}, state) do
    {:noreply, Map.put(state, key, value)}
  end

  @impl GenServer
  def handle_call({:get, key}, _from, state) do
    {:reply, Map.get(state, key), state}
  end

  # Public Functions

  def start do
    GenServer.start(__MODULE__, nil, name: __MODULE__)
  end

  def get(pid, key) do
    GenServer.call(pid, {:get, key})
  end

  @spec put(atom() | pid() | {atom(), any()} | {:via, atom(), any()}, any(), any()) :: :ok
  def put(pid, key, value) do
    GenServer.cast(pid, {:put, key, value})
  end

  # Does the Konami code on the GenServer
  # This shows that we can send arbitrary messages to the GenServer and it will handle them
  # by using the handle_info callback
  def cheat(pid) do
    send(pid, {:uduplrlrss})
  end
end
