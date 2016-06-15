require "gosu"

WINDOW_WIDTH  = 1280
WINDOW_HEIGHT = 768
BOX_SIZE      = 256


class Butterfly < Gosu::Window
  def initialize
    super(WINDOW_WIDTH, WINDOW_HEIGHT)
    self.caption = "Butterfly!"

    @caterpillar = Caterpillar.new
    @egg1        = Egg.new(:black)
    @egg2        = Egg.new(:yellow)
    @incubator   = Incubator.new
    @leaf_spot   = LeafSpot.new

    @all_sprites = [
      @caterpillar, 
      @egg1,
      @egg2,
      @incubator,
      @leaf_spot,
    ]
  end

  # Show the system cursor
  def needs_cursor?
    true
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
           @egg1.draw(600, 100, 1)
           @egg2.draw(900, 100, 1)

      @incubator.draw_static
      @leaf_spot.draw_static
  end

  def button_down(id)
    if id == Gosu::MsLeft
      @all_sprites.each do |sprite|
        sprite.clicked?(mouse_x, mouse_y)
      end
    end
  end

  def draw_square(x,y,size)
    draw_quad(
      x,      y,      0xff008800, 
      x+size, y,      0xff008800, 
      x+size, y+size, 0xff008800, 
      x,      y+size, 0xff008800
    )
  end
end

module Clicked
  def clicked?(x,y)
    puts "#{self.class} #{x},#{y}"
  end
end

class Caterpillar < Gosu::Image
  include Clicked
  def initialize
    path = "images/black_caterpillar_1.png"
    super(path)
  end
end

class Egg < Gosu::Image
  include Clicked
  def initialize(type)
    path = "images/black_egg_1.png"  if type == :black
    path = "images/yellow_egg_1.png" if type == :yellow
    super(path)
  end
end

class Incubator < Gosu::Image
  include Clicked
  def initialize
    path = "images/incubator_1.png"
    super(path)
  end

  def draw_static
    width = BOX_SIZE
    height = BOX_SIZE
    x = BOX_SIZE * 1
    y = BOX_SIZE * 1
    draw(x, y, 1)
  end
end

class LeafSpot < Gosu::Image
  include Clicked
  def initialize
    path = "images/leaf_spot_1.png"
    super(path)
  end

  def draw_static
    width = BOX_SIZE
    height = BOX_SIZE
    x = BOX_SIZE * 3
    y = BOX_SIZE * 1
    draw(x, y, 1)
  end
end

window = Butterfly.new
window.show
