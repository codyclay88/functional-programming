# Calling Java from Clojure

Clojure provides simple, direct syntax for calling Java code: creating objects, invoking methods, and accessing static methods and fields. In addition, Clojure provides syntactic sugar that makes calling Java from Clojure more concise than calling Java from Java!

Not all types in Java are created equal: the primitives and arrays work differently. Where Java has special cases, Clojure gives you direct access to these as well. Finally, Clojure provides a set of convenience functions for common tasks that would be unwieldy in Java.

## `new` special form

The first step in many Java interop scenarios is creating a Java object. Clojure provides the `new` special form for this purpose: `(new classname)`

```clj
(new java.util.Random)

;; This is an equivalent form to above, explained further below.
(java.util.Random.)
```

As shown above, another more frequently used shortcut for creating a new instance of a class is to append a trailing `.` to the class name.

To use a new random instance, you need to save it away somewhere. For now, simply use `def` to save the `Random` into a Clojure `var`:

```clj
(def rnd (new java.util.Random))
;; or alternatively
(def rnd (java.util.Random.))

(. rnd nextInt)
; -> -517304247

(. rnd nextInt)
; -> -864224297
```

## `.` special form

As shown in the previous example, you can call a method on a java object using the `.` special form.

```
(. class-or-instance member-symbol & args)
(. class-or-instance (member-symbol & args))
```

In the examples below, the first shows calling the `nextInt` method with no parameters, while the second shows calling the `nextInt` method with parameters.

```clj
(. rnd nextInt)
; -> -1228923016
(. rnd nextInt 10)
; -> 4

;; equivalent forms below
(. rnd (nextInt))
; -> -1228923016
(. rnd (nextInt 10))
; -> 4
```

The `.` syntax can also be used to access instance fields, static methods, and static fields:

```clj
;; Instance field
(def p (java.awt.Point. 10 20))
(. p x)
; -> 10

;; Static method
(. System lineSeparator)
; -> "\n"

;; Static field
(. Math PI)
; -> 3.141592653589793
```

However, Clojure also provides a more concise syntax for both instance and static access that is preferred:

```
(.method instance & args)
(.field instance)
(.-field instance) -- for when a class has a field and method of the same name, but you want to use the field.
(Class/method & args)
Class/field
```

```clj
(.nextInt rnd 10)
; -> 4

(.x p)
; -> 10

(System/lineSeparator)
; -> "\n"

Math/PI
; -> 3.141592653589793
```

Clojure provides a `javadoc` function to display javadoc information for a particular class.

```clj
(javadoc java.net.URL)
```
