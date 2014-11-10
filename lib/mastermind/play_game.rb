require 'mastermind/interact'
require 'mastermind/game_round'

module Mastermind
  class PlayGame
    attr_accessor :interact

    def initialize
      self.interact = Mastermind::Interact.new($stdin, $stdout)
    end

    def run
      interact.print_game_info
      round = Mastermind::GameRound.new
      round.play
      interact.print_intro
    end
  end
end
