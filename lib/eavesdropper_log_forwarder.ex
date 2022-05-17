defmodule Eavesdropper.EavesdropperLogForwarder do
  @moduledoc """
  Enables and Disables the logger based upon if eavesdropper is registered
  """
  use GenServer
  require Logger

  def start_link(args) do
    GenServer.start_link(__MODULE__, [], name: Keyword.get(args, :name, __MODULE__))
  end

  def init(_) do
    :ok = :net_kernel.monitor_nodes(true)

    receiving_node =
      Application.get_env(:logger, EavesdropperLoggerBackend)
      |> Keyword.get(:receiving_node, "earth@127.0.0.1")

    initial_state = %{receiving_node: receiving_node}
    {:ok, initial_state}
  end

  def handle_info({:nodeup, node_name}, %{receiving_node: receiving_node} = state) do
    if node_name == :"#{receiving_node}" do
      Logger.add_backend(EavesdropperLoggerBackend)
    end

    {:noreply, state}
  end

  def handle_info({:nodedown, node_name}, %{receiving_node: receiving_node} = state) do
    if node_name == :"#{receiving_node}" do
      Logger.remove_backend(EavesdropperLoggerBackend)
    end

    {:noreply, state}
  end

  def handle_info(_unhandled, state) do
    {:noreply, state}
  end
end
