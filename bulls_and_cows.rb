# frozen_string_literal: true

COLORS = %w[black white orange brown red pink].sort.freeze

# basic mastermind game
class Game
  def initialize(max_rounds = 12)
    @color_code = new_code
    @max_rounds = max_rounds
    @rounds = 1
    # set @games to 0 to enable tutorial on first play
    @games = 0
    @player = Player.new('Mastermind')
  end

  def play
    p @color_code
    tutorial unless @games.positive?
    @games += 1
    round
  end

  private

  def tutorial
    print "Welcome Cowboy Mastermind!\nThe bulls and cows are running around freely. Will you help us out?\n\n"
    print 'This is a challenge for a Mastermind. There is a secret code to the cattle Bell, consisting of 4 colors. '
    print 'Your goal is to guess this code within 12 turns. Capture all the bulls and cows and lock them back up!'
    print "\n\nYou can choose from the following colors:\n#{COLORS.join("\n")}\n\n"
    print 'Every guessing round you can input a color for each position. Duplicates are allowed, blanks are not. '
    print "You will then be shown:\n"
    print "- how many colors are in the correct position\n- how many other colors are correct but in the wrong position"
    print "\n\nNote: if you choose a color that's not in the list above, "
    print "you will be asked to enter all guesses for that round again.\n"
  end

  def round
    while @rounds <= @max_rounds
      print "\nRound ##{@rounds}. Cowboy #{@player.name}, type your guess below:\n"
      result = check(guesses)
      print "Correct position AND color:    #{result[0]}\n\n"
      print "Correct color, wrong position: #{result[1]}\n"
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
    puts "\nYour guess: #{code.join(' - ')}\n\n"
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

  def winner
    @player.wins += 1
    @rounds = @max_rounds + 1
    print "\nWINNER!\n\nYou have secured all the cows and bulls!"
    print "\n\nA for effort and a Bell for the Big Brain."
    score
    new_game
  end

  def loser
    print "\n\nThe cows and bulls will roam free until the end of time! No Bells for you..."
    score
    new_game
  end

  def new_game
    print "\n\nDo you want to play a new game? (y/n)\n"
    abort score.to_s unless gets.chomp == 'y'

    @rounds = 1
    @color_code = new_code
    play
  end

  def score
    print "\n\nYou have won #{@player.wins} Bell#{'s' if @player.wins > 1} "
    print "in #{@games} attempt#{'s' if @games > 1}."
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
