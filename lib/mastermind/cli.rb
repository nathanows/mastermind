require 'mastermind/interact'

module Mastermind
  class CLI
    attr_accessor :command, :game
    attr_reader :interact

    def initialize
      self.command = ""
      @interact = Mastermind::Interact.new($stdin, $stdout)
      @game = Mastermind::PlayGame.new
    end

    def run
      interact.screen_clear
      interact.print_title
      interact.print_intro
      until quit?
        get_command
        process_command
      end
    end

    def get_command
      self.command = interact.get_input
    end

    def process_command
      case
      when quit?         then interact.print_farewell
      when instructions? then interact.print_instructions
      when play?         then game.run
      else                    puts interact.print_invalid(command)
      end
    end

    def quit?
      command == 'Q' || command == 'QUIT'
    end

    def play?
      command == 'P' || command == 'PLAY'
    end

    def instructions?
      command == 'I' || command == 'INSTRUCTIONS'
    end
  end
end
