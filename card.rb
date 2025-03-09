require_relative "factionable"

class Card
  include Factionable

  attr_accessor :name, :faction, :power, :resources, :force, :special_used, :consumed

  def initialize(name: "card", faction: :neutral, power: 0, resources: 0, force: 0, &special_block)
    @name = name
    @faction = faction
    @power = power
    @resources = resources
    @force = force
    @special_used = false
    @special_block = special_block
    @consumed = consumed
  end

  def self.luke
    new(name: "Luke Skywalker", faction: :rebel, power: 6, force: 3)
  end

  def self.vader
    new(name: "Darth Vader", faction: :empire, power: 8, force: 3)
  end

  def self.grand_moff
    new(name: "Grand Moff Tarken", faction: :empire, power: 2, force: 2, resources: 2)
  end

  def self.han_solo
    new(name: "Han Solo", faction: :rebel, power: 4, force: 0, resources: 3)
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
    new(faction: :empire, name: "Emperial Shuttle", resources: 1)
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

  def restore
    @consumed = false
  end
end
