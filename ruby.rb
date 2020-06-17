class Board

    attr_reader :current_round, :array, :code_size
    
    def initialize(code_size, num_turns, num_rounds)
        @code_size = code_size
        @num_turns = num_turns
        @num_rounds = num_rounds
        @current_round = 1
        @array = Array.new(@num_turns){Array.new(@code_size, "o")}
        #@guess_array = Array.new(@num_turns){Array.new(@code_size, ".")}
        #@array = Array.new(@num_turns)#{Array.new(@code_size, "b")}
    end

    def print_board()
        puts @array.map { |x| x.join(' ') }
        #puts @guess_array.map { |x| x.join(' ') }
    end

    def human_play()
        puts "Make your guess from the following colors (Red, Green, Blue, Yellow, Purple, Orange)"
        puts "(type first letter of each guess. eg BBGR (Blue Blue Green Red)"
        @array[@current_round-1] = gets.chomp.upcase.split("")
        #@array[@current_round-1] += response_array
        @current_round += 1
    end

end

class GamePlay
    
    def initialize()
    end
end

class ComputerPlay
    attr_reader :colors, :code
    def initialize(code_size)
        @colors = ["R", "G", "B", "Y", "P", "O"] #red, green, blue, yellow, purple, orange
        @code = [@colors.sample, @colors.sample, @colors.sample, @colors.sample]
        @code_size = code_size
    end

    def comp_evaluate(array)
        colors_correct = @code_size - (@code - array).length
        correct_peg = 0
        i = 0
        @code.each do |x|
            if x == array[i]
                correct_peg +=1
                colors_correct -=1
            end
            i+=1
        end
        
            
        
        if @code == array
            puts "You Win"
            return true
        elsif correct_peg > 0 || colors_correct > 0
            array.push("-- Correct Pegs: #{correct_peg} and Correct Colors: #{colors_correct}")
            #puts "#{guesses}"
            return false
        else
            puts "none right"
        end
    end
end




    

def play()
=begin
    #start the game
    puts "what size code would you like to play (4, 6, 8, 10, or 12)?"
    code_size = gets.chomp

    puts "how many turns (8, 10, or 12)?"
    num_turns = gets.chomp

    puts "how many rounds (2, 4, or 6)?"
    num_rounds = gets.chomp
=end
code_size = 4
num_turns = 10
num_rounds = 2
    board = Board.new(code_size, num_turns, num_rounds)
    comp = ComputerPlay.new(board.code_size)
    
    i = 0
    gameover = false
    while i < num_turns && gameover == false
        puts "#{comp.code} - this is the code to break"
        board.human_play
        if comp.comp_evaluate(board.array[i])
            break
        end
        board.print_board
        i+=1
        #puts board.array[0]
    end
    puts "GAMEOVER"
end

play()