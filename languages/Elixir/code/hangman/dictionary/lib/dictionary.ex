defmodule Dictionary do
  @moduledoc """
    This is a cool Dictionary!
  """
  alias Dictionary.WordList

  @spec start() :: [String.t()]
  defdelegate start(), to: WordList, as: :word_list 

  @spec random_word([String.t()]) :: String.t()
  defdelegate random_word(words), to: WordList
end
