# Reader Forms

## Symbols

- Symbols begin with a non-numeric character and can contain alphanumeric characters and `*`, `+`, `!`, `-`, `'`, `?`, `<`, `>`, and `=` (other characters may be allowed eventually).
- `/` has special meaning, it can be used once in the middle of a symbol to separate the namespace from the name, e.g. `my-namespace/foo`. `/` by itself names the division function.
- `.` has special meaning - it can be used one or more times in the middle of a symbol to designate a fully-qualified class name, e.g., `java.util.BitSet`, or in namespace names. Symbols containing `/` or `.` are said to be 'qualified'.
- Symbols beginning or ending with `:` are reserved by Clojure. A symbol can contain one or more non-repeating `:` characters.

## Literals

- Strings - enclosed in "double quotes". May span multiple lines. Standard Java escape characters are supported.
- Numbers - generally represented as per Java.
- Characters - preceded by a backslash: `\c`, `\newline`, `\space`, `\tab`, `\formfeed`, `\backspace`, and `\return` yield the corresponding characters. Unicode characters are represented with `\uNNNN` as in Java. Octals are represented with `\oNNN`.
- `nil` means nothing/no-value. Represents Java `null` and tests logical false.
- Booleans: `true` and `false`
- Symbolic values - `##Inf`, `##-INF`, and `##NaN`
- Keywords, which are like symbols except they can and must begin with a colon, e.g. `:fred`. They cannot contain `.` in the name part, or name classes.

## Lists

Lists are zero or more forms enclosed in parentheses: `(a b c)`

## Vectors

Vectors are zero or more forms enclosed in square brackets: `[1 2 3]`

## Maps

Maps are zero or more key/value pairs enclosed in braces: `{:a 1 :b 2}`

Commas are considered whitespace, and can be used to organize the pairs: `{:a 1, :b 2}`

Both keys and values can be any forms.

## Sets

Sets are zero or more forms enclosed in braces preceded by `#`: `#{:a :b :c}`.
