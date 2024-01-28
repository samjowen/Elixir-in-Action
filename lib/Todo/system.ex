defmodule Todo.System do
  # Automatically defines child_spec/1
  @moduledoc false
  use Supervisor

  def start_link(_init_arg) do
    Supervisor.start_link(__MODULE__, nil, name: __MODULE__)
  end

  @impl true
  def init(_init_arg) do
    children = [
      {Todo.Cache, nil}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
