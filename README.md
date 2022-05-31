# Eavesdropper

## Motivation
We wanted the ability for a node to join a cluster and do some work that might stress the systems in which it interacts. We would like to capture all errors from all nodes in the cluster. Eavesdropper would allow minimal configuration on the forwarding nodes, and the ability for the receiving node to be spun up and down at will without a lot of overhead.
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
