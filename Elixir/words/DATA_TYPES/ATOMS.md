# Atoms

An atom in Elixir is a constant whose value is its own name. Some other languages call these symbols. For example `:apple` and `:orange` are both atoms. Because an atom's value is it's name, the expression `:apple == :apple` is true, while `:apple == :orange` is false.

You will often see atoms used to express the state of an operation, by using values such as `:ok` or `:error`.

The booleans `true` and `false` are also atoms:

```zsh
iex(1)> true == :true
true
iex(2)> is_atom(false)
true
iex(3)> is_atom(:false)
true
iex(4)> is_boolean(:false)
true
iex(5)> is_atom(false)
true
```

Elixir allows you to skip the leading `:` character for `true`, `false`, and `nil`.

Finally, Elixir has a construct called aliases that start with upper case and are also atoms:

```zsh
iex(1)> is_atom(Hello)
true
iex(2)> is_atom(hello)
** (CompileError) iex:2: undefined function hello/0
    (stdlib 3.15.2) lists.erl:1358: :lists.mapfoldl/3
```

Notice in the first prompt that `Hello` is considered an atom, while in the second prompt the compiler thinks that `hello` is supposed to be a function.
