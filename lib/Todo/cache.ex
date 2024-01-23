defmodule Todo.Cache do
  use GenServer

  def init(_) do
    # Use an empty Map as the default state
    {:ok, %{}}
  end
end
