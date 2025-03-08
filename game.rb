# frozen_string_literal: true
require_relative "deck"
require_relative "player"
require_relative "planet"

class Game
  attr_reader :deck, :galaxy_row, :players, :player

  def initialize
    @players = [Player.new(faction: :empire), Player.new(faction: :rebel)].cycle
    @planets = { rebel: rebel_planets, empire: empire_planets }

    @deck = Deck.new
    @deck.shuffle!
    @galaxy_row = fill_galaxy_row
    @current_player = @players.next
  end

  def player
    @current_player
  end

  def rebel_player
    @players.find(&:rebel?)
  end

  def empire_player
    @players.find(&:empire?)
  end

  def start_hand
    player.start_hand
  end

  def hand
    player.hand
  end

  def rebel_planets
    @rebel_planets ||= [
      Planet.new(faction: :rebel, name: "Dantooine", power: 8),
      Planet.new(faction: :rebel, name: "Hoth", power: 14),
      Planet.new(faction: :rebel, name: "Yavin IV", power: 16)
    ]
  end

  def empire_planets
    @empire_planets ||= [
      Planet.new(faction: :empire, name: "Lothal", power: 8),
      Planet.new(faction: :empire, name: "Corellia", power: 14),
      Planet.new(faction: :empire, name: "Death Star", power: 16)
    ]
  end

  private

  def fill_galaxy_row
    @galaxy_row = []

    6.times do
      @galaxy_row << @deck.draw
    end

    @galaxy_row
  end

end
