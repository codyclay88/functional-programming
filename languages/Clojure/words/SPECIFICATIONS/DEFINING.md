# Defining Specs

Specs are logical compositions of predicates (functions returning a logical true/false value) used to describe a set of data values. The spec library provides operations to create, combine, and register specs.

To work with specs, you'll need to load the namespace `clojure.spec.alpha`, which is commonly aliased to `s`:

```clj
(require '[clojure.spec.alpha :as s])
```

The `s/def` macro names and registers a spec in the global registry of specs accessible in the current Clojure program. The syntax for `s/def` is:

```clj
(s/def name spec)
```

Spec names are qualified keywords. For example, a simple spec definition using a predicate spec looks like:

```clj
(s/def :my.app/company-name string?)
```

At runtime, specs are read and evaluated like function definitions. The global spec registry stores the spec, keyed by name.

Spec names must be fully qualified keywords. As a Clojure developer, it's your responsibility to use sufficiently qualified keywords as names so that your code will work with other code in the greater ecosystem.
