defmodule Todo.Server do
  @moduledoc false
  use GenServer

  @impl GenServer
  def init(name) do
    {:ok, {name, Todo.Database.get(name) || Todo.List.new()}}
  end

  @impl GenServer
  def handle_call({:entries, date}, _from, state) do
    {_name, list} = state
    {:reply, TodoList.entries(list, date), state}
  end

  @impl GenServer
  def handle_cast({:add_entry, entry}, state) do
    {_name, list} = state
    {:noreply, TodoList.add_entry(list, entry)}
  end

  # Public Interfaces
  def start(todo_list_name) do
    GenServer.start(__MODULE__, todo_list_name)
  end

  def entries(date) do
    GenServer.call(__MODULE__, {:entries, date})
  end

  def add_entry(entry) do
    GenServer.cast(__MODULE__, {:add_entry, entry})
  end
end
