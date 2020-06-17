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
        @code = create_code(code_size)
        @code_size = code_size
    end

    def create_code(code_size)
        i=0
        code_creater = []
        until i == code_size
            code_creater.push("#{@colors.sample}")
            i+=1
        end
        return code_creater
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
            return false
        else
            puts "none right"
        end
    end
end

def play()
    #start the game
    puts "what size code would you like to play (4, 6, or 8 - 4 is standard)?"
    code_size = gets.chomp.to_i

    puts "how many turns (even number - 12 is standard)?"
    num_turns = gets.chomp.to_i

    puts "how many rounds (even number)?"
    num_rounds = gets.chomp.to_i

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
        if i == num_turns 
            puts "GAMEOVER - YOU LOSE!!"
        end
    end
end

play()