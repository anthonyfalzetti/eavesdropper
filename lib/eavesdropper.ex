defmodule Eavesdropper do

  def add_eavesdropper(node_name) do
    contents = Eavesdropper.LoggerBackendBuilder.build_contents()
    :rpc.call(:"#{node_name}", Module, :create, [EavesdropperLoggerBackend, contents, Macro.Env.location(__ENV__)])
    :rpc.call(:"#{node_name}", Logger, :add_backend, [EavesdropperLoggerBackend])
  end
end
