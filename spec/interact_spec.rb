require 'mastermind/interact'

RSpec.describe Mastermind::Interact do
  before do
    @interact = Mastermind::Interact.new
  end

  it 'can return a colored string given a string input' do
    colored = @interact.color_guess("R")
    expect(colored).to eql("\e[0;31;49mR\e[0m")
  end

  it 'prints an intro title' do
    expect(@interact.print_title).to include("0;32;49m")
  end

  it 'prints the main menu' do
    expect(@interact.print_intro).to include("(i)")
  end

  it 'prints an invalid command message' do
    invalid_cmd = "XXXX"
    expect(@interact.print_invalid(invalid_cmd)).to include("not a valid")
    expect(@interact.print_invalid(invalid_cmd)).to include(invalid_cmd)
  end

  it 'prints a round over message' do
    expect(@interact.print_round_over).to include("Round over")
  end

  it 'prints an invalid guess message' do
    invalid_cmd = "XXXX"
    expect(@interact.print_invalid_guess(invalid_cmd)).to include("not a valid")
    expect(@interact.print_invalid_guess(invalid_cmd)).to include(invalid_cmd)
  end

end
