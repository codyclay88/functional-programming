# The Unified Update Model

`refs`, `atoms`, and `agents` all provide functions for updating their state by applying a function to their previous state. This unified model for handling shared state is one of the central concepts in Clojure. The unified functions for each reference type are summarized in the following table

| Update Mechanism       | Ref Function | Atom Function | Agent Function |
| ---------------------- | ------------ | ------------- | -------------- |
| Function application   | `alter`      | `swap!`       | `send-off`     |
| Function (commutative) | `commute`    | N/A           | N/A            |
| Function (nonblocking) | N/A          | N/A           | `send`         |
| Simple setter          | `ref-set`    | `reset!`      | N/A            |

The unified update model is by far the most important way to update refs, atoms, and agents. The ancillary functions, on the other hand, are optimizations and options that stem from the semantics peculiar to each API:

- The opportunity for the `commute` optimization arises when coordinating updates. Since only refs provide coordinated updates, `commute` only makes sense for refs.
- Updates to refs and atoms take place on the thread they are called on, so they provide no scheduling options. Agents update later, on a thread pool, making blocking/nonblocking a relevant scheduling option.

Clojure's final reference type, the var, is a different beast entirely. Vars do not participate in the unified update model and are instead used to manage thread-local, private state.
