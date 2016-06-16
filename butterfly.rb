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
 
    @caterpillar.draw_dynamic(100, 100)
           @egg1.draw_dynamic(600, 100)
           @egg2.draw_dynamic(900, 100)

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
  def clicked?(click_x, click_y)
    puts "#{self.class} #{x},#{y}"

    return false if click_x < x
    return false if click_x > (x + width)
    return false if click_y < y
    return false if click_y > (y + height)
    puts "*** #{self.class} CLICKED! ***"
  end
end

module DrawDynamic
  def draw_dynamic(x,y)
    @x = x
    @y = y
    draw(x,y,1)
  end
end

class Caterpillar < Gosu::Image
  include Clicked
  include DrawDynamic

  attr_reader :x, :y, :width, :height

  def initialize
    @width, @height = [ 248, 91 ]
    path = "images/black_caterpillar_1.png"
    super(path)
  end
end

class Egg < Gosu::Image
  include Clicked
  include DrawDynamic

  attr_reader :x, :y, :width, :height

  def initialize(type)
    @width, @height = [ 94, 180 ]
    path = "images/black_egg_1.png"  if type == :black
    path = "images/yellow_egg_1.png" if type == :yellow
    super(path)
  end

  def draw_dynamic(x,y)
    @x = x
    @y = y
    draw(x,y,1)
  end
end

class Incubator < Gosu::Image
  include Clicked

  attr_reader :x, :y, :width, :height

  def initialize
    @x, @y, @width, @height = [ BOX_SIZE * 1, BOX_SIZE * 1, BOX_SIZE, BOX_SIZE ]
    path = "images/incubator_1.png"
    super(path)
  end

  def draw_static
    draw(x, y, 1)
  end
end

class LeafSpot < Gosu::Image
  include Clicked

  attr_reader :x, :y, :width, :height

  def initialize
    @x, @y, @width, @height = [ BOX_SIZE * 3, BOX_SIZE * 1, BOX_SIZE, BOX_SIZE ]
    path = "images/leaf_spot_1.png"
    super(path)
  end

  def draw_static
    draw(x, y, 1)
  end
end

window = Butterfly.new
window.show
