# frozen_string_literal: true

require_relative "spec_helper"
require_relative "../card"
require_relative "../deck"

RSpec.describe Deck do
  describe "initialization" do
    let(:deck) { Deck.new }

    it "creates 60 cards" do
      expect(deck.size).to eql(60)
    end

    it "creates 20 rebel cards" do
      rebel_cards = deck.cards.select { |card| card.faction == :rebel }

      expect(rebel_cards.size).to eql(20)
    end

    it "creates 20 empire cards" do
      empire_cards = deck.cards.select { |card| card.faction == :empire }

      expect(empire_cards.size).to eql(20)
    end

    it "creates 20 neutral cards" do
      neutral_cards = deck.cards.select { |card| card.faction == :neutral }

      expect(neutral_cards.size).to eql(20)
    end
  end

  describe ".shuffle!" do
    it "shufles the deck" do
      deck = Deck.new
      original_cards = deck.cards.dup
      deck.shuffle!

      expect(deck.cards).not_to eql(original_cards)
    end
  end

  describe ".draw" do
    it "pops a card off the deck" do
      deck = Deck.new
      drawn_card = deck.draw

      expect(deck.cards.size).to eql(59)
      expect(drawn_card).to be_a(Card)
    end
  end

  describe ".empty?" do
    it "returns false when the deck still has cards" do
      deck = Deck.new

      expect(deck).not_to be_empty
    end

    it "returns true when the deck still has cards" do
      deck = Deck.new

      60.times { deck.draw }

      expect(deck).to be_empty
    end
  end
end
