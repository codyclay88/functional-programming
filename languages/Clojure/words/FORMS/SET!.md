# `set!`

Assignment special form.

When the first operand is a symbol, it must resolve to a global var. The value of the var's current thread binding is set to the value of expr.

Currently, it is an error to attempt to et the root binding of a var using `set!`, i.e. var assignments are thread-local. In all cases the value of expr is returned.
