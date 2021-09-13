# Namespaces

In Clojure, a namespace is a collection of names (symbols) that refer to vars.

Root bindings live in a namespace.

In the REPL, by default you will be operating in the `user` namespace. You can treat the `user` namespace as a sort of scratch namespace for exploratory development.

You can switch namespaces, creating a new one if needed, with `in-ns`:

```clj
user=> (in-ns 'myapp)
; -> #object[clojure.lang.Namespace 0x7063686f "myapp"]
myapp=>
```

As the prompt indicates after calling `in-ns`, your REPL is now in the `myapp` namespace, and anything that you `def` or `defn` will belong to `myapp`.

When you create a new namespace with `in-ns`, the `java.lang` package is automatically available to you, but you will need to `use` the `clojure.core` namespace whenever you move to a new namespace, making Clojure's core functions available in the new namespace as well.

```clj
user=> (in-ns 'myapp)
; -> #object[clojure.lang.Namespace 0x7063686f "myapp"]
myapp=> (map #(* % 2) [1 2 3 4])
; -> Syntax error compiling at (REPL:1:1).
; -> Unable to resolve symbol: map in this context
myapp=> (clojure.core/use 'clojure.core)
; -> nil
myapp=> (map #(* % 2) [1 2 3 4])
; -> (2 4 6 8)
```

As you can see from the console output, if we move to a new namespace and try to use a function from the `clojure.core` namespace, the REPL will not be able to resolve functions like `map`.

When working with Java packages, you can import individual classes from a package into the current namespace with the `import` function.

```clj
(import '(java.io InputStream File))
; -> java.io.File
(.exists (File. "/tmp"))
; -> true
```

`import` is only for Java classes. To use a Clojure var from another namespace without the namespace qualified, you must refer the external vars into the current namespace. For example, take Clojure's `split` function that resides in the `clojure.string` namespace:

```clj
(require 'clojure.string)
(split "Something,separated,by,commas" #",")
; Syntax error compiling at (REPL:1:1).
; Unable to resolve symbol: split in this context

;; using the fully qualified namespace
(clojure.string/split "something,separated,by,commas" #",")
; -> ["something" "separated" "by" "commas"]

;; aliasing the fully qualified name
(require '[clojure.string :as str])
(str/split "something,separated,by,commas" #",")
; -> ["something" "separated" "by" "commas"]
```

This simple form of `require` causes the current namespace to reference all public vars in `clojure.string` via the alias `str`.

## The `ns` macro

```clj
(ns name & references)
```

The `ns` macro sets the current namespace (available as `*ns*`) to `name`, creating the namespace if necessary. The `references` can include `:import`, `:require`, and `:use`, which work like the similarly named functions to set up the namespace mappings in a single form at the top of a source file.

```clj
(ns examples.exploring
    (:require [clojure.string :as str])
    (:import (java.io File)))
```

The namespace functions can do quite a bit more than what we've shown here.

You can examine namespaces and add or remove mappings at any time. To find out more, issue this command at the REPL. Since we've moved around a bit in the REPL, we'll also ensure that we're in the user namespace so that our REPL utilities are available to us.

```clj
(in-ns 'user)
(find-doc "ns-")
```

Vars can be interned in a namespace, using `def` or any of its variants, in which case they have a simple symbol for a name and a reference to their containing namespace, and the namespace maps that symbol to the same var.

A namespace can also contain mappings from vars interned in other namespaces by using `refer` or `use`, or symbols to Class objects by using `import`.

Note that namespaces are first-class, they can be enumerated, etc.

Namespaces are also dynamic, they can be created, removed, and modified at runtime, at the REPL, etc.

The best way to set up a new namespace at the top of a Clojure source file is to use the `ns` macro. By default this will create a new namespace that contains mappings for the classnames in `java.lang` plus `clojure.lang.Compiler` and the functions in `clojure.core`.

## Interning

The Namespace system maintains global maps of symbols to Var objects.

If a `def` expression does not find an interned entry in the current namespace for the symbol being `def`ed, it creates on, otherwise it uses the existing Var. This "find-or-create" process is called interning. This means that, unless they have been unmap-ed, Var objects are stable references and need not be looked up every time. It also means that namespaces constitute a global environment in which the compiler attempts to resolve all free symbols as Vars.
