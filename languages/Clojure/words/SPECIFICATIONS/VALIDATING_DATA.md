# Validating data with spec

Any time you receive a value from a user or an external source, that data may contain values that break your expectations. Instead, Clojure specs precisely describe those expectations, check whether the data is valid, and determine how it conforms to the spec. In the case where data is invalid, you may want to know what parts are invalid and why.

Predicates are the simplest kind of spec -- they check whether a predicate matches a single value. Other specs compose predicates (and other specs) to create more complicated specs. Some of the tools are range specs, logical connectors like `and` and `or`, and collection specs. These specs combine to cover any data structure you need to describe.

## Predicates

Predicate functions that take a single value and return a logical true or false value are valid specs. Clojure provides dozens of predicates (many of these functions end in `?`); you can use any of those or ones in your own project. Some example predicates in clojure.core are functions like `boolean?`, `string?`, and `keyword?`. These predicates check for a single underlying type.

Other predicates combine several types together, such as `rational?`, which returns true for a value that is an integer, a decimal, or a ration. Many predicates verify a property of the value itself, like `pos?`, `zero?`, `empty?`, `any?`, and `some?`.

```clj
(s/def :my:app/company-name string?)
```

Consider a simple predicate spec for a company name:

```clj
(s/valid? :my-app/company-name "Acme Moving")
; -> true
(s/valid? :my.app/company-name 100)
; -> false
```
