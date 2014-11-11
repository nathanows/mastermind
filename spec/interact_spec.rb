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
    expect(@interact.print_title).to include("6MMMMb")
  end

  it 'prints the main menu' do
    expect(@interact.print_intro).to include("(i)nstructions")
  end

  it 'prints an out of guesses message' do
    expect(@interact.print_out_of_guesses(["R", "R", "R", "R"])).to include("out of guesses")
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

  it 'prints guess stats' do
    num_guesses = 4
    cor_pos = 1
    cor_col = 2
    max_guesses = 12
    guess = "RRRR"
    expect(@interact.print_guess_stats(num_guesses, cor_pos, cor_col, guess, max_guesses))
      .to include(num_guesses.to_s, cor_pos.to_s, cor_col.to_s)
  end

end
