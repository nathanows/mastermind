require 'mastermind/cli'
require 'spec_helper'
require 'stringio'

RSpec.describe Mastermind::CLI do
  it "should be able to quit" do
    stdin = StringIO.new("Q")
    cli = Mastermind::CLI.new(stdin, StringIO.new)
    expect(cli.quit?).to be_falsey

    cli.get_command
    expect(cli.quit?).to be_truthy

    stdin.string = "q"
    cli.get_command
    expect(cli.quit?).to be_truthy
  end

  it "should print intro title and content" do
    stdin = StringIO.new("\nq")
    stdout = StringIO.new()
    cli = Mastermind::CLI.new(stdin, stdout)
    cli.run
    expect(stdout.string).to include("0;32;49m")
    expect(stdout.string).to include("MA1N")
    expect(stdout.string).to include("_/")
  end

  it "should print instructions when prompted" do
    stdin = StringIO.new("i\nq")
    stdout = StringIO.new()
    cli = Mastermind::CLI.new(stdin, stdout)
    cli.run
    expect(stdout.string).to include("(i)")
  end

  it "should play the game when prompted" do
    stdin = StringIO.new("p\nq\nq")
    stdout = StringIO.new()
    cli = Mastermind::CLI.new(stdin, stdout)
    cli.run
    expect(stdout.string).to include("0PTZ")
  end
end
