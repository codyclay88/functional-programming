defmodule EctoSampleTest do
  use ExUnit.Case
  doctest EctoSample

  test "greets the world" do
    assert EctoSample.hello() == :world
  end
end
