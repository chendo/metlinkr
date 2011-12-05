class Metlinkr
  class Step
    attr_reader :method, :origin, :destination, :departure_time, :arrival_time, :duration

    def self.parse(row_set)
      step = new
      step.parse(row_set)
    end

    def parse(row_set)
      @row_set = row_set

      parse_method

      self
    end

    protected

    def parse_method
      @method = case @row_set[0].xpath("//td[1]/img").first.attributes['alt'].value
      when /tram/i
        :tram
      end
    end
  end
end
