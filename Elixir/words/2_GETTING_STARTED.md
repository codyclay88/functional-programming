# Getting Started with Elixir

I'm not going to talk about Installation here. [The Elixir docs cover that in depth:](https://elixir-lang.org/install.html#macos)

Instead, let's start by getting up and running with `iex`, the Elixir Integrated Shell.

## Iex

Once elixir is installed, you can start the interactive shell by running the command `iex` at a terminal. You'll see something like this:

```zsh
codyclay@Codys-MBP ~ % iex
Erlang/OTP 24 [erts-12.0.3] [source] [64-bit] [smp:16:16] [ds:16:16:10] [async-threads:1] [jit] [dtrace]

Interactive Elixir (1.12.2) - press Ctrl+C to exit (type h() ENTER for help)
iex(1)>
```

You can type in any ole Elixir code into the prompt:

```zsh
iex(1)> IO.puts("Hello World!")
Hello World!
:ok
```

Here we typed the `IO.puts/1` function into the prompt with the string argument `Hello World!`.
The result is that "Hello World!" was printed to the console, along with `:ok`. Because Elixir strives to be a functional language, every function call returns a value: there is no concept of `void` in most functional languages. In this case, Elixir chose to return a `symbol` with the value `ok` as a means of letting the programmer know that the function executed successfully.

## Mix

Mix is a build tool that ships with Elixir that provides tasks for creating, compiling, testing your application, managing its dependencies and much more.

We can create a new project by invoking `mix new` from the command line, an example with output is provided below:

```zsh
codyclay@Codys-MBP code % mix new first_project
* creating README.md
* creating .formatter.exs
* creating .gitignore
* creating mix.exs
* creating lib
* creating lib/first_project.ex
* creating test
* creating test/test_helper.exs
* creating test/first_project_test.exs

Your Mix project was created successfully.
You can use "mix" to compile it, test it, and more:

    cd first_project
    mix test

Run "mix help" for more commands.
```

If we now `cd` into our new project directory, we can compile our project by typing `mix compile`:

```zsh
codyclay@Codys-MBP first_project % mix compile
Compiling 1 file (.ex)
Generated first_project app
```

Once the project is complied, we can start an `iex` session inside the project by running the following command `iex -S mix`:

```zsh
codyclay@Codys-MBP first_project % iex -S mix
Erlang/OTP 24 [erts-12.0.3] [source] [64-bit] [smp:16:16] [ds:16:16:10] [async-threads:1] [jit] [dtrace]

Interactive Elixir (1.12.2) - press Ctrl+C to exit (type h() ENTER for help)
iex(1)> FirstProject.sample
Hello World!
:ok
iex(2)>
```

As you can see from the snippet above, once we compile the project into `iex`, we then have access to all the modules and functions defined within the project. FREAKING COOL!

If you make changes to the project while the `iex` session is running, you can recompile the code within the running `iex` session by using the `recompile` helper:

```zsh
iex(2)> recompile()
:noop
iex(3)> recompile()
Compiling 1 file (.ex)
:ok
iex(4)>
```

In the command on prompt `iex(2)`, I hadn't yet made any changes to the app, so there was no need to rebuild the code, which is why we see a `:noop` returned.
For prompt `iex(3)` however, a change was made to the code, and recompiling yielded the `:ok` symbol, with a bit of helper text.
