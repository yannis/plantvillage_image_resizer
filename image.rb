require 'rubygems'
require 'bundler/setup'
require './resizer'
require 'zip'
require 'rmagick'

class Image

  attr_reader :path, :file

  def initialize(path)
    @path = path
    @file = Magick::Image.read(path).first
    return @file
  end

  def valid?
    %w(jpg png).include?(self.get_image_extension)
  end

  def get_image_extension
    begin
      png = Regexp.new("\x89PNG".force_encoding("binary"))
      jpg = Regexp.new("\xff\xd8\xff\xe0\x00\x10JFIF".force_encoding("binary"))
      jpg2 = Regexp.new("\xff\xd8\xff\xe1(.*){2}Exif".force_encoding("binary"))
      case IO.read(@path, 10)
      when /^GIF8/
        'gif'
      when /^#{png}/
        'png'
      when /^#{jpg}/
        'jpg'
      when /^#{jpg2}/
        'jpg'
      else
        mime_type = `file #{@path} --mime-type`.gsub("\n", '') # Works on linux and mac
        raise UnprocessableEntity, "unknown file type" if !mime_type
        mime_type.split(':')[1].split('/')[1].gsub('x-', '').gsub(/jpeg/, 'jpg').gsub(/text/, 'txt').gsub(/x-/, '')
      end
    rescue
      'bad_file'
    end
  end

  def resize(max_x, max_y)
    parent_path = File.expand_path('..', @path)
    extension = File.extname(@path)
    basename = File.basename(@path, ".*")
    new_filename = File.join(parent_path, basename+'_resized'+extension)
    Resizer.new(@file, new_filename, max_x, max_y).save
  end
end
