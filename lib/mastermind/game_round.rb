require 'mastermind/processor'
require 'pry'

module Mastermind
  class GameRound
    attr_accessor :interact,
                  :secret,
                  :valid_colors,
                  :command,
                  :guesses,
                  :round_over,
                  :max_guesses,
                  :instream,
                  :outstream,
                  :interact

    def initialize(instream, outstream, interact)
      @instream     = instream
      @outstream    = outstream
      @interact     = interact
      @secret       = Mastermind::Processor.secret(4, 6)
      @valid_colors = Mastermind::Processor.colors(6)
      @max_guesses  = 12
      @command      = ""
      @guesses      = []
      @round_over    = false
    end

    def play
      outstream.puts interact.print_round_intro(color_string)
      until quit? || round_over
        outstream.print interact.guess_prompt
        self.command = instream.gets.strip.upcase
        process_command
      end
    end

    def process_command
      case
      when quit?          then quit_confirm
      when !valid_guess?  then outstream.puts interact.print_invalid_guess(command)
      when valid_guess?   then guess
      end
    end

    def color_string
      Mastermind.color_option_string(6)
    end

    def round_over!
      self.round_over = true
      outstream.puts interact.print_round_over
    end

    def win!
      outstream.puts interact.print_win(num_guesses)
      round_over!
    end

    def correct_guess?
      command.chars == secret
    end

    def guesses_remaining?
      num_guesses < max_guesses
    end

    def quit?
      command == "Q" || command == "QUIT"
    end

    def out_of_guesses
      outstream.puts interact.print_out_of_guesses(secret)
      round_over!
    end

    def guess
      guesses << command
      if    correct_guess?      then win!
      elsif !guesses_remaining? then out_of_guesses
      else  outstream.puts interact.print_guess_stats(num_guesses, correct_pos, correct_color, command, max_guesses)
      end
    end

    def num_guesses
      guesses.length
    end

    def correct_pos
      Mastermind::Processor.num_correct_pos(command, secret)
    end

    def correct_color
      Mastermind::Processor.num_correct_colors(command, secret)
    end

    def valid_guess?
      Mastermind::Processor.validate(command, secret, valid_colors)
    end

    def quit_confirm
      outstream.puts interact.print_are_you_sure
      outstream.print interact.command_prompt
      confirmation = instream.gets.strip.upcase
      case confirmation
      when "Y", "YES" then self.command = "Q"
      else                 self.command = ""
      end
    end
  end
end
