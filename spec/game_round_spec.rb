require 'mastermind/player'
require 'mastermind/game_round'
require 'mastermind/interact'
require 'mastermind/processor'
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

  #context "when generating multi player secrets" do
    #before do
      #@game = Mastermind::PlayGame.new(stdin, stdout, interact)
      #@players = @game.player_gen(2)
      #@round = Mastermind::GameRound.new(stdin, stdout, interact, @players)
    #end

    #it "knows the initial state of each players secret is invalid" do
      #expect(@round.players[0].secret).to eql(["X", "X", "X", "X"])
      #expect(@round.players[1].secret).to eql(["X", "X", "X", "X"])
    #end

    #it "changes the secret from its initial state" do
      #thread = Thread.new do
        #allow(@round).to receive(:secret_gen).and_return(["R", "R", "R", "R"])
        #@round.play
      #end
      #sleep(0.5)
      #player = @round.players[0]
      #expect(player.secret).to_not eql(["X", "X", "X", "X"])
      #thread.kill
    #end

    #it "generates a valid secret" do
      #thread = Thread.new do
        #@round.play
      #end
      #sleep(0.1)
      #player = @round.players[0]
      #colors = Mastermind::Processor.colors(6)
      #expect(Mastermind::Processor.validate(player.secret.join, player.secret, colors)).to be_truthy
      #thread.kill
    #end
  #end

  #it "should load a secret" do
    #expect(@game.secret.length).to eql(4)
  #end

  #it "loads a list of valid colors" do
    #expect(@game.valid_colors).to eql(["R", "Y", "G", "B", "P", "M"])
  #end

  #it "sets max guesses to 12 for single difficulty model" do
    #expect(@game.max_guesses).to eql(12)
  #end

  #it "it has a blank string command to start with" do
    #expect(@game.command).to eql("")
  #end

  #it "does not have any guesses by default" do
    #expect(@game.guesses).to be_empty
  #end

  #it "is not round over by default" do
    #expect(@game.round_over).to be_falsey
  #end

  #it "can identify a winning guess" do
    #@game.secret = ["R", "R", "R", "R"]
    #@game.command = "RRRR"
    #expect(@game.correct_guess?).to be_truthy
  #end

  #it "knows how many guesses have been taken" do
    #@game.secret = ["R", "R", "R", "R"]
    #@game.command = "BBBB"
    #expect(@game.num_guesses).to eql(0)
    #@game.guess
    #expect(@game.num_guesses).to eql(1)
  #end
end
