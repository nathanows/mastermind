require 'mastermind'

module Mastermind
  class Processor
    def self.secret(length, num_colors)
      secret = []
      length.times do
        secret << Mastermind::COLORS.first(num_colors).sample
      end
      secret
    end

    def self.colors(num_colors)
      Mastermind::COLORS.first(num_colors)
    end

    def self.validate(guess, code, valid_colors)
      valid_length?(guess, code) && valid_colors?(guess, valid_colors)
    end

    def self.valid_length?(guess, code)
      guess.length == code.length
    end

    def self.valid_colors?(guess, valid_colors)
      validity = guess.split("").map do |char|
        valid_colors.any? { |color| color == char }
      end
      !validity.any? { |char| char == false }
    end

    def self.num_correct_colors(guess, code)
      match = guess.chars.map.with_index {|char, i| guess[i] == code[i] }
      table = guess.chars.zip(code, match)
      results = table.map { |x| table.map { |y| y[2] == false && x[0] == y[1] } }
      correct = results.map { |rec| rec.any? { |stmt| stmt == true } }
      correct.count(true)
    end

    def self.num_correct_pos(guess, code)
      guess.chars.zip(code).count { |comp| comp[0] == comp[1] }
    end
  end
end
