# frozen_string_literal: true

require_relative "spec_helper"
require_relative "../card"
require_relative "../deck"
require_relative "../game"

RSpec.describe Game do
  let(:game) { Game.new }

  it "sets up a galaxy row"  do
    expect(game.galaxy_row.size).to eql(6)
  end

  it "creates 3 rebel planets" do
    expect(game.rebel_planets.size). to eql(3)
  end

  it "creates 3 empire planets" do
    expect(game.empire_planets.size). to eql(3)
  end

  it "creates a rebel player" do
    rebel_player = game.players.find(&:rebel?)

    expect(rebel_player.faction).to eql(:rebel)
  end

  it "creates an empire player" do
    empire_player = game.players.find(&:empire?)

    expect(empire_player.faction).to eql(:empire)
  end

  describe "#rebel_player" do
    it "returns the rebel player" do
      expect(game.rebel_player.faction).to eql(:rebel)
    end
  end

  describe "#empire_player" do
    it "returns the empire player" do
      expect(game.empire_player.faction).to eql(:empire)
    end
  end

  describe "#player" do
    it "defaults to the empire player" do
      game = Game.new

      expect(game.player).to be_a_empire
    end
  end

  describe "#start_hand" do
    it "deals 5 cards to the current player" do
      game.start_hand

      expect(game.hand.size).to eql(5)
    end
  end

  describe "#end_hand" do
    let(:game) { Game.new }

    it "switches the player" do
      game.start_hand
      expect(game.player).to be_a_empire

      game.end_hand
      expect(game.player).to be_a_rebel

      game.start_hand
      game.end_hand
      expect(game.player).to be_a_empire

      game.start_hand
      game.end_hand
      expect(game.player).to be_a_rebel
    end

    it "resets the card consumption" do
      game = Game.new
      game.start_hand
      game.player.consume_all # TODO: prevent card with action from being consumed

      game.end_hand
      game.start_hand
      game.end_hand
      game.start_hand

      # rebel's turn again, they should be useable again
      expect(game.hand.all? { |c| c.consumed? }).to be_falsey
    end

    it "places all exiled cards in the exile pile" do
      # start game, add outer rim pilot
      game = Game.new
      game.start_hand
      player = game.player
      card = Card.outer_rim_pilot
      player.hand << card

      card.special(:exile)
      game.end_hand

      expect(player.exile_pile).to include(card)
    end
  end

  describe "#buy" do
    let(:game) { Game.new }
    let(:card) { Card.new(cost: 1, resources: 1, faction: :empire) }

    it "allows the player to buy something from the galaxy row" do
      allow(game.galaxy_row).to receive(:[]).with(0).and_return(card)
      allow(game.galaxy_row).to receive(:remove_card).with(0).and_return(card)
      allow(game.galaxy_row).to receive(:refill)
      game.player.resources = 5

      game.buy(0)

      expect(game.player.resources).to eq(4)
      expect(game.player.discard_pile.length).to eql(1)
    end
  end

  describe "#buy_outer_rim_pilot" do
    let(:game) { Game.new }

    it "allows you to buy an outer rim pilot" do
      player = game.player
      player.resources = 2
      game.buy_outer_rim_pilot

      expect(player.discard_pile.size).to eql(1)
      expect(player.resources).to eql(0)
    end
  end

  describe "#attack_planet" do
    let(:game) { Game.new }

    it "reduces the power of the opponents current planet" do
      game.start_hand
      player = game.player
      player.power = 4
      planet = game.current_planet
      planet.power = 8

      game.attack_planet(4)

      expect(player.power).to eql(0)
      expect(planet.power).to eql(4)
    end
  end

  describe "#current_planet" do
    context "as an empire player" do
      let(:game) { Game.new }
      context "when all planets are alive" do
        it "returns the rebel's first planet" do
          rebel_planets = game.rebel_planets

          rebel_planets.each { _1.power = 10 }

          expect(game.current_planet).to eql(rebel_planets.first)
        end
      end

      context "when first planet is defeated" do
        it "returns the rebel's second planet" do
          p1, p2, p3 = game.rebel_planets

          p1.power = 0
          p2.power = 10
          p3.power = 10

          expect(game.current_planet).to eql(p2)
        end
      end
    end

    context "as a rebel player" do
      let(:game) { Game.new }

      before do
        game.end_hand
        game.start_hand # now rebel player
      end

      context "when all planets are alive" do
        it "returns the empires's first planet" do
          empire_planets = game.empire_planets

          empire_planets.each do |planet|
            planet.power = 10
          end

          expect(game.current_planet).to eql(empire_planets.first)
        end
      end

      context "when first planet is defeated" do
        it "returns the rebel's second planet" do
          p1, p2, p3 = game.empire_planets

          p1.power = 0
          p2.power = 10
          p3.power = 10

          expect(game.current_planet).to eql(p2)
        end
      end
    end
  end
end
