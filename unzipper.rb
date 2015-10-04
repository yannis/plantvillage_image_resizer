require 'rubygems'
require 'bundler/setup'
require 'zip'

class Unzipper

  attr_accessor :source, :extract, :result

  def initialize(source_path=nil)
    @source = source_path
    @result = nil
  end

  def extract
    if @source.nil?
      raise "Source can't be nil"
    end
    destination = File.dirname(@source)
    Zip::File.open(@source) do |zip_file|
      zip_file.each do |f|
        f_path = File.join(destination, f.name)
        FileUtils.mkdir_p(File.dirname(f_path)) unless File.exist?(f_path)
        f.extract(f_path)
      end
    end
    result_path = @source.gsub(/.zip$/, '')
    @result = result_path if File.exist?(result_path)
    if @result
      FileUtils.rm_r @source
    end
    FileUtils.rm_r("__MACOSX") if File.exist?("__MACOSX")
  end

end
