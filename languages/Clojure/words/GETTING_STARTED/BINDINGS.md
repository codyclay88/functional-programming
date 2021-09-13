# Bindings

Vars are bound to names, but there are other kinds of bindings as well. For example, in a function call, argument values bind to parameter names. In the following call, the name `number` is locally bound to the value `10` inside the `triple` function:

```clj
(defn triple [number] (* 3 number))

(triple 10)
; -> 30
```

A function's parameter bindings have a lexical scope: they're only visible inside the text of the function body. Functions are not the only way to create a lexical binding. The special form `let` does nothing other than create a set of lexical bindings:

```clj
(let [bindings*] exprs*)
```

The `bindings` are then in effect for `exprs`, and the value of the `let` is the value of the last expression in `exprs`.

Imagine that you want coordinates for the four corners of a square, given the `bottom`, `left`, and `size`. You can `let` the `top` and `right` coordinates, based on the values given:

```clj
(defn square-corners [bottom left size]
    (let [top (+ bottom size)
          right (+ left size)]
        [[bottom left] [top left] [top right] [bottom right]]))

(square-corners  10 20 30)
; -> [[10 20] [40 20] [40 50] [10 50]]
```

The `let` binding binds `top` and `right`. This saves you the trouble of calculating `top` and `right` more than once (Both are needed twice to generate the return value). The `let` then returns its last form, which in this example becomes the return value of `square-corners`.

## Destructuring

In many programming languages, you bind a variable to an entire collection when you need to access only a part of the collection.

Imagine that you are working on a database of book authors. You track both first and last names, but some functions need to use only the first name:

```clj
(defn greet-author-1 [author]
    (println "Hello, " (:first-name author)))

(greet-author-1 {:last-name "Vinge" :first-name "Vernor"})
; "Hello, Vernor
```

This works just fine, but having to bind to author feels unsatisfying. You don't need the author; all you need is the `first-name`. Clojure solves this with `destructuring`. Any place that you bind names, you can nest a vector or a map in the binding to reach into a collection and bind only the part you want.

```clj
(defn greet-author-2 [{fname :first-name}]
    (println "Hello," fname))

(greet-author-2 {:first-name "Cody" :last-name "Clay"})
; Hello, Cody
```

The binding form `{fname :first-name}` tells Clojure to bind `fname` to the `:first-name` of the function argument.

Just as you can use a map to destructure any associative collection, you can use a vector to destructure a sequential collection. For example, you could bind only the first two coordinates in a three-dimensional coordinate space:

```clj
(let [[x y] [1 2 3]]
    [x y])
; -> [1 2]
```

The expression `[x y]` destructures the vector `[1 2 3]`, binding `x` to `1` and `y` to `2`. Since no symbol lines up with the final element `3`, it's not bound to anything.

It's also possible to simultaneously bind both a collection and elements within the collection. Inside a destructuring expression, an `:as` clause gives you a binding for the entire enclosing structure. For example, you could capture the `x` and `y` coordinates individually, plus the entire collection as `coords`, to report the total number of dimensions:

```clj
(let [[x y :as coords] [1 2 3 4 5 6]]
    (str "x: " x ", y:" y ", total dimensions " (count coords)))
```
