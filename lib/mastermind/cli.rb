require 'mastermind/interact'

module Mastermind
  class CLI
    attr_accessor :command
    attr_reader :interact, :instream, :outstream, :game

    def initialize(instream, outstream)
      @instream  = instream
      @outstream = outstream
      @command   = ""
      @interact  = Mastermind::Interact.new
    end

    def run
      outstream.puts interact.screen_clear
      outstream.puts interact.print_title
      outstream.puts interact.print_intro
      until quit?
        get_command
        process_command
      end
    end

    def get_command
      outstream.print interact.command_prompt
      self.command = instream.gets.strip.upcase
    end

    def process_command
      case
      when quit?         then outstream.puts interact.print_farewell
      when instructions? then outstream.puts interact.print_instructions
      when play?         then Mastermind::PlayGame.new(instream, outstream, interact).run
      else                    outstream.puts interact.print_invalid(command)
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
