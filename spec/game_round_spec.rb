require 'mastermind/game_round'
require 'mastermind/interact'
require 'stringio'

RSpec.describe Mastermind::GameRound do
  before do
    instream = StringIO.new
    outstream = StringIO.new
    interact = Mastermind::Interact.new
    @game = Mastermind::GameRound.new(instream, outstream, interact)
  end

  it "should load a secret" do
    expect(@game.secret.length).to eql(4)
  end

  it "loads a list of valid colors" do
    expect(@game.valid_colors).to eql(["R", "Y", "G", "B", "P", "M"])
  end

  it "sets max guesses to 12 for single difficulty model" do
    expect(@game.max_guesses).to eql(12)
  end

  it "it has a blank string command to start with" do
    expect(@game.command).to eql("")
  end

  it "does not have any guesses by default" do
    expect(@game.guesses).to be_empty
  end

  it "is not round over by default" do
    expect(@game.round_over).to be_falsey
  end

  it "can identify a winning guess" do
    @game.secret = ["R", "R", "R", "R"]
    @game.command = "RRRR"
    expect(@game.correct_guess?).to be_truthy
  end

  it "knows how many guesses have been taken" do
    @game.secret = ["R", "R", "R", "R"]
    @game.command = "BBBB"
    expect(@game.num_guesses).to eql(0)
    @game.guess
    expect(@game.num_guesses).to eql(1)
  end
end
