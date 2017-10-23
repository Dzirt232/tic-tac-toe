class Game
  $count_players = 0
  $x_choose = false
  $o_choose = false

  class Player
    attr_accessor :name, :type, :kind_player

    def initialize(kind_player)
      @kind_player = kind_player
      $count_players += 1

      if @kind_player == :people
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
      elsif @kind_player == :computer
        name = "Computer_#{rand(100)}"
        type = $x_choose == true ? "0" : "x"
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

    def xod_people
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

    def xod_computer

    end

    def xod
      puts "Ход игрока #{self.name}"
      if self.kind_player == :people
        self.xod_people
      elsif self.kind_player == :computer
        self.xod_computer
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

  def self.greeting
    puts "Добро пожаловать в игру, #{@@player_1.name} и #{@@player_2.name}!"
    if @@player_1.type == "0"
      @@player_1, @@player_2 = @@player_2, @@player_1
    end
  end

  def self.player_vs_player
    @@player_1 = Player.new(:people)
    @@player_2 = Player.new(:people)
    greeting
  end

  def player_vs_comp
    @@player_1 = Player.new(:people)
    @@player_2 = Player.new(:computer)
    greeting
  end

  def comp_vs_comp
    @@player_1 = Player.new(:computer)
    @@player_2 = Player.new(:computer)
    greeting
  end

  def self.start
    $pole = Pole.new
    puts "Привет, добро пожаловать в крестики-нолики!"
    puts "Выберите режим игры: 1 игрок против игрока; 2 игрок против компьютера; компьютер против компьютера"
    case gets.chomp.strip.to_i
    when 1 then player_vs_player
    when 2 then player_vs_comp
    when 3 then comp_vs_comp
    else player_vs_player
    end

    Pole.show_pole #показываем поле

    loop do
      break if @@player_1.xod == true
      break if @@player_2.xod == true
    end
  end
end

Game.start
