module GuessFeedback
    
    def evaluate_both(guess)
        colors_correct = @code_size - @code.subtract_once(guess).length
        correct_peg = 0
        i = 0
        @code.each do |x|
            if x == guess[i]
                correct_peg +=1
                colors_correct -=1
            end
            i+=1
        end

        if @code == guess
            puts "You Win, the correct code was #{guess}"
        else 
            guess.push("-- Correct Pegs: #{correct_peg} and Correct Colors: #{colors_correct}")
        end
        return [correct_peg, colors_correct]
    end

    def evaluate_location(code_copy, guess)
       correct_peg = 0
        i = 0
        code_copy.each do |x|
            if x == guess[i]
                correct_peg +=1
            end
            i+=1
        end
        return correct_peg
    end

    def evaluate_color(code_copy, guess)
        colors_correct = @code_size - @code.subtract_once(guess).length
        i = 0
        code_copy.each do |x|
            if x == guess[i]
                colors_correct -=1
            end
            i+=1
        end
        return colors_correct
    end
end

class Array
    def subtract_once(values) #used to count colors correct
        counts = values.inject(Hash.new(0)) { |h, v| h[v] += 1; h }
        reject { |e| counts[e] -= 1 unless counts[e].zero? }
    end
end

class Board

    attr_reader :code_size, :code
    attr_accessor :current_turn, :array
    
    def initialize(code_size, num_turns, num_rounds)
        @code_size = code_size
        @num_turns = num_turns
        @num_rounds = num_rounds
        @current_turn = 1
        @array = Array.new(@num_turns){Array.new(@code_size, "o")}
        @code
    end

    def print_board()
        puts "--------------------------------------------------"
        puts @array.map { |x| x.join(' ') }
        puts "--------------------------------------------------"
    end
end

class Player
    include GuessFeedback

    def initialize(code_size)
        @code_size = code_size
        @current_turn = 1
        @code
    end

    def human_guess(array)
        puts "Make your guess from the following colors (Red, Green, Blue, Yellow, Purple, Orange - type first letter of each guess"
        array[@current_turn-1] = gets.chomp.upcase.split("")
        while !valid_code(array[@current_turn-1])
            puts "Please enter a valid guess (RGBYPO) #{@code_size} long: "
            array[@current_turn-1] = gets.chomp.upcase.split("")
        end
        @current_turn += 1
    end

    def human_code_generator()
        puts "enter the code you are using, ensure is #{@code_size} long. choose from (RGBYPO)"
        @code = gets.chomp.upcase.split("")
        while !valid_code(@code)
            puts "Please enter a valid guess (RGBYPO) #{@code_size} long: "
            @code = gets.chomp.upcase.split("")
        end
        puts "human code: #{@code}"
        @code
    end
    
    def human_eval(previous_guess_array)
        puts "Time to evaluate the guess, enter 0 if completely wrong, "\
        "1 if color is correct, and 2 if color/location both correct.
        Your Code:  #{@code}
        Comp Guess: #{previous_guess_array}"
        response_array = gets.chomp.upcase.split("")
        response_array
    end

    def valid_code(guess)
        guess.length == @code_size && guess.all? { |val| /[RGBYPO]/.match(val) }
    end
end

class ComputerPlay
    include GuessFeedback
    attr_reader :colors, :code
    attr_accessor :num_correct, :col_correct, :guess

    def initialize(code_size)
        @colors = ["R", "G", "B", "Y", "P", "O"] #red, green, blue, yellow, purple, orange
        @code = create_code(code_size) #computer generated code
        @code_size = code_size
        @num_correct = nil #for guessing code
        @col_correct = nil #for guessing code
        @current_turn = 1
        @guess = []
        @possible_guesses = []
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

    def computer_guess(board)
        #based on this methodology: https://puzzling.stackexchange.com/questions/546/clever-ways-to-solve-mastermind 
        #where the computer creates a list of all the permutations and removes all possibilities that would not return
        #the same result of correct locations/colors as the previous guess. 
        if @num_correct == nil && @col_correct == nil
            board[@current_turn-1] = [@colors[0], @colors[0], @colors[1], @colors[1]]
            @guess = [@colors[0], @colors[0], @colors[1], @colors[1]]
            @possible_guesses = @colors.repeated_permutation(@code_size).to_a
        else
            @possible_guesses.delete_if do |arr|
                arr_copy = arr.dup
                @num_correct != evaluate_location(arr_copy, @guess) && @col_correct != evaluate_color(arr_copy, @guess)
            end
            @guess = @possible_guesses.first
            board[@current_turn-1] = @guess
        end
        @current_turn +=1
        @guess
    end
end

def human_code_breaker(code_size, num_turns, num_rounds)

    board = Board.new(code_size, num_turns, num_rounds)
    player = Player.new(code_size)
    comp = ComputerPlay.new(code_size)

    i = 0

    while i < num_turns 
        puts "turn #{i}"
        player.human_guess(board.array)
        response = comp.evaluate_both(board.array[i])
        puts "response: #{response}, codesize: #{code_size}"
        if response[0] == code_size
            break
        end
        board.print_board
        i+=1
        if i == num_turns 
            puts "GAMEOVER - YOU LOSE!! #{comp.code} - this was the code to break"
        end
    end
end

def computer_code_breaker(code_size, num_turns, num_rounds)

    board = Board.new(code_size, num_turns, num_rounds)
    comp = ComputerPlay.new(code_size)
    player = Player.new(code_size)
    code = player.human_code_generator()
    response = [nil,nil]

    i = 0

    while i < num_turns 
        puts "turn #{i}"
        guess = comp.computer_guess(board.array)
        puts "comp guess: #{guess}"

        comp.num_correct = player.evaluate_location(code, guess)
        comp.col_correct = player.evaluate_color(code, guess)

        puts "#{comp.num_correct} correct pegs and #{comp.col_correct} correct colors"
        puts ""
        
        if comp.num_correct == code_size
            puts "Computer WINS by guessing #{guess}"
            break
        end
        i+=1
        if i == num_turns 
            puts "GAMEOVER - COMPUTER LOSES!!"
        end
    end  
end

#set up the game
puts "Do you want to create the code (type '1') or guess the code (type '2')"
user_choice = gets.chomp
puts "what size code would you like to play (4, 6, or 8 - 4 is standard)?"
code_size = gets.chomp.to_i
puts "how many turns (even number - 12 is standard)?"
num_turns = gets.chomp.to_i
#puts "how many rounds (even number)?"
num_rounds = 1 #gets.chomp.to_i

if user_choice == "1"
    computer_code_breaker(code_size, num_turns, num_rounds)
elsif user_choice == "2"
    human_code_breaker(code_size, num_turns, num_rounds)
else puts "Bad Selection, Good Bye!"
end