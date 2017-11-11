class Game
  $count_players = 0
  $anti_vilka = true

  class Player
    attr_accessor :name, :type, :kind_player
    @@next_xod = 0 #переменная показывающая куда следует походить компьютеру в своем ходу, используется в #may_win_lose?

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
        @name = "Computer_#{rand(100)}"
        if $x_choose == false
          @type = "x"
          $x_choose = true
        else
          @type = "0"
          $o_choose = true
        end
      end
    end

    def won?
      if Pole.victory_combination?(@type)
       print "\n--------------------------------\n!!!Игрок #{@name} выиграл!!!\n--------------------------------\n"
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
        $pole.change_pole(position, @type) #переменная $pole это глобальная переменная она обьявляется в функции Game.start
        Pole.show_pole                             #и приравнивается новому обьекту класса поле
      else
        puts "Неверный ход, попробуйте снова."
        Pole.show_pole
        self.xod
      end
    end

    def may_win_lose?(type = @type)
      k = false
      for i in 1..9 do
        if free?(i-1)
          $pole.change_pole(i, type)
          if Pole.victory_combination?(type)
            k = true
            @@next_xod = i
          end
          Pole.pole[i-1] = i
        end
      end
      return true if k == true
      return false
    end

    def anti_vilka(angle)
      position = 0
      case angle
      when 0
        if free?(2)
          position = 2
        elsif free?(6)
          position = 6
        elsif free?(5)
          position = 5
        elsif free?(7)
          position = 7
        else
          $anti_vilka = false
        end
      when 2
        if free?(0)
          position = 0
        elsif free?(8)
          position = 8
        elsif free?(3)
          position = 3
        elsif free?(7)
          position = 7
        else
          $anti_vilka = false
        end
      when 6
        if free?(0)
          position = 0
        elsif free?(8)
          position = 8
        elsif free?(1)
          position = 1
        elsif free?(5)
          position = 5
        else
          $anti_vilka = false
        end
      when 8
        if free?(6)
          position = 6
        elsif free?(2)
          position = 2
        elsif free?(1)
          position = 1
        elsif free?(3)
          position = 5
        else
          $anti_vilka = false
        end
      end
      position
    end

    def anti_vilka?(i)
      anti_vilka(i)
      $anti_vilka
    end

    def xod_computer
      t = true
      k = false
      position = 0
      enemy_type = @type == "x" ? "0" : "x"
      if free?(4)
        position = 5
      elsif may_win_lose?
        position = @@next_xod
      elsif may_win_lose?(enemy_type)
        position = @@next_xod
      else
        for i in [0,2,6,8] do
          if Pole.pole[i] == enemy_type && anti_vilka?(i)
            position = anti_vilka(i)+1
            k = true
            break
          elsif free?(i)
            k = true
            position=i+1
            break
          end
        end
        if k == false
          while t do
            position = 1+rand(9)
            t = false if free?(position-1)
          end
        end
      end
      $pole.change_pole(position, @type)
      Pole.show_pole
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

    def free?(index)
      return true until ["x","0"].any? { |symbol| Pole.pole[index] == symbol}
    end

    def right_xod?(position)
      return false if (position < 1 || position > 9 || !free?(position-1))
      true
    end
  end

  class Pole
    @@pole = [1,2,3,4,5,6,7,8,9]
    @@combinations = [[0,1,2],[3,4,5],[6,7,8],[0,4,8],[2,4,6],[0,3,6],[1,4,7],[2,5,8]]

    def self.pole_blank?
      @@pole.all? { |e| e != "x" && e != "0"}
    end

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

  def self.player_vs_comp
    @@player_1 = Player.new(:people)
    @@player_2 = Player.new(:computer)
    greeting
  end

  def self.comp_vs_comp
    @@player_1 = Player.new(:computer)
    @@player_2 = Player.new(:computer)
    greeting
  end

  def self.start
    $pole = Pole.new
    $x_choose = false
    $o_choose = false
    puts "Привет, добро пожаловать в крестики-нолики!"
    puts "Выберите режим игры: 1 игрок против игрока; 2 игрок против компьютера; 3 компьютер против компьютера"
    case gets.chomp.strip.to_i
    when 1 then player_vs_player
    when 2 then player_vs_comp
    when 3 then comp_vs_comp
    else player_vs_player
    end

    Pole.show_pole #показываем поле

    loop do
      break if @@player_1.xod == true || @@player_2.xod == true
    end
  end
end


# Game.start
