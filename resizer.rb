require 'rubygems'
require 'bundler/setup'
require 'rmagick'

class Resizer

  attr_reader :image, :filename, :max_x, :max_y

  def initialize(image, filename, max_x, max_y)
    @image = image
    @filename = filename
    @max_x = max_x
    @max_y = max_y
  end

  def save
    two_step_resize
  end

private

  def two_step_resize
    x = @image.columns
    y = @image.rows
    #make sure it's a float w/ the 1.0*
    ratio = (1.0*x)/y

    new_y = @max_y
    new_x = ratio * new_y

    if (new_x > @max_x)
      new_x = @max_x
      new_y = new_x / ratio
    end

    # do the change in two steps, first the height
    @image.resize!(x, new_y);
    #then the width
    @image.resize!(new_x, new_y)

    #save it, with the least compression to get a better image
    @image.write(@filename){self.quality=100}
  end
end
