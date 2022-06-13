defmodule Eavesdropper.Receiver do
  use GenServer

  require Logger

  alias Logger.Formatter

  # Client

  def start_link(default) when is_list(default) do
    GenServer.start_link(__MODULE__, default, name: __MODULE__)
  end

  # Server
  @impl true
  def init(initial_state) do
    {:ok, configure(initial_state)}
  end

  def get_state() do
    GenServer.call(__MODULE__, :get_state)
  end

  @impl true
  def handle_call(:get_state, _pid, state) do
    {:reply, state, state}
  end


  @impl true
  def handle_cast({:message_received, {level, msg}}, [forward: true, receiver: receiver] = state) do
    GenServer.cast(receiver, {:message_received, msg})
    {:noreply, state}
  end


  @impl true
  def handle_cast({:message_received, {level, msg}}, state) do
    formatted_msg = format_msg(msg)

    apply(Logger, :bare_log, [level, formatted_msg])
    {:noreply, state}
  end

  defp format_msg({Logger, message, {date, time}, metadata}) do
    dt_date = Formatter.format_date(date)
    dt_time = Formatter.format_time(time)
    "#{dt_date}T#{dt_time}Z: #{message}"
  end

  def configure(params) do
    Application.get_all_env(:eavesdropper)
    |> Keyword.merge(params)
  end
end
