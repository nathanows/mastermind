require "mastermind/version"

module Mastermind
  COLORS = ["R", "Y", "G", "B", "P", "M"]

  COLOR_NAMES = {
    "R" => "(r)ed",
    "Y" => "(y)ellow",
    "G" => "(g)reen",
    "B" => "(b)lue",
    "P" => "(p)ink",
    "M" => "(m)agenta"
  }

  COLOR_CODES = {
    "R" => :red,
    "Y" => :yellow,
    "G" => :green,
    "B" => :blue,
    "P" => :magenta,
    "M" => :light_magenta
  }

  def self.color_option_string(num_colors)
    COLOR_NAMES.values.first(num_colors).join(" | ")
  end

end
