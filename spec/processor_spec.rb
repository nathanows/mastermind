require 'mastermind/processor'

RSpec.describe Mastermind::Processor do
  it "generates a random 4 char secret code" do
    secret = Mastermind::Processor.secret(4, 6)
    expect(secret.length).to eql(4)
    expect(Mastermind::Processor.valid_colors?(secret.join(""), Mastermind::Processor.colors(6))).to be_truthy
  end

  it "can pull the first x numbers" do
    expect(Mastermind::Processor.colors(3)).to eql(["R", "Y", "G"])
  end

  context "when validating a guess" do
    it "validates that a correct length guess is valid" do
      valid_length = Mastermind::Processor.valid_length?("RBBY", ["R", "G", "R", "R"])
      expect(valid_length).to be_truthy
    end

    it "says that an input containing only valid colors is valid" do
      valid_color = Mastermind::Processor.valid_colors?("MRRB", ["R", "G", "B", "Y", "P", "M"])
      expect(valid_color).to be_truthy
    end

    it "says that an input with the correct length and colors is valid" do
      valid = Mastermind::Processor.validate("RGMY", ["R", "G", "B", "Y"], ["R", "G", "B", "Y", "P", "M"])
      expect(valid).to be_truthy
    end

    it "says that an input that is too long is invalid" do
      invalid = Mastermind::Processor.validate("RG", ["R", "G", "B", "Y"], ["R", "G", "B", "Y", "P", "M"])
      expect(invalid).to be_falsey
    end

    it "says that an input that is too short is invalid" do
      invalid = Mastermind::Processor.validate("XRESRG", ["R", "G", "B", "Y"], ["R", "G", "B", "Y", "P", "M"])
      expect(invalid).to be_falsey
    end

    it "says that an input with invalid letters is invalid" do
      invalid = Mastermind::Processor.validate("RRRX", ["R", "G", "B", "Y"], ["R", "G", "B", "Y", "P", "M"])
      expect(invalid).to be_falsey
    end
  end

  context "when checking a valid guess" do
    it "checks how many colors are correct but not in the correct position once" do
      colors = Mastermind::Processor.num_correct_colors("YBBB", ["B", "P", "P", "Y"])
      expect(colors).to eql(2)
    end

    it "checks how many colors are in the correct position" do
      positions = Mastermind::Processor.num_correct_pos("RGYM", ["R", "M", "G", "M"])
      expect(positions).to eql(2)
    end

  end
end
