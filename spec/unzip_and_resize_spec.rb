require 'spec_helper'
require './unzip_and_resize'

RSpec.describe UnzipAndResize do
  before {
    unless File.exist?('spec/uploads/')
      FileUtils.mkdir 'spec/uploads/'
    end
    unless File.exist?('spec/uploads/plantimages98.zip')
      FileUtils.cp_r 'spec/support/files/plantimages98.zip', 'spec/uploads/'
    end
    unless File.exist?('spec/uploads/plantimages2.zip')
      FileUtils.cp_r 'spec/support/files/plantimages2.zip', 'spec/uploads/'
    end
  }
  after {
    if File.exist?('spec/uploads/')
      FileUtils.rm_r('spec/uploads/')
    end
  }

  describe 'unzip_and_resize' do
    let(:unzip_and_resize){ UnzipAndResize.new("spec/uploads/") }
    it { expect(File.exist?('spec/uploads/plantimages2.zip')).to be true }
    it { expect(File.exist?('spec/uploads/plantimages98.zip')).to be true }

    describe '#run' do
      before { unzip_and_resize.run }

      it { expect(File.exist?('spec/uploads/plantimages98')).to be true }
      it { expect(File.exist?('spec/uploads/plantimages2')).to be true }
      it { expect(Dir["spec/uploads/plantimages98/*"].length).to eql 7 }
      it { expect(Dir["spec/uploads/plantimages2/*"].length).to eql 9 }
    end
  end
end
