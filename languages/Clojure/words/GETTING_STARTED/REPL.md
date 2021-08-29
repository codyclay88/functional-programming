# Getting Started

## Clojure REPL

You can start a clojure REPL session by typing `clj` at a terminal.

```clj
user=> (defn square [x] (* x x))
#'user/square
user=> (square 3)
9
```

## Using Leiningen

You can start a REPL using Leiningen with the command `lein repl`.

```zsh
% lein repl
OpenJDK 64-Bit Server VM warning: Options -Xverify:none and -noverify were deprecated in JDK 13 and will likely be removed in a future release.
nREPL server started on port 57310 on host 127.0.0.1 - nrepl://127.0.0.1:57310
REPL-y 0.4.4, nREPL 0.8.3
Clojure 1.10.1
OpenJDK 64-Bit Server VM 16.0.2+0
    Docs: (doc function-name-here)
          (find-doc "part-of-name-here")
  Source: (source function-name-here)
 Javadoc: (javadoc java-object-or-class-here)
    Exit: Control+D or (exit) or (quit)
 Results: Stored in vars *1, *2, *3, an exception in *e

my-stuff.core=> (-main)
I'm a little teapot!
nil
```

As you can see from the output of the command, using leiningen with the REPL "imports" the current project into the REPL. In this case the namespace is `my-stuff.core`. This means we can run any functions that exist in that namespace, such as `(-main)`.
