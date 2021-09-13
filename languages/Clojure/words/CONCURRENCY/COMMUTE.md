# `commute`

`commute` is a specialized variant of `alter` allowing for more concurrency: `(commute ref update-fn & args)`.

Of course, there's a trade-off. Commutes are so named because they must be _commutative_. That is, updates must be able to occur in any order. This gives the STM system freedom to reorder commutes.

To use `commute`, replace `alter` with `commute` in your implementation of `add-message`.

```clj
(defn add-message [msg]
    (dosync (commute messages conj msg)))
```

`commute` returns the new value of the ref. However, the last in-transaction value you see from a `commute` will _not_ always match the end-of-transaction value of a ref, because of reordering. If another transaction sneaks in and alters a ref that you're trying to `commute`, the STM will not restart your transaction. Instead, it will run your `commute` function again, out of order. Your transaction will _never even see_ the ref value that your `commute` function finally ran against.

Since Clojure's STM can reorder commutes behind your back, you can only use them when you don't care about ordering.

Literally speaking, this isn't true for a chat application. The list of messages certainly has an order, so if two message adds get reversed, the resulting list will not show correctly the order in which the messages arrived.

Practically speaking, chat message updates are _commutative enough_. STM-based reordering of messages will likely happen on time scales of microseconds or less. For users of a chat application, there are already reorderings on much larger timescales due to network and human latency. (Think about times you have "spoken out of turn" in an online chat because another speaker's mesage hadn't reached you yet.) Since these larger reorderings are unfixable, it's reasonable for a chat application to ignore the smaller reorderings that might bubble up from Clojure's STM.

## Prefer `alter`

Many updates are not commutative. For example, consider a counter that returns an increasing sequence of numbers. You might use such a counter to build unique IDs in a system. The counter can be a simple reference to a number.

```clj
(def counter (ref 0))
```

You should not use `commute` to update the counter. `commute` returns the in-transaction value of the counter at the time of the `commute`, but reorderings could cause the actual end-of-transaction value to be different. This could lead to more than one caller gettings the same counter value. Instead, use alter:

```clj
(defn next-counter [] (dosync (alter counter inc)))
```

In general, you should prefer `alter` over `commute`. Its semantics are easy to understand and error proof. `commute`, on the other hand, requires that you think carefully about transactional semantics. If you use `alter` when `commute` would suffice, the worst thing that might happen is performance degradation. But if you use `commute` when `alter` is required, you'll introduce a subtle bug that's difficult to detect with automated tests.
