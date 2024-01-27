defmodule ServerProcess do
  @moduledoc false
  @spec start(atom()) :: pid()
  def start(callback_module) do
    spawn(fn _ ->
      initial_state = callback_module.init()
      loop(callback_module, initial_state)
    end)
  end

  def loop(callback_module, current_state) do
    receive do
      {request, caller} ->
        {response, new_state} =
          callback_module.handle_call(request, current_state)

        send(caller, {:response, response})

        loop(callback_module, new_state)
    end
  end

  def call(server_pid, request) do
    send(server_pid, {request, self()})

    receive do
      {:response, response} ->
        response
    end
  end
end

defmodule KeyValueStore do
  @moduledoc false
  def init do
    %{}
  end

  def handle_call({:put, key, value}, state) do
    {:ok, Map.put(state, key, value)}
  end

  def handle_call({:get, key}, state) do
    {Map.get(state, key), state}
  end

  def start do
    ServerProcess.start(__MODULE__)
  end

  def get(server_pid, key) do
    ServerProcess.call(server_pid, {:get, key})
  end

  def put(server_pid, key, value) do
    ServerProcess.call(server_pid, {:put, key, value})
  end
end
