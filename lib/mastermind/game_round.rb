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
                  :max_guesses

    def initialize
      self.secret       = Mastermind::Processor.secret(4, 6)
      self.interact     = Mastermind::Interact.new($stdin, $stdout)
      self.valid_colors = Mastermind::Processor.colors(6)
      self.max_guesses  = 12
      self.command      = ""
      self.guesses      = []
      self.round_over    = false
    end

    def play
      interact.print_round_intro(color_string)
      until quit? || round_over
        self.command = interact.get_guess
        process_command
      end
    end

    def process_command
      case
      when quit?          then quit_confirm
      when !valid_guess?  then interact.print_invalid_guess(command)
      when valid_guess?   then guess
      end
    end

    def color_string
      Mastermind.color_option_string(6)
    end

    def round_over!
      self.round_over = true
      interact.print_round_over
    end

    def win!
      interact.print_win(num_guesses)
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
      interact.print_out_of_guesses(secret)
      round_over!
    end

    def guess
      guesses << command
      if    correct_guess?      then win!
      elsif !guesses_remaining? then out_of_guesses
      else  interact.print_guess_stats(num_guesses, correct_pos, correct_color, command, max_guesses)
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
      interact.print_are_you_sure
      confirmation = interact.get_input
      case confirmation
      when "Y", "YES" then self.command = "Q"
      else                 self.command = ""
      end
    end
  end
end
