module EbFFA
  # A Chord is just an array of notes. Chords are typically built by either
  # adding together notes (like <tt>C + E + G</tt>) or by using a Chord
  # constructor such as Chord.triad or Chord.v7.
  class Chord
    include Enumerable

    attr_accessor :notes

    # Make a new Chord out of an array of notes.
    def initialize(notes)
      @notes = notes
    end

    # Loop through the notes of a Chord. This gives Chord its Enumerable powers.
    def each
      @notes.each do |note|
        yield note
      end
    end

    # Two Chords are equal if they have the same exact notes, regardless of
    # order.
    def ==(other)
      @notes.uniq.sort == other.notes.uniq.sort
    end

    # Two Chords are triply-equal if they have the same exact notes, regardless
    # of order and regardless of octave. So two different inversions of the same
    # chord will always be triply-equal by this operator.
    def ===(other)
      @notes.map(&:base).uniq.sort == other.notes.map(&:base).uniq.sort
    end

    # Add a note to a Chord, or the notes of a Chord to a Chord.
    def +(other)
      if other.is_a? Note
        Chord.new(@notes + [other])
      elsif other.is_a? Chord
        Chord.new(@notes + other.notes)
      end
    end

    # Raise whole chord by a certain number of octaves.
    def >>(octaves)
      Chord.new(@notes.map { |note| note >> octaves })
    end

    # Lower whole chord by a certain number of octaves.
    def <<(octaves)
      Chord.new(@notes.map { |note| note << octaves })
    end

    # Play chord through the bloopsaphone, in a :harmonic or :melodic style.
    def play(how = :harmonic)
      Sound.play(@notes.map(&:bloops_note).join(" "), how)
    end

    # Say it's a chord, then show the notes it is composed of.
    def inspect
      "chord " + @notes.map { |note| note.to_s }.join(", ")
    end

    # Raise (or lower) the whole chord by a certain interval.
    def ^(interval)
      Chord.new @notes.map { |note| note ^ interval }
    end

    # Raise the lowest note in the chord by octaves until it is the highest note
    # in the chord. This generates inversions of the chord.
    def invert!
      min = @notes.delete(@notes.min)
      max = @notes.max

      min >>= 1 until min > max

      @notes << min
    end

    # Invert the chord but return it as a new chord.
    def invert
      chord = self.dup
      chord.invert!
      chord
    end

    # Construct a triad from a particular +tonic+, +quality+, and +inversion+.
    #
    # +tonic+ can be any Note.
    #
    # +quality+ may be any one of:
    #
    # - <tt>:maj</tt> for a major triad.
    # - <tt>:min</tt> for a minor one.
    # - <tt>:dim</tt> for a diminished.
    # - <tt>:halfdim</tt> for a half-diminished.
    #
    # +inversion+ is the number of times to invert the triad.
    def self.triad(tonic, quality = :maj, inversion = 0)
      case quality
      when :maj
        c = new [tonic, tonic ^ M3, tonic ^ P5]
      when :min
        c = new [tonic, tonic ^ Mn3, tonic ^ P5]
      when :dim
        c = new [tonic, tonic ^ Mn3, tonic ^ D5]
      when :halfdim
        c = new [tonic, tonic ^ M3, tonic ^ D5]
      end
      inversion.times { c.invert! }
      c
    end

    # Construct a dominant seventh chord.
    #
    # +tonic+ can be any Note.
    #
    # +inversion+ is the number of the times to invert the chord.
    def self.v7(tonic, inversion = 0)
      root = tonic ^ P5
      c = new [root, root ^ M3, root ^ P5, root ^ Mn7]
      inversion.times { c.invert! }
      c
    end

    # Construct a diminished seventh chord.
    #
    # +tonic+ can be any Note.
    #
    # +inversion+ is the number of the times to invert the chord.
    def self.o7(tonic, inversion = 0)
      root = tonic ^ Mn2.below
      c = new [root, root ^ Mn3, root ^ D5, root ^ D7]
      inversion.times { c.invert! }
      c
    end
  end
end

