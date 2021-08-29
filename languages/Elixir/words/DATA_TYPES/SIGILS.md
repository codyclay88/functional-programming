# Sigils

A sigil is simply a notion for creating values from strings.

All tildes start with the tilde character `~`. This is followed by a single letter, which determines the type of value to be generated. Next comes the string, between delimiters, and finally there may be some optional flags.

The delimiters can be:

```elixir
~r/.../
~r"..."
~r'...'
~r<...>
~r[...]
~r(...)
~r{...}
~r"""
:
:
"""
```

Finally, the optional flags are simply a string of letters. Their interpretation depends on the sigil type. For example, `~r/cat/i` has the flag `i`, which makes the pattern match case sensitive.

The sigils that come as part of Elixir are:

- ~c// ~C// list of character codes
- ~r// ~R// regular expression
- ~s// ~S// string
- ~w// ~W// list of words

```elixir
~c/cat\0/
# => [99, 97, 116, 0]
~r/cat/i
# => ~r/cat/i
~s/dog/
# => "dog"
~w/now is the time/
# => ["now", "is", "the", "time"]
```

The lowercase versions of sigils expand escape sequences and interpolate embedded expressions:

```elixir
name = "Betty"
~s/Hello #{name}\n/
# => "Hello Betty\n"
~c/#{name}\0/
# => [66, 101, 116, 116, 121, 0]
```

The uppercase equivalents do no expansion:

```elixir
~S/Hello #{name}\n/
# => "Hello \#{name}\\n"
```

There are three additional built-in sigils, `~D//`, `~N//`, and `~T//`. These generate dates and times.

Finally, you can add your own sigils into the language by writing appropriately named functions. This is rarely done.
