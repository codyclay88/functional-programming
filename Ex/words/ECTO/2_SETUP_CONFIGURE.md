# Setting up Ecto

Let's create a new Elixir app with the following command:

```zsh
$ mix new ecto_sample --sup
```

The `--sup` option ensures that this application has a supervision tree, which we'll need for Ecto a little later on.

To add Ecto to this application, there are a few steps that we need to take. The first step will be adding Ecto and a driver called Postgrex to our `mix.exs` file, which we'll do by changing the `deps` definition in that file to this:

```elixir
defp deps do
  [
    {:ecto_sql, "~> 3.0"},
    {:postgrex, ">= 0.0.0"}
  ]
end
```

Ecto provides the common querying API, but we need the Postgrex driver installed too, as that is what Ecto uses to speak in terms a PostgreSQL database can understand. Ecto talks to its own `Ecto.Adapters.Postgres` module, which then in turn talks to the `postgrex` package to talk to PostgreSQL.

To install these dependencies, we will run this command: `mix deps.get`

The Postgrex application will receive queries from Ecto and execute them against our database. If we didn't do this step, we wouldn't be able to do any querying at all.

Now we need to setup some configuration for Ecto so that we can perform actions on a database from within the application's code. We can do this by running the following command:

```zsh
$ mix ecto.gen.repo -r Friends.Repo
```

This command will generate the configuration required to connect to a database. The first bit of configuration is in `config/config.exs`.

```elixir
config :ecto_sample, Friends.Repo,
  database: "ecto_sample_repo",
  username: "cody",
  password: "mysecretpassword",
  hostname: "localhost"
```

---

NOTE: You can create a postgres database to connect to if docker is installed by running the following command:

```zsh
$ docker run --name some-postgres -p 5432:5432 -e POSTGRES_PASSWORD=mysecretpassword -e POSTGRES_USER=cody -d postgres
```

---

This configures how Ecto will connect to our database, called "friends". Specifically, it configures a "repo".

The `Friends.Repo` module is defined in `lib/friends/repo.ex` by our `mix.gen.repo` command.

```elixir
defmodule Friends.Repo do
  use Ecto.Repo,
    otp_app: :ecto_sample,
    adapter: Ecto.Adapters.Postgres
end
```

This module is what we'll be using to query our database shortly. It uses the `Ecto.Repo` module, and the `otp_app` tells Ecto which Elixir application it can look for database configuration in. In this case, we've specified that it is the `:friends` application where Ecto can find that configuration and so Ecto will use the configuration that was set up in `config/config.exs`. Finally, we configure the database `:adapter` to Postgres.

The final piece of configuration is to setup the `Friends.Repo` as a supervisor within the application's supervision tree, which we can do in `lib/friends/application.ex`, inside the `start/2` function:

```elixir
def start(_type, _args) do
    children = [
        Friends.Repo,
        # Starts a worker by calling: EctoSample.Worker.start_link(arg)
        # {EctoSample.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: EctoSample.Supervisor]
    Supervisor.start_link(children, opts)
end
```

This piece of configuration will start the Ecto process which receives and executes our application's queries. Without it, we wouldn't be able to query the database at all!

There's one final bit of configuration that we'll need to add outselves, since the generator does not add it. Underneath the configuration in `config/config.exs`, add this line:

```elixir
config :friends, ecto_repos: [Friends.Repo]
```

This tells our app about the repo, which will allow us to run commands such as `mix ecto.create` very soon.

With everything now configured, let's now create our database, add a table to it, and then perform some queries.
