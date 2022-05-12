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
    {:ok, []}
  end

  def handle_info({:nodeup, :"earth@127.0.0.1"}, state) do
    Logger.add_backend(EavesdropperLoggerBackend)
    {:noreply, state}
  end

  def handle_info({:nodedown, :"earth@127.0.0.1"}, state) do
    Logger.remove_backend(EavesdropperLoggerBackend)
    {:noreply, state}
  end

  def handle_info(_unhandled, state) do
    {:noreply, state}
  end
end
