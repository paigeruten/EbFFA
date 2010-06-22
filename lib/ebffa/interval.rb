module EbFFA
  class Interval
    attr_accessor :semitones, :quality, :interval

    def initialize(quality, interval)
      @quality, @interval = quality, interval

      @semitones = _interval_to_semitones(@quality, @interval)
    end

    def ==(other)
      @semitones == other.semitones
    end

    def below
      Interval.new(@quality, -@interval)
    end

    def to_s
      qualities = { :per => 'P', :dim => 'D', :min => 'Mn', :maj => 'M', :aug => 'A' }

      if @interval < 0
        qualities[@quality] + @interval.abs.to_s + ' B'
      else
        qualities[@quality] + @interval.to_s + ' A'
      end
    end

    def inspect
      "interval " + to_s
    end

    def _interval_to_semitones(quality, interval)
      base_interval = (interval.abs - 1) % 7 + 1

      base_semitones = [nil, 0, 2, 4, 5, 7, 9, 11][base_interval]
      octaves = (interval.abs - 1) / 7
      semitones = base_semitones + octaves * 12

      if [1, 4, 5].include? base_interval
        qualities = { :per => 0, :dim => -1, :aug => 1 }
      else
        qualities = { :maj => 0, :min => -1, :dim => -2, :aug => 1 }
      end

      semitones += qualities[quality]
      semitones = -semitones if interval < 0
      semitones
    end
  end
end

