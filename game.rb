# frozen_string_literal: true

require "debug"
require_relative "deck"
require_relative "player"
require_relative "planet"
require_relative "galaxy_row"

class Game
  attr_reader :deck, :galaxy_row, :player
  attr_accessor :players, :outer_rim_pilots

  def initialize(deck: Deck.new)
    @players = [Player.new(faction: :empire), Player.new(faction: :rebel)].cycle
    @planets = { rebel: rebel_planets, empire: empire_planets }
    @outer_rim_pilots = Array.new(10) { Card.outer_rim_pilot }

    @deck = deck
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
    player
  end

  def end_hand
    player.reset_consumption
    player.return_to_discard_pile

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

  def buy(index)
    card = galaxy_row[index]
    return false unless can_buy?(card)

    player.resources -= card.cost
    purchased_card = galaxy_row.remove_card(index)
    player.add_to_discard_pile(purchased_card)
    galaxy_row.refill
    true
  end

  def attack_planet(amount_to_attack)
    if player.power >= amount_to_attack
      player.power -= amount_to_attack
      current_planet.power -= amount_to_attack

      return true
    end
    false
  end

  def current_planet
    if player.faction == :empire
      rebel_planets.find(&:alive?)
    else
      empire_planets.find(&:alive?)
    end
  end

  def consume_all
    player.consume_all
    player
  end

  private

  def can_buy?(card)
    (card.faction == player.faction || card.faction == :neutral) &&
      player.resources >= card.cost
  end

  def fill_galaxy_row
    @galaxy_row = GalaxyRow.new
    @galaxy_row.refill
    @galaxy_row
  end
end
