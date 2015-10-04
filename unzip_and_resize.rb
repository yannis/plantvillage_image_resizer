require 'rubygems'
require 'bundler/setup'
require 'byebug'
require './unzipper'
require './resizer'
require './image'

class UnzipAndResize

  attr_reader :source_path

  def initialize(path)
    @source_path = path
  end

  def run
    extract_all
    resize_all
  end

  def extract_all
    zipped_dirs.each do |zipped_dir|
      Unzipper.new(File.join(source_path, zipped_dir)).extract
    end
  end

  def resize_all
    source_dirs.each do |directory|
      Dir.entries(File.join(source_path, directory)).select {|entry| File.file?(File.join(source_path, directory, entry)) }.each do |file|
        begin
          image = Image.new(File.join(source_path, directory, file))
          if image.valid?
            image.resize(800, 800)
          end
        rescue Exception => e
          p "'#{file}' is not an image: #{e.message}"
        end
      end
    end
  end

  def zipped_dirs
    Dir.entries(source_path).select {|entry| File.file?(File.join(source_path, entry)) and entry.match(/plantimages/) and entry.match(/\.zip$/) }
  end

  def source_dirs
    Dir.entries(source_path).select {|entry| File.directory? File.join(source_path,entry) and !(entry =='.' || entry == '..') and entry.match(/plantimages/) }
  end

end


