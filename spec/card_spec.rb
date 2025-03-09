# frozen_string_literal: true
#
require "debug"
require_relative "spec_helper"
require_relative "../card"

RSpec.describe Card do
  let(:name) { "A Card" }
  let(:faction) { :neutral }
  let(:power) { 0 }
  let(:resources) { 0 }
  let(:force) { 0 }

  let(:card) do
    card = Card.new(name:, faction:, power:, resources:, force:)
  end

  it "initializes with expected values" do
    expect(card.name).to eql("A Card")
    expect(card.faction).to eql(:neutral)
    expect(card.power).to eql(0)
    expect(card.resources).to eql(0)
    expect(card.force).to eql(0)
  end

  it "has defaults" do
    default_card = Card.new

    expect(default_card.name).to eql("card")
    expect(default_card.faction).to eql(:neutral)
    expect(default_card.power).to eql(0)
    expect(default_card.resources).to eql(0)
    expect(default_card.force).to eql(0)
  end

  describe "#cost" do
    it "defaults to the max of resources, force, power" do
      card = Card.new(faction: :rebel, power: 3, force: 2, resources: 1)

      expect(card.cost).to eql(3)
    end

    it "uses the cost if it is set" do
      card = Card.new(faction: :rebel, power: 3, force: 2, resources: 1, cost: 4)

      expect(card.cost).to eql(4)
    end
  end

  describe "#reward" do
    describe "when power is an ability" do
      it "defaults to giving resource equal to power" do
        card = Card.new(faction: :rebel, power: 3, force: 0, resources: 0)

        expect(card.reward).to eql({
          resources: 3,
          power: 0,
          force: 0
        })
      end
    end

    describe "when resources is an ability" do
      it "defaults to giving resources equal to resources" do
        card = Card.new(faction: :rebel, power: 0, force: 0, resources: 2)

        expect(card.reward).to eql({
          resources: 2,
          power: 0,
          force: 0
        })
      end
    end

    describe "when force is an ability" do
      it "defaults to giving 2 force" do
        card = Card.new(faction: :rebel, power: 0, force: 3, resources: 0)

        expect(card.reward).to eql({
          resources: 0,
          power: 0,
          force: 2
        })
      end
    end

    it "defaults to the  when resource is >= 2" do
      card = Card.new(faction: :rebel, power: 0, force: 0, resources: 2)

      expect(card.reward).to eql({
        resources: 2,
        power: 0,
        force: 0
      })
    end
  end

  describe "#rebel?" do
    it "returns true when the faction is rebel" do
      card = Card.new(faction: :rebel)

      expect(card.rebel?).to be_truthy
    end

    it "returns false when the faction is neutral" do
      card = Card.new(faction: :neutral)

      expect(card.rebel?).to be_falsey
    end

    it "returns false when the faction is empire" do
      card = Card.new(faction: :empire)

      expect(card.rebel?).to be_falsey
    end
  end

  describe "#empire?" do
    it "returns true when the faction is empire" do
      card = Card.new(faction: :empire)

      expect(card.empire?).to be_truthy
    end

    it "returns false when the faction is neutral" do
      card = Card.new(faction: :neutral)

      expect(card.empire?).to be_falsey
    end

    it "returns false when the faction is rebel" do
      card = Card.new(faction: :rebel)

      expect(card.empire?).to be_falsey
    end
  end

  describe "#neutral?" do
    it "returns true when the faction is neutral" do
      card = Card.new(faction: :neutral)

      expect(card.neutral?).to be_truthy
    end

    it "returns false when the faction is rebel" do
      card = Card.new(faction: :rebel)

      expect(card.neutral?).to be_falsey
    end

    it "returns false when the faction is empire" do
      card = Card.new(faction: :empire)

      expect(card.neutral?).to be_falsey
    end
  end

  describe "inquisitor" do
    it "starts with no powers" do
      card = Card.inquisitor

      expect(card.power).to eql(0)
      expect(card.force).to eql(0)
      expect(card.resources).to eql(0)
    end

    it "allows you to select power" do
      card = Card.inquisitor
      card.special(:power)

      expect(card.power).to eql(1)
    end

    it "allows you to select power" do
      card = Card.inquisitor
      card.special(:force)

      expect(card.force).to eql(1)
    end

    it "allows you to select power" do
      card = Card.inquisitor
      card.special(:resources)

      expect(card.resources).to eql(1)
    end

    it "prevents you from applying multiple times" do
      card = Card.inquisitor
      card.special(:force)

      expect do
        card.special(:force)
      end.to raise_error "special power already used"
    end
  end
end
