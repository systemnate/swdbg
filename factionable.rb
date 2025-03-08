# frozen_string_literal: true

module Factionable
  def rebel?
    faction == :rebel
  end

  def empire?
    faction == :empire
  end

  def neutral?
    faction == :neutral
  end
end
