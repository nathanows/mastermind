require 'mastermind/processor'
require 'io/console'

module Mastermind
  class GameRound
    attr_accessor :interact,
                  :secret,
                  :valid_colors,
                  :command,
                  :guesses,
                  :round_over,
                  :max_guesses,
                  :instream,
                  :outstream,
                  :interact,
                  :start_time

    def initialize(instream, outstream, interact, players)
      @instream     = instream
      @outstream    = outstream
      @interact     = interact
      @player1_secret = nil
      @player2_secret = nil
      @valid_colors = Mastermind::Processor.colors(6)
      @max_guesses  = 12
      @command      = ""
      @guesses      = []
      @round_over   = false
      @start_time   = Time.now
      @players      = players
    end

    def play
      player_reset
      outstream.puts interact.print_round_intro(color_string)
      secret_gen
      set_turn_pos
      until quit?(@players.first) || quit?(@players.last) || round_over?
        @players.each do |player|
          if player.round_over == false && round_over == false
            outstream.print interact.guess_prompt(player)
            player.command = instream.gets.strip.upcase
            process_command(player)
          end
        end
      end
    end

    def player_reset
      @players.each do |player|
        player.secret = ["X", "X", "X", "X"]
        player.round_over = false
        player.guesses = []
        player.start_time = Time.now
        player.completion_time = nil
        player.turn_pos = nil
      end
    end

    def secret_gen
      if single_player? then @players.first.secret = Mastermind::Processor.secret(4, 6)
      else
        @players.shuffle
        outstream.puts interact.print_get_secret
        @players.last.secret  = get_secret(@players.first)
        @players.first.secret = get_secret(@players.last)
      end
    end

    def get_secret(player)
      outstream.puts interact.print_player_secret_intro(player.name)
      code = "xxxx"
      until valid_guess?(code, player.secret, valid_colors)
        outstream.print interact.secret_guess_prompt
        code = instream.noecho(&:gets).strip.upcase
        outstream.puts code
        outstream.puts
      end
      code.chars
    end

    def set_turn_pos
      @players[0].turn_pos = 0
      @players[1].turn_pos = 1 if @players[1]
    end

    def process_command(player)
      case
      when quit?(player)                                               then quit_confirm(player)
      when !valid_guess?(player.command, player.secret, valid_colors)  then outstream.puts interact.print_invalid_guess(player.command)
      when valid_guess?(player.command, player.secret, valid_colors)   then guess(player)
      end
    end

    def single_player?
      @players.length == 1
    end

    def color_string
      Mastermind.color_option_string(6)
    end

    def player_round_over!(player)
      player.round_over = true
      outstream.puts interact.print_round_over
    end

    def round_over?
      !@players.any? {|player| player.round_over == false}
    end

    def game_round_over?
      round_over
    end

    def win!(player)
      time = Time.now - player.start_time
      player.completion_time = time
      outstream.puts interact.print_win(num_guesses(player), time.round)
      player_round_over!(player)
    end

    def correct_guess?(player)
      player.command.chars == player.secret
    end

    def guesses_remaining?(player)
      num_guesses(player) < max_guesses
    end

    def quit?(player)
      player.command == "Q" || player.command == "QUIT"
    end

    def out_of_guesses
      outstream.puts interact.print_out_of_guesses(secret)
      round_over!
    end

    def guess(player)
      player.guesses << player.command
      if    correct_guess?(player)      then win!(player)
      elsif !guesses_remaining?(player) then out_of_guesses
      else  outstream.puts interact.print_guess_stats(num_guesses(player), correct_pos(player), correct_color(player), player.command, max_guesses, player)
      end
    end

    def num_guesses(player)
      player.guesses.length
    end

    def correct_pos(player)
      Mastermind::Processor.num_correct_pos(player.command, player.secret)
    end

    def correct_color(player)
      Mastermind::Processor.num_correct_colors(player.command, player.secret)
    end

    def valid_guess?(command, secret, valid_colors)
      Mastermind::Processor.validate(command, secret, valid_colors)
    end

    def quit_confirm(player)
      outstream.puts interact.print_are_you_sure
      outstream.print interact.command_prompt
      confirmation = instream.gets.strip.upcase
      case confirmation
      when "Y", "YES" 
        self.round_over = true
        player.command = "Q"
      else                 player.command = ""
      end
    end
  end
end
