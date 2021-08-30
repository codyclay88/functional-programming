# Maps!

Some languages call them dictionaries, hashes, or associative arrays. Elixir calls them _maps_.

```elixir
counties = %{
    "BFA" => "Burkina Faso",
    "BDI" => "Burundi",
    "KHM" => "Cambodia",
    "CMR" => "Camaroon",
    "CAN" => "Canada"
}

countries["BFA"]
# => "Burkina Faso"

countries ["XXX"]
# => nil

countries [123]
# => nil
```

Maps are an unordered collection of key/value pairs. Both keys and values can be any Elixir type, and those types can be mixed within a map.

We often use maps as lookup tables, where the keys are all atoms. For these cases Elixir has a shortcut syntax.

```elixir
multipliers = %{ once: 1, twice: 2, thrice: 3 }
5 * multipliers[:twice]
# => 10
5 * multipliers.twice
# => 10
```
