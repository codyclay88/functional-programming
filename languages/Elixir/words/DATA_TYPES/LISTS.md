# (Linked) Lists

A list is either:

- an empty list, or
- a head and a tail, where the tail is a list

An empty list looks like this: `[ ]`

A list with a head and a tail looks like this: `[h|t]`

The list containing the values `1` and `2` has a head of `1` and a tail which is another list. That second list has a head of `2` and a tail which is the empty list. It looks like this:

```elixir
[ 1 | [ 2 | [] ] ]
```

A list containing 1, 2, and 3 looks like this:

```elixir
[ 1 | [2 | [ 3 | [] ] ] ]
```

This is valid Elixir, but in practice we we use the shortcut syntax: `[1, 2, 3]`
