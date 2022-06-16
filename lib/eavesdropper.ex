defmodule Eavesdropper do
  @moduledoc """
  Eavesdropper allows a node to receive the logs of other nodes without adding a
  dependency. This is done via creating the Eavesdropper.LoggerBackend on the
  target node and adding it as a Logger backend.
  """

  alias Eavesdropper.LogForwarder

  defdelegate start_eavesdropping(node_name), to: LogForwarder
  defdelegate stop_eavesdropping(node_name), to: LogForwarder
end
