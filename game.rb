# frozen_string_literal: true

require "debug"
require_relative "deck"
require_relative "player"
require_relative "planet"
require_relative "galaxy_row"

class Game
  attr_reader :deck, :galaxy_row, :player, :planet_destroyed
  attr_accessor :players, :outer_rim_pilots

  def initialize(deck: Deck.new)
    @players = [Player.new(faction: :empire), Player.new(faction: :rebel)].cycle
    @planets = { rebel: rebel_planets, empire: empire_planets }
    @outer_rim_pilots = Array.new(10) { Card.outer_rim_pilot }

    @deck = deck
    @deck.shuffle!
    @galaxy_row = GalaxyRow.new(@deck)
    @current_player = @players.next
    @planet_destroyed = false
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
    @planet_destroyed = false
    player.start_hand
    player
  end

  def end_hand
    player.exile_cards
    player.reset_consumption
    player.return_to_discard_pile
    player.forfeit_unused_abilities

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

  def buy_outer_rim_pilot
    return false if outer_rim_pilots.empty?
    return false unless can_buy?(outer_rim_pilots.first)

    card = outer_rim_pilots.pop
    player.resources -= card.cost
    player.add_to_discard_pile(card)

    true
  end

  def attack_galaxy_row(index)
    card_to_attack = galaxy_row[index]
    return false unless valid_faction?(card_to_attack)
    return false if player.power < card_to_attack.target_value

    card = galaxy_row.remove_card(index)
    player.discard_pile << card
    player.power -= card.target_value

    player.power += card.reward.fetch(:power, 0)
    player.resources += card.reward.fetch(:resources, 0)
    player.force += card.reward.fetch(:force, 0)
    galaxy_row.refill

    true
  end

  def attack_planet(amount_to_attack)
    return false if player.power < amount_to_attack || planet_destroyed

    planet = current_planet

    player.power -= amount_to_attack
    planet.power -= amount_to_attack

    @planet_destroyed = true if planet.defeated?

    true
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

  def valid_faction?(card)
    (card.faction == :rebel && player.faction == :empire) ||
      (card.faction == :empire && player.faction == :rebel)
  end
end
