# Vars

When you define an object with `def` or `defn`, that object is stored in a Clojure var. For example, the following `def` creates a var named `user/foo`:

```clj
(def foo 10)
; -> #'user/foo
```

In this case, the symbol `user/foo` refers to a var that is bound to the value `10`.

The initial value of a var is its _root binding_.

You can refer to a var directly. The `var` special form returns a var itself, not the var's value:

```clj
(var some-symbol)
```

You can use `var` to return the var bound to `user/foo`:

```clj
(var foo)
; -> #'user/foo
```

You will almost never see the `var` form directly in Clojure code. Instead, you'll see the equivalent reader macro `#`, which returns the var or a symbol.

```clj
#'foo
; -> #'user/foo
```

When would you want to refer to a var directly? Most of the time, you won't, and you can often simply ignore the distinction between vars and symbols. But keep it in the back of your mind that vars have may abilities other than just storing a value:

- the same var can be aliased in more than one namespace, which allows you to use convenient short names.
- Vars can have metadata. Var metadata includes documentation, type hints for optimizations, and unit tests.
- Vars can be dynamically rebound on a per-thread basis
