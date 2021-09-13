# Refs and Software Transactional Memory

Most objects in Clojure are immutable. When you really want mutable data, you must be explicit about it, such as by creating a mutable reference (ref) to an immutable object. You can create a ref with this: `(ref initial-state)`.

########
REFLECT ON THIS: "creating a mutable reference to an immutable object."
A _reference_ (as a software construct) is mutable, not the objects that the _reference_ points to. To model change, a reference points to a new "version" of what was being pointed to, rather than changing the object being pointed to. This means that the original object being pointed to is
not modified when a ref is updated.
########

For example, you could create a reference to the current song in your music playlist:

```clj
(def current-track (ref "Mars, the Bringer of War"))
; -> #'user/current-track
```

The ref wraps and protects access to its internal state. To read the contents of the reference, you can call `deref`: `(deref reference)`

The `deref` function can be shortened to the `@` reader macro.

```clj
(deref current-track)
; -> "Mars, the Bringer of War"

@current-track
; -> "Mars, the Bringer of War"
```

Notice how in this example the Clojure model fits the real world. A track is an immutable entity. It doesn't change into another track when you're finished listening to it. But the current track is a reference to an entity, and it does change.

## Transaction Properties

STM allows programmers to describe reads and writes to stateful references in the scope of a transaction, which guarantees some important properties:

- Updates are atomic. If you update more than one ref in a transaction, the cumulative effect of all the updates will appear as a single instantaneous event to anyone not inside your transaction.
- Updates are consistent. Refs can specify validation functions. If any of these functions fail, the entire transaction will fail.
- Updates are isolated. Running transactions can't see partially completed results from other transactions.

If you change more than one ref in a single transaction, the changes are all coordinated to "happen at the same time" from the perspective of any code outside the transaction. So, you can make sure that updates to `current-track` and `current-composer` are coordinated:

```clj
(def current-track (ref "Venus, the Bringer of Peace"))
(def current-composer (ref "Holst"))

(dosync
    (ref-set current-track "Credo")
    (ref-set current-composer "Byrd"))

@current-track
; -> "Credo
@current-composer
; -> "Byrd"
```

Because the updates are in a transaction, no other thread will ever see an updated track with an out of date composer, or vice versa.

## Adding Validation to Refs

Database transactions maintain consistency through various integrity checks. You can do something similar with Clojure's transactional memory, by specifying a validation function when you create a ref: `(ref initial-state options*)`

The options to `ref` include an optional validation function that can throw an exception to _prevent a transaction from completing_. Not that `options` is _not_ a map; it's a sequence of key/value pairs spliced into the function call.

```clj
;; helper function, returns `nil` if either of the conditions evaluates to a `falsy` value.
(defn valid-message? [msg]
    (and (:sender msg) (:text msg)))

;; validation function
(def validate-message-list #(every? valid-message? %))

;; using the validation function when creating the ref
(def messages (ref () :validator validate-message-list))

;; function to add a message to the ref
(defn add-message [msg]
    (dosync (alter messages conj msg)))

;; `add-message` will now throw an exception if the message being added is not valid.
(add-message "not a valid message")
; -> Execution error (IllegalStateException) at user/add-message (REPL:2).
; -> Invalid reference state
```

In the example above, now when we supply an invalid message to `add-message`, an exception is thrown, which prevents the transaction from committing.

Refs are great for coordinated access to shared state, but not all tasks require such coordination. _For updating a single piece of isolated data, prefer an atom._
