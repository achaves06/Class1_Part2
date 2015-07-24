#Draw Shapes Shape[0] = rock shape[1] = paper shape [2] scissors

#rock

require 'pry'

module Autoselectable
  def choose
    rand(1..3)
  end

end

class Player


  attr_accessor :name, :choice

  def initialize(name)
    @name = name
  end

  def shape_index
    @shape_index = self.choice - 1
  end

end

class Computer < Player
  include Autoselectable

  def initialize
    @name = "Computer"
  end
end

class Game
  attr_accessor :score, :winner, :player, :computer


    SHAPES = [
      [
      '                 ',
      '    __ __ __     ',
      '   /        \    ',
      '  /          \   ',
      '  |           |  ',
      '   \         /   ',
      '    \__ __ _/    ',
      '                 ',
      '                 ',
      '                 ',
      '      ROCK       '
      ],
      [
      '  ____________   ',
      ' |            |  ',
      ' |            |  ',
      ' |            |  ',
      ' |            |  ',
      ' |            |  ',
      ' |            |  ',
      ' |            |  ',
      ' |            |  ',
      ' |____________|  ',
      '     PAPER       '
      ],
      ['   ___     ___  ',
      '  /   \   /   \ ',
      '  \___/   \___/ ',
      '    \ \   / /	',
      '     \ \ / /	',
      '      \ / /     ',
      '       /./      ',
      '      / / \     ',
      '     / / \ \    ',
      '     |/   \|    ',
      '    SCISSORS   ']]

  def initialize
    @score = {player: 0, computer: 0}
    @computer = Computer.new
    @player = Player.new(grab_name)
  end


  def get_choice
    puts "\nLet's play! Enter the number corresponding to one of the following options: \n \n1) Rock \n2) Paper \n3) Scissors\n"
    user_selection = gets.chomp
    while !%w(1 2 3).include? user_selection
      puts "\nYour entry was invalid. Please enter 1,2, or 3\n1) Rock \n2) Paper \n3) Scissors"
      user_selection = gets.chomp
    end
    user_selection.to_i
  end

  def show_result
    if winner
      case self.winner
      when 1 #Rock
        puts "\nRock breaks scissors"
      when 2 #Paper
        puts "\nPaper wraps rock"
      when 3 #Scissors
        puts "\nScissors cut paper"
      end
      puts "\n#{self.winner == :computer? ? @computer.name : @player.name} wins"
    else # there was no winner, it's a tie
      puts "It's a tie..."
    end
    puts "   COMPUTER < ---------- >  #{player.name}   "
    i = 0
    11.times do
      puts "#{SHAPES[computer.shape_index][i]}  #{SHAPES[player.shape_index][i]}"
      i += 1
    end
  end


  def detect_winner
    if @player.choice == @computer.choice
      false
    else
      case @computer.choice
      when 1 #Rock
        @player.choice == 2 ? :player : :computer
      when 2 #Paper
        @player.choice == 3 ? :player : :computer
      when 3 #Scissors
        @player.choice == 1 ? :player : :computer
      end
    end
  end

  def update_score
    binding.pry
    self.score[winner] += 1 if winner
  end

  def show_score
    puts "Running Total --- Computer: #{score[:computer]} #{@player.name}: #{score[:player]}"
  end

  def exit?
    puts "\nEnter 'quit' to exit or anything else to continue"
    exit if gets.chomp == "quit"
  end

  def run

    loop do
      @player.choice = self.get_choice
      @computer.choice = @computer.choose
      self.winner = self.detect_winner
      self.update_score
      self.show_result
      self.show_score
      self.exit?
    end
  end

  private

  def grab_name
    puts "Welcome to Rock Paper Scissors. What's your name?"
    gets.chomp
  end
end


game = Game.new
game.run
