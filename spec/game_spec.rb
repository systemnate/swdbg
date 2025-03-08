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
      game = Game.new
      game.start_hand

      expect(game.hand.size).to eql(5)
    end
  end

  describe "#play" do
    let(:game) { Game.new }
  end
end
