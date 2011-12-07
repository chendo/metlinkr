require 'mechanize'
require 'nokogiri'

class Metlinkr

  START_URL = "http://jp.metlinkmelbourne.com.au/metlink/XSLT_TRIP_REQUEST2?language=en&itdLPxx_view=advanced"
  def self.instance
    @instance ||= new
  end

  def initialize

  end

  def route(from, to, options = {})
    agent = Mechanize.new
    agent.user_agent = 'Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; WOW64; Trident/5.0; chromeframe/12.0.742.112)'
    page = agent.get(START_URL)

    require 'pp'
    f = page.form('tripRequest')

    # Shitty hack for forcing address

    f.anyObjFilter_origin = 29
    f.execIdentifiedLoc_origin = 1
    f.execStopList_origin = 0

    f.anyObjFilter_destination = 29
    f.execIdentifiedLoc_destination = 1
    f.execStopList_destination = 0

    f.name_origin = from
    f.name_destination = to
    results = f.click_button

    body = results.body

    doc = Nokogiri::HTML(body)

    link = doc.search('tr.p4 td.dontprint a').first

    href = link.attributes['href'].value

    body = agent.get(href).body

    Journey.parse(body)
  end

end

$LOAD_PATH << File.dirname(__FILE__)
require 'metlinkr/version'
require 'metlinkr/journey'
require 'metlinkr/step'

