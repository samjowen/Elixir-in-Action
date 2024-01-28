defmodule Todo.Server do
  @moduledoc false
  # I.e., don't restart if it crashes
  use GenServer, restart: :temporary

  @impl GenServer
  def init(name) do
    {:ok, {name, Todo.Database.get(name) || Todo.List.new()}}
  end

  @impl GenServer
  def handle_call({:entries, date}, _from, state) do
    {_name, list} = state
    {:reply, TodoList.entries(list, date), state}
  end

  def via_tuple(name) do
    Todo.ProcessRegistry.via_tuple({__MODULE__, name})
  end

  @impl GenServer
  def handle_cast({:add_entry, entry}, state) do
    {_name, list} = state
    {:noreply, TodoList.add_entry(list, entry)}
  end

  # Public Interfaces
  def start_link(todo_list_name) do
    GenServer.start_link(__MODULE__, todo_list_name, name: via_tuple(todo_list_name))
  end

  def entries(date) do
    GenServer.call(__MODULE__, {:entries, date})
  end

  def add_entry(entry) do
    GenServer.cast(__MODULE__, {:add_entry, entry})
  end
end
