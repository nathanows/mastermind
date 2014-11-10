require 'mastermind/play_game'
require 'colorize'

module Mastermind
  class Interact
    attr_accessor :stdin, :stdout

    def initialize(stdin, stdout)
      self.stdin = stdin
      self.stdout = stdout
    end

    def print_title
      stdout.puts %q(
___       ___                                                                               ___ 
`MMb     dMM'                                                            68b                `MM 
 MMM.   ,PMM                      /                                      Y89                 MM 
 M`Mb   d'MM    ___      ____    /M       ____   ___  __ ___  __    __   ___ ___  __     ____MM 
 M YM. ,P MM  6MMMMb    6MMMMb\ /MMMMM   6MMMMb  `MM 6MM `MM 6MMb  6MMb  `MM `MM 6MMb   6MMMMMM 
 M `Mb d' MM 8M'  `Mb  MM'    `  MM     6M'  `Mb  MM69 "  MM69 `MM69 `Mb  MM  MMM9 `Mb 6M'  `MM 
 M  YM.P  MM     ,oMM  YM.       MM     MM    MM  MM'     MM'   MM'   MM  MM  MM'   MM MM    MM 
 M  `Mb'  MM ,6MM9'MM   YMMMMb   MM     MMMMMMMM  MM      MM    MM    MM  MM  MM    MM MM    MM 
 M   YP   MM MM'   MM       `Mb  MM     MM        MM      MM    MM    MM  MM  MM    MM MM    MM 
 M   `'   MM MM.  ,MM  L    ,MM  YM.  , YM    d9  MM      MM    MM    MM  MM  MM    MM YM.  ,MM 
_M_      _MM_`YMMM9'Yb.MYMMMM9    YMMM9  YMMMM9  _MM_    _MM_  _MM_  _MM__MM__MM_  _MM_ YMMMMMM_
      ).colorize(:green)
    end

    def print_intro
      stdout.puts
      stdout.puts "&%&%&%&%&%&%&%&%&%&%&%&%&%&&%%&%%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%".colorize(:green)
      stdout.puts
      stdout.puts
      stdout.puts "                         #====================================#"
      stdout.puts "                         #        MASTERMIND MAIN MENU        #"
      stdout.puts "                         #------------------------------------#"
      stdout.puts "                         #                                    #"
      stdout.puts "                         #          (i)nstructions            #"
      stdout.puts "                         #          (p)lay the game           #"
      stdout.puts "                         #          (q)uit                    #"
      stdout.puts "                         #                                    #"
      stdout.puts "                         #====================================#"
      stdout.puts
    end

    def get_input
      stdout.print "Enter command: "
      stdin.gets.chomp.upcase
    end

    def screen_clear
      stdout.puts "\e[H\e[2J"
    end

    def get_guess
      stdout.print "Enter guess: "
      stdin.gets.chomp.upcase
    end

    def print_invalid(input)
      stdout.print "'#{input}' is not a valid command, please enter a valid command."
    end

    def print_out_of_guesses(secret)
      stdout.puts
      stdout.puts
      stdout.puts "                  *****************************************************"
      stdout.puts "                          Nope, sorry, you are out of guesses."
      stdout.puts "                                      Nice try."
      stdout.puts "                                The secret code was:"
      stdout.puts "                                       #{secret.join(" ")}"
      stdout.puts "                  *****************************************************"
    end

    def print_farewell
      stdout.puts
      stdout.puts "Thanks for playing"
      stdout.puts
    end

    def print_instructions
      stdout.puts "These are the instructions."
    end

    def print_game_info
      stdout.puts ""
    end

    def print_round_intro(colors)
      stdout.puts "A random code consisting of 4 colors has been generated for you.\n"
      stdout.puts
      stdout.puts "The valid color options are:"
      stdout.puts "#{colors}"
      stdout.puts
      stdout.puts "Enter your guess in the form of 'RGBY':"
      stdout.puts "------------------------------"
    end

    def print_round_over
      stdout.puts
      stdout.puts "                         **************************************"
      stdout.puts "                         *             Round over             *"
      stdout.puts "                         **************************************"
      stdout.puts
    end

    def print_are_you_sure
      stdout.puts
      stdout.puts "Are you sure you want to quit? (y)es/(n)o".colorize(:red)
    end

    def print_invalid_guess(invalid_command)
      stdout.puts "'#{invalid_command}' is not a valid guess, please guess again."
    end

    def print_guess_stats(number_guesses, correct_pos, correct_color, guess, max_guesses)
      stdout.puts
      stdout.puts "Guess ##{number_guesses} (#{color_guess(guess)}): #{max_guesses - number_guesses} guesses remaining"
      stdout.puts "Correct position: #{correct_pos}   Correct colors: #{correct_color}"
      stdout.puts
      stdout.puts "Nope... let's try that again"
      stdout.puts "------------------------------"
    end

    def print_win(number_guesses)
      stdout.puts
      stdout.puts "                  ******************************************************".colorize(:green)
      stdout.puts "                    Congraulations! YOU WIN! Code broken in #{number_guesses} guesses".colorize(:green)
      stdout.puts "                  ******************************************************".colorize(:green)
    end

    def color_guess(code)
      input = code.kind_of?(Array) ? code : code.chars
      colored = []
      input.map { |char| colored << char.colorize(color_code(char)) }
      colored.join("")
    end

    def color_code(letter)
      Mastermind::COLOR_CODES[letter]
    end
  end
end
