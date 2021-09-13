# Flow Control

Clojure has very few flow control forms. In this section, you'll me `if`, `do`, and `loop/recur`.

As it turns out, this is almost all you'll ever need. Clojure provides a library of additional forms, but they're largely built from these primitives.

## Branch with `if`

Clojure's `if` evaluates it's first argument. If the argument is logically true, it returns the result of evaluating it's second argument:

```clj
(defn is-small? [number]
    (if (< number 100) "yes"))

(is-small? 50)
; -> "yes"

(is-small? 5000)
; -> nil
```

```clj
(defn is-small? [number]
    (if (< number 100) "yes" "no"))

(is-small? 1000)
; -> "no"
(is-small? 10)
; -> "yes"
```

The `when` and `when-not` control flow macros are built on top of `if`.

## Introduce side effects with `do`

Clojure's `if` allows only one form for each branch. What if you want to do more than one thing on a branch?

For example, you might want to log that a certain branch was chosen. `do` takes any number of forms, evaluates them all, and returns the last.

```clj
(defn is-small? [number]
    (if (< number 100)
        "yes"
        (do
            (println "Saw a big number" number)
            "no")))

(is-small? 1000)
; "Saw a big number 1000"
; -> "no"
```

In this sample above, the `else` branch of the `if` form provided two expressions, the first was a call to `println` and the second was the string `"no"`.

The call to `println` is an example of a side effect. The `println` doesn't contribute to the return value of `is-small?` at all. Instead, it reaches into the world outside the function and actually does something.

Many programming languages mix pure functions and side effects in a completely ad hoc fashion, but this is not the case with Clojure. In Clojure, side effects are explicit and unusual. `do` is one way to say "side effects to follow." Since `do` ignores the return value of all its forms exception the last, those forms must have side effects to be of any use at all.

## Recur with `loop`/`recur`

The Swiss army knife of flow control in Clojure is `loop`: `(loop [bindings*] exprs*)`.

The `loop` special form works like `let`, establishing `bindings` and then evaluating `exprs`. The difference is that `loop` sets a recursion point, which can then be targeted by the `recur` special form: `(recur exprs*)`.

`recur` binds new values for `loop`s bindings and returns control to the top of the loop. For example, the following `loop`/`recur` returns a countdown:

```clj
;; define a loop expression, binding the `result` var to `[]` and the `x` var to `5`.
(loop [result [] x 5]
    ;; start an `if` expression that determines whether the number is zero
    (if (zero? x)
        ;; if the number is zero, return the result
        result
        ;; if the number is not zero, restart the loop with the updated bindings,
        ;;  setting `result` equal to the current `result` with the value of `x` appended,
        ;;  and `x` to the current value of `x` - 1.
        (recur (conj result x) (dec x))))
; -> [5 4 3 2 1]
```

```clj
;; start a loop expression, binding the var `current` to the value `10`
(loop [current 10]
    ;; if the value of `current` is less than or equal to `0`
    (if (<= current 0)
      (println "I'm all done")
      (do
        (println "I'm going to print" current "more times")
        ;; restart the loop, rebinding `current` to the value of `current` minus 1
        (recur (dec current)))))
```

Instead of using a `loop`, you can `recur` back to the top of a function. This makes it simple to write a function whose entire body acts as an implicit loop:

```clj
(defn countdown [result x]
    (if (zero? x)
        result
        (recur (conj result x) (dec x))))
```

`recur` is a powerful building block. But you may not use it very often, because many common recursions are provided by Clojure's sequence library.

For example, countdown could be expressed as any of these:

```clj
(into [] (take 5 (iterate dec 5)))

(into [] (drop-last (reverse (range 6))))

(vec (reverse (rest (range 6))))
```

Clojure will not perform automatic tail-call optimization, however it will optimize calls to `recur`.

## Where's my for loop?

Clojure has no `for` loop and no direct mutable variables. Clojure provides indirect mutable references, but these must be explicitly called out in your code. So how do we write all that code we're acccustomed to writing with `for` loops?
