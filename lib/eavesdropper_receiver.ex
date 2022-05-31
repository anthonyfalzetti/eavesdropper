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
    {:ok, configure(initial_state)}
  end

  def get_state() do
    GenServer.call(__MODULE__, :get_state)
  end

  @impl true
  def handle_cast({:message_received, msg}, [forward: true, receiver: receiver] = state) do
    GenServer.cast(receiver, {:message_received, msg})
    {:noreply, state}
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

  @impl true
  def handle_call(:get_state, _pid, state) do
    {:reply, state, state}
  end

  defp format_msg(%{message: message, app_name: app_name, timestamp: {date, time}}) do
    dt_date = Formatter.format_date(date)
    dt_time = Formatter.format_time(time)
    "#{app_name} - #{dt_date}T#{dt_time}Z: #{message}"
  end

  def configure(params) do
    Application.get_all_env(:eavesdropper)
    |> Keyword.merge(params)
  end
end
