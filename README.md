# Eavesdropper

## Motivation
We wanted the ability for a node to join a cluster and monitor the logs of all the nodes in the cluster without adding anything as a dependency. 

## Installation

It's [available on Hex](https://hex.pm/packages/eavesdropper), the package can be installed as:

### Installing and configuring the receiving application

1. add `:eavesdropper` to your dependencies
```elixir
def deps do
  [
    {:eavesdropper, "~> 0.0.1"}
  ]
end
```
2. Add `{Eavesdropper.EavesdropperReceiver, []}` to the application tree
### Installing and configuring the forwarding application
1. add `:eavesdropper` to your dependencies
```elixir
def deps do
  [
    {:eavesdropper, "~> 0.0.1"}
  ]
end
```
2. Add `{Eavesdropper.EavesdropperLogForwarder, []}` to the application tree
3. Configure the EavesdropperLoggerBackend
```elixir
config :logger, EavesdropperLoggerBackend,
 receiving_node: node_name,
 level: :warn
```

### Runtime configuration changes
Changes can be changed at runtime using the following example.
```elixir
Logger.configure_backend(EavesdropperLoggerBackend, level: :warn)
```
