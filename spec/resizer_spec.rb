require 'spec_helper'
require './resizer'
require './image'

RSpec.describe Resizer do

  before { FileUtils.cp_r('spec/support/files/image.JPG', 'spec') }
  after {
    if File.exist?('spec/image.JPG')
      FileUtils.rm_r('spec/image.JPG')
    end
    if File.exist?('spec/image_resized.JPG')
      FileUtils.rm_r('spec/image_resized.JPG')
    end
  }

  let(:image) { Image.new('spec/image.JPG').file }
  let(:resizer) { Resizer.new image, "spec/image_resized.JPG", 800, 800 }
  it { expect(resizer).to respond_to :image }
  it { expect(resizer).to respond_to :max_x }
  it { expect(resizer).to respond_to :max_y }

  describe '#save' do
    before { resizer.save }
    it { expect(File.exist?('spec/image_resized.JPG')).to be true }
  end
end
