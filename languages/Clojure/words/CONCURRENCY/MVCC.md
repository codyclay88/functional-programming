# Multiversion Concurrency Control

Clojure's STM uses a technique called Multiversion Concurrency Control (MVCC), which is also used in several major databases. Here's how MVCC works in Clojure:

Transaction A begins by taking a _point_, which is simply a number that acts as a unique timestamp in the STM world. Transaction A has access to its own _effectively private_ copy of any reference it needs, associated with that point. Clojure's persistent data structures make it cheap to provide these effectively private copies.

During Transaction A, operations on a ref work against (and return) the transaction's private copy of the ref's data, called the _in-transaction value_.

If at any point the STM detects that another transaction has already set/altered a ref that Transaction A wants to set/alter, Transaction A is forced to retry. If you throw an exception out of the `dosync` block, then Transaction A aborts _without_ a retry.

If and when Transaction A commits, its heretofore private writes will become visible to the world, associated with a single point in the transaction timeline.

Sometimes the approach implied by `alter` is too cautious. What if you _don't care_ that another transaction `alter`ed a reference in the middle of your transaction? If in such a situation you'd be willing to commit your changes anyways, you can beat `alter`'s performance with `commute`.
