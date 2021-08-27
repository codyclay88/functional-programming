# Schemas!

The schema is an Elixir representation of data from our database. Schemas are commonly associated with a database table, however they can be associated with a database view as well.

Let's create the schema within our application at `lib/friends/person.ex`.

```elixir
defmodule Friends.Person do
  use Ecto.Schema

  schema "people" do
    field(:first_name, :string)
    field(:last_name, :string)
    field(:age, :integer)
  end
end
```

This defines the schema from the database that this schema maps to. In this case, we;re telling Ecto that the `Friends.Person` schema maps to the `people` table in the database, and the `first_name`, `last_name`, and `age` fields in that table. The second argument passed to `field` tells Ecto how we want the information from the database to be represented in our schema.

We've called this schema `Person` because the naming convention in Ecto for schemas is a singularized name.

We can play around with this schema in an IEx session by starting one up with `iex -S mix` and then running this code in it:

```elixir
person = %Friends.Person{}
```

This code will give us a new `Friends.Person` struct, which will have `nil` values for all the fields. We can set values on these fields by generating a new struct:

```elixir
person = %{ person | first_name: "Cody", last_name: "Clay", age: 28 }
```

We can insert a new record into our `people` table with this code:

```elixir
Friends.Repo.insert(person)
```

To insert the data into our database, we call `insert` on `Friends.Repo`, which is the module that uses Ecto to talk to our database. This function tells Ecto that we want to insert a new `Friends.Person` record into the database corresponding with `Friends.Repo`. The `person` struct here represents the data that we want to insert into the database.
