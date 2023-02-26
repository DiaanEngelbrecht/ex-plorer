# Explorer

An attempt to visualize the process structure on the beam. This is meant as a OTP learning exercise, rather use LiveDashboard's Applications tab if you need this kind of functionality in your production applications.

## Why?

Erlang's observer tool is pretty great to have an at-a-glance visualization of your applications' supervision tree. This can help to build intuition on how an elixir application is structured and better understand your applications' runtime landscape. This becomes even more valuable when you start running multiple nodes and distributed workloads.

## How?

Explorer runs a simple liveview that allows you to have a look at the applications running on a given node.

It attempts to construct your supervision tree, and then sketches it out using D3 js.

## Examples

![Explorer view on SSL](docs/explorer_ssl.png?raw=true "Explorer view on SSL")

## Disclaimer

While I have tested this against observer's view for few cases(some phoenix apps & core libs like ssl), I cannot guarantee that this implementation is the same as observer's. I've mostly relied on values exposed via Elixir's wrappers of erlangs' :process_info and the dictionary values of $ancestors.

The following cases are not shown in the tree:
- Linked processes that are not direct children/parent relationships (blue lines in observer).
- Monitored processes.
