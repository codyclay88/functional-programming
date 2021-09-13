# Transactions

Transactions should not have side effects, because Clojure may retry a transaction an arbitrary number of times. However, sometimes you _want_ a side effect when a transaction succeeds. Agents provide a solution. If you send an action to an agent from within a transaction, that action is send exactly once, if and only if the transaction succeeds.

As an exammple of where this would be useful, consider an agent that writes to a file when a transaction succeeds. You could combine such an agent with the chat example from the "commute" notes, to automatically back up chat messages. First, create a `backup-agent` that stores the `filename` to write to:

```clj
(def backup-agent (agent "output/messages-backup.clj"))
```

Then, create a modified version of `add-message`. The new function `add-message-with-backup` should do two additional things:

- Grab the return value of `commute`, which is the current database of messages, in a `let` binding.
- While still in a transaction, `send` an action to the backup agent that writes the message database to `filename`. For simplicity, have the action function return `file-name` so that the agent uses the same filename for the next backup.

```clj
(defn add-message-with-backup [msg]
    (dosync
        (let [snapshot (commute messages conj msg)]
            (send-off backup-agent (fn [filename]
                (spit filename snapshot)
                filename))
            snapshot)))
```

The new function has one other critical difference: it calls `send-off` instead of `send` to communicate with the agent. `send-off` is a variant of `send` for actions that expect to block, as a file write might do. `send-off` actions get their own expandable thread pool. Never `send` a blocking function, or you may unnecessarily prevent other agents from making progress.

```clj
(add-message)
```
