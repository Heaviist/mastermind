# frozen_string_literal: true

# define checks
module Codes
  COLORS = %w[black white orange brown red pink].sort.freeze

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

  def permutations
    COLORS.repeated_permutation(4).to_a
  end

  def new_code(colors = COLORS)
    [colors.sample, colors.sample, colors.sample, colors.sample]
  end

  def update_permutations(result, guesses, options = permutations)
    options.select! { |a| (a & guesses).empty? } if result == [0, 0]
    options.select! { |a| (a & guesses).length == 1 } if result == [0, 1]
    options.select! { |a| (a & guesses).length >= 1 && (guesses - a).length <= 2 } if result == [0, 2] #
    options.select! { |a| (a | guesses).length >= 4 && (a - guesses).length <= 1 } if result == [0, 3]
    options.select! { |a| (a - guesses).empty? } if result == [0, 4]
    guesses.each_with_index do |guess, i|
      options.select! { |a| a[i] == guess } if result[0] == 1
      options.reject! { |a| a[i] == guess } if result[0].zero?
    end
    p options.length
  end
end

# Write tutorial for the game
module Texts
  def tutorial
    print "Welcome Cowboy #{@player.name}!\nThe bulls and cows are running around freely. Will you help us out?\n\n"
    print 'This is a challenge for a Mastermind. There is a secret code to the cattle Bell, consisting of 4 colors. '
    print 'Your goal is to guess this code within 12 turns. Capture all the bulls and cows and lock them back up!'
    print "\n\nYou can choose from the following colors:\n#{COLORS.join("\n")}\n\n"
    print 'Every guessing round you can input a color for each position. Duplicates are allowed, blanks are not. '
    print "You will then be shown:\n"
    print "- how many colors are in the correct position\n- how many other colors are correct but in the wrong position"
    print "\n\nNote: if you choose a color that's not in the list above, "
    print "you will be asked to enter all entries for that round again.\n"
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
    print "\n\nYou have won #{@player.wins} Bell#{'s' if @player.wins > 1} "
    print "in #{@games} attempt#{'s' if @games > 1}."
  end

  def winner_text
    print "\nWINNER!\n\nYou have secured all the cows and bulls!"
    print "\n\nA for effort and a Bell for the Big Brain."
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
    p @color_code
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
      code[i] = gets.chomp.downcase
      break guesses unless COLORS.include?(code[i])
    end
    puts "\nYour code: #{code.join(' - ')}\n\n"
    code
  end

  def winner
    @player.wins += 1
    @rounds = @max_rounds + 1
    winner_text
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

  def pc_crack(code, guess = pc_guess)
    print "Computer guess #{@rounds}: #{guess.join(' - ')}\n"
    result = check(guess, code)
    print_result(result)
    update_permutations(result, guess)
    @rounds += 1
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
