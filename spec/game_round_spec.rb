require 'mastermind/player'
require 'mastermind/game_round'
require 'mastermind/interact'
require 'mastermind/processor'
require 'spec_helper'
require 'stringio'

RSpec.describe Mastermind::GameRound do
  attr_accessor :stdin, :stdout, :interact
  before do
    self.stdin = StringIO.new("\nSimon\nAlvin\n")
    self.stdout = StringIO.new
    self.interact = Mastermind::Interact.new
  end

  it "should generate a random secret when there is one player" do
    game = Mastermind::PlayGame.new(stdin, stdout, interact)
    players = game.player_gen(1)
    round = Mastermind::GameRound.new(stdin, stdout, interact, players)
    expect(round.players[0].secret).to eql(["X", "X", "X", "X"])
    thread = Thread.new do
      round.play
      binding.pry
    end
    sleep(0.1)
    player = round.players[0]
    colors = Mastermind::Processor.colors(6)
    expect(player.secret).to_not eql(["X", "X", "X", "X"])
    expect(Mastermind::Processor.validate(player.secret.join, player.secret, colors)).to be_truthy
    thread.kill
  end

  context "when generating a single player secret" do
    before do
      @game = Mastermind::PlayGame.new(stdin, stdout, interact)
      @players = @game.player_gen(1)
      @round = Mastermind::GameRound.new(stdin, stdout, interact, @players)
    end

    it "knows the initial state of the secret is invalid" do
      expect(@round.players[0].secret).to eql(["X", "X", "X", "X"])
    end

    it "changes the secret from its initial state" do
      thread = Thread.new do
        @round.play
      end
      sleep(0.1)
      player = @round.players[0]
      expect(player.secret).to_not eql(["X", "X", "X", "X"])
      thread.kill
    end

    it "generates a valid secret" do
      thread = Thread.new do
        @round.play
      end
      sleep(0.1)
      player = @round.players[0]
      colors = Mastermind::Processor.colors(6)
      expect(Mastermind::Processor.validate(player.secret.join, player.secret, colors)).to be_truthy
      thread.kill
    end
  end

  context "when generating multi player secrets" do
    before do
      stdin.string = "m\nSimon\nTheodore\nrrrr\nrrrr\n"
      @game = Mastermind::PlayGame.new(stdin, stdout, interact)
      @players = @game.player_gen(2)
      @round = Mastermind::GameRound.new(stdin, stdout, interact, @players)
    end

    it "knows the initial state of each players secret is invalid" do
      expect(@round.players[0].secret).to eql(["X", "X", "X", "X"])
      expect(@round.players[1].secret).to eql(["X", "X", "X", "X"])
    end

    it "changes the secret from its initial state" do
      thread = Thread.new do
        @round.play
      end
      sleep(0.1)
      player = @round.players[0]
      expect(player.secret).to_not eql(["X", "X", "X", "X"])
      expect(player.secret).to eql(["R", "R", "R", "R"])
      thread.kill
    end

    it "generates a valid secret" do
      thread = Thread.new do
        @round.play
      end
      sleep(0.1)
      player = @round.players[0]
      colors = Mastermind::Processor.colors(6)
      expect(Mastermind::Processor.validate(player.secret.join, player.secret, colors)).to be_truthy
      thread.kill
    end
  end

  it "loads a list of valid colors" do
    game = Mastermind::PlayGame.new(stdin, stdout, interact)
    players = game.player_gen(1)
    round = Mastermind::GameRound.new(stdin, stdout, interact, players)
    expect(round.valid_colors).to eql(["R", "Y", "G", "B", "P", "M"])
  end

  it "sets max guesses to 12 for single difficulty model" do
    game = Mastermind::PlayGame.new(stdin, stdout, interact)
    players = game.player_gen(1)
    round = Mastermind::GameRound.new(stdin, stdout, interact, players)
    expect(round.max_guesses).to eql(12)
  end

  context "when resetting a Players' round info before the round" do
    before do
      @game = Mastermind::PlayGame.new(stdin, stdout, interact)
      @players = @game.player_gen(2)
      @round = Mastermind::GameRound.new(stdin, stdout, interact, @players)
    end

    # NOTE: alternating b/w player 1 and 2 to verify it works for each player

    it "resets the players password to XXXX" do
      @round.players[0].secret = ["Z", "Z", "Z", "Z"]
      expect(@round.players[0].secret).to_not eql(["X", "X", "X", "X"])
      @round.player_reset
      expect(@round.players[0].secret).to eql(["X", "X", "X", "X"])
    end

    it "sets the players round_over status to false" do
      @round.players[1].round_over = true
      expect(@round.players[1].round_over).to be_truthy
      @round.player_reset
      expect(@round.players[1].round_over).to be_falsey
    end

    it "clears the players guess log" do
      @round.players[0].guesses = ["gggg", "gggg"]
      expect(@round.players[0].guesses).to_not be_empty
      @round.player_reset
      expect(@round.players[0].guesses).to be_empty
    end

    it "it resets the time counter" do
      test_time = Time.now
      @round.player_reset
      expect(@round.players[1].start_time).to be_within(1).of(test_time)
    end

    it "it resets the completion time to nil" do
      @round.players[0].completion_time = Time.new - 500
      expect(@round.players[0].completion_time).to_not be_nil
      @round.player_reset
      expect(@round.players[0].completion_time).to be_nil
    end

    it "resets a players turn position" do
      @round.players[1].turn_pos = 1
      expect(@round.players[1].turn_pos).to_not be_nil
      @round.player_reset
      expect(@round.players[1].turn_pos).to be_nil
    end

  end

  it "it has a blank global string command to start with" do
    game = Mastermind::PlayGame.new(stdin, stdout, interact)
    players = game.player_gen(1)
    round = Mastermind::GameRound.new(stdin, stdout, interact, players)
    expect(round.command).to eql("")
  end

  it "is not round over by default" do
    game = Mastermind::PlayGame.new(stdin, stdout, interact)
    players = game.player_gen(1)
    round = Mastermind::GameRound.new(stdin, stdout, interact, players)
    expect(round.round_over).to be_falsey
  end

  it "can identify a winning guess" do
    game = Mastermind::PlayGame.new(stdin, stdout, interact)
    players = game.player_gen(1)
    round = Mastermind::GameRound.new(stdin, stdout, interact, players)
    round.players[0].secret = ["R", "R", "R", "R"]
    round.players[0].command = "RRRR"
    expect(round.correct_guess?(round.players[0])).to be_truthy
  end

  it "knows how many guesses have been taken" do
    stdin = StringIO.new("m\nsimon\ntheo\nrrrr\nrrrr\ngggg\nyyyy\nbbbb\n")
    game = Mastermind::PlayGame.new(stdin, stdout, interact)
    players = game.player_gen(2)
    round = Mastermind::GameRound.new(stdin, stdout, interact, players)
    thread = Thread.new do
      round.play
    end
    sleep(0.1)
    expect(round.num_guesses(players[0])).to eql(2)
    expect(round.num_guesses(players[1])).to eql(1)
    thread.kill
  end

  context "when one player guesses correct" do
    before do
      stdin = StringIO.new("m\nsimon\ntheo\nrrrr\nrrrr\nrrrr\nyyyy\nbbbb\n")
      game = Mastermind::PlayGame.new(stdin, stdout, interact)
      players = game.player_gen(2)
      @round = Mastermind::GameRound.new(stdin, stdout, interact, players)
    end

    it "knows that player1's round is over" do
      thread = Thread.new do
        @round.play
      end
      sleep(0.1)
      expect(@round.players[0].round_over).to be_truthy
      thread.kill
    end

    it "knows that the game round is not over after one player wins" do
      thread = Thread.new do
        @round.play
      end
      sleep(0.1)
      expect(@round.round_over).to be_falsey
      thread.kill
    end

    it "continues prompting for guesses for the other player" do
      thread = Thread.new do
        @round.play
      end
      sleep(0.1)
      expect(@round.num_guesses(@round.players[1])).to eql(2)
      thread.kill
    end
  end

  context "when both players guess correctly" do
    before do
      stdin = StringIO.new("m\nsimon\ntheo\nrrrr\nrrrr\nrrrr\nyyyy\nbbbb\nrrrr\n")
      game = Mastermind::PlayGame.new(stdin, stdout, interact)
      players = game.player_gen(2)
      @round = Mastermind::GameRound.new(stdin, stdout, interact, players)
    end

    it "knows that each players' round is over" do
      thread = Thread.new do
        @round.play
      end
      sleep(0.1)
      expect(@round.players[0].round_over).to be_truthy
      expect(@round.players[1].round_over).to be_truthy
      thread.kill
    end

    it "knows that the game round is over" do
      thread = Thread.new do
        @round.play
      end
      sleep(0.1)
      expect(@round.round_over).to be_truthy
      thread.kill
    end
  end
end
