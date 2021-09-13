# Metadata

The Wikipedia entry on metadata begins by saying that metadata is "data about data." That is true but not usably specific. In Clojure, metadata is data that is orthogonal to the logical value of an object. For example, a person's first or last names are plain old data. The fact that a person object can be serializable to XML has nothing to do with the person and is therefore metadata. Likewise, the fact that a person object is dirty and needs to be flushed to the database is metadata.

The Clojure language itself uses metadata in several places. For example, vars have a metadata map containing documentation, type information, and source information.

Much of the metadata on a var is added automatically by the compiler. To add your own key'value pairs to a var, use the metadata reader macro: `^metadata form`

For example, you could create a simple shout function that upcases a string and then document that `shout` both expects and returns a string, using the `:tag` key:

```clj
(defn ^{:tag String} shout [^{:tag String} s] (clojure.string/upper-case s))

; This is a shorter form of the same definition above:
(defn ^String shout [^String s] (clojure.string/upper-case s))

(pprint (meta #'shout))
;; {:tag java.lang.String,
;;  :arglists ([s]),
;;  :line 1,
;;  :column 1,
;;  :file "NO_SOURCE_PATH",
;;  :name shout,
;;  :ns #object[clojure.lang.Namespace 0x431f1eaf "user"]}
```

In this case, you provided the tag key, but Clojure provided the other keys. The `:file` value `NO_SOURCE_PATH` indicates that the code was entered at the REPL.

Because `:tag` metadata is so common, you can also use the short form `^Classname`, which examples to `^{:tag Classname}`.

Symbols and collections support metadata, a map of data about the symbol or collection.

The metadata system allows for arbitrary annotation of data. It is used to convey information to the compiler about types, but can also be used by application developers for many purposes, annotating data sources, policy, etc.

An important thing to understand about metadata is that it is not considered to be part of the value of the object. As such, metadata does not impact equality (or hash codes). Two objects that differ only in metadata are equal.

That said, metadata and its relationship to an object is immutable - an object with different metadata is a different object. One consequence of this is that applying metadata to a lazy sequence will realize the head of the sequence so that both objects can share the same sequence.

```clj

(pprint (meta #'+)) ;; #'+ is the `+` var

;; {:added "1.2",
;;  :ns #object[clojure.lang.Namespace 0x1a480135 "clojure.core"],
;;  :name +,
;;  :file "clojure/core.clj",
;;  :inline-arities
;;  #object[clojure.core$_GT_1_QMARK_ 0x7318daf8 "clojure.core$_GT_1_QMARK_@7318daf8"],
;;  :column 1,
;;  :line 986,
;;  :arglists ([] [x] [x y] [x y & more]),
;;  :doc
;;  "Returns the sum of nums. (+) returns 0. Does not auto-promote\n  longs, will throw on overflow. See also: +'",
;;  :inline
;;  #object[clojure.core$nary_inline$fn__5558 0x6d5037a9 "clojure.core$nary_inline$fn__5558@6d5037a9"]}

```

```clj
;; can define a var with metadata like so
(def something ^:hi [1 2 3])
(meta something)
; -> {:hi true}

;; can update the metadata of a var using `with-meta` which overwrites existing metadata
(def something (with-meta something {:bye true}))
(meta something)
; -> {:bye true}


```
