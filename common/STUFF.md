**Taken from Dave Thomas's "Elixir for Programmers" course**

In object-oriented programming, we tell objects to change their state by invoking instance methods. This is convenient, but if you've been doing OO programming for a while, you'll also know it has some drawbacks.

First, there's the coupling between state and behavior. In an ideal world, this wouldn't be a proble. But in the real world, we don't really have tidy encapsulation like this. Instead, we find ourselves constantly subclassing just so we can share methods. If you're a Rails developer, this is your dominant model of programming.

Second, there's confusion about roles. The state stored in a class is tied to the role implemented by that class. If you need to have it participate in other ways, you have to extend the class, perhaps with mixins or (heaven forbid!) subclassing. Yet more coupling.

Third (and in today's world probably the most significant issue) is the idea that methods mutate object state. In a concurrent system, if you have a reference to an object, you have no guarantees that the value of that object won't just change, even if you do nothing to it. We fix that with various synchronization techniques; it is difficult to verify that we did this correctly.

## Functions and State

In the world of functional programming, state is decoupled from behavior. State is always immutable -- it represents a fact that is true at some point in the life of your code.

Functions transform state into new state. They never change the state that's given to them. This means that ideal functions are _pure_: given a particular input, they will always produce the same output. In turn, this means that functions are easy to compose and reuse.

Our goal when using a functional paradigm is to think out our programs as one big function, transforming its inputs into outputs. We then break this down into progressively smaller functions, until we end up with a bunch of small functions which each does just one thing.
