# frozen_string_literal: true

require "debug"
require "awesome_print"

class GalaxyRow
  attr_reader :deck, :cards

  def initialize(deck)
    @deck = deck
    @cards = []
    refill
  end

  def [](index)
    @cards[index]
  end

  def refill
    while @cards.length < 6
      @cards << @deck.draw
    end

    self
  end

  def size
    cards.length
  end

  def inspect
    cards = @cards.map.with_index do |c, i|
      reward_str = c.reward.map { |k, v| k.to_s[0] + "->" + v.to_s }.join
      str = "#{i}|$#{c.cost}|#{c.name}(#{c.faction[0]})|🪵:#{c.resources};💪:#{c.power};🪄:#{c.force}|s:#{c.special_block.nil? ? 'f' : 't'}|+#{reward_str}+"
    end
    ap cards
  end

  def to_s
    @cards.to_s
  end
end
