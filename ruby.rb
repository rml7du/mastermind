require 'pry'

class Array
    def subtract_once(values) #used to count colors correct
        counts = values.inject(Hash.new(0)) { |h, v| h[v] += 1; h }
        reject { |e| counts[e] -= 1 unless counts[e].zero? }
    end
end

class Board

    attr_reader :array, :code_size, :human_code, :current_turn
    
    def initialize(code_size, num_turns, num_rounds)
        @code_size = code_size
        @num_turns = num_turns
        @num_rounds = num_rounds
        @current_turn = 1
        @array = Array.new(@num_turns){Array.new(@code_size, "o")}
        @human_code
    end

    def print_board()
        puts @array.map { |x| x.join(' ') }
    end

    def human_play()
        puts "Make your guess from the following colors (Red, Green, Blue, Yellow, Purple, Orange - type first letter of each guess"
        @array[@current_turn-1] = gets.chomp.upcase.split("")
        @current_turn += 1
    end

    def human_code_generator()
        puts "enter the code you are using, ensure is #{@code_size} long. choose from (RGBYPO)"
        @human_code = gets.chomp.upcase.split("")
        puts "human code: #{@human_code}"
    end
    
    def human_eval(previous_guess_array)
        puts "Time to evaluate the guess, enter 0 if completely wrong, "\
        "1 if color is correct, and 2 if color/location both correct.
        Your Code:  #{@human_code}
        Comp Guess: #{previous_guess_array}"


        response_array = gets.chomp.upcase.split("")
        response_array
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
        @num_correct = 0 #for guessing code
        @col_correct = 0 #for guessing code
        @current_turn = 1
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

    def comp_guess(turn_array, previous_guess_array, response_array, code)
        
        if !response_array.include?("1") && !response_array.include?("2")
            puts "step one of comp_guess #{response_array}"
            i=0
            until i == @code_size
                previous_guess_array[i] = ("#{@colors.sample}")
                i+=1
            end
        elsif @num_correct == @code_size
            puts "Computer Wins by guessing the code #{previous_guess_array}"
            previous_guess_array
        elsif response_array.include?("1") || response_array.include?("2")
            i = 0
            binding.pry
            response_array.each do |x|
                if x == 0
                    previous_guess_array[i] = @colors.sample
                elsif x == 2
                    puts "the value of #{i} and #{previous_guess_array[i]}"
                    previous_guess_array[i] = previous_guess_array[i]
                    @num_correct +=1
                else 
                end
                i+=1
            end
        end
        turn_array[@current_turn-1] = previous_guess_array
        @current_turn += 1
        
        puts "previous guess array #{previous_guess_array}"
        previous_guess_array
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
    comp = ComputerPlay.new(code_size)

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

def computer_guess_play()
    puts "what size code would you like to play (4, 6, or 8 - 4 is standard)?"
    code_size = gets.chomp.to_i

    puts "how many turns (even number - 12 is standard)?"
    num_turns = gets.chomp.to_i

    puts "how many rounds (even number)?"
    num_rounds = gets.chomp.to_i

    board = Board.new(code_size, num_turns, num_rounds)
    comp = ComputerPlay.new(code_size)
    previous_guess_array = Array.new(code_size, "0")
    response_array = Array.new(code_size, "0")
    #eval_array = Array.new(code_size)
    code = board.human_code_generator()

    i = 0

    while i < num_turns 
        previous_guess_array = comp.comp_guess(board.array[i], previous_guess_array, response_array, code)
        board.print_board

        response_array = board.human_eval(previous_guess_array)
        #puts "#{comp.code} - this is the code to break"
        
        #if comp.comp_evaluate(board.array[i])
        #    break
        #end
        
        i+=1
        if i == num_turns 
            puts "GAMEOVER - COMPUTER LOSES!!"
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