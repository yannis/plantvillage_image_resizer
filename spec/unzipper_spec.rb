require 'spec_helper'
require './unzipper'

RSpec.describe Unzipper do
  describe 'an unzipper' do
    let(:unzipper){ Unzipper.new() }
    it { expect(unzipper).to respond_to :source }
    it { expect(unzipper).to respond_to :extract }
    it { expect(unzipper).to respond_to :result }
  end


  describe "#extract" do
    context "source is nil" do
      let(:unzipper) { Unzipper.new() }
      it { expect(unzipper.source).to be_nil }
      it { expect{ unzipper.extract }.to raise_error RuntimeError, "Source can't be nil" }
    end

    context "source is a zip file" do
      before(:all) {
        FileUtils.rm_r('spec/__MACOSX') if File.exist?('spec/__MACOSX')
        unless File.exist?('plantimages98.zip')
          FileUtils.cp_r 'spec/support/files/plantimages98.zip', 'spec'
        end
      }
      after(:all) {
        FileUtils.rm_r('spec/__MACOSX') if File.exist?('spec/__MACOSX')
        if File.exist?('spec/plantimages98')
          FileUtils.rm_r('spec/plantimages98')
        end
      }
      let!(:source_file) { 'spec/plantimages98.zip' }
      let(:unzipper) { Unzipper.new(source_file) }
      it { expect(File.exist?(source_file)).to be true }
      it { expect(unzipper.result).to be nil }
      it {
        unzipper.extract
        expect(unzipper.result).to eql "spec/plantimages98"
        expect(Dir["spec/plantimages98/*"].length).to eql 4
      }
    end
  end
end
