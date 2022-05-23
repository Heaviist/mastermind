# frozen_string_literal: true

# Checks for inputs, entered codes and computer guesses
module Codes
  COLORS = %w[black white orange brown red pink].sort.freeze
  PERMUTATIONS = COLORS.repeated_permutation(4).to_a

  def colors
    COLORS
  end

  def check(guess, code, result = Array.new(2, 0))
    code.each_with_index do |color, i|
      next unless guess[i] == color

      result[0] += 1
    end
    result[1] = check_colors(guess, code) - result[0]
    result
  end

  def check_colors(guess, code, count = 0)
    guess.uniq.each do |color|
      count += [guess.count(color), code.count(color)].min if code.count(color).positive?
    end
    count
  end

  def new_code(colors = COLORS)
    [colors.sample, colors.sample, colors.sample, colors.sample]
  end

  def possible_codes(guess, result, options, outcomes = [], outcome = [])
    options.each do |code|
      outcome = check(guess, code)
      outcomes << code if outcome == result
    end
    outcomes
  end

  def color_input
    input = gets.chomp.downcase
    if COLORS.include?(input)
      input
    else
      print "Please enter a correct color!\n"
      color_input
    end
  end
end

# Collection of text outputs used during the game
module Texts
  include Codes

  def tutorial
    print "Welcome Cowboy #{@player.name}!\nThe bulls and cows are running around freely all over the land."
    print " Will you help us out and catch them all? Just find the secret code to the cattle Bell!\n\n"
    print 'This is a challenge for a Mastermind. The code to the cattle Bell consists of 4 colors. '
    print 'Your goal is to guess this code within 12 turns. Capture all the bulls and cows by ringing the Bell'
    print " and lock them back up!\n\nYou can choose from the following colors:\n#{COLORS.join("\n")}\n\n"
    print 'Every guessing round you can input a color for each position. Duplicates are allowed, blanks are not. '
    print "You will then be shown:\n"
    print "- how many colors are in the correct position\n- how many other colors are correct but in the wrong position"
  end

  def play_as_computer?
    puts "You can also challenge the computer to break your code.\n"
    puts 'Do you prefer to create a code for the computer to crack? (y/n)'
  end

  def print_result(result)
    print "Correct position AND color:    #{result[0]}\n\n"
    print "Correct color, wrong position: #{result[1]}\n"
  end

  def loser_text
    print "\n\nThe cows and bulls will roam free until the end of time! No Bells for you..."
  end

  def score
    print "\n\nYou have won #{@player.wins} Bell#{'s' if @player.wins != 1} "
    print "in #{@games} attempt#{'s' if @games > 1}."
  end

  def winner_text(player)
    if player == 'human'
      print "\nWINNER!\n\nYou have secured all the cows and bulls!"
      print "\n\nA for effort and a Bell for the Big Brain."
    else
      print "\nThe computer has cracked your code! That's a real Big Brain!"
      print "\n\nThe computer holds all the Bells, and whistles. Nothing left for you!"
      print "\n\nReady for an other challenge?"
    end
  end
end

# basic mastermind game
class Game
  include Codes
  include Texts
  def initialize(max_rounds = 12)
    @color_code = new_code
    @max_rounds = max_rounds
    @rounds = 1
    @games = 0
    @player = Player.new('Mastermind')
  end

  def play
    # p @color_code #enable to show code before play
    tutorial unless @games.positive?
    @games += 1
    play_as_computer?
    if gets.chomp.downcase == 'y'
      @color_code = guesses
      pc_crack(@color_code)
    else
      human_crack
    end
  end

  private

  def human_crack
    while @rounds <= @max_rounds
      print "\nRound ##{@rounds}. Cowboy #{@player.name}, type your guess below:\n"
      result = check(guesses, @color_code)
      print_result(result)
      winner if result.first == @color_code.length
      @rounds += 1
    end
    loser
  end

  def guesses
    code = []
    (0..3).each do |i|
      print "Position #{i + 1} - "
      code[i] = color_input
    end
    puts "\nYour code: #{code.join(' - ')}\n\n"
    code
  end

  def winner(player = 'human')
    @player.wins += 1 if player == 'human'
    @rounds = @max_rounds + 1
    winner_text(player)
    score
    new_game
  end

  def loser
    loser_text
    score
    new_game
  end

  def new_game
    print "\n\nDo you want to play a new game? (y/n)\n"
    abort score.to_s unless gets.chomp.downcase == 'y'

    @rounds = 1
    @color_code = new_code
    play
  end

  def pc_crack(code, previous_options = PERMUTATIONS, guess = pc_guess)
    print "Computer round ##{@rounds}: #{guess.join(' - ')}\n"
    result = check(guess, code)
    print_result(result)
    winner('Computer') if result.first == @color_code.length
    @rounds += 1
    gets
    options = possible_codes(guess, result, previous_options)
    pc_crack(code, options, options.sample)
  end

  def pc_guess(round1 = [COLORS.sample])
    if @rounds == 1
      (round1 * 2 << [(COLORS - round1).sample] * 2).flatten
    else
      ([COLORS.sample] << [COLORS.sample]).flatten
    end
  end
end

# Player of the game
class Player
  def initialize(name)
    @name = name
    @played = 0
    @wins = 0
  end

  attr_reader :name
  attr_accessor :played, :wins
end

game = Game.new
game.play
# Below will be the rules of the game, for reference, taken as a starting point for creating the code.
# Once the game is complete, the explanation will be given before play and deleted from this file.
# 6 colors, 4 holes, 12 attempts
# No blanks in both code and guesses, but duplicates are allowed.
# Keep tally for: colors in the correct position AND colors correct but not in the right position.
# These values will be returned to the player after each turn
# Win if you can guess within 12 attempts
