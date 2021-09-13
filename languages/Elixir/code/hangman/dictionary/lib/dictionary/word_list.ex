defmodule Dictionary.WordList do
  @moduledoc false

  def word_list do
    "../../assets/words.txt"
    |> Path.expand(__DIR__)
    |> File.read!()
    |> String.split(~r/\n/)
  end

  @spec random_word([String.t()]) :: String.t()
  def random_word(words) do
    words
    |> Enum.random()
  end
end
