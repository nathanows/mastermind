require 'mastermind/play_game'
require 'colorize'

module Mastermind
  class Interact
    def print_title
      %q(
    _/      _/                        _/                                          _/                  _/
   _/_/  _/_/    _/_/_/    _/_/_/  _/_/_/_/    _/_/    _/  _/_/  _/_/_/  _/_/        _/_/_/      _/_/_/
  _/  _/  _/  _/    _/  _/_/        _/      _/_/_/_/  _/_/      _/    _/    _/  _/  _/    _/  _/    _/
 _/      _/  _/    _/      _/_/    _/      _/        _/        _/    _/    _/  _/  _/    _/  _/    _/
_/      _/    _/_/_/  _/_/_/        _/_/    _/_/_/  _/        _/    _/    _/  _/  _/    _/    _/_/_/
      ).colorize(:green)
    end

    def line_break
      "
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
      ".colorize(:green)
    end

    def blank_line
      "\n"
    end

    def print_intro
      line_break +
      blank_line +
      "
                           ====================================
                          |        M4573RM1ND MA1N M3NV        |
                          | ---------------------------------- |
                          |                                    |
                          |          (i)NStRUCti0nZ            |
                          |          (p)1aY the g4M3           |
                          |          (q)V1t                    |
                          |                                    |
                           ====================================
      ".colorize(:green) +
      blank_line
    end


    def print_game_options
      line_break +
      blank_line +
      "
                           ====================================
                          |        M4573RM1ND 9AM3 0PTZ        |
                          |------------------------------------|
                          |                                    |
                          |          (s)1nG1e pl4y0r           |
                          |          (m)u171 pl4y0r            |
                          |          (q)V1t                    |
                          |                                    |
                           ====================================
      ".colorize(:green) +
      blank_line
    end

    def command_prompt
      "Enter command: "
    end

    def screen_clear
      "\e[H\e[2J"
    end

    def multi_player_div
      "\n"+
      "Player 1                                    Player 2\n"+
      "==================================================================================="
    end

    def guess_prompt(player)
      if player.turn_pos == 0
      "\n"+
      "#{player.name} - Enter your guess: "
      else
      "\n"+
      "                                            #{player.name} - Enter your guess: "
      end
    end

    def print_invalid(input)
      "
'#{input}' is not a valid command, please enter a valid command.
      "
    end

    def print_out_of_guesses(number_guesses, correct_pos, correct_color, guess, max_guesses, player)
      if player.turn_pos == 0
      "\n"+
      "----------------------------------------\n"+
      "Guess ##{number_guesses} (#{color_guess(guess)}): #{max_guesses - number_guesses} guesses remaining\n"+
      "Correct position: #{correct_pos}   Correct colors: #{correct_color}\n"+
      "\n"+
      "Nope... sorry #{player.name}, that was your last\n"+
      "guess and you still didn't get it right....\n"+
      "The secret code was: #{color_guess(player.secret)}\n"+
      "----------------------------------------\n"
      else
      "\n"+
      "                                            ----------------------------------------\n"+
      "                                            Guess ##{number_guesses} (#{color_guess(guess)}): #{max_guesses - number_guesses} guesses remaining\n"+
      "                                            Correct position: #{correct_pos}   Correct colors: #{correct_color}\n"+
      "\n"+
      "                                            Nope... sorry #{player.name}, that was your last\n"+
      "                                            guess and you still didn't get it right....\n"+
      "                                            The secret code was: #{color_guess(player.secret)}\n"+
      "                                            ----------------------------------------\n"
      end
    end

    def print_farewell
      "
Thanks for playing
      "
    end

    def print_instructions
      "
These are the instructions.
      "
    end

    def print_game_info
      ""
    end

    def print_player_intro
      "Player(s) need to enter their name."
    end

    def name_prompt(player_no)
      "Player #{player_no} Name: "
    end

    def print_player_secret_intro(player_name)
      "
#{player_name} - Pick the secret code for your opponent"
    end

    def secret_guess_prompt
      "Enter secret code: "
    end

    def print_get_secret
      "Time to create some secrets. Each player will create the secret
That their opponent will be guessing."
    end

    def print_round_intro(colors)
      "
A random code consisting of 4 colors has been generated for you.

The valid color options are:
#{colors}

Enter your guess in the form of '#{color_guess("RGBY")}':
------------------------------
      "
    end

    def print_round_over
      "
                          **************************************
                          *             Round over             *
                          **************************************
      "
    end

    def print_are_you_sure
      "
Are you sure you want to quit? (y)es/(n)o".colorize(:red)
    end

    def print_invalid_guess(invalid_command)
"'#{invalid_command}' is not a valid guess, please guess again."
    end

    def print_guess_stats(number_guesses, correct_pos, correct_color, guess, max_guesses, player)
      if player.turn_pos == 0
      "\n"+
      "----------------------------------------\n"+
      "Guess ##{number_guesses} (#{color_guess(guess)}): #{max_guesses - number_guesses} guesses remaining\n"+
      "Correct position: #{correct_pos}   Correct colors: #{correct_color}\n"+
      "\n"+
      "Nope... sorry #{player.name} let's try that again\n"+
      "----------------------------------------\n"
      else
      "\n"+
      "                                            ----------------------------------------\n"+
      "                                            Guess ##{number_guesses} (#{color_guess(guess)}): #{max_guesses - number_guesses} guesses remaining\n"+
      "                                            Correct position: #{correct_pos}   Correct colors: #{correct_color}\n"+
      "\n"+
      "                                            Nope... sorry #{player.name} let's try that again\n"+
      "                                            ----------------------------------------\n"
      end
    end

    def print_win(number_guesses, time, secret, player)
      if player.turn_pos == 0
      "\n"+
      "******************************\n"+
      "       CONGRATULATIONS\n"+
      "******************************\n"+
      " You guessed the code (#{color_guess(secret)})\n"+
      "    It took you #{number_guesses} guesses\n"+
      "       over #{time} seconds!\n"+
      "******************************\n"
      else
      "\n"+
      "                                            ******************************\n"+
      "                                                   CONGRATULATIONS\n"+
      "                                            ******************************\n"+
      "                                             You guessed the code (#{color_guess(secret)})\n"+
      "                                                It took you #{number_guesses} guesses\n"+
      "                                                   over #{time} seconds!\n"+
      "                                            ******************************\n"
      end
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
