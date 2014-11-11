require 'mastermind/interact'
require 'mastermind/game_round'

module Mastermind
  class PlayGame
    attr_accessor :interact, :instream, :outstream

    def initialize(instream, outstream, interact)
      @instream  = instream
      @outstream = outstream
      @interact  = interact
    end

    def run
      outstream.puts interact.print_game_info
      round = Mastermind::GameRound.new(instream, outstream, interact)
      round.play
      outstream.puts interact.print_intro
    end
  end
end
