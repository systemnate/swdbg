# frozen_string_literal: true
require_relative "factionable"

class Planet
  include Factionable

  attr_reader :faction, :name, :power

  def initialize(faction:, name: "A planet", power: 8)
    @faction = faction
    @name = name
    @power = power
  end
end
