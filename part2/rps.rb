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
  attr_accessor :score, :result, :winner


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
  end

  def get_choice
    puts "\nLet's play! Enter the number corresponding to one of the following options: \n \n1) Rock \n2) Paper \n3) Scissors\n"
    user_selection = gets.chomp
    while !([*?1..?3].include? user_selection)
      puts "\nYour entry was invalid. Please enter 1,2, or 3\n1) Rock \n2) Paper \n3) Scissors"
      user_selection = gets.chomp
    end
    user_selection.to_i
  end

  def show_result(player, computer)
    if self.winner.class != NilClass # there was no error in compare
      if self.winner.class != FalseClass
        case self.winner.choice
        when 1 #Rock
          puts "\nRock breaks scissors"
        when 2 #Paper
          puts "\nPaper wraps rock"
        when 3 #Scissors
          puts "\nScissors cut paper"
        else
        end
        puts "\n#{self.winner.name} wins"
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
  end


  def compare(player, computer)
    if player.choice == computer.choice
      self.winner = false
    else
      case computer.choice
      when 1 #Rock
        player.choice == 2 ? self.winner = player : self.winner = computer
      when 2 #Paper
        player.choice == 3 ? self.winner = player : self.winner = computer
      when 3 #Scissors
        player.choice == 1 ? self.winner = player : self.winner = computer
      else
        puts "Oh Oh... We couldn't run the game"
        self.winner = nil
      end
    end
  end

  # def update_score(winner)
  #   binding.pry
  #   self.score[winner.to_sym] += 1 if winner.class != NilClass || winner.class != FalseClass
  # end

  def exit?
    puts "Enter 'quit' to exit or anything else to continue"
    exit if gets.chomp == "quit"
  end

  def run
    computer = Computer.new
    puts "Welcome to Rock Paper Scissors. What's your name?"
    player = Player.new(gets.chomp)
    loop do
      player.choice = self.get_choice
      computer.choice = computer.choose
      self.compare(player, computer)
    #  self.update_score(self.winner)
      self.show_result(player, computer)
      self.exit?
    end
  end
end


game = Game.new
game.run
