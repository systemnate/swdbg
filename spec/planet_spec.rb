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
end
