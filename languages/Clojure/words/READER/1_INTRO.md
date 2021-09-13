# The Reader

Clojure is a _homoiconic_ language, which is a fancy term describing the fact that Clojure programs are represented by Clojure data structures. This is a very important Clojure (along with Common Lisp) and most other programming languages - Clojure is defined in terms of the evaluation of data structures and **not** in terms of the syntax of character streams/files.

Because of this, it is quite common, and easy, for Clojure programs to manipulate, transform, and produce other Clojure programs.

That said, most Clojure programs begin life as text files, and it is the task of the _reader_ to parse the text and produce the data structure the compiler will see. This is not merely a phase of the compiler. The reader, and the Clojure data representations, have utility on their own in many of the same contexts one might use XML or JSON etc.

One might say the reader has syntax defined in terms of characters, and the Clojure language has syntax defined in terms of symbols, lists, vectors, maps etc. The reader is represented by the function `read`, which reads the next form (not character) from a stream, and returns the object represented by that form.
