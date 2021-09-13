# Agents

## Use Agents for Asynchronous Updates

Some applications have tasks that can proceed independently with minimal coordination between tasks. Clojure _agents_ support this style of task.

Agents have much in common with refs. Like refs, you create an agent by wrapping some piece of initial state: `(agent initial-state)`

Create a `counter` agent that wraps an initial count of zero:

```clj
(def counter (agent 0))
; -> #'user/counter
```

Once you have an agent, you can `send` the agent a function to update its state. `send` queues an `update-fn` to run later, on a thread in a thread pool: `(send agent update-fn & args)`

Sending to an agent is much like commuting a ref. Tell the `counter` to `inc`:

```clj
(send counter inc)
; -> #object[clojure.lang.Agent 0x373f7450 {:status :ready, :val 1}]
```

Notice that the call to `send` doesn't return the new value of the agent, returning instead the agent itself. That's because `send` _does not know_ the new value. After `send` queues the `inc` to run later, it returns immediately.

Although `send` does not know the new value of an agent, the REPL _might_ know. Depending on whether the agent thread or the REPL thread runs first, you might see a `1` or a `0` for the `:val` in the previous output.

You can check the current value of an agent with `deref`/`@`, just as you would a ref. By the time you get around to checking the `counter`, the `inc` will almost certainly have completed on the thread pool, raising the value to 1.

If the race condition between the REPL and the agent thread bothers you, there is a solution. If you want to be sure that the agent has completed the actions _you sent_ to it, you can call `await` or `await-for`: `(await & agents)`, `(await-for timeout-millis & agents)`.

These functions cause the current thread to block until all actions sent from the current thread or agent have completed. `await-for` returns `nil` if the timeout expires and returns a non-`nil` value otherwise. `await` has no timeout, so be careful: `await` is willing to wait forever.

## Validating Agents and Handling Errors

Agents have other points in common with refs. They also can take a validation function:

```clj
(agent initial-state options*)
; options include
;   :validator validate-fn
;   :meta metadata-map
;   :error-handler handler-fn
;   :error-mode mode-keyword (:continue or :fail)
```

Recreate the `counter` with a validator that ensures it's a number:

```clj
(def counter (agent 0 :validator number?))
```

Try to set the agent to a value that's not a number by passing an update function that ignores the current value and simply returns a string:

```clj
(send counter (fn [_] "boo"))
; -> #object[clojure.lang.Agent 0x373f7450 {:status :ready, :val 0}]
```

Everything looks fine (so far) because `send` still returns immediately. When the agent tries to update itself on a pooled thread, it encounters an exception while applying the action. Agents have two possible error modes -- `:fail` and `:continue`. If no `:error-handler` is supplied when the agent is created, the error mode is set to `:fail`, and any exception that occurs during an action or during validation puts the agent into an exceptional state.

When an agent is in this failed state, it can still be dereferenced and will return the last value from before the failed action. To discover the last error on an agent, call `agent-error` which returns either the failure or nil if not in a failed state:

```clj
(agent-error counter)
;; #error {
;;     :cause ​"Invalid reference state"​ ​
;;     :via [{:type java.lang.IllegalStateException ​
;;         :message ​"Invalid reference state"​ ​
;;         :at [clojure.lang.ARef validate ​"ARef.java"​ 33]}] ​
;;         :trace ​
;;             [[clojure.lang.ARef validate ​"ARef.java"​ 33] ​
;;             ... ]}]}
```

All new actions are queued until the agent is restarted using `restart-agent`. Once an agent has errors, all subsequent attempts to query the agent return an error. You can make the agent active again by calling `restart-agent`:

```clj
(restart-agent counter 0)
; -> nil

@counter
; -> 0
```

If an `:error-handler` is supplied when the agent is created, the agent will instead be in error mode `:continue`. When an error occurs, the error handler is invoked and the agent then continues as if no error occurred.

```clj
(defn handler [agent err]
    (println "ERR!" (.getMessage err)))

(def counter2 (agent 0 :validator number? :error-handler handler))

(send counter2 (fn [_] "boo"))
; ERR! Invalid reference state

(send counter2 inc)

@counter2
; -> 1
```
