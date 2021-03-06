require 'pry'

module Autoselectable


  def choose(board, total_counts_by_line, strings_by_line, empty_squares)
    @choice = nil
    empty_squares = empty_squares
    counts_by_line = total_counts_by_line
    @choice = block_player_from_winning(counts_by_line, strings_by_line)
    #nothing to win or block, then try to position to form a line
    pick_square_when_player_cant_win(counts_by_line, strings_by_line, empty_squares) if @choice.nil?
    @choice
  end

  def block_player_from_winning(counts_by_line, strings_by_line)
    counts_by_line.each do |line, count|
      if count[:user] == 0 && count[:computer] == 2 #computer can win then win
        square_index = strings_by_line[line].index(' ')
        @choice = Game::WINNING_LINES[line][square_index]
        break
      elsif count[:user] == 2 && count[:computer] == 0 #block user
        square_index = strings_by_line[line].index(' ')
        @choice = Game::WINNING_LINES[line][square_index]
      end
    end
    @choice
  end

  def pick_square_when_player_cant_win(counts_by_line, strings_by_line,empty_squares)
    counts_by_line.each do |line, count|
      if count[:user] == 0 && count[:computer] == 1 #computer can win then win
        square_index = strings_by_line[line].index(' ')
        @choice = Game::WINNING_LINES[line][square_index]
        break
      elsif count[:user] == 0 && count[:computer] == 0 #block user
        square_index = strings_by_line[line].index(' ')
        self.choice = Game::WINNING_LINES[line][square_index]
      else
        @choice = empty_squares.sample
      end
      @choice
    end
  end
end

class Player
  attr_accessor :name, :choice

  def initialize(name)
    @name = name
  end

  def get_choice(empty_squares)
    puts "Select an available square from 1 to 9"
    selection = gets.chomp.to_i
    until empty_squares.include? selection
      puts "Your entry is not valid or has already been used. Please select an available square from 1-9"
      selection = gets.chomp.to_i
    end
    selection
  end

end

class Computer < Player
  include Autoselectable

  def initialize
    @name = "Computer"
  end
end

class Game
  attr_accessor :board, :score, :computer, :player, :strings_by_line, :total_counts_by_line, :winner
  WINNING_LINES = [[1,2,3],[4,5,6],[7,8,9],[1,4,7],[1,5,9],[2,5,8],[3,6,9],[3,5,7]]

  def initialize
    @board = {}
    @score = {player: 0, computer: 0}
    @computer = Computer.new
    @player = Player.new(grab_name)
    @empty_squares = empty_squares
    @winner = false
  end

  def draw_board
    system "clear"
    puts "\n\n\n\n\n\n"
    puts " 1      |2        |3       "
    puts "   #{board[1]}    |    #{board[2]}    |    #{board[3]}    "
    puts "________|_________|________"
    puts " 4      |5        |6       "
    puts "   #{board[4]}    |    #{board[5]}    |    #{board[6]}    "
    puts "________|_________|________"
    puts "7       |8        |9       "
    puts "   #{board[7]}    |    #{board[8]}    |    #{board[9]}    "
    puts "        |         |        "
    puts "\n\n\n"
  end

  def empty_squares
    board.select {|key,value| value == ' ' }.keys
  end

  def show_result
    if winner
      puts "\n#{winner == :computer ? @computer.name : @player.name} wins"
    else
      puts "It's a tie..."
    end
  end


  def detect_winner
    total_counts_by_line.each do |line,value|
      if value[:computer] == 3
        self.winner = :computer
        break
      elsif value[:user] == 3
        self.winner = :player
        break
      else
        self.winner = false
      end
    end
    self.winner
  end

  def update_score
    self.score[winner] += 1 if winner
  end

  def show_score
    puts "Running Total --- Computer: #{score[:computer]} #{@player.name}: #{score[:player]}"
  end

  def exit?
    puts "\nEnter 'quit' to exit or anything else to continue"
    exit if gets.chomp == "quit"
  end

  def convert_lines_to_string
    self.strings_by_line = []
    WINNING_LINES.each_with_index do |line,index|
      line.each do |square|
        if strings_by_line[index].nil?
          self.strings_by_line[index] = board[square]
        else
          self.strings_by_line[index] = strings_by_line[index] + board[square]
        end
      end
    end
  end

  def calculate_total_counts_by_line
    self.total_counts_by_line = {}
    strings_by_line.each_with_index do |line,index|
      self.total_counts_by_line[index]= {user: line.scan("X").count,computer: line.scan("O").count}
    end
  end

  def initialize_board
    (1..9).each {|position| @board[position]= ' '}
  end

  def check_for_winner
    convert_lines_to_string
    calculate_total_counts_by_line
    self.winner = detect_winner
  end

  def run

    loop do
      initialize_board
      loop do
        draw_board
        @player.choice = @player.get_choice(empty_squares)
        board[@player.choice]= 'X'
        draw_board
        check_for_winner
        break if winner || empty_squares.empty?
        @computer.choice = @computer.choose(self.board, self.total_counts_by_line, self.strings_by_line, self.empty_squares)
        board[@computer.choice] = 'O'
        draw_board
        check_for_winner
        break if winner || empty_squares.empty?
      end
      update_score
      show_result
      show_score
      exit?
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
