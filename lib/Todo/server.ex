defmodule Todo.Server do
  use GenServer

  @impl GenServer
  def init(_) do
    {:ok, TodoList.new()}
  end

  @impl GenServer
  def handle_call({:entries, date}, _from, state) do
    {:reply, TodoList.entries(state, date), state}
  end

  @impl GenServer
  def handle_cast({:add_entry, entry}, state) do
    {:noreply, TodoList.add_entry(state, entry)}
  end

  # Public Interfaces
  def start() do
    GenServer.start(__MODULE__, nil, name: __MODULE__)
  end

  def entries(date) do
    GenServer.call(__MODULE__, {:entries, date})
  end

  def add_entry(entry) do
    GenServer.cast(__MODULE__, {:add_entry, entry})
  end
end
