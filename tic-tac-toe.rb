class Game
  $count_players = 0
  @@players = []

  class Player
    attr_accessor :name

    def initialize(name)
      @name = name
      if $count_players == 1
        @type = "x"
      else
        @type = "0"
      end
    end

    def won?
      if Pole.victory_combination?(@type)
       print "\n-----------------------\n!!!Игрок #{@name} выиграл!!!\n-----------------------\n"
       return true
     elsif Pole.full?
       print "\n-----------------------\n!!!Ничья!!!\n-----------------------\n"
       return true
      else
        return false
      end
    end

    def xod
      puts "Ход игрока #{self.name}"
      position = gets.chomp.to_i
      if right_xod?(position)
        izmen = $pole.change_pole(position, @type) #переменная $pole это глобальная переменная она обьявляется в функции Game.start
        Pole.show_pole                             #и приравнивается новому обьекту класса поле
      else
        puts "Неверный ход, попробуйте снова."
        Pole.show_pole
        self.xod
      end
    end

    def right_xod?(position)
      return false if position < 1 || position > 9
      if Pole.pole[position-1] == "x" || Pole.pole[position-1] == "0"
        return false
      else
        return true
      end
    end
  end

  def self.new_player(name="player_#{$count_players}")
    $count_players += 1
    pl = Player.new(name)
    @@players << pl
    return pl
  end

  class Pole
    @@pole = [1,2,3,4,5,6,7,8,9]
    @@combinations = [[0,1,2],[3,4,5],[6,7,8],[0,4,8],[2,4,6],[0,3,6],[1,4,7],[2,5,8]]

    def self.show_pole
      puts
      @@pole.each_index { |i|
        print "\n\n" if i % 3 == 0 && i >= 3
        print "| #{@@pole[i]} | "
      }
      print "\n\n"
    end

    def change_pole(position, type)
      @@pole.map! { |e|
        e = type if e == position
        e
       }
    end

    def self.full?
      @@pole.all? { |e| e == "x" || e == "0"}
    end

    def self.victory_combination?(type)
      if @@combinations.any? { |comb|  comb.all? { |e| @@pole[e] == type } }
        return true
      end
      return false
    end

    def self.pole
      @@pole
    end
  end

  def self.game_over?
    return true if @@players.any? { |e| e.won? }
    false
  end

  def self.start
    $pole = Pole.new
  end
end

Game.start
puts "Привет, добро пожаловать в крестики-нолики!"
puts "Введите имя первого игрока: "
name_1 = gets.chomp
player_1 = name_1 == "" ? Game.new_player() : Game.new_player(name_1)
puts "Введите имя второго игрока: "
name_2 = gets.chomp
player_2 = name_2 == "" ? Game.new_player() : Game.new_player(name_2)
puts "Добро пожаловать в игру, #{player_1.name} и #{player_2.name}!"
Game::Pole.show_pole

until Game.game_over?
  player_1.xod
  break if Game.game_over?
  player_2.xod
end
