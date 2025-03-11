# frozen_string_literal: true

require "debug"
require_relative "deck"
require_relative "player"
require_relative "planet"
require_relative "galaxy_row"

class Game
  attr_reader :deck, :galaxy_row, :player
  attr_accessor :players, :outer_rim_pilots

  def initialize
    @players = [Player.new(faction: :empire), Player.new(faction: :rebel)].cycle
    @planets = { rebel: rebel_planets, empire: empire_planets }
    @outer_rim_pilots = Array.new(10) { Card.outer_rim_pilot }

    @deck = Deck.new
    @deck.shuffle!
    @galaxy_row = GalaxyRow.new(@deck)
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

  def end_hand
    player.reset_consumption

    @current_player = @players.next
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
    @galaxy_row = GalaxyRow.new
    @galaxy_row.refill
    @galaxy_row
  end
end
