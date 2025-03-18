class Deck
  attr_reader :cards

  def initialize
    @cards = []
    add_rebel_cards
    add_empire_cards
    add_neutral_cards
    shuffle!
  end

  def size
    cards.length
  end

  def shuffle!
    cards.shuffle!
  end

  def draw
    cards.pop
  end

  def empty?
    size == 0
  end

  private

  def add_rebel_cards
    cards << Card.luke
    cards << Card.han_solo

    18.times do
      r = rand(1..3)
      if r == 1
        cards << Card.new(
          faction: :rebel,
          power: rand(1..5)
        )
      elsif r == 2
        cards << Card.new(
          faction: :rebel,
          force: rand(1..2),
          resources: rand(1..2)
        )
      elsif r == 3
        cards << Card.new(
          faction: :rebel,
          resources: rand(2..4)
        )
      end
    end
  end

  def add_empire_cards
    cards << Card.vader
    cards << Card.grand_moff

    18.times do
      r = rand(1..3)
      if r == 1
        cards << Card.new(
          faction: :empire,
          power: rand(1..5)
        )
      elsif r == 2
        cards << Card.new(
          faction: :empire,
          force: rand(1..2),
          resources: rand(1..2)
        )
      elsif r == 3
        cards << Card.new(
          faction: :empire,
          resources: rand(2..4)
        )
      end
    end
  end

  def add_neutral_cards
    20.times do
      r = rand(1..3)
      if r == 1
        cards << Card.new(
          faction: :neutral,
          power: rand(1..5)
        )
      elsif r == 2
        cards << Card.new(
          faction: :neutral,
          force: rand(1..2),
          resources: rand(1..2)
        )
      elsif r == 3
        cards << Card.new(
          faction: :neutral,
          resources: rand(2..4)
        )
      end
    end
  end
end
