require "gosu"

WINDOW_WIDTH  = 1280
WINDOW_HEIGHT = 768
BOX_SIZE      = 256


class Butterfly < Gosu::Window
  def initialize
    super(WINDOW_WIDTH, WINDOW_HEIGHT)
    self.caption = "Butterfly!"

    @caterpillar = Caterpillar.new(show: false)
    @egg         = Egg.new(:black, show: false)

    @incubator   = Incubator.new(@egg)
    @leaf_spot   = LeafSpot.new

    @all_sprites = [
      @caterpillar, 
      @egg,
      @incubator,
      @leaf_spot,
    ]
  end

  # Show the system cursor
  def needs_cursor?
    true
  end

  def update
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
            @egg.draw_dynamic(600, 100)

      @incubator.draw_static
      @leaf_spot.draw_static
  end

  def draw_square(x,y,size)
    draw_quad(
      x,      y,      0xff008800, 
      x+size, y,      0xff008800, 
      x+size, y+size, 0xff008800, 
      x,      y+size, 0xff008800
    )
  end

  def button_down(id)
    if id == Gosu::MsLeft
      @all_sprites.each do |sprite|
        sprite.clicked?(mouse_x, mouse_y)
      end
    end
  end
end

# Module that allows rectangular sprites to tell whether they have bee clicked
module Clicked
  def clicked?(click_x, click_y)
    return false if x.nil? || y.nil?

    puts "#{self.to_s} #{x},#{y}"

    return false if click_x < x
    return false if click_x > (x + width)
    return false if click_y < y
    return false if click_y > (y + height)

    puts "*** #{self.to_s} CLICKED! ***"

    perform_click_action
  end
end

# Module for sprites that will be drawn dynamically
module DrawDynamic
  def show?
    @show == true
  end

  def draw_dynamic(x,y)
    return if !show?

    @x = x
    @y = y
    draw(x,y,1)
  end
end

module Container
  def full?
  end
end

# Caterpillar sprite
class Caterpillar < Gosu::Image
  include Clicked
  include DrawDynamic

  attr_reader :x, :y, :width, :height

  def initialize(show:)
    @show = show
    @width, @height = [ 248, 91 ]
    path = "images/black_caterpillar_1.png"
    super(path)
  end

  def to_s
    self.class
  end
end

# Egg sprite
class Egg < Gosu::Image
  include Clicked
  include DrawDynamic

  attr_reader :x, :y, :width, :height

  def initialize(type, show:)
    @type = type
    @show = show
    @width, @height = [ 94, 180 ]
    path = "images/black_egg_1.png"  if @type == :black
    path = "images/yellow_egg_1.png" if @type == :yellow
    super(path)
  end

  def show=(value)
    @show = value
  end

  def to_s
    "#{self.class} #{@type}"
  end
end

# Incubator sprite
class Incubator < Gosu::Image
  include Clicked

  attr_reader :x, :y, :width, :height

  attr_reader :has_egg

  def initialize(egg)
    @x, @y, @width, @height = [ BOX_SIZE * 1, BOX_SIZE * 1, BOX_SIZE, BOX_SIZE ]
    @has_egg = false
    @egg = egg
    path = "images/incubator_1.png"
    super(path)
  end

  def draw_static
    draw(x, y, 1)
  end

  def to_s
    self.class
  end

  def perform_click_action
    return if @has_egg
    @has_egg = true
    @egg.show = true
  end
end

# Leafspot sprite
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

  def to_s
    self.class
  end
end

window = Butterfly.new
window.show
