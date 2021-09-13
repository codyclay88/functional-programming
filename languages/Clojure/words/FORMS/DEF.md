# `def`

Clojure is a practical language that recognizes the need to maintain a persistent reference to a changing value and provides 4 distinct mechanisms for doing so in a controlled manner -- Vars, Refs, Agents, and Atoms.

Vars provide a mechanism to refer to a mutable storage location that can be dynamically rebound (to a new storage location) on a per-thread basis.

The special form `def` creates and (interns) a Var.

```clj
user=> (def x)
#'user/x
user=> x
#object[clojure.lang.Var$Unbound 0x5d05ef57 "Unbound: #'user/x"]
```

Supplying an initial value binds the root (even if it was already bound).

```clj
user=> (def x 1)
#'user/x
user=> x
1
```

By default Vars are static, but Vars can be marked as dynamic to allow per-thread binginds via the macro `binding`. Within each thread they obey a stack discipline:

```clj
user=> (def ^:dynamic x 1)
user=> (def ^:dynamic y 1)
user=> (+ x y)
2
user=> (binding [x 2 y 3] (+ x y))
5
user=> (+ x y)
2
```

Bindings created with `binding` cannot be seen by any other thread. Likewise, binding created with `binding` can be assigned to, which provides a means for a nested context to communicate with code before it on the call stack. This capability is opt-in only by setting a metadata tag: `^:dynamic` to true as in the code clock above.

Functions defined with `defn` are stored in Vars, allowing for the redefinition of functions in a running program. This also enables many of the possibilities of aspect- or context-oriented programming. For instance, you could wrap a function with logging behavior only in certain call contexts or threads.
