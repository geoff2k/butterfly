require "gosu"

class Butterfly < Gosu::Window
  def initialize
    super(800,600)
    self.caption = "Butterfly!"
  end

  def draw
    size = 200
    y = 0
    loop do
      x = 0
      loop do
        draw_square(x, y, size)
        x += size
        break if x >= 800
      end
      y += size
      break if y >= 600
    end
  end

  def draw_square(x,y,size)
    draw_quad(x, y, 0xffffffff, x+size, y, 0xff000000, x+size, y+size, 0x00ff0000, x, y+size, 0x0000ff00)
  end
end

class Incubator < Gosu::Image
  def initialize(path)
    super(path)
  end
end

class LeafSpot < Gosu::Image
  def initialize(path)
    super(path)
  end
end

class Egg < Gosu::Image
  def initialize(path)
    super(path)
  end
end

class Caterpillar < Gosu::Image
  def initialize(path)
    super(path)
  end
end

window = Butterfly.new
window.show
