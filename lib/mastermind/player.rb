module Mastermind
  class Player
    attr_reader :name
    attr_accessor :secret, :command, :guesses, :round_over, :start_time, :completion_time

    def initialize(name)
      @secret     = ["X", "X", "X", "X"]
      @name       = name
      @round_over = false
      @guesses    = []
      @command    = ""
      @start_time = nil
      @completion_time = nil
    end
  end
end
