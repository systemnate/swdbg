# frozen_string_literal: true

require_relative "spec_helper"
require "debug"
require_relative "../player"

RSpec.describe Player do
  describe "rebel player" do
    let(:player) { Player.new(faction: :rebel) }

    it "can create a rebel player" do
      expect(player).to be_a_rebel
    end

    it "creates a starting deck" do
      expect(player.deck.size).to eql(10)
    end

    it "creates a deck of all rebel cards" do
      expected = true
      actual = player.deck.all?(&:rebel?)

      expect(actual).to eql(expected)
    end
  end

  describe "empire player" do
    let(:player) { Player.new(faction: :empire) }

    it "can create an empire player" do
      player = Player.new(faction: :empire)

      expect(player).to be_an_empire
    end

    it "creates a starting deck" do
      expect(player.deck.size).to eql(10)
    end

    it "creates a deck of all empire cards" do
      expected = true
      actual = player.deck.all?(&:empire?)

      expect(actual).to eql(expected)
    end
  end

  describe "#reshuffle" do
    let(:player) { Player.new(faction: :rebel) }

    it "takes the discard pile, shuffles, and makes it the deck" do
      # initial setup, deck is size 10
      expect(player.deck.size).to eql(10)

      # empty the deck into the discard pile
      until player.deck.empty? do
        player.discard_pile << player.deck.pop
      end

      # deck now contains no cards
      expect(player.deck.size).to eql(0)

      player.reshuffle

      # now the deck is the shuffled discard pile
      expect(player.deck.size).to eql(10)
      expect(player.discard_pile.size).to eql(0)
    end
  end

  describe "#start_hand" do
    let(:player) { Player.new(faction: :rebel) }

    it "puts 5 cards in the hand from the deck" do
      # deck starts with 10 cards
      expect(player.deck.size).to eql(10)

      # start_hand
      player.start_hand

      # hand should have 5, deck should have 5
      expect(player.deck.size).to eql(5)
      expect(player.hand.size).to eql(5)
    end
  end

  describe "#consume" do
    let(:player) { Player.new(faction: :rebel) }

    it "applies abilities from all cards to the player's abilities" do
      hand = [
        Card.alliance_shuttle, # resources: 1
        Card.alliance_shuttle, # resources: 1
        Card.alliance_shuttle, # resources: 1
        Card.alliance_shuttle, # resources: 1
        Card.rebel_trooper     # power: 2
      ]

      allow(player).to receive(:hand).and_return(hand)

      player.consume(0)

      expect(player.resources).to eql(1)
    end

    it "doesn't allow you to consume the same card twice" do
      hand = [
        Card.alliance_shuttle, # resources: 1
        Card.alliance_shuttle, # resources: 1
        Card.alliance_shuttle, # resources: 1
        Card.alliance_shuttle, # resources: 1
        Card.rebel_trooper     # power: 2
      ]

      allow(player).to receive(:hand).and_return(hand)

      player.consume(0)
      expect(player.resources).to eql(1)

      player.consume(0)
      expect(player.resources).to eql(1)
    end

    it "doesn't consume a card if the special hasn't been used" do
      card = Card.temple_guardian # card that has special
      hand = [
        card
      ]

      allow(player).to receive(:hand).and_return(hand)

      player.consume(0)
      expect(card).not_to be_consumed
    end
  end

  describe "#consume_all" do
    let(:player) { Player.new(faction: :rebel) }

    it "applies abilities from all cards to the player's abilities" do
      hand = [
        Card.alliance_shuttle, # resources: 1
        Card.alliance_shuttle, # resources: 1
        Card.alliance_shuttle, # resources: 1
        Card.alliance_shuttle, # resources: 1
        Card.rebel_trooper     # power: 2
      ]

      allow(player).to receive(:hand).and_return(hand)

      player.consume_all

      expect(player.resources).to eql(4)
      expect(player.power).to eql(2)
    end

    it "prevents you from consuming everything twice" do
      hand = [
        Card.alliance_shuttle, # resources: 1
        Card.alliance_shuttle, # resources: 1
        Card.alliance_shuttle, # resources: 1
        Card.alliance_shuttle, # resources: 1
        Card.rebel_trooper     # power: 2
      ]

      allow(player).to receive(:hand).and_return(hand)

      player.consume_all
      player.consume_all # consume an extra time

      # doesn't matter; they are no-ops
      expect(player.resources).to eql(4)
      expect(player.power).to eql(2)
    end
  end

  describe "#abilities" do
    let(:player) { Player.new(faction: :rebel) }

    it "returns a hash of all abilities" do
      hand = [
        Card.alliance_shuttle, # resources: 1
        Card.alliance_shuttle, # resources: 1
        Card.alliance_shuttle, # resources: 1
        Card.temple_guardian,  # will consume for 1 force
        Card.rebel_trooper     # power: 2
      ]

      allow(player).to receive(:hand).and_return(hand)

      player.hand[3].special(:force)
      player.consume_all

      expect(player.abilities).to eql({
        resources: 3,
        force: 1,
        power: 2
      })
    end
  end

  describe "#add_to_discard_pile" do
    let(:player) { Player.new(faction: :rebel) }

    it "lets you add a card to the discard pile" do
      expect(player.discard_pile.size).to eql(0)

      player.add_to_discard_pile(Card.new)

      expect(player.discard_pile.size).to eql(1)
    end
  end

  describe "#return_to_discard_pile" do
    let(:player) { Player.new(faction: :rebel) }

    it "returns cards from the hand to the discard pile" do
      player.start_hand

      expect(player.hand.length).to eql(5)

      player.return_to_discard_pile

      expect(player.hand.length).to eql(0)
      expect(player.discard_pile.length).to eql(5)
    end
  end

  describe "#exile_pile" do
    let(:player) { Player.new(faction: :rebel) }

    it "starts off as empty" do
      expect(player.exile_pile).to be_empty
    end
  end

  describe "#exile_cards" do
    let(:player) { Player.new(faction: :rebel) }

    it "moves cards marked as exile to the exile pile" do
      card = Card.outer_rim_pilot
      player.hand << card

      card.special(:exile)

      player.exile_cards

      expect(player.exile_pile).to include(card)
    end
  end

  describe "#forfeit_unused_abilities" do
    let(:player) { Player.new(faction: :rebel) }

    it "sets abilities to 0" do
      player.force = 2
      player.resources = 2
      player.power = 2

      player.forfeit_unused_abilities

      expect(player.force).to eql(0)
      expect(player.resources).to eql(0)
      expect(player.power).to eql(0)
    end
  end
end
