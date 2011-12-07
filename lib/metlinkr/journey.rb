require 'nokogiri'
class Metlinkr
  class Journey
    attr_accessor :steps

    def self.parse(html)
      journey = new

      doc = Nokogiri::HTML(html)

      rows = doc.xpath("//table[@text-align='top']/tr")

      rows.shift # Get rid of header row

      if rows.length % 3 != 0
        raise "Rows not a multiple of 3"
      end

      journey.steps = []
      rows.each_slice(3) do |row_set|
        journey.steps << Step.parse(row_set)
      end

      journey
    end
  end
end
