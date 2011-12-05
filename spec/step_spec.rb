require 'spec_helper'

describe Metlinkr::Step do
  describe '#parse' do
    let(:tram_snippet) do
      File.read(File.dirname(__FILE__) + "/fixtures/tram_snippet.html")
    end

    let(:row_set) do
      Nokogiri::HTML(tram_snippet).xpath("//tr")
    end

    subject do
      Metlinkr::Step.parse(row_set)
    end

    it "parses the mode of transport" do
      subject.method.should == :tram
    end
  end
end
