defmodule Eavesdropper.EavesdropperReceiver do
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
    {:ok, initial_state}
  end

  @impl true
  def handle_cast({:message_received, %{level: :info} = params}, state) do
    params
    |> format_msg()
    |> Logger.info()

    {:noreply, state}
  end

  def handle_cast({:message_received, %{level: :debug} = params}, state) do
    params
    |> format_msg()
    |> Logger.debug()

    {:noreply, state}
  end

  def handle_cast({:message_received, %{level: :warn} = params}, state) do
    params
    |> format_msg()
    |> Logger.warn()

    {:noreply, state}
  end

  def handle_cast({:message_received, %{level: :error} = params}, state) do
    params
    |> format_msg()
    |> Logger.error()

    {:noreply, state}
  end

  defp format_msg(%{message: message, app_name: app_name, timestamp: {date, time}}) do
    dt_date = Formatter.format_date(date)
    dt_time = Formatter.format_time(time)
    "#{app_name} - #{dt_date}T#{dt_time}Z: #{message}"
  end
end
