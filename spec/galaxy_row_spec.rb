# frozen_string_literal: true

require_relative "spec_helper"
require_relative "../galaxy_row"
require_relative "../deck"
require_relative "../card"

RSpec.describe GalaxyRow do
  let(:deck) { Deck.new }
  subject(:galaxy_row) { described_class.new(deck) }

  describe "#refill" do
    it "fills the galaxy row with cards from the deck" do
      initial_deck_size = deck.size

      subject.refill

      expect(subject.size).to eql(6)
      expect(deck.size).to eql(initial_deck_size - 6)
    end
  end

  it "allows you to index into the card" do
    subject.refill

    expect(subject[0]).to be_a(Card)
  end
end
