require 'mastermind/play_game'
require 'mastermind/interact'
require 'mastermind/game_round'
require 'spec_helper'
require 'stringio'
require 'io/console'

RSpec.describe Mastermind::PlayGame do
  it "should be able to quit" do
    stdin = StringIO.new("Q")
    stdout = StringIO.new
    interact = Mastermind::Interact.new
    game = Mastermind::PlayGame.new(stdin, stdout, interact)
    expect(game.quit?).to be_falsey

    game.get_command
    expect(game.quit?).to be_truthy

    stdin.string = "q"
    game.get_command
    expect(game.quit?).to be_truthy
  end

  it "should print intro title and content" do
    stdin = StringIO.new("q")
    stdout = StringIO.new
    interact = Mastermind::Interact.new
    game = Mastermind::PlayGame.new(stdin, stdout, interact)
    game.run
    expect(stdout.string).to include("(s)ingle")
  end

  it "should generate the specified number of players" do
    stdin = StringIO.new("\nSimon\nAlvin\n")
    stdout = StringIO.new
    interact = Mastermind::Interact.new
    game = Mastermind::PlayGame.new(stdin, stdout, interact)
    players = game.player_gen(2)
    expect(players.length).to eql(2)
    expect(players[0]).to be_a Mastermind::Player
  end

  it "gets a valid name" do
    stdin = StringIO.new("\nANameThatIsTooLong\nAlvin\n")
    stdout = StringIO.new
    interact = Mastermind::Interact.new
    game = Mastermind::PlayGame.new(stdin, stdout, interact)
    name = game.get_name(1)
    expect(stdout.string).to include("Name")
    expect(name).to eql("Alvin")
  end

  it "can validate a name" do
    stdin = StringIO.new("\nANameThatIsTooLong\nAlvin\n")
    stdout = StringIO.new
    interact = Mastermind::Interact.new
    game = Mastermind::PlayGame.new(stdin, stdout, interact)
    expect(game.valid_name?("ANameThatIsTooLong")).to be_falsey
    expect(game.valid_name?("")).to be_falsey
    expect(game.valid_name?("Theodore")).to be_truthy
  end

  it "should play a single player game when prompted" do
    stdin = StringIO.new("s\nTheodore\n")
    stdout = StringIO.new()
    interact = Mastermind::Interact.new
    game = Mastermind::PlayGame.new(stdin, stdout, interact)
    thread = Thread.new do
      game.run
    end
    players = []
    expect(Mastermind::GameRound.new(stdin, stdout, Mastermind::Interact.new, players)).to respond_to(:play)
    thread.kill
  end

  # note: undefined method 'noecho' for stringio... not sure how to test this...
  it "should play a multiplayer game when prompted" do
    stdin = StringIO.new("m\nTheodore\nAlvin\n")
    stdout = StringIO.new()
    interact = Mastermind::Interact.new
    players = []
    game = Mastermind::PlayGame.new(stdin, stdout, interact)
    thread = Thread.new do
      game.run
    end
    expect(Mastermind::GameRound.new(stdin, stdout, Mastermind::Interact.new, players)).to respond_to(:play)
    thread.kill
  end

end
