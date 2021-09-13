# Examples

## `refs` and `records`

### `ref`, `defrecord`, `dosync`, `alter`

```clj
(def students (ref []))
; -> #'user/students

(defrecord Student [name grade])
; -> user.Student

;; `dosync` causes the update to `students` to take place
;; inside a transaction.
(dosync
    (alter students conj (->Student "Owen Clay" "Kindergarten")))
; -> [#user.Student{:name "Owen Clay", :grade "Kindergarten"}]

(get @students 0)
; -> user.Student{:name "Owen Clay", :grade "Kindergarten"}
```

## Changing a ref does not change the underlying object, instead points to a new object.

### `dosync`, `ref-set`

```clj
;; define a basic map and bind it to the var `something`
(def something {:name "Cody"})

;; Create a reference to `something` and bind it to the var `someref`.
(def someref (ref {:name "Cody"}))
; -> #'user/someref

;; Update the reference to `someref` to a new value
(dosync
    (ref-set someref {:name "Kristian"}))
; -> {:name "Kristian"}

;; the value of `something` did not change
something
; -> {:name "Cody"}

;; `someref` now points to a different value
@someref
; -> {:name "Kristian"}
```
