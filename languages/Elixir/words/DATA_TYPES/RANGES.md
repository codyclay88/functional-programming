# Ranges

Ranges represent a bounded set of integers. They are typically used in two contexts.

First, they are used with the `in` operator to check that an integer falls between two bounds:

```elixir
a = 5..10
# => 5..10
b = 8..3
# => 8..3
4 in a
# => false
4 in b
# => true
```

Second, they are enumerable, and so are used as the starting point for different kinds of iteration (which we cover later).

```elixir
b = 8..3
for i <- b, do: i*3
# => [24, 21, 18, 15, 12, 9]
```
