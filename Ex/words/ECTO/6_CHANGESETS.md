# Validating Changes with Changesets

In Ecto, you may wish to validate changes before they go to the database. For instance, you may wish that a person has both a first name and a last name before a record can be entered into the database. For this, Ecto has changesets.

Let's add a changeset to our `Friends.Person` module inside `lib/friends/person.ex`:

```elixir
def changeset(person, params \\ %{}) do
    person
    |> Ecto.Changeset.cast(params, [:first_name, :last_name, :age])
    |> Ecto.Changeset.validate_required([:first_name, :last_name])
end
```

This changeset takes a `person` and a set of params, which are to be the changes to apply to this person. The `changeset` function first casts the `first_name`, `last_name`, and `age` keys from the parameters passed in to the changeset. Casting tells the changeset what parameters are allowed to be passed through in this changeset, and anything not in the list will be ignored.

On the next line, we call `validate_required` which says that, for this changeset, we expect `first_name` and `last_name` to have values specified. Let's use this changeset to attempt to create a new record without a `first_name` and `last_name`:

```elixir
person = %Friends.Person{}
changeset = Friends.Person.changeset(person, %{})
Friends.Repo.insert(changeset)
```

On the second line we are doing something new: we are defining a changeset. This changeset says that on the specified `person` object, we're looking to make some changes. In this case, we're not looking to change anything at all.

On the final line, rather than inserting the `person`, we insert the `changeset`. The `changeset` knows about the `person`, the changes and the validation rules that must be met before the data can be entered into the database. When this third line runs, we'll see this:

```
$ Friends.Repo.insert(changeset)
{:error,
 #Ecto.Changeset<
   action: :insert,
   changes: %{},
   errors: [
     first_name: {"can't be blank", [validation: :required]},
     last_name: {"can't be blank", [validation: :required]}
   ],
   data: #Friends.Person<>,
   valid?: false
 >}
```

This returns a tuple where the first element is `:error`, which indicates something bad happened. The specifics of what happened are included in the changeset which is returned. We can access these by doing some pattern matching:

```elixir
{:error, changeset} = Friends.Repo.insert(changeset)
```

Then we can get to the errors by doing `changeset.errors`:

```elixir
[
  first_name: {"can't be blank", [validation: :required]},
  last_name: {"can't be blank", [validation: :required]}
]
```

And we can ask the changeset itself if it is valid, even before doing an insertion:

```elixir
$ changeset.valid?
false
```

If inserting a changeset completes successfully, you will see the tuple `{:ok, person}` where the `person` is the `Friends.Person` record that the changeset encapsulated. Otherwise, if the insertion fails, we will see the tuple `{:error, changeset}` where the `changeset` is the original changeset passed in.

Due to `Friends.Repo.insert` returning a tuple, we can use a `case` to determine different code paths depending on what happens:

```elixir
case Friends.Repo.insert(changeset) do
    {:ok, person} ->
        # do something with person
    {:error, changeset} ->
        # do something with changeset
end
```
