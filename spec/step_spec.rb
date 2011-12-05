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

    it "parses the origin name" do
      subject.origin.should == "Stop 29 - Barkers Rd/High St (Kew)"
    end

    it "parses the destination name" do
      subject.destination.should == "Stop 19 - North Richmond Railway Station/Victoria St (Richmond)"
    end

    it "parses the route" do
      subject.route.should == '109 tram towards Port Melbourne'
    end
  end
end
