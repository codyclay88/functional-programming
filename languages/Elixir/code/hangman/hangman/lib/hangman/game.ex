defmodule Hangman.Game do
  # This struct has the same name as the module it's contained in
  defstruct(
    turns_left: 7,
    game_state: :initializing,
    letters: [],
    used: MapSet.new()
  )

  def new_game() do
    Dictionary.random_word()
    |> new_game
  end

  def new_game(word) do
    %Hangman.Game{
      letters: word |> String.codepoints()
    }
  end

  # Pattern matching with a "when" clause. 
  # Bind the `game_state` to a local `state` variable, 
  # and then in the `when` clause, test it's value. 
  def make_move(game = %{game_state: state}, _guess) when state in [:won, :lost] do
    game
  end

  def make_move(game, guess) do
    accept_move(game, guess, MapSet.member?(game.used, guess))
  end

  def tally(game) do
    %{
      game_state: game.game_state,
      turns_left: game.turns_left,
      letters: game.letters |> reveal_guessed(game.used),
      used: game.used
    }
  end

  #################################

  defp accept_move(game, _guess, _already_guessed = true) do
    Map.put(game, :game_state, :already_used)
  end

  defp accept_move(game, guess, _already_guessed) do
    Map.put(game, :used, MapSet.put(game.used, guess))
    |> score_guess(Enum.member?(game.letters, guess))
  end

  defp score_guess(game, _good_guess = true) do
    new_state =
      MapSet.new(game.letters)
      |> MapSet.subset?(game.used)
      |> maybe_won

    Map.put(game, :game_state, new_state)
  end

  # This will match when there is one turn left in the game
  # and the guess was bad
  defp score_guess(game = %{turns_left: 1}, _bad_guess) do
    %{game | game_state: :lost}
  end

  # This will match when there is not one turn left in the game
  # and the guess was bad, binding the `:turns_left` to the variable
  # `turns_left`
  defp score_guess(game = %{turns_left: turns_left}, _bad_guess) do
    %{game | game_state: :bad_guess, turns_left: turns_left - 1}
  end

  defp maybe_won(true), do: :won
  defp maybe_won(_false), do: :good_guess

  defp reveal_guessed(letters, used) do
    letters
    |> Enum.map(fn letter -> reveal_letter(letter, MapSet.member?(used, letter)) end)
  end

  defp reveal_letter(letter, _in_word = true), do: letter
  defp reveal_letter(_letter, _not_in_word), do: "_"
end
