defmodule Eavesdropper.LoggerBackendBuilder do
  @moduledoc """
  Builds the logger backend that will cast log messages that are
  greater than the configured level
  """

  def build_arguments() do
    contents = build_contents()
    [EavesdropperLoggerBackend, contents, Macro.Env.location(__ENV__)]
  end

  def build_contents() do
    config = Application.get_all_env(:eavesdropper)

    quote do
      @moduledoc """
      A eavesdropper logger backend for `Logger`.
      """

      @behaviour :gen_event
      require Logger
      alias Eavesdropper.Receiver

      def init(__MODULE__) do
        {:ok, configure(%{}, Enum.into(unquote(config), %{}))}
      end

      def handle_call({:configure, opts}, state) do
        {:ok, :ok, configure(state, opts)}
      end

      def handle_event(
            {level, _groupleader, msg},
            %{receiving_node: receiving_node, min_level: min_level} = state
          ) do
        if should_log?(min_level, level) do
          GenServer.cast({Receiver, :"#{receiving_node}"}, {:message_received, {level, msg}})
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

      def handle_event(_, state) do
        {:ok, state}
      end

      defp should_log?(nil, _lvl), do: true

      defp should_log?(min, lvl) do
        Logger.compare_levels(lvl, min) != :lt
      end

      defp configure(state, opts) do
        state
        |> Map.merge(Enum.into(%{}, opts))
      end
    end
  end
end
