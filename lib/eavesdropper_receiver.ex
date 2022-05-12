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
  def handle_cast({:message_received, %{level: :info, message: message}}, state) do
    Logger.info("Message Received: #{message}")
    {:noreply, state}
  end

  def handle_cast({:message_received, %{level: :debug, message: message}}, state) do
    Logger.debug("Message Received: #{message}")
    {:noreply, state}
  end

  def handle_cast({:message_received, %{level: :warn, message: message}}, state) do
    Logger.warn("Message Received: #{message}")
    {:noreply, state}
  end

  def handle_cast({:message_received, %{level: :error, message: message}}, state) do
    Logger.error("Message Received: #{message}")
    {:noreply, state}
  end
end
