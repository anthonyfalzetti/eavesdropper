defmodule Eavesdropper.LoggerBackendBuilder do
  @moduledoc """
  Builds the logger backend that will cast log messages that are
  greater than the configured level
  """

  @doc "Returns the arguments for Module.create for a Logger backend that
        will cast the messages that exceed the min_log threshold to the receiving node"
  def build_arguments(node_name) do
    contents = build_contents(node_name)
    [EavesdropperLoggerBackend, contents, Macro.Env.location(__ENV__)]
  end

  defp build_contents(node_name) do
    config =
      Application.get_all_env(:eavesdropper)
      |> Keyword.put(:node_name, node_name)

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
            %{receiving_node: receiving_node, min_level: min_level, node_name: node_name} = state
          ) do
        if should_log?(min_level, level) do
          GenServer.cast(
            {Receiver, :"#{receiving_node}"},
            {:message_received, {level, msg, node_name}}
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

      def handle_event(_, state) do
        {:ok, state}
      end

      defp should_log?(nil, _lvl), do: true

      defp should_log?(min, lvl) do
        Logger.compare_levels(lvl, min) != :lt
      end

      defp configure(state, opts) do
        Map.merge(state, Enum.into(%{}, opts))
      end
    end
  end
end
