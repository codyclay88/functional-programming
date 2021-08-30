# Pinning in a match

How could you use the value in a variable on the LHS of a pattern match?

We can do this by using the _pin operator_, which is the `^` character. By prefixing a variable with `^`, the value of the variable will not be rebound in a match:

```elixir
first = 42
{ ^first, second } = { 42, 53 }
second
# => 53
{ ^first, second } = { 43, 53}
# => ** (MatchError) no match of right hand side value: {42, 53}
{ first, second } = { 43, 53 }
first
# => 43
second
# => 53
```
