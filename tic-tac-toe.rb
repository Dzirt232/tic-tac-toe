class Game
  @@players = 0

  class Player
    attr_accessor :name

    def initialize(name)
      @name = name
    end

    def self.won?
      return false
    end

    def xod(position)

    end
  end

  def self.new_player(name="player_#{@@players}")
    @@players += 1
    Player.new(name)
  end

  class Pole
    @@pole = [1,2,3,4,5,6,7,8,9]
    def self.show_pole
      puts
      @@pole.each { |e|
        print "| #{e} | "
        print "\n\n" if e % 3 == 0 && e >= 3
      }
      puts
    end
  end

  def self.game_over?
    return true if Player.won?
    return false
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

until Game.game_over?
  puts "Ход игрока #{player_1.name}"
  position = gets.chomp.to_i
  player_1.xod(position)
  Game::Pole.show_pole
  break until Game.game_over?
  puts "Ход игрока #{player_2.name}"
  position = gets.chomp.to_i
  player_2.xod(position)
  Game::Pole.show_pole
end

puts "#{player_1} выиграл!!!"
