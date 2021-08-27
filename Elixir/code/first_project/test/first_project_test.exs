defmodule FirstProjectTest do
  use ExUnit.Case
  doctest FirstProject

  test "greets the world" do
    assert FirstProject.sample() == :ok
  end
end
