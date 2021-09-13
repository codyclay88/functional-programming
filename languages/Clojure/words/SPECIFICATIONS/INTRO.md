# Introduction to Specifications

Statically typed languages like Java create unique, named data structures (classes) for every unit of data in a program. Clojure is dynamically typed and instead relies on reusing a few generic collection types (vectors, maps, sets, lists, and sequences) to represent a program's data. This approach yields tremendous benefits for code reuse, simplicity, generality, and extension.

However, one consequence of this approach is that functions in a Clojure program lack the explicit types that programmers in a statically typed language rely on as signposts to understand a piece of code.

In Clojure 1.9, Clojure introduced the _spec_ library, which allows us to create "specs" that describe the structure of our data, and the inputs and outputs of our functions. The actual code we write is the same -- it still uses generic collections and generic operations on those collections. Adding specs to your code can make the implicit structure explicit.

For example, lets look at a Java class that takes a recipe ingredient and scales the quantity for a larger recipe:

```java
public class Ingredient {
    private String name;
    private double quantity;
    private Unit unit;

    //....

    public static Ingredient scale(Ingredient ingredient, double factor) {
        ingredient.setQuantity(ingredient.getQuantity() * factor);
        return ingredient;
    }
}
```

Using `spec`, we could define an equivalent Clojure function (`s` here is an alias for the `clojure.spec.alpha` namespace):

```clj
;; Specs describing an ingredient
(s/def ::ingredient (s/keys :req [::name ::quantity ::unit]))
(s/def ::name     string?)
(s/def ::quantity number?)
(s/def ::unit     keyword?)

;; Function spec for scale-ingredient
(s/fdef scale-ingredient
    :args (s/cat :ingredient ::ingredient :factor number?)
    :ret ::ingredient)

​(​defn​ scale-ingredient [ingredient factor] ​
    (update ingredient :quantity * factor))
```

These specs give us a precise description of the shape of an ingredient map, its fields, and their contents. The function spec gives us an explicit definitions of the arguments and return value of `scale-ingredient`. These specs don't just serve as documentation. The spec library uses them to provide several additional tools that operate on specs -- data validation, explanations of invalid data, generation of example data, and even automatically created generative tests for functions with a spec.

Let's consider how to define specs in our code and how to use them at runtime, followed by how we combine specs and validate data.
