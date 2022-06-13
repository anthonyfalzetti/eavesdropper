defmodule Eavesdropper.EavesdropperLogForwarder do
  @moduledoc """
  Enables and Disables the logger based upon if eavesdropper is registered
  """
  use GenServer
  require Logger
  alias Eavesdropper.LoggerBackendBuilder

  def start_link(args) do
    GenServer.start_link(__MODULE__, [], name: Keyword.get(args, :name, __MODULE__))
  end

  def init(_) do
    :ok = :net_kernel.monitor_nodes(true)
    {:ok, %{}}
  end

  def get_state() do
    GenServer.call(__MODULE__, :get_state)
  end

  def handle_info({:nodeup, node_name}, state) do
    Logger.info "Connected to #{node_name}"
    # contents = Eavesdropper.LoggerBackendBuilder.build_contents()
    # :rpc.call(:"#{node_name}", Module, :create, [EavesdropperLoggerBackend, contents, Macro.Env.location(__ENV__)])
    # :rpc.call(:"#{node_name}", Logger, :add_backend, [EavesdropperLoggerBackend])

    {:noreply, state}
  end

  def handle_info({:nodedown, _node_name}, state) do
    {:noreply, state}
  end

  def handle_info(_unhandled, state) do
    {:noreply, state}
  end
end
