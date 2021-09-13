# Atoms

## Use Atoms for Uncoordinated, Synchronous Updates

Atoms are a lighter-weight mechanism than refs. Where multiple ref updates can be coordinated in a transaction, atoms allow updates of a single value, uncoordinated with anything else.

You can create atoms with `atom`, which has a signature similar to `ref`: `(atom initial-state options?)` where `options` include `:validator validate-fn` and `:meta metadata-map`.

Returning to our music player example, you could store the `current-track` in an atom instead of a ref:

```clj
(def current-track (atom "Venus, the Bringer of Peace"))
```

You can dereference an atom to get its value, just as you would a ref.

Atoms don't participate in transactions and thus do not require a `dosync`. To set the value of an atom, just call `reset!`: `(reset! an-atom new-value)`.

For example, you can set the `current-track` to `"Credo"`:

```clj
(reset! current-track "Credo")
; -> "Credo"
```

What if you want to coordinate an update of both `current-track` and `current-composer` with an atom? The short answer is, "You can't." That's the difference between refs and atoms. If you need coordinated access, use a ref.

The longer answer is, "You can... if you're willing to change the way you model the problem." What if you store the track and composer in a map and then store the whole map in a single atom?

```clj
(def current-track (atom {:title "Credo" :composer "Byrd"}))
```

Now you can update both values in a single `reset!`

```clj
(reset! current-track {:title "Spem in Alium" :composer "Tallis"})
; -> {:title "Spem in Alium" :composer "Tallis"}
```

Maybe you like to listen to several tracks in a row by the same composer. If so, you want to change the track title but keep the same composer. `swap!` will do the trick: `(swap! an-atom f & args)`.

`swap!` updates `an-atom` by calling function `f` on the current value of `an-atom`, plus any additional `args`.

To change the track title, use `swap!` with `assoc` to update only the `:title`:

```clj
(swap! current-track assoc :title "Sancte Deus")
; -> {:title "Sancte Deus" :composer "Tallis"}
```

`swap!` returns the new value. Calls to `swap!` might be retried, if other threads are attempting to modify the same atom. So, the function you pass to `swap!` should have no side effects.

Both refs and atoms perform synchronous updates. When the update function returns, the value is already changed. If you don't need this level of control and can tolerate updates happening asynchronously at some later time, prefer an agent.
