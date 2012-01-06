class Metlinkr
  class Step
    attr_reader :method, :origin, :destination, :departure_time, :arrival_time, :duration, :route

    def self.parse(row_set)
      step = new
      step.parse(row_set)
    end

    def parse(row_set)
      @row_set = row_set

      parse_method
      parse_origin
      parse_destination
      parse_route
      parse_departure_time
      parse_arrival_time
      parse_duration

      @row_set = nil

      self
    end

    protected

    def parse_method
      @method = case @row_set[0].xpath("td[1]/img").first.attributes['alt'].value
      when /\btram\b/i
        :tram
      when /\btrain\b/i
        :train
      when /\bbus\b/i
        :bus
      when /\bwalk\b/i
        :walk
      else
        nil
      end
    end

    def parse_origin
      @origin = clean_stop_name(@row_set[0].xpath("td")[3].content)
    end

    def parse_destination
      @destination = clean_stop_name(@row_set[2].xpath("td")[3].content)
    end

    def parse_route
      @route = @row_set[1].xpath("td/strong").first.content.strip rescue nil
    end

    def parse_departure_time
      @departure_time = clean_time(@row_set[0].xpath("td/span").first.content) rescue nil
    end

    def parse_arrival_time
      # Why the FUCK is that div there?
      @arrival_time = clean_time(@row_set[2].xpath("td/div/span").first.content) rescue nil
    end

    def parse_duration
      @duration = @row_set[1].xpath("td").last.content.match(/(\d+ min)/)[1]
    end

    def clean_stop_name(stop)
      stop.gsub(/^(From( Stop)?)|(Get off at( stop)?)|(To)\b/i, '').gsub(/(\d+)-/, 'Stop \1 - ').gsub(/[^ -z]+/, ' ').strip
    end

    def clean_time(time)
      time.gsub(/^.*,/, '').gsub(/[^0-9a-z:]/, '').strip
    end
  end
end
