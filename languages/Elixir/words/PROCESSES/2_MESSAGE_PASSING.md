# Passing Messages between Processes

We can send messages to a process with `send/2`...

```elixir
iex(1)> send(self(), {:hello, "world"})
{:hello, "world"}
```

...and receive them with `receive/1`

```elixir
iex(10)> receive do
...(10)>   {:hello, msg} -> msg
...(10)>   {:world, _msg } -> "won't match"
...(10)> end
"world"
```

When a message is sent to a process, the message is stored in the process mailbox. The `receive/1` block goes through the current process mailbox searching for a message that matches any of the given patterns.

```elixir
iex(15)> send(self(), {:hello, "world"})
{:hello, "world"}
iex(16)> send(self(), {:hello, "everybody"})
{:hello, "everybody"}
iex(17)> receive do
...(17)>   {:hello, msg} -> msg
...(17)> end
"world"
iex(18)> receive do
...(18)>   {:hello, msg} -> msg
...(18)> end
"everybody"
```

Notice from the example above that a `receive/1` block only processes a single message at a time.
