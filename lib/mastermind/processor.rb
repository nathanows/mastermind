require 'mastermind'
require 'pry'

module Mastermind
  class Processor
    def self.secret(length, num_colors)
      secret = []
      length.times do
        secret << colors(num_colors).sample
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
      non_posd = code.select.with_index { |letter, i| letter != guess[i] }
      colors = []
      guess.chars.map do |letter|
        idx = non_posd.find_index { |char| letter == char }
        colors << non_posd.delete_at(idx) if idx
      end
      colors.length
    end

    def self.num_correct_pos(guess, code)
      guess.chars.zip(code).count { |comp| comp[0] == comp[1] }
    end
  end
end
