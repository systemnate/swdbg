# Star Wars The Deck Building Game Ruby Edition

## Disclaimer
This project is created solely for educational purposes and personal enjoyment. It is not affiliated with, endorsed by, or connected to Lucasfilm Ltd., Disney, Fantasy Flight Games, 
Asmodee, or any Star Wars license holders. All Star Wars characters, names, and references are property of their respective owners.

This is a non-commercial fan project created to practice programming skills and learn game development concepts. No copyright infringement is intended.


## How to play

This is highly subject to change, but you can interact with the game like this.

```
$ bundle install
$ bundle exec rails c
```

```Ruby
game = Game.new
game.start_hand
game.player # view player with stats and hand
game.player.consume_all # consume powers from card and add to player
game.galaxy_row # see what is available in the galaxy row
# index of item you want to buy - true if player resources is > card cost
and belongs to same faction or is neutral
game.buy(2)
# if you have any power you can attack the current planet
game.current_planet # opponent's planet
game.attack_planet(2) # succeeds if player power <= amount
game.current_planet # planets power has been reduced
# you can also attack the galaxy row: game.attack_galaxy_row(0)
game.end_hand # end hand

game.start_hand
game.player # it continues...
```
