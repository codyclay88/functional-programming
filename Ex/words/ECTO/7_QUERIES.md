# Queries!

Querying a database requires two steps in Ecto.

First, we must construct the query against the database by passing the query to the repository.

## Fetching a single record

Let's start off with fetching just one record from our `people` table.

```elixir
$ Friends.Person |> Ecto.Query.first
#Ecto.Query<from p0 in Friends.Person, order_by: [asc: p0.id], limit: 1>
```

This yielded an `Ecto.Query`, where the code between the angle brackets here shows the Ecto query which has been constructed. We could also construct this query ourselves using almost the exact same syntax:

```elixir
$ require Ecto.Query
$ Ecto.Query.from p in Friends.Person, order_by: [asc: p.id], limit: 1
#Ecto.Query<from p0 in Friends.Person, order_by: [asc: p0.id], limit: 1>
```

We need to `require Ecto.Query` here to enable the macros from that module.

To execute the query we've constructed, we can call `Friends.Repo.one`:

```elixir
$ Friends.Person |> Ecto.Query.first |> Friends.Repo.one

09:31:06.094 [debug] QUERY OK source="people" db=1.9ms queue=4.0ms idle=1451.6ms
SELECT p0."id", p0."first_name", p0."last_name", p0."age" FROM "people" AS p0 ORDER BY p0."id" LIMIT 1 []
%Friends.Person{
  __meta__: #Ecto.Schema.Metadata<:loaded, "people">,
  age: 28,
  first_name: "Cody",
  id: 1,
  last_name: "Clay"
}
```

The `one` function retrieves just one record from our database and returns a new struct from the `Friends.Person` module.

## Fetching all records

To fetch all records from the schema, Ecto provides the `all` function:

```elixir
$ Friends.Person |> Friends.Repo.all

09:33:29.874 [debug] QUERY OK source="people" db=5.3ms queue=13.7ms idle=218.7ms
SELECT p0."id", p0."first_name", p0."last_name", p0."age" FROM "people" AS p0 []
[
  %Friends.Person{
    __meta__: #Ecto.Schema.Metadata<:loaded, "people">,
    age: 28,
    first_name: "Cody",
    id: 1,
    last_name: "Clay"
  },
  %Friends.Person{
    __meta__: #Ecto.Schema.Metadata<:loaded, "people">,
    age: nil,
    first_name: "Owen",
    id: 2,
    last_name: "Clay"
  }
]
```

This returns a `Friends.Person` struct representation of all the records that currently exist within our `people` table.

## Fetch a single record by ID

```elixir
$Friends.Person |> Friends.Repo.get(1)

09:36:44.039 [debug] QUERY OK source="people" db=2.9ms queue=15.3ms idle=382.3ms
SELECT p0."id", p0."first_name", p0."last_name", p0."age" FROM "people" AS p0 WHERE (p0."id" = $1) [1]
%Friends.Person{
  __meta__: #Ecto.Schema.Metadata<:loaded, "people">,
  age: 28,
  first_name: "Cody",
  id: 1,
  last_name: "Clay"
}
```

## Fetch a single record by specific attribute

```elixir
$ Friends.Person |> Friends.Repo.get_by(first_name: "Owen")

09:38:32.745 [debug] QUERY OK source="people" db=4.7ms queue=13.5ms idle=1087.0ms
SELECT p0."id", p0."first_name", p0."last_name", p0."age" FROM "people" AS p0 WHERE (p0."first_name" = $1) ["Owen"]
%Friends.Person{
  __meta__: #Ecto.Schema.Metadata<:loaded, "people">,
  age: nil,
  first_name: "Owen",
  id: 2,
  last_name: "Clay"
}
```

## Filtering results

If we want multiple records matching a specific attribute, we can use `where`:

```elixir
$ Friends.Person |> Ecto.Query.where(last_name: "Clay") |> Friends.Repo.all

09:40:32.015 [debug] QUERY OK source="people" db=1.9ms queue=2.3ms idle=1370.8ms
SELECT p0."id", p0."first_name", p0."last_name", p0."age" FROM "people" AS p0 WHERE (p0."last_name" = 'Clay') []
[
  %Friends.Person{
    __meta__: #Ecto.Schema.Metadata<:loaded, "people">,
    age: 28,
    first_name: "Cody",
    id: 1,
    last_name: "Clay"
  },
  %Friends.Person{
    __meta__: #Ecto.Schema.Metadata<:loaded, "people">,
    age: nil,
    first_name: "Owen",
    id: 2,
    last_name: "Clay"
  }
]
```

## Composing Ecto queries

Ecto queries don't have to be built in one spot. They can be built by calling `Ecto.Query` functions on existing queries.

```elixir
$ query = Friends.Person |> Ecto.Query.where(last_name: "Clay")
#Ecto.Query<from p0 in Friends.Person, where: p0.last_name == "Clay">
$  query = query |> Ecto.Query.where(first_name: "Owen")
#Ecto.Query<from p0 in Friends.Person, where: p0.last_name == "Clay",
 where: p0.first_name == "Owen">
$ query |> Friends.Repo.all

09:44:31.415 [debug] QUERY OK source="people" db=2.1ms queue=4.3ms idle=1769.1ms
SELECT p0."id", p0."first_name", p0."last_name", p0."age" FROM "people" AS p0 WHERE (p0."last_name" = 'Clay') AND (p0."first_name" = 'Owen') []
[
  %Friends.Person{
    __meta__: #Ecto.Schema.Metadata<:loaded, "people">,
    age: nil,
    first_name: "Owen",
    id: 2,
    last_name: "Clay"
  }
]
```

## Updating records

Updating records in Ecto requires us to first fetch a record from the database. We then create a changeset from that record and the changes we want to make to that record, and then call the `Ecto.Repo.update` function.

```elixir
## Fetch me from the database
$ me = Friends.Person |> Friends.Repo.get(1)
09:46:55.426 [debug] QUERY OK source="people" db=9.4ms idle=1777.2ms
SELECT p0."id", p0."first_name", p0."last_name", p0."age" FROM "people" AS p0 WHERE (p0."id" = $1) [1]
%Friends.Person{
  __meta__: #Ecto.Schema.Metadata<:loaded, "people">,
  age: 28,
  first_name: "Cody",
  id: 1,
  last_name: "Clay"
}

## Wrap me in a changeset. We want to change my first name to "Kristian"
$ me_changes = Friends.Person.changeset(me, %{first_name: "Kristian"})
#Ecto.Changeset<
  action: nil,
  changes: %{first_name: "Kristian"},
  errors: [],
  data: #Friends.Person<>,
  valid?: true
>

## Update me!
$ Friends.Repo.update(me_changes)
09:47:42.991 [debug] QUERY OK db=6.7ms queue=9.1ms idle=1336.3ms
UPDATE "people" SET "first_name" = $1 WHERE "id" = $2 ["Kristian", 1]
{:ok,
 %Friends.Person{
   __meta__: #Ecto.Schema.Metadata<:loaded, "people">,
   age: 28,
   first_name: "Kristian",
   id: 1,
   last_name: "Clay"
 }}
```
