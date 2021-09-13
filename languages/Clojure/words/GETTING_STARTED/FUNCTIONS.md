# Functions

To define your own functions, use `defn`

```clj
(defn name doc-string? attr-map [params*] prepost-map? body)
```

The `name` is a symbol naming the function (implicitly defined within the current namespace).

The `doc-string` is an optional string describing the function.

The `attr-map` associates metadata with the function's var.

The `prepost-map?` can be used to define preconditions and postconditions that are automatically checked on invocation.

The `body` contains any number of expressions. The result of the final expression is the return value of the function.

```clj
(defn greeting
  "Returns a greeting of the form 'Hello, username.'"
  [username]
  (str "Hello, " username))

(greeting "world")
; -> "Hello, world"

(doc greeting)
; -> Returns a greeting of the form 'Hello, username.'
```

You can provide multiple "versions" of a function with different arities as follows:

```clj
(defn greeting
    "Returns a greeting of the form, 'Hello, username'. Default username is 'world'."
    ([] (greeting "world"))
    ([username] (str "Hello, " username)))

(greeting)
; -> "Hello, world"
```

You can create a function with variable arity by including an ampersand in the parameter list. Clojure binds the name after the ampersand to a sequence of all the remaining parameters. There may only be one variable arity parameter, and it must be last in the parameter list.

The following function allows two people to go on a date with a variable number of chaperones:

```clj
(defn date [person-1 person-2 & chaperones]
    (println person-1 " and " person-2
        " went out with " (count characters) "chaperones."))

(date "Romeo" "Juliet" "Friar Lawrence" "Nurse")
; -> Romeo and Juliet went out with 2 chaperones.
```

`defn` is intended for defining functions at the top level. If you want to create a function from within another function, you should use an anonymous function form instead.

## Anonymous functions with `fn`

In addition to named functions with `defn` you can also create anonymous functions with `fn`. At least three reasons exist to create an anonymous function:

1. The function is so brief and self-explanatory that giving it a name makes the code harder to read, not easier.
2. The function is being used only from inside another function and needs a local name, not a top-level binding.
3. The function is created inside another function for the purpose of capturing the values of parameters or local bindings.

```clj
(require '[cloure.string :as str])

;; the following two forms are equivalent:
;; the first uses an anonymous function
;; the second uses a reader macro syntax for anonymous functions using implicit parameter names.

(filter (fn [w] (> (count w) 2)) (str/split "A fine day" #"\W+"))
; -> ("fine" "day")

(filter #(> (count %) 2) (str/split "A fine day" #"\W+"))
; -> ("fine" "day")
```

```clj
;; This function makes other functions
(defn make-greeter [greeting-prefix]
    (fn [username] (str greeting-prefix ", " username)))

;; These functions are made from the above function
(def hello-greeter (make-greeter "Hello"))
(def mean-greeter (make-greeter "Shut up"))

(hello-greeter "Cody")
; -> "Hello, Cody"

(mean-greeter "Cody")
; -> "Shut up, Cody"

((make-greeter "Hello") "pardner")
; -> "Hello, pardner"
```
