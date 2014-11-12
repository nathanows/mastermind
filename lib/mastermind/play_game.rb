require 'mastermind/interact'
require 'mastermind/game_round'
require 'mastermind/player'

module Mastermind
  class PlayGame
    attr_accessor :interact, :instream, :outstream, :command

    def initialize(instream, outstream, interact)
      @instream  = instream
      @outstream = outstream
      @interact  = interact
      @command   = ""
    end

    def run
      outstream.puts interact.print_game_info
      outstream.puts interact.print_game_options
      until quit?
        outstream.print interact.command_prompt
        self.command = instream.gets.strip.upcase
        process_command
      end
      outstream.puts interact.print_intro
    end

    def process_command
      case
      when command == "S"
        players = player_gen(1)
        Mastermind::GameRound.new(instream, outstream, interact, players).play
      when command == "M"
        players = player_gen(2)
        Mastermind::GameRound.new(instream, outstream, interact, players).play
      else                    outstream.puts interact.print_invalid(command)
      end
    end

    def player_gen(num_players)
      players = []
      outstream.puts interact.print_player_intro
      num_players.times do |i|
        name = get_name(i+1)
        players << Player.new(name)
      end
      players
    end

    def get_name(player_no)
      name = ""
      until valid_name?(name)
        outstream.print interact.name_prompt(player_no)
        name = instream.gets.strip
      end
      name
    end

    def valid_name?(name)
      name.length > 0 && name.length < 12
    end

    def quit?
      command == "Q" || command == "QUIT"
    end
  end
end
