require 'nokogiri'
class Metlinkr
  class Trip
    attr_accessor :steps

    def self.parse(html)
      trip = new

      doc = Nokogiri::HTML(html)

      rows = doc.xpath("//table[@text-align='top']/tr")

      rows = rows.to_a.reject do |row|
        # Reject the hidden ones
        klass = row.attributes['class'].value rescue ""
        klass =~ /addinfo|jpText/
      end

      rows.shift # Get rid of header row

      if rows.length % 3 != 0
        raise "Rows not a multiple of 3"
      end

      trip.steps = []
      rows.each_slice(3) do |row_set|
        trip.steps << Step.parse(row_set)
      end

      trip
    end
  end
end
