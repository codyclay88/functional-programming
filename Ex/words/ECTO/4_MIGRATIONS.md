# Migrations

#### This assumes that you have followed the steps outlined in the "2_SETUP_CONFIGURE.md" and "3_CREATE_DATABASE.md" documents.

A database by itself isn't very queryable, so we will need to create a table within that database. To do that, we'll use what's referred to as a _migration_. If you've come from Active Record or Entity Framework, you will have seen these before. A migration is a single step in the process of constructing your database.

We can create a migration now with this command:

```
mix ecto.gen.migration create_people
```

The command will generate a brand new migration file in `priv/repo/migrations`, which is empty by default:

```elixir
defmodule Friends.Repo.Migrations.CreatePeople do
  use Ecto.Migration

  def change do

  end
end
```

Let's add some code to this migration to create a new table called "people", with a few columns in it.

```elixir
defmodule Friends.Repo.Migrations.CreatePeople do
  use Ecto.Migration

  def change do
    create table(:people) do
      add :first_name, :string
      add :last_name, :string
      add :age, :integer
    end
  end
end
```

This new code will tell Ecto to create a new table called `people`, and add three new fields: `first_name`, `last_name`, and `age` to that table. The types of these fields are `string` and `integer`. (The different types that Ecto supports are covered in the [Ecto.Schema](https://hexdocs.pm/ecto/Ecto.Schema.html) documentation)

NOTE: The naming convention for tables in Ecto databases is to use a pluralized name.

To run this migration and create the `people` table in our database, we will run this command: `mix ecto.migrate`

We now have a table create in our database. The next step that we'll need to do is create the schema.
