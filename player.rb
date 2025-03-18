# frozen_string_literal: true

require "debug"
require "dry-initializer"
require "dry-types"
require_relative "types"
require_relative "card"
require_relative "cardable"
require_relative "factionable"

class Player
  include Cardable
  extend Dry::Initializer

  option :faction, Types::PlayerFactionType

  attr_reader :deck, :hand, :discard_pile, :exile_pile
  attr_accessor :power, :force, :resources

  def initialize(*args, **kwargs, &block)
    super(*args, **kwargs)
    @faction = faction
    @discard_pile = []
    @exile_pile = []
    @deck = create_starting_deck
    @hand = []
    @power = 0
    @force = 0
    @resources = 0
  end

  def rebel?
    faction == :rebel
  end

  def empire?
    faction == :empire
  end

  def reshuffle
    return unless deck.empty?

    @deck = discard_pile.shuffle!
    @discard_pile = []
  end

  def start_hand
    reshuffle
    until hand.size == 5
      reshuffle if deck.empty?
      hand << deck.pop
    end
  end

  def consume(index)
    return if hand[index].consumed?
    return if hand[index].special_used?

    @power += hand[index].power
    @force += hand[index].force
    @resources += hand[index].resources

    hand[index].consume
  end

  def consume_all
    hand.each.with_index do |_card, index|
      consume(index)
    end
  end

  def reset_consumption
    hand.each(&:restore)
  end

  def abilities
    {
      force:,
      power:,
      resources:
    }
  end

  def exile_cards
    cards = hand.select(&:exiled).to_a
    hand.reject!(&:exiled)
    exile_pile.push(*cards)
  end

  def inspect
    stats = "force:#{force}|resources:#{resources}|power:#{power}"
    row = "-" * 75
    faction_string = faction.to_s.center(75, "-")
    cards_string = "cards".center(75, "-")
    cards = hand.map.with_index do |c, i|
      card_str(c, i).ljust(72, "-")
    end
    [row, faction_string, stats, row, cards_string, cards, row].flatten.join("\n")
  end

  def add_to_discard_pile(card)
    @discard_pile << card
  end

  def return_to_discard_pile
    hand.each do |card|
      add_to_discard_pile(card)
    end
    @hand = []
  end

  def forfeit_unused_abilities
    @force = 0
    @resources = 0
    @power = 0
  end

  private

  def create_starting_deck
    starting_deck = []
    if rebel?
      2.times { starting_deck << Card.rebel_trooper }
      7.times { starting_deck << Card.alliance_shuttle }
      starting_deck << Card.temple_guardian
    else empire?
      2.times { starting_deck << Card.storm_trooper }
      7.times { starting_deck << Card.imperial_shuttle }
      starting_deck << Card.inquisitor
    end

    starting_deck.shuffle!
  end
end
