require 'mechanize'
require 'nokogiri'

class Metlinkr

  class Journey

    START_URL = "http://jp.metlinkmelbourne.com.au/metlink/XSLT_TRIP_REQUEST2?language=en&itdLPxx_view=advanced"

    attr_reader :from, :to, :options, :trips, :url

    def initialize(from, to, options = nil)
      @from = from
      @to = to
      @options = options || {:methods => :all, :ignore_earlier_trip => true, :limit => 1}
    end

    def plan

      agent = Mechanize.new
      agent.user_agent = 'Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; WOW64; Trident/5.0; chromeframe/12.0.742.112)'

      page = agent.get(START_URL)

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

      select_methods(f, options[:methods])

      results = f.click_button

      body = results.body

      doc = Nokogiri::HTML(body)

      @from, @to = doc.search('div.jpHeaderBoxInner div.jpText').map { |node| node.content.gsub(/[^a-zA-Z\(\) \d-]/, '').strip }

      links = doc.search('tr.p4 td.dontprint a, tr.p2 td.dontprint a')

      links.shift if options[:ignore_earlier_trip]

      links = links.slice(0, options[:limit])
      @trips = links.map do |link|
        href = link.attributes['href'].value
        fetch_and_parse_trip_from_href(agent, href)
      end
    end

    private

    def fetch_and_parse_trip_from_href(agent, href)
      Trip.parse(agent.get(href).body)
    end

    METHOD_MAPPING = {
      :train        => 'inclMOT_1',
      :tram         => 'inclMOT_4',
      :bus          => 'inclMOT_5',
      :vline        => 'inclMOT_0',
      :regional_bus => 'inclMOT_6',
      :skybus       => 'inclMOT_3'
    }

    ALL_METHODS = [:tram, :train, :bus, :vline, :regional_bus, :skybus]

    def select_methods(form, methods = :all)
      if methods == :all
        methods = ALL_METHODS
      end

      (ALL_METHODS - [methods].flatten).each do |method|
        form.checkbox_with(:name => METHOD_MAPPING[method]).uncheck
      end

    end
  end
end
