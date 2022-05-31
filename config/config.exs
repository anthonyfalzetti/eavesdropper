import Config

config :logger, EavesdropperBackend,
  receiving_node: "earth@127.0.0.1",
  level: :error,
  truncate: 4096,
  receiver: Eavesdropper.EavesdropperReceiver
