require 'mastermind/processor'

RSpec.describe Mastermind::Processor do
  it "validates that a guess is valid" do
    valid_length = Mastermind::Processor.valid_length?("RBBY", ["R", "G", "R", "R"])
    expect(valid_length).to be_truthy

    valid_color = Mastermind::Processor.valid_colors?("MRRB", ["R", "G", "B", "Y", "P", "M"])
    expect(valid_color).to be_truthy

    valid = Mastermind::Processor.validate("RGMY", ["R", "G", "B", "Y"], ["R", "G", "B", "Y", "P", "M"])
    expect(valid).to be_truthy
  end

  it "checks how many colors are correct but not in the correct position" do
    colors = Mastermind::Processor.num_correct_colors("YBBB", ["B", "P", "P", "Y"])
    expect(colors).to eql(2)
  end
end
