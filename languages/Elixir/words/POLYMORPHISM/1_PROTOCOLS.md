# Protocols

Protocols are a mechanism to achieve polymorphism in Elixir when you want behavior to vary depending on the data type. We are already familiar with one way of solving this type of problem: via pattern matching and guard clauses. Consider a simple utility funct

Protocols are the Elixir way of providing something roughly similar to OO interfaces. Protocols allow developers to create a generic logic that can be used with any type of data, assuming that some contract is implemented for the given data.

An excellent example is the `Enum` module, which provides many useful functions for manipulating anything that is enumerable.
