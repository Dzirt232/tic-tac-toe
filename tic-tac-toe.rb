class Game
  $count_players = 0
  $x_choose = false
  $o_choose = false

  class Player
    attr_accessor :name, :type

    def initialize
      $count_players += 1
      puts "Введите имя #{$count_players} игрока: "
      name = gets.chomp.strip
      @name = name != "" ? name : "Player_#{$count_players}"
      begin
        puts "Вы хотите играть за 'x' или '0'?"
        type = gets.chomp.strip
        if type == 'x' && $x_choose == false
          @type = "x"
          $x_choose = true
        elsif type == "0" && $o_choose == false
          @type = "0"
          $o_choose = true
        else
          raise "Упс... Похоже вы ввели что-то другое, попробуйте снова."
        end
      rescue Exception => e
        puts e
        retry
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
      won?
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

  def self.start
    $pole = Pole.new
    puts "Привет, добро пожаловать в крестики-нолики!"
    player_1 = Player.new
    player_2 = Player.new
    puts "Добро пожаловать в игру, #{player_1.name} и #{player_2.name}!"
    Pole.show_pole

    if player_1.type == "0"
      player_1, player_2 = player_2, player_1
    end

    loop do
      break if player_1.xod == true
      break if player_2.xod == true
    end
  end
end

Game.start
