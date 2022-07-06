defmodule Eavesdropper.Receiver do
  @moduledoc """
  Simple GenServer that receives log messages log messages and either forwards
  them onto a configured receiver or logs them.
  """
  use GenServer

  require Logger

  alias Logger.Formatter

  # Client
  def start_link(default) when is_list(default) do
    GenServer.start_link(__MODULE__, default, name: __MODULE__)
  end

  @doc "Simply returns the current state"
  def get_state() do
    GenServer.call(__MODULE__, :get_state)
  end

  # Server
  @impl true
  def init(initial_state) do
    {:ok, configure(initial_state)}
  end

  @impl true
  def handle_call(:get_state, _pid, state) do
    {:reply, state, state}
  end

  @impl true
  def handle_cast({:message_received, msg}, %{forward: true, receiver: receiver} = state) do
    GenServer.cast(receiver, {:message_received, msg})
    {:noreply, state}
  end

  def handle_cast({:message_received, {level, msg, node_name}}, state) do
    formatted_msg = format_msg(msg, node_name)

    apply(Logger, :bare_log, [level, formatted_msg])
    {:noreply, state}
  end

  defp format_msg({Logger, message, {date, time}, _metadata}, node_name) do
    dt_date = Formatter.format_date(date)
    dt_time = Formatter.format_time(time)
    "#{node_name} #{dt_date}T#{dt_time}Z: #{message}"
  end

  defp configure(params) do
    Application.get_all_env(:eavesdropper)
    |> Keyword.merge(params)
    |> Enum.into(%{})
  end
end
