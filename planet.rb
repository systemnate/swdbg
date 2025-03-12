# frozen_string_literal: true

require "dry-initializer"
require "dry-types"
require_relative "factionable"
require_relative "types"

class Planet
  include Factionable
  extend Dry::Initializer

  option :faction, Types::Symbol
  option :name, Types::String, default: proc { "A planet" }
  option :power, Types::Integer, default: proc { 8 }

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
