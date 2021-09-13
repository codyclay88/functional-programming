# Vars

## Managing Per-Thread State with Vars

When you call `def` or `defn`, you create a _var_. In all the examples so far in this book, you pass an initial value to `def`, which becomes the _root binding_ for the var. For example, the following code creates a root binding for `foo` of `10`:

```clj
(def ^:dynamic foo 10)
; -> #'user/foo
```

The binding of `foo` is shared by all threads. You can check the value of `foo` on your own thread by typing `foo` into the REPL.

You can also verify the value of `foo` from another thread. Create a new thread, passing it a function that prints `foo`. Don't forget to `start` the thread:

```clj
(.start (Thread. (fn [] (println foo))))
; -> nil
; 10
```

In the above example, the call to `start` returns `nil`, and then the value of `foo` is printed from a new thread.

Most vars are content to keep their root bindings forever. However, you can create a _thread-local_ binding for a var with the `binding` macro: `(binding [bindings] & body)`

Bindings have _dynamic scope_. In other words, a binding is visible anywhere a thread's execution takes it, until the thread exits the scope where the binding began. A binding in not visible to other threads.
