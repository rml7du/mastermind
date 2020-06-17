class Array
    def subtract_once(values) #used to count colors correct
        counts = values.inject(Hash.new(0)) { |h, v| h[v] += 1; h }
        reject { |e| counts[e] -= 1 unless counts[e].zero? }
    end
end

class Board

    attr_reader :array, :code_size 
    
    def initialize(code_size, num_turns, num_rounds)
        @code_size = code_size
        @num_turns = num_turns
        @num_rounds = num_rounds
        @current_turn = 1
        @array = Array.new(@num_turns){Array.new(@code_size, "o")}
    end

    def print_board()
        puts @array.map { |x| x.join(' ') }
    end

    def human_play()
        puts "Make your guess from the following colors (Red, Green, Blue, Yellow, Purple, Orange - type first letter of each guess"
        @array[@current_turn-1] = gets.chomp.upcase.split("")
        @current_turn += 1
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
        colors_correct = @code_size - @code.subtract_once(array).length
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
        else 
            array.push("-- Correct Pegs: #{correct_peg} and Correct Colors: #{colors_correct}")
            return false
        end
    end
end

def human_guess_play()
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

    while i < num_turns 
        #puts "#{comp.code} - this is the code to break"
        board.human_play
        if comp.comp_evaluate(board.array[i])
            break
        end
        board.print_board
        i+=1
        if i == num_turns 
            puts "GAMEOVER - YOU LOSE!! #{comp.code} - this was the code to break"
        end
    end
end


puts "Do you want to create the code (type '1') or guess the code (type '2')"
user_choice = gets.chomp
if user_choice == "1"
    computer_guess_play()
elsif user_choice == "2"
    human_guess_play()
else puts "Bad Selection, Good Bye!"
end