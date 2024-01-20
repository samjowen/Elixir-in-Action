defmodule Concurrency.Calculator do
  # Public Start Method to make this process
  @spec start() :: pid()
  def start(initial_state \\ 0) do
    spawn(fn _ -> loop(initial_state) end)
  end

  defp process_message(current_state, {:value, caller_pid}) do
    send(caller_pid, {:response, current_state})
  end

  defp process_message(current_state, {:add, amount}) do
    current_state + amount
  end

  defp process_message(current_state, {:subtract, amount}) do
    current_state - amount
  end

  defp process_message(current_state, {:multiply, amount}) do
    current_state * amount
  end

  defp process_message(current_state, {:divide, amount}) do
    current_state / amount
  end

  defp loop(current_state) do
    new_state =
      receive do
        message ->
          process_message(current_state, message)
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
