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

Erlang uses sequences of bytes to represent strings. It considers this just another byte stream -- binary data -- and so calls these values _binaries_. This convention carries forward into Elixir, so don't be surprised to see the word _binary_ where you were expecting _string_.

An Elixir string is a sequence of Unicode codepoints. They look and behave much like strings in other languages, although they are immutable.

You can write a string as `"hello"`. This is equivalent to `~s{hello}`. Be careful not to use single quotes when you want a string. `'hello'` is the same as `~c{hello}`; it generates a list of character codepoints.
