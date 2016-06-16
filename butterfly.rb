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


    @leaf_spot   = LeafSpot.new

    font = Gosu::Font.new(30)

    @timer = Timer.new(font, seconds: 10, notified: @egg)

    @incubator   = Incubator.new(@egg, @timer)

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
    @timer.update
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
            @egg.draw_dynamic(337, 294)

      @incubator.draw_static
      @leaf_spot.draw_static

          @timer.draw_dynamic(370,472)
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

  def draw_dynamic(x_new, y_new)
    return if !show?

    @x = x_new
    @y = y_new

    draw(x, y, 1)
  end
end

module Container
  def full?
  end
end

module ClassBasedToString
  def to_s
    self.class
  end
end

module Drawable
  attr_reader :x, :y, :width, :height
end

# Caterpillar sprite
class Caterpillar < Gosu::Image
  include Drawable
  include DrawDynamic
  include Clicked

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
  include Drawable
  include Clicked
  include DrawDynamic

  def timer_complete
  end

  def initialize(type, show:)
    @type = type
    @show = show
    @width, @height = [ 94, 180 ]

    path = nil
    if @type == :black
      path = "images/black_egg_1.png"
    end
    if @type == :yellow
      path = "images/yellow_egg_1.png"
    end

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
  include Drawable
  include Clicked
  include ClassBasedToString

  attr_reader :has_egg

  def initialize(egg, timer)
    @x, @y, @width, @height = [ BOX_SIZE * 1, BOX_SIZE * 1, BOX_SIZE, BOX_SIZE ]
    @has_egg = false
    @egg = egg
    @timer = timer
    path = "images/incubator_1.png"
    super(path)
  end

  def draw_static
    draw(x, y, 1)
  end

  def perform_click_action
    return if @has_egg
    @has_egg = true
    @egg.show = true
    @timer.start
  end
end

# Leafspot sprite
class LeafSpot < Gosu::Image
  include Drawable
  include Clicked
  include ClassBasedToString

  def initialize
    @x, @y, @width, @height = [ BOX_SIZE * 3, BOX_SIZE * 1, BOX_SIZE, BOX_SIZE ]
    path = "images/leaf_spot_1.png"
    super(path)
  end

  def draw_static
    draw(x, y, 1)
  end
end

class Timer
  include Drawable
  include DrawDynamic

  def initialize(font, seconds:, notified:)
    @font = font
    @seconds = seconds
    @notified = notified
  end

  def start
    @show = true
    @initial_value = Gosu.milliseconds
  end

  def draw(x, y, opacity)
    @font.draw(string, x, y, 2)
  end

  def update
    if @show == true
      if number_of_seconds_to_display == 0
        @show = false
        @notified.timer_complete
      end
    end
  end

  def number_of_seconds_to_display
    now = Gosu.milliseconds
    milliseconds_since_start = now - @initial_value
    seconds_since_start = milliseconds_since_start / 1000
    @seconds - seconds_since_start
  end

  def string
    number_of_seconds_to_display.to_s
  end
end

window = Butterfly.new
window.show
