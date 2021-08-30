# Pattern Matching with Function Calls

Pattern Matching in Elixir can be accomplished in more places than just the `=` operator.

## Functions can pattern match their parameters

When you call a function, the arguments you pass are not simply assigned to the corresponding parameters in the function. Instead, each argument is pattern matched to its parameter.

For example, here's a function that takes a two-element tuple:

```elixir
def func({ a, b }) do
    IO.puts "a = #{a}, b = #{b}"
end
```

If we call it with `func({1, 2})` the pattern match will bind `1` to `a` and `2` to `b`.

If we want to access both the components of the tuple and the tuple itself, we could write:

```elixir
def func(t = { a, b }) do
    IO.puts "a = #{a}, b = #{b}, is_tuple{t}"
end
```

This isn't special syntax. When the arguent is matched to the parameter, it's as if we'd written

```elixir
t = { a, b } = { 1, 2 }
```

Two pattern matches take place, and three variables are bound.

## Using constants in our patterns

What does this function match?

```elixir
def read_file({:ok, file}) do
    #...
end
```

This will only be invoked if it is passed a two element tuple where the first element is `:ok`.

Similarly, the following function will only be invoked when passed an `:error` tuple.

```elixir
def read_file({:error, reason}) do
    #...
end
```

## Multiple function heads

Many languages support method overloading -- you can have two or more implementations of the same function if the specification of their parameters is different.

It's the same in Elixir -- functions can be overloaded based on the patterns their parameters match.

Let's take the two functions we just wrote:

```elixir
def read_file({ :ok, file }) do
    file
    |> IO.read(:line)
end

def read_file({ :error, reason }) do
    Logger.error("File error: #{reason})
    []
end
```

Remember that `File.open` returns a tuple containing either `{ :ok, file }` or `{ :error, reason }`. So we can use that fact in the following code:

```elixir
"my_file.txt"
|> File.open
|> read_file
```

We passed the value returned by `File.open` to our `read_file` function. Elixir chose which of the two function bodies to invoke by pattern matching this value against the parameters. If the file was opened successfully, the first body will be called. If not, it'll call the second body.

Pattern matching in parameter lists means we can take functions that would otherwise be a mess of nested conditional logic and rewrite them as a set of small, focused functions, each of which handles just one particular flow.

This is a major win. It makes code easier to write, and easier to read. And code that is easier to read is easier to change. And that's what good design is.
