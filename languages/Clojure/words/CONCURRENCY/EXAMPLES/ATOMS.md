# `atom` examples

## `swap!` example

```clj
(def visitors (atom #{}))
; -> #object[clojure.lang.Atom 0x35cd68d4 {:status :ready, :val #{}}]

;; swap! applies an `update-fn` to the reference, with optional args if necessary.
;; ?? Why does this not need a transaction ??
(swap! visitors conj "Stu")
; -> #{"Stu"}

visitors
; -> #object[clojure.lang.Atom 0x61af1510 {:status :ready, :val #{"Stu"}}]

;; dereference an atom by prefixing the name with "@"
@visitors
; -> #{"Stu"}

;; the `deref` function is a longer way to do the same thing as "@"
(deref visitors)
; -> #{"Stu"}

;; This function uses the visitors atom
(defn hello
    "Writes hello mesage to *out*. Calls you by username. Knows if you have been here before."
    [username]
    (swap! visitors conj username)
    (str "Hello, " username))
; -> #'user/hello

(hello "Cody")
; -> "Hello, Cody"

;; "Cody" was added to the set of visitors
@visitors
; -> #{"Stu" "Cody"}
```
