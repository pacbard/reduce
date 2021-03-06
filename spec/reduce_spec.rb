require File.expand_path("spec_helper", File.dirname(__FILE__))
files = File.join(File.dirname(__FILE__),'files')

def cleanup(files)
  Dir[files+'/*.min.*', files+'/*.temp'].each{|f| FileUtils.rm(f)}
end

describe Reduce do
  after(:all){ cleanup(files) }

  cleanup(files)
  Dir[files+'/*.*'].each do |file|
    extension = File.extname(file)
    it "reduces #{File.extname(file)} and returns the content" do
      data = Reduce.reduce(file)
      data.length.should < File.size(file)
    end
  end

  it "uses PunyPng for gifs" do
    Smusher.should_receive(:optimize_image).with(anything, hash_including(:service => 'PunyPng'))
    Reduce.reduce(File.join(files, 'test.gif'))
  end

  it "uses SmushIt for other images" do
    Smusher.should_receive(:optimize_image).with(anything, hash_including(:service => 'SmushIt'))
    Reduce.reduce(File.join(files, 'paintcan.png'))
  end

  it "has a VERSION" do
    Reduce::VERSION.should =~ /^\d+\.\d+\.\d+$/
  end
end