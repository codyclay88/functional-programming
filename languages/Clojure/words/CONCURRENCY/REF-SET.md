# `ref-set`

You can change where a reference points with `ref-set`: `(ref-set reference new-value)`.

Call `ref-set` to listen to a different track:

```clj
(ref-set current-track "Venus, the Bringer of Peace")
; Execution error (IllegalStateException) at user/eval463 (REPL:1).
; No transaction running
```

Oops! Because refs are mutable, you must protect their updates. In many languages, you would use a _lock_ for this purpose, but in Clojure you can use a _transaction_. Transactions are wrapped in a `dosync`: `(dosync & exprs)`

Wrap your `ref-set` with a `dosync`, and all is well:

```clj
(dosync (ref-set current-track "Venus, the Bringer of Peace"))
; -> "Venus, the Bringer of Peace"
```

The `current-track` now references a different track.
