require 'rubygems'
require 'bundler/setup'
require 'zip'
require 'rmagick'

def is_image?(filename)
  !filename.downcase.match(/\.jpeg|\.jpg/).nil?
end

def two_step_resize(img, filename, max_x, max_y)
  x = img.columns
  y = img.rows

  #make sure it's a float w/ the 1.0*
  ratio = (1.0*x)/y

  new_y = max_y
  new_x = ratio * new_y

  if (new_x > max_x)
    new_x = max_x
    new_y = new_x / ratio
  end

  # do the change in two steps, first the height
  img.resize!(x, new_y);
  #then the width
  img.resize!(new_x, new_y)

  #save it, with the least compression to get a better image
  img.write(filename){self.quality=100}

end

def unzip_file (file)
  destination = "."
  p "Extracting: #{file}"
  Zip::File.open(file) do |zip_file|
    zip_file.each do |f|
      f_path = File.join(destination, f.name)
      FileUtils.mkdir_p(File.dirname(f_path)) unless File.exist?(f_path)
      f.extract(f_path)
    end
  end
end

# unzip zipped dirs
zipped_dirs = Dir.entries('.').select {|entry| File.file?(File.join('.', entry)) and entry.match(/plantimages/) and entry.match(/\.zip$/) }
zipped_dirs.each do |zipped_dir|
  if unzip_file zipped_dir
    FileUtils.rm(zipped_dir)
  end
  FileUtils.rmdir("./__MACOSX")
end

#list all plantimages dirs
directories = Dir.entries('.').select {|entry| File.directory? File.join('.',entry) and !(entry =='.' || entry == '..')and entry.match(/plantimages/) }

directories.each do |directory|
  images = Dir.entries(directory).select do |filename|
    is_image?(filename)
  end
  images.each do |image|
    p "Resizing image: #{image}"
    image_fullpath = File.join(directory, image)
    image_basename = File.basename(image)
    img = Magick::Image.read(image_fullpath).first
    new_image_filename = image_fullpath.gsub(image_basename, image_basename+"_resized")
    two_step_resize(img, new_image_filename , 600, 800)
  end
end



