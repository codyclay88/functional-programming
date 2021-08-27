import Config

config :ecto_sample, Friends.Repo,
  database: "ecto_sample_repo",
  username: "cody",
  password: "mysecretpassword",
  hostname: "localhost"

config :ecto_sample, ecto_repos: [Friends.Repo]
