defmodule Hangman.Game do
    
  # This struct has the same name as the module it's contained in
  defstruct(
    turns_left: 7,
    game_state: :initializing,
    letters: [],
    used: MapSet.new(),
  )

  def new_game() do
    %Hangman.Game{
      letters: Dictionary.random_word |> String.codepoints
    }
  end

  # Pattern matching with a "when" clause. 
  # Bind the `game_state` to a local `state` variable, 
  # and then in the `when` clause, test it's value. 
  def make_move(game = %{ game_state: state }, _guess) when state in [:won, :lost] do
    { game, tally(game) }
  end

  def make_move(game, guess) do
    game = accept_move(game, guess, MapSet.member?(game.used, guess))
    { game, tally(game) }
  end

  def accept_move(game, guess, _already_guessed = true) do
    Map.put(game, :game_state, :already_used)
  end

  def accept_move(game, guess, _already_guessed) do
    Map.put(game, :used, MapSet.put(game.used, guess))
  end

  def tally(game) do
    123
  end

end