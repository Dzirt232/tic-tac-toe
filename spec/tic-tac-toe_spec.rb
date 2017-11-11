require './tic-tac-toe'

describe Game do
  let(:player_1){Game::Player.new(:computer)}
  let(:player_2){Game::Player.new(:computer)}

  before(:each) do
    $x_choose = false
    $o_choose = false
    player_1
    player_2
  end

  describe Game::Player do
    before :example do
      $pole = Game::Pole.new
    end

    context "it initialize players" do
      it "with right types" do
        expect(player_1.type).to eql("x")
        expect(player_2.type).to eql("0")
      end
    end

    context "it game over when one of players won" do
      it "player_1 won if horizontal is his" do
        class Game::Pole
          @@pole = ["x","x","x","0",5,6,"0",8,9]
        end
        expect(player_1.won?).to be true
      end

      it "player_1 won if vertical is his" do
        class Game::Pole
          @@pole = ["0","x",3,"0","x",6,"0","x",9]
        end
        expect(player_1.won?).to be true
      end

      it "player_1 won if diagonal is his" do
        class Game::Pole
          @@pole = ["0","0","x","0","x",6,"x",8,9]
        end
        expect(player_1.won?).to be true
        expect(player_2.won?).to be false
      end

      it "player_2 won if is diagonal is his" do
        class Game::Pole
          @@pole = ["x","x","0",4,"0",6,"0",8,9]
        end
        expect(player_1.won?).to be false
        expect(player_2.won?).to be true
      end

      it "draw" do
        class Game::Pole
          @@pole = ["x","x","0","0","0","x","0","x","x"]
        end
          expect(player_1.won?).to be true
          expect(player_2.won?).to be true
          class Game::Pole
            @@pole = ["x","x",3,4,5,"0",7,"x",9]
          end
      end
    end

    context "it may win or lose" do
      it "may win" do
        expect(player_1.may_win_lose?).to be true
      end

      it "may lose" do
        expect(player_2.may_win_lose?(player_1.type)).to be true
      end
    end
  end

  describe Game::Pole do
    before(:each) do
      class Game::Pole
        @@pole = [1,2,3,4,5,6,7,8,9]
      end
    end
    let(:pole){Game::Pole.new}

    context "it change pole" do
      it "when x" do
        expect(pole.change_pole(2,"x")).to eql([1,"x",3,4,5,6,7,8,9])
      end

      it "when 0" do
        expect(pole.change_pole(3,"0")).to eql([1,2,"0",4,5,6,7,8,9])
      end
    end

    context "it examine full pole" do
      it "pole blank" do
        expect(Game::Pole.pole_blank?).to be true
      end

      it "pole not blank" do
        class Game::Pole
          @@pole = [1,"x",3,4,5,6,7,8,"0"]
        end
        expect(Game::Pole.pole_blank?).to be false
      end
    end
  end
end
