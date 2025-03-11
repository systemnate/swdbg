module Cardable
  def card_str(card, index)
    "#{index}|$#{card.cost}|#{card.name}(#{card.faction[0]})|🪵:#{card.resources};💪:#{card.power};🪄:#{card.force}|s:#{card.special_block.nil? ? 'f' : 't'}"
  end
end
