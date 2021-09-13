# State and Concurrency Intro

A _state_ is the value of an identity at a point in time.

A value is an immutable, persistent data structure.

The flow of time makes things substantially more difficult. Updating an identity does not destroy old values. In fact, updating an identity has no impact on existing values whatsoever.

Clojure's reference model clearly separates identities from values. Almost everything in Clojure is a value. For identities, Clojure provides four reference types:

- Refs manage coordinated, synchronous changes to shared state.
- Atoms manage uncoordinated, synchronous changes to shared state.
- Agents manage asynchronous changes to shared state.
- Vars manage thread-local state.

## Concurrency, Parallelism, and Locking

A concurrent program models more than one thing happening simultaneously. A parallel program takes an operation that could be sequential and chooses to break it into separate pieces that can execute concurrently to speed overall execution.

Clojure's model for state and identity solves the problems inherent in Concurrency and Parallelism -- without using locks as traditional languages do.

The small parts of the codebase that truly benefit from mutability are distinct and must explicitly select one of four reference models. Using these models, you can split your models into two layers:

- a _functional_ model that has no mutable state. Most of your code will normally be in this layer, which is easier to read, easier to test, and easier to parallelize
- _reference_ models for the parts of the application that you find more convenient to deal with using mutable state (despite its disadvantages).
