require 'spec_helper'

describe Metlinkr::Trip do
  let(:raw_shitty_html) do
    File.read(File.dirname(__FILE__) + "/fixtures/multiple_journey.html")
  end

  subject do
    Metlinkr::Trip.parse(raw_shitty_html)
  end

  it "parses Trip effectively" do
    subject.steps.length.should == 7

    step = subject.steps.first

    step.method.should == :tram
    step.origin.should == "Stop 29 - Barkers Rd/High St (Kew)"
    step.destination.should == "Stop 19 - North Richmond Railway Station/Victoria St (Richmond)"
    step.departure_time.should == "8:39pm"
    step.arrival_time.should == "8:48pm"
    step.duration.should == "9 min"
    step.route.should == "109 tram towards Port Melbourne"
  end
end
