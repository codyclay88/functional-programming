# Anonymous Functions

Elixir provides anonymous functions, which allow us to store and pass executable code around as if it was an integer or a string. They are delimited by the keywords `fn` and `end`:

```zsh
iex(1)> add = fn a, b -> a + b end
#Function<43.40011524/2 in :erl_eval.expr/5>
iex(2)> add.(1, 2)
3
iex(3)> is_function(add)
true
```

In the example above we defined an anonymous function that receives two arguments, `a` and `b`, and returns the result of `a + b`. The arguments are always on the left-hand side of `->` and the code to be executed on the right-hand side. The anonymous function is stored in the variable `add`.

We can invoke anonymous functions by passing arguments to it. Note that a dot (`.`) between the variable and parentheses is required to invoke an anonymous function. The dot ensures there is no ambiguity between calling the anonymous function matched to a variable `add` and a named function `add/2`.
