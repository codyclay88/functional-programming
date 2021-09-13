# Records

Records in Clojure are simple abstractions on top of maps.
This means that all of the sequence functions that can be used
with maps can also be used with records.

```clj
(defrecord Person [first-name last-name])

;; `->Person` is a constructor function for initializing `Person` records
(def me (->Person "Cody" "Clay"))
; -> #user.Person{:first-name "Cody", :last-name "Clay"}

(:first-name me)
; -> "Cody"

(get me :first-name)
; -> "Cody"
```
