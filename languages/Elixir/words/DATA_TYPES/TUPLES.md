# Tuples

A tuple is a fix-length collection of values. Back when you did geometry in school, you used tuples all the time: `{x, y}` and `{x, y, z}` are both tuples.

Tuple literals are written as a list of expressions between braces:

```elixir
{ :ok, "wilma" }
{ :reply, destination, "rain with chance of hail" }
{ 1, 2, 3+4 }
```

Typically tuples are small (two or three elements). They are frequently used to pass flagged values to and from functions. For example, if successful, `File.read` returns the tuple `{ :ok, contents }` where the first element is the atom `:ok` and the second is the contents of the file.

If instead the file could not be read, `File.read` would return: `{ :error, reason }` where reason is the explanation of the failure.

This might seem a little clunky, but later on we'll look at pattern matching and we'll see that tuples are actually easy to manipulate.
