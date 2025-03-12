# frozen_string_literal: true
require_relative "factionable"

class Planet
  include Factionable

  attr_reader :faction, :name
  attr_accessor :power

  def initialize(faction:, name: "A planet", power: 8)
    @faction = faction
    @name = name
    @power = power
  end

  def defeated?
    power <= 0
  end

  def alive?
    power > 0
  end
end
