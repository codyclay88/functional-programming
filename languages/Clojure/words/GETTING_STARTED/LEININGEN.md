# Leiningen

[From docs located here.](https://github.com/technomancy/leiningen/blob/stable/doc/TUTORIAL.md)

Leiningen is for automating Clojure projects without setting your hair on fire.

It offers various project-related tasks and can:

- create new projects
- fetch dependencies for your project
- run tests
- run a fully-configured REPL
- compile Java sources (if any)
- run the project (if the project isn't a library)
- generate a maven-style "pom" file for the project for interop
- compile and package projects for deployment
- publish libraries to repositories such as Clojars
- run custom automation scripts written in Clojure

## Projects

Leiningen works with projects. A project is a directory containing a group of Clojure (and possibly Java) source files, along with a bit of metadata about them. The metadata is stored in a file named `project.clj` in the project's root directory, which is how you tell Leiningen about things like

- project name
- project description
- what libraries the project depends on
- what clojure version to use
- where to find source files
- what's the main namespace of the app
  and more...

Most leiningen tasks only make sense in the context of a project. Some (for example `repl` or `help`) can also be called from any directory.

## Creating a project

Generating a new project is easy:

```zsh
$ lein new app my-stuff
```

In these example the `app` template is used, which is intended for an application project rather than a library. Omitting the `app` argument will use the `default` template, which is suitable for libraries.

### Directory Layout

In a new project, a `src/` directory contains the code, a `test/` directory, and a `project.clj` file which describes the project to Leiningen. The `src/my_stuff/core.clj` file corresponds to the `my-stuff.core` namespace.
