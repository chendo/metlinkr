require 'spec_helper'

describe Metlinkr::Journey do
  let(:raw_shitty_html) do
    File.read(File.dirname(__FILE__) + "/fixtures/multiple_journey.html")
  end

  subject do
    Metlinkr::Journey.parse(raw_shitty_html)
  end

  it "parses journey effectively" do
    subject.steps.length.should == 7

    pp subject.steps
  end
end
