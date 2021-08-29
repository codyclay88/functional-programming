# What is a Form?

All Clojure code is written in a uniform structure. Clojure recognizes two kinds of structures:

- Literal representations of data structures (like numbers, strings, maps, and vectors)
- Operations

The term `form` refers to valid code. Clojure evaluates every form to produce a value. These literal representations are all valid forms:

```clj
1
"a string"
["a" "vector" "of" "strings"]
```

Your code will rarely contain free-floating literals, of course, because they don't actually do anything on their own. Instead, you'll use literals in operations. Operations are how you do things. All operations take the following form: `open paren, operator, operands, closing paren`, for example:

```clj
(operator operand1 operand2 ... operandn)
```

Notice there are no commas. Clojure uses whitespace to separate operands, and it treats commas as whitespace. Here are some examples:

```clj
(+ 1 2 3)
(str "It was the panda " "in the library " "with a dust buster")
```

In the first operation, the operator `+` adds the operands `1`, `2`, and `3`. In the second operation, `str` concatenates three strings to form a new string.

## Control Flow

There are three basic control flow operators: `if`, `do`, and `when`.

```clj
(if boolean-form
    then-form
    optional-else-form)
```

A boolean form is just a form that evaluates to a truthy or falsy value.

```clj
(if true
    "By Zeus's hammer!"
    "By Aquaman's trident!")
```

The above expression will always return `By Zeus's hammer!`. You can also omit the `else` branch.

```clj
(if false
    "By Odin's Elbow!")
```

The above expression will always return `nil`, because the `false` will always be _falsy_.

The `do` operator lets you wrap up multiple forms in parentheses and run each of them.

```clj
(if true
    (do (println "Success!")
        "By Zeus's hammer!")
    (do (println "Failure!")
        "By Aquaman's trident!"))
```

As you can see, the `do` operator lets you do multiple things in each of the `if` expression's branches. In this case, two things happen: `Success!` is printed, and `By Zeus's hammer!` is returned as the value of the entire `if` expression.

The `when` operator is like a combination of `if` and `do`, but with no `else` branch.

```clj
(when true
    (println "Success!")
    "abra cadabra")
```

Clojure's equality operator is `=`:

```clj
(= 1 1)
; => true

(= nil nil)
; => true

(= 1 2)
; => false
```

You can use `def` to bind a name to a value:

```clj
(def failed-protagonist-names
    ["Larry Potter" "Doreen the Explorer" "The Incredible Bulk"])

failed-protagonist-names
; => ["Larry Potter" "Doreen the Explorer" "The Incredible Bulk"]
```

The term `bind` is used rather than `assign`, and this is intentional
