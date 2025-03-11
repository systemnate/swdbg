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

      expect(game.hand.all? { |c| c.consumed? }).to be_truthy

      game.end_hand
      game.start_hand
      game.end_hand

      # rebel's turn again, they should be useable again
      expect(game.hand.all? { |c| c.consumed? }).to be_falsey
    end
  end

  describe "#buy" do
    it "allows the player to buy something from the galaxy row" do
      deck = Deck.new
      cards = []
      20.times { cards << Card.new(cost: 1, resources: 1, faction: :empire) }
      allow(deck).to receive(:cards).and_return(cards)

      game = Game.new(deck: deck)
      game.start_hand
      game.player.consume_all

      initial_resources = game.player.resources

      game.buy(0)

      expect(game.player.resources).to eql(initial_resources - 1)
    end
  end
end
