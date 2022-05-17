# frozen_string_literal: true

COLORS = %w[black white orange brown red pink].sort.freeze

# basic mastermind game
class Game
  def initialize(max_rounds = 12)
    @color_code = new_code
    @max_rounds = max_rounds
    @rounds = 1
    # set @games to 0 to enable tutorial on first play
    @games = 1
    @player = Player.new('Mastermind')
  end

  def play
    p @color_code
    tutorial unless @games.positive?
    while @rounds <= @max_rounds
      round
      @rounds += 1
    end
    @games += 1
  end

  private

  def tutorial
    print "Welcome Cowboy Mastermind!\nThe bulls and cows are running around freely. Will you help us out?\n\n"
    print 'This is a guessing game called Mastermind. There is a secret code, consisting of 4 colors. '
    print 'Your goal is to guess this code within 12 turns. Capture all the bulls and cows and lock them back up!'
    print "\n\nYou can choose from the following colors:\n#{COLORS.join("\n")}\n\n"
    print 'Every guessing round you can input a color for each position. Duplicates are allowed, blanks are not.'
    print "\nYou will they be shown:\n"
    print "- how many colors are in the correct position\n- how many other colors are correct but in the wrong position"
    print "\n\nNote: if you choose a color that's not in the list above, it ask all your guesses for that round again."
  end

  def round
    print "\n\nRound ##{@rounds}. Cowboy #{@player.name}, type your guess below:\n"
    result = check(guesses)
    print "Correct position AND color:    #{result[0]}\n\nCorrect color, wrong position: #{result[1]}"
  end

  def guesses
    code = []
    (0..3).each do |i|
      print "Position #{i + 1} - "
      code[i] = gets.chomp.downcase
      break guesses unless COLORS.include?(code[i])
    end
    puts "\nYour guesses: #{code.join(' - ')}\n\n"
    code
  end

  def check(guess)
    result = Array.new(2, 0)
    @color_code.each_with_index do |code, i|
      next unless guess[i] == code

      result[0] += 1
    end
    result[1] = check_colors(guess) - result[0]
    result
  end

  def check_colors(guess, count = 0)
    guess.uniq.each do |color|
      count += [guess.count(color), @color_code.count(color)].min if @color_code.count(color).positive?
    end
    count
  end

  def new_code
    [COLORS.sample, COLORS.sample, COLORS.sample, COLORS.sample]
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
