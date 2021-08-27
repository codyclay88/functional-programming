# Strings

Strings in Elixir are delimited by double quotes, and they are encoded in UTF-8.

Elixir supports string interpolation:

```zsh
iex(1)> string = :world
:world
iex(2)> "hello #{string}"
"hello world"
```

You can print a string by using the `IO.puts/1` function from the `IO` module.

```zsh
iex(1)> IO.puts("hello\n\n\nworld")
hello


world
:ok
iex(2)>
```

Strings in Elixir are represented internally by contiguous sequences of bytes known as binaries.
