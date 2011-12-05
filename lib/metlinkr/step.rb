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

      self
    end

    protected

    def parse_method
      @method = case @row_set[0].xpath("//td[1]/img").first.attributes['alt'].value
      when /tram/i
        :tram
      end
    end

    def parse_origin
      @origin = clean_stop_name(@row_set[0].xpath("td/strong/a").first.content)
    end

    def parse_destination
      @destination = clean_stop_name(@row_set[2].xpath("td/a").first.content)
    end

    def parse_route
      @route = @row_set[1].xpath("td/strong").first.content.strip
    end

    def parse_departure_time
      @departure_time = clean_time(@row_set[0].xpath("td/span").first.content)
    end

    def parse_arrival_time
      # Why the FUCK is that div there?
      @arrival_time = clean_time(@row_set[2].xpath("td/div/span").first.content)
    end

    def clean_stop_name(stop)
      stop.gsub!(/(\d+)-/, 'Stop \1 - ').strip
    end

    def clean_time(time)
      time.gsub(/^.*,/, '').gsub(' ', '').strip
    end
  end
end
