# frozen_string_literal: true

require_relative "spec_helper"
require_relative "../planet"

RSpec.describe Planet do
  it "lets you create a planet with a faction, name, and power" do
    planet = Planet.new(faction: :rebel, name: "Dagobah", power: 8)

    expect(planet.name).to eql("Dagobah")
    expect(planet.power).to eql(8)
    expect(planet.faction).to eql(:rebel)
    expect(planet.rebel?).to be_truthy
    expect(planet.empire?).to be_falsey
  end

  describe "defeated?" do
    it "is defeated when power is = 0" do
      planet = Planet.new(power: 0, faction: :rebel)

      expect(planet).to be_defeated
    end

    it "is defeated when power is less than zero" do
      planet = Planet.new(power: -1, faction: :rebel)

      expect(planet).to be_defeated
    end

    it "is not defeated when power is > 0" do
      planet = Planet.new(power: 1, faction: :rebel)

      expect(planet).not_to be_defeated
    end
  end

  describe "#alive?" do
    it "is alive when power is > 0" do
      planet = Planet.new(power: 1, faction: :rebel)

      expect(planet).to be_alive
    end

    it "is not alive when power = 0" do
      planet = Planet.new(power: 0, faction: :rebel)

      expect(planet).not_to be_alive
    end

    it "is not alive when power < 0" do
      planet = Planet.new(power: -1, faction: :rebel)

      expect(planet).not_to be_alive
    end
  end
end
