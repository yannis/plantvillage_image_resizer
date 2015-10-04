require 'spec_helper'
require './image'

RSpec.describe Image do


  before { FileUtils.cp_r('spec/support/files/image.JPG', 'spec') }
  after {
    if File.exist?('spec/image.JPG')
      FileUtils.rm_r('spec/image.JPG')
    end
    if File.exist?('spec/image_resized.JPG')
      FileUtils.rm_r('spec/image_resized.JPG')
    end
  }

  describe 'an image' do
    let(:image) { Image.new('spec/image.JPG') }
    it { expect(image).to be_valid }

    describe "#resize" do
      before { image.resize(800, 800) }
      it { expect(File.exist?('spec/image_resized.JPG')).to be true }
    end
  end
  describe 'an invalid image' do
    it { expect{ Image.new('spec/support/files/test.txt') }.to raise_error Magick::ImageMagickError, /unable to read font/ }
  end
end
