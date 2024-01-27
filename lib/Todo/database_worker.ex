defmodule Todo.DatabaseWorker do
  use GenServer

  @impl GenServer
  def init(db_folder_path) do
    {:ok, db_folder_path}
  end

  @spec start(any()) :: :ignore | {:error, any()} | {:ok, pid()}
  def start(db_folder_path) do
    GenServer.start(__MODULE__, db_folder_path)
  end
end
