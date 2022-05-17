defmodule EavesdropperLoggerBackend do
  @behaviour :gen_event

  @moduledoc """
  A eavesdropper backend for `Logger`.
  """
  require Logger

  @base_config %{
    name: __MODULE__,
    level: :error,
    truncate: 4096
  }

  def init(__MODULE__) do
    {:ok, configure(__MODULE__, [])}
  end

  def handle_call({:configure, opts}, %{name: name} = state) do
    {:ok, :ok, configure(name, opts, state)}
  end

  def handle_event(
        {level, _groupleader, {Logger, message, timestamp, metadata}},
        %{level: min_level, receiving_node: receiving_node, app_name: app_name} = state
      ) do
    if should_log?(min_level, level) do
      msg = %{
        level: level,
        message: message,
        timestamp: timestamp,
        metadata: metadata,
        app_name: app_name
      }

      GenServer.cast(
        {Eavesdropper.EavesdropperReceiver, :"#{receiving_node}"},
        {:message_received, msg}
      )
    end

    {:ok, state}
  end

  def handle_event(:flush, state) do
    {:ok, state}
  end

  def handle_info(_msg, state) do
    {:ok, state}
  end

  def terminate(_reason, _state) do
    :ok
  end

  def code_change(_old, state, _extra) do
    {:ok, state}
  end

  defp configure(name, opts) do
    Application.get_env(:logger, name, [])
    |> Keyword.merge(opts)
    |> Enum.into(@base_config)
  end

  defp configure(_name, [level: new_level], state) do
    Map.merge(state, %{level: new_level})
  end

  defp configure(_name, _opts, state), do: state

  defp should_log?(nil, _lvl), do: true

  defp should_log?(min, lvl) do
    Logger.compare_levels(lvl, min) != :lt
  end
end
