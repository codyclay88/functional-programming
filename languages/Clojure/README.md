# Clojure

The Clojure language is distinct from the Clojure compiler. The Clojure language is a Lisp dialect with a functional emphasis whose syntax and semantics are independent of any implementation. The compiler is an executable JAR file, clojure.jar, which takes code written in the Clojure language and compiles it to JVM bytecode. You'll see Clojure used to refer to both the language and the compiler, which can be confusing if you're not aware that they're separate things. But now that you're aware, you'll be fine.

This distinction is necessary because, unlike most programming languages, Clojure is a _hosted_ language. Clojure programs are executed within a JVM and rely on the JVM for core features like threading and garbage collection. Clojure also targets JavaScript and the CLR, but this will focus mostly on the JVM implementation.

For now, we need to understand the following things about the relationship between Clojure and the JVM:

- JVM processes execute Java bytecode
- Usually, the Java Compiler produces Java bytecode from Java source code.
- JAR files are collections of Java bytecode
- Java programs are usually distributed as JAR files
- The Java program `clojure.jar` reads Clojure source code and produces Java bytecode.
- The Java bytecode is then executed by the same JVM process already running `clojure.jar`
