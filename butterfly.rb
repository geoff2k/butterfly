require "gosu"

WINDOW_WIDTH  = 1280
WINDOW_HEIGHT = 1024
BOX_SIZE      = 256


class Butterfly < Gosu::Window
  def initialize
    super(WINDOW_WIDTH, WINDOW_HEIGHT)
    self.caption = "Butterfly!"

    @caterpillar = Caterpillar.new
    @egg         = Egg.new
    @incubator   = Incubator.new
    @leaf_spot   = LeafSpot.new
  end

  def draw
    size = BOX_SIZE
    y = 0
    loop do
      x = 0
      loop do
        draw_square(x, y, size)
        x += size
        break if x >= WINDOW_WIDTH
      end
      y += size
      break if y >= WINDOW_HEIGHT
    end
 
    @caterpillar.draw(100, 100, 1)
            @egg.draw(600, 100, 1)
      @incubator.draw(100, 300, 1)
      @leaf_spot.draw(900, 300, 1)
  end

  def draw_square(x,y,size)
    draw_line x,      y,      0xff000000, x+size, y,      0xff00ff00
    draw_line x+size, y,      0xff000000, x+size, y+size, 0xff00ff00
    draw_line x+size, y+size, 0xff000000, x,      y+size, 0xff00ff00
    draw_line x,      y+size, 0xff000000, x,      y,      0xff00ff00
  end
end

class Caterpillar < Gosu::Image
  def initialize
    path = "images/black_caterpillar_1.png"
    super(path)
  end
end

class Egg < Gosu::Image
  def initialize
    path = "images/black_egg_1.png"
    path = "images/yellow_egg_1.png"
    super(path)
  end
end

class Incubator < Gosu::Image
  def initialize
    path = "images/incubator_1.png"
    super(path)
  end
end

class LeafSpot < Gosu::Image
  def initialize
    path = "images/leaf_spot_1.png"
    super(path)
  end
end

window = Butterfly.new
window.show
