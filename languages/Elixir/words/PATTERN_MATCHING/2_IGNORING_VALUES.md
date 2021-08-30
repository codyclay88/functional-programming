# Ignoring values in a match

The special variable whose name is a single underscore is never bound by pattern matching - in effect it acts as a placeholder, useful when you want to match the structure of a value, but don't care about some of the values it contains.

```elixir
[ a, _, _ ]
# match a three element list (where each element is potentially
# different to the others) and associate the value of the first
# element with `a`.

[ a, _, a ]
# match a three element list where the first and last elements
# are the same, binding that value to `a`.

[ h | _ ]
# extract just the head of the list
```
