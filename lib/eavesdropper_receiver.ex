defmodule Eavesdropper.EavesdropperReceiver do
  use GenServer

  require Logger

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
  def handle_cast(
        {:message_received, %{level: :info, message: message, app_name: app_name}},
        state
      ) do
    Logger.info("#{app_name}: #{message}")
    {:noreply, state}
  end

  def handle_cast(
        {:message_received, %{level: :debug, message: message, app_name: app_name}},
        state
      ) do
    Logger.debug("#{app_name}: #{message}")
    {:noreply, state}
  end

  def handle_cast(
        {:message_received, %{level: :warn, message: message, app_name: app_name}},
        state
      ) do
    Logger.warn("#{app_name}: #{message}")
    {:noreply, state}
  end

  def handle_cast(
        {:message_received, %{level: :error, message: message, app_name: app_name}},
        state
      ) do
    Logger.error("#{app_name}: #{message}")
    {:noreply, state}
  end
end
