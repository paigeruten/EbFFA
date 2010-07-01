module EbFFA
  # An Interval is the distance between two notes. Note#^ and Note#- both use
  # intervals. They are concious of what "key" you are in, and set up
  # accidentals accordingly. That is why an Interval isn't just the number of
  # semitones between notes. It's the number of letter-names between two notes,
  # with a +quality+ to make up for the missing or excess semitones.
  class Interval
    attr_accessor :semitones, :quality, :interval

    # Make a new Interval. Takes a +quality+ and an +interval+.
    #
    # +quality+ can be one of:
    #
    # - <tt>:per</tt> for perfect
    # - <tt>:dim</tt> for diminished
    # - <tt>:min</tt> for minor
    # - <tt>:maj</tt> for major
    # - <tt>:aug</tt> for augmented
    #
    # +interval+ is the number of letter-names between notes. There are 3
    # between C and E, and 5 between C and G, for example.
    def initialize(quality, interval)
      @quality, @interval = quality, interval

      @semitones = _interval_to_semitones(@quality, @interval)
    end

    # Intervals are compared by the number of semitones between each interval.
    # So an augmented fourth equals a diminished fifth.
    def ==(other)
      @semitones == other.semitones
    end

    # Makes an "above" interval a "below" one. I guess it also makes a "below"
    # interval an "above" interval. So, using the defined constants in
    # Intervals, you can do something like <tt>P5.below</tt> to get a perfect
    # fifth below interval.
    def below
      Interval.new(@quality, -@interval)
    end

    # Display the quality as a very short abbreviation, then the interval, then
    # a 'B' or an 'A' depending on whether it's a below or above interval.
    #
    # So, you'll get stuff like "P5 B" (perfect fifth below) and "A4 A"
    # (augmented fourth above).
    def to_s
      qualities = { :per => 'P', :dim => 'D', :min => 'Mn', :maj => 'M', :aug => 'A' }

      if @interval < 0
        qualities[@quality] + @interval.abs.to_s + ' B'
      else
        qualities[@quality] + @interval.to_s + ' A'
      end
    end

    # Say it's an interval then show it.
    def inspect
      "interval " + to_s
    end

    private

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

