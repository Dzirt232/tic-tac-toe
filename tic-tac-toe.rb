class Game
  @@players = 0

  class Player
    attr_accessor :name

    def initialize(name)
      @name = name
    end
  end

  def self.new_player(name="player_#{@@players}")
    @@players += 1
    Player.new(name)
  end

  class Pole

  end
end

puts "Привет, добро пожаловать в крестики нолики!"
puts "Введите имя первого игрока: "
name_1 = gets.chomp
player_1 = name_1 == "" ? Game.new_player() : Game.new_player(name_1)
puts "Введите имя второго игрока: "
name_2 = gets.chomp
player_2 = name_2 == "" ? Game.new_player() : Game.new_player(name_2)
puts "Добро пожаловать в игру, #{player_1.name} и #{player_2.name}!"
