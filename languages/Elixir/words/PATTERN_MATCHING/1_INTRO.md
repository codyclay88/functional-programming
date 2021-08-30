# Introduction to Pattern Matching in Elixir

The `=` is NOT an assignment operator (unlike most languages).

```elixir
a = 1
a + 1
# => 2
1 = a
# => no error... what??
2 = a
# => ** (MatchError) no match of right hand side value: 1
```

What is happening here?

The `=` in Elixir is called the "match operator." When Elixir sees the match operator, it tries to make the left and right sides of the operator the same.

Let's look a bit closer at the expression `a = 1`.

At the start of the expression, all the variables on the LHS (left hand side) are marked as unbound. Elixir then says "what can I do to make the LHS and RHS equal?" The answer is to bind `1` to `a`.

Now `a` has the value `1`. When we write `b = a`, Elixir goes through the same process. `b` is unbound, and `a` is `1`, so Elixir binds `1` to `b`.

Then we write `1 = a`. There are no unbound variables. But fortunately that doesn't matter, as the LHS and RHS are already equal.

That explains why `2 = a` raises an error. Again, there are no unbound variables, so Elixir has no freedom to change anything. The LHS (2) doesn't equal the RHS (1), and there's no way for Elixir to make them equal. It admits defeat with a `NoMatchError`.

Further examples:

```elixir
{ a, b } = { "cat", "dog" }
a
# => "cat"
b
# => "dog"
```

The LHS and RHS are both two-element tuples. How can Elixir make them equal? By binding `"cat"` to `a` and `"dog"` to `b`.

```elixir
{ a, a } = { "cat", "dog" }
# => ** (MatchError) no match of right hand side value: {"cat", "dog"}
```

There is no way for Elixir to make the following match. `a` cannot equal both `"cat"` and `"dog"` at the same time.
