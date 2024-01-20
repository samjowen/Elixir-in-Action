defmodule Concurrency.Calculator do
  # Public Start Method to make this process
  def start(initial_state \\ 0) do
    spawn(fn _ -> loop(initial_state) end)
  end

  defp loop(state) do
    new_state =
      receive do
        # Value getter
        {:value, caller_pid} ->
          send(caller_pid, {:response, state})
          state

        # Adder
        {:add, amount} ->
          state + amount

        # Subtractor
        {:subtract, amount} ->
          state - amount

        # Muliplyer
        {:multiply, amount} ->
          state * amount

        # Divider
        {:divide, amount} ->
          state / amount
      end

    loop(new_state)
  end

  # Public Value Getting Method
  def value(calculator_pid) do
    send(calculator_pid, {:value, self()})

    receive do
      {:response, value} ->
        value
    end
  end

  def add(calculator_pid, amount) do
    send(calculator_pid, {:add, amount})
  end

  def subtract(calculator_pid, amount) do
    send(calculator_pid, {:subtract, amount})
  end

  def multiply(calculator_pid, amount) do
    send(calculator_pid, {:multiply, amount})
  end

  def divide(calculator_pid, amount) do
    send(calculator_pid, {:divide, amount})
  end
end
