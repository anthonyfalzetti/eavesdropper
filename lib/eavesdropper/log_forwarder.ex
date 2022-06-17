defmodule Eavesdropper.LogForwarder do
  @moduledoc """
  Enables and Disables the logger based upon if eavesdropper is registered
  """

  use GenServer
  require Logger
  alias Eavesdropper.LoggerBackendBuilder

  @spec start_link(list()) :: :ok
  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: Keyword.get(args, :name, __MODULE__))
  end

  @doc "Creates Eavesdropper.LoggerBackend on the target node, and adds it as a logger backend"
  @spec start_eavesdropping(binary()) :: {:ok, pid()} | {:badrpc, :nodedown}
  def start_eavesdropping(node_name) do
    GenServer.call(__MODULE__, {:eavesdrop_on_node, node_name})
  end

  @doc "Removes Eavesdropper.LoggerBackend as a backend on target node"
  @spec stop_eavesdropping(binary()) :: :ok | {:badrpc, :nodedown}
  def stop_eavesdropping(node_name) do
    GenServer.call(__MODULE__, {:stop_eavesdrop_on_node, node_name})
  end

  @doc "Simply returns the current state"
  @spec get_state() :: map()
  def get_state() do
    GenServer.call(__MODULE__, :get_state)
  end

  @impl true
  def init(_) do
    :ok = :net_kernel.monitor_nodes(true)
    Process.flag(:trap_exit, true)
    {:ok, %{listening_posts: []}}
  end

  @impl true
  def handle_info(_unhandled, state) do
    {:noreply, state}
  end

  @impl true
  def handle_call(:get_state, _pid, state) do
    {:reply, state, state}
  end

  @impl true
  def handle_call({:eavesdrop_on_node, node_name}, _pid, %{listening_posts: posts} = state) do
    :rpc.call(:"#{node_name}", Module, :create, LoggerBackendBuilder.build_arguments())

    result = :rpc.call(:"#{node_name}", Logger, :add_backend, [EavesdropperLoggerBackend])

    {:reply, result, %{state | listening_posts: [node_name | posts]}}
  end

  @impl true
  def handle_call({:stop_eavesdrop_on_node, node_name}, _pid, state) do
    result = :rpc.call(:"#{node_name}", Logger, :remove_backend, [EavesdropperLoggerBackend])

    {:reply, result, %{state | listening_posts: List.delete(state.listening_posts, node_name)}}
  end

  @impl true
  def terminate(reason, %{listening_posts: posts}) do
    Enum.each(posts, &(stop_eavesdropping(&1))
  end
end
