# Intro

Programs manipulate data. At the lowest level, programs work with structures such as strings, lists, vectors, maps, sets, and trees. At a higher level, these same data structure abstractions crop up again and again. For example:

- XML data is a tree
- Database result sets can be viewed as lists or vectors
- Directory hierarchies are trees
- Files are often viewed as one big string or as a vector of lines.

In Clojure, all these data structures can be accessed through a single abstraction: the sequence (or seq).

A seq (pronounced "seek") is a logical list. It's logical because Clojure does not tie sequences to the concrete implementation details of the list data structure. Instead, the seq is an abstraction that can be used everywhere.

Collections that can be viewed as seqs are called _seq-able_ (pronounced "SEEK-a-bull"). In this chapter, you'll meet a variety of seq-able collections:

- All Clojure collections
- All Java collections
- Java arrays and strings
- Regular expression matches
- Directory structures
- I/O streams
- XML trees

You'll also meet the sequence library, a set of functions that work with any seq-able. Because so many things are sequences, the sequence library is much more powerful and general than the collection API in most languages. The sequence library includes functions to create, filter, and transform data. These functions act as the collection API for Clojure, and they also replace many of the loops you would write in an imperative language.

## Everything is a Sequence

Every aggregate data structure in Clojure can be viewed as a sequence. A sequence has three core capabilities:

- You can get the `first` item in a sequence: `(first aseq)`. which returns `nil` if its argument is empty or `nil`
- You can get everything after the first item -- the `rest` of a sequence: `(rest aseq)`, which returns an empty set (not `nil`) if there are no more items.
- You can construct a new sequence by adding an item to the front of an existing sequence. This is called `cons`ing: `(cons elem aseq)`

Under the hood, these three capabilities are declared in the Java interface `clojure.lang.ISeq`.

The `seq` function will return a seq on any seq-able collection: `(seq coll)`.

`seq` will return nil if its `coll` is empty or `nil`. The `next` function will return the `seq` of items after the first `(next aseq)`, which is equivalent to `(seq (rest aseq))`.

When you apply `rest` or `cons` to a vector, the result is a seq, not a vector. In the REPL, seqs print just like lists, as you can see in the earlier output. You can check the actual returned type using using the `seq?` predicate.

You can treat maps as `seqs`, if you think of a map as a sequence of map entries (where each entry is a key/value pair).

```clj
(first {:first-name "Cody" :last-name "Clay"})
; [:first-name "Cody"]
```

Here is an example of using a `loop` form to iterate through the elements in a map, printing them to the console, using `first` and `rest`.

```clj
(loop [me {:first-name "Kristian" :middle-name "Cody" :last-name "Clay"}]
    (let [item (first me)]
        (if (= item nil)
            (println "That's all folks!")
            (do
                (println (item 0) "=" (item 1))
                (recur (rest me))))))
```

Maps and sets have a stable traversal order, but that order depends on implementation details, and you shouldn't rely on it. Elements of a set will not necessarily come back in the order that you put them in:

```clj
#{:the :quick :brown :fox}
; -> #{:fox :the :quick :brown}
```

If you want a reliable order, you can use this: `(sorted-set & elements)`, which will sort the set in natural order.

```clj
(sorted-set :the :quick :brown :fox)
; -> #{:brown :fox :quick :the}
```

Likewise, key/value pairs in maps won't necessarily come back in the order that you put them in, but you can create a sorted map with `sorted-map`: `(sorted-map & elements)`, which will come back sorted by key:

```clj
(sorted-map :a 1 :x 2 :c 4)
; -> {:a 1, :c 4, :x 2}
```

In addition to the core capabilities of seq, two other capabilities are worth meeting immediately: `conj` and `into`.

```clj
(conj coll element & elements)
(into to-coll from-coll)
```

`conj` adds one or more elements to a collection, and `into` adds all the items in one collection to another. Both `conj` and `into` add items at an efficient insertion spot for the underlying data structure. For lists, `conj` and `into` add to the front. For vectors, `conj` and `into` add to the back.
