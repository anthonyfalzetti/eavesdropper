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
2. add to the application tree
```elixir
  {Eavesdropper.Receiver, []},
  {Eavesdropper.LogForwarder, []}
```
3. Add configs
```elixir
config :eavesdropper,
  receiving_node: "earth@127.0.0.1", # name of the node that will receive the logs
  min_level: :error, # The minimum level of logs to be forwarded
  truncate: 4096 # max of logs (default is what Logger is defaulted to)
```
4. Once connected to a node run `Eavesdropper.start_eavesdropping(node_name)` to start seeing the logs from the target node
5. To stop eavesdropping on a target node run `Eavesdropper.stop_eavesdropping(node_name)`
