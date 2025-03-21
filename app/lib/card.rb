require "dry-initializer"
require "dry-types"
require_relative "factionable"
require_relative "types"

class Card
  include Factionable
  extend Dry::Initializer

  option :name, Types::String, default: proc { "card" }
  option :faction, Types::Symbol, default: proc { :neutral }
  option :power, Types::Integer, default: proc { 0 }
  option :resources, Types::Integer, default: proc { 0 }
  option :force, Types::Integer, default: proc { 0 }
  option :cost, Types::Integer, default: proc { 0 }
  option :reward, Types::Hash, default: proc { {} }
  option :consumed, Types::Bool, default: proc { false }
  option :special_block, Types::Callable.optional, default: proc { nil }
  option :target_value, Types::Integer, default: proc { cost }

  attr_accessor :power, :force, :resources, :special_used, :reward, :exiled

  def initialize(*args, **kwargs, &block)
    super(*args, **kwargs)
    @special_block = block if block
    @special_used = false
    @exiled = false
  end

  def exile!
    @exiled = true
  end

  def exiled?
    @exiled == true
  end

  def self.luke
    new(
      name: "Luke Skywalker",
      faction: :rebel,
      power: 6, force: 3,
      cost: 8,
      reward: { resources: 3, force: 3 }
    )
  end

  def self.vader
    new(
      name: "Darth Vader",
      faction: :empire,
      power: 8,
      force: 3,
      cost: 8,
      reward: { resources: 3, force: 3 }
    )
  end

  def self.grand_moff
    new(
      name: "Grand Moff Tarken",
      faction: :empire,
      power: 2,
      force: 2,
      resources: 2,
      cost: 6,
      reward: { resources: 3, force: 2 }
    )
  end

  def self.han_solo
    new(
      name: "Han Solo",
      faction: :rebel,
      power: 4,
      force: 0,
      resources: 3,
      cost: 5,
      reward: { resources: 4, force: 2 }
    )
  end

  def self.boba_fett
    new(
      name: "Boba Fett",
      faction: :empire,
      power: 5,
      force: 0,
      resources: 0
    )
  end

  def self.rebel_trooper
    new(faction: :rebel, name: "Rebel Trooper", power: 2)
  end

  def self.storm_trooper
    new(faction: :empire, name: "Storm Trooper", power: 2)
  end

  def self.alliance_shuttle
    new(faction: :rebel, name: "Alliance Shuttle", resources: 1)
  end

  def self.imperial_shuttle
    new(faction: :empire, name: "Imperial Shuttle", resources: 1)
  end

  def self.outer_rim_pilot
    new(faction: :neutral, name: "Outer Rim Pilot", resources: 2) do |c, powerup|
      case powerup
      when :exile
        c.force += 1
        c.exile!
      end
    end
  end

  def self.temple_guardian
    new(faction: :rebel, name: "Temple Guardian") do |c, powerup|
      case powerup
      when :force
        c.force += 1
      when :resources
        c.resources += 1
      when :power
        c.power += 1
      end
    end
  end

  def self.inquisitor
    new(faction: :empire, name: "Inquisitor") do |c, powerup|
      case powerup
      when :force
        c.force += 1
      when :resources
        c.resources += 1
      when :power
        c.power += 1
      end
    end
  end

  def cost
    return @cost if @cost > 0

    [power, force, resources].max
  end

  def reward
    return @reward unless @reward.empty?

    if power > 0
      @reward = { resources: power, power: 0, force: 0 }
    elsif resources >= 2
      @reward = { resources: resources, power: 0, force: 0 }
    else
      @reward = { resources: 0, power: 0, force: 2 }
    end
  end

  def special(option)
    if @special_used
      raise "special power already used"
    elsif @special_block.nil?
      raise "this card has no special powers"
    else
      @special_used = true
      @special_block.call(self, option) if @special_block
    end
  end

  def consume
    @consumed = true
  end

  def consumed?
    @consumed
  end

  def special_used?
    !@special_block.nil? && !@special_used
  end

  def restore
    @consumed = false
    # won't work for other special abilities
    # but works for inquistor and temple guardian
    # need to re-think how to reset cards with
    # special abilities back to their original
    # state
    if @special_used
      @power = 0
      @resources = 0
      @force = 0
    end
    @special_used = false
  end

  def inspect
    "#{name.ljust(20, '-')}|#{faction}|r:#{resources};p:#{power};f:#{force}|s?:#{!special_block.nil?}"
  end

  def to_s
    inspect
  end
end
