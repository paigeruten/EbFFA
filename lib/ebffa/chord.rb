module EbFFA
  class Chord
    include Enumerable

    attr_accessor :notes

    def initialize(notes)
      @notes = notes
    end

    def each
      @notes.each do |note|
        yield note
      end
    end

    # checks if the two chords have the exact same notes, regardless of order
    def ==(other)
      @notes.sort == other.notes.sort
    end

    # checks if the two chords have the same notes, regardless of order and
    # ignoring the notes' octave
    def ===(other)
      @notes.map { |note| note.va(0) }.sort == other.notes.map { |note| note.va(0) }.sort
    end

    # adds a note to the chord, or the notes of a chord to the chord
    def +(other)
      if other.is_a? Note
        Chord.new(@notes + [other])
      elsif other.is_a? Chord
        Chord.new(@notes + other.notes)
      end
    end

    # raise whole chord by a certain number of octaves
    def >>(octaves)
      Chord.new(@notes.map { |note| note >> octaves })
    end

    # lower whole chord by a certain number of octaves
    def <<(octaves)
      Chord.new(@notes.map { |note| note << octaves })
    end

    # play chord through the bloopsaphone, in a :harmonic or :melodic way
    def play(how = :harmonic)
      Sound.play(@notes.map(&:bloops_note).join(" "), how)
    end

    def inspect
      "chord " + @notes.map { |note| note.to_s }.join(", ")
    end

    # raise (or lower) the whole chord by a certain interval
    def ^(interval)
      Chord.new @notes.map { |note| note ^ interval }
    end

    # raise the lowest note in the chord by octaves until it is the highest note
    # in the chord
    def invert!
      min = @notes.delete(@notes.min)
      max = @notes.max

      min >>= 1 until min > max

      @notes << min
    end

    def invert
      chord = self.dup
      chord.invert!
      chord
    end

    # construct a triad from a particular tonic, quality (major, minor,
    # diminished, or half-diminished), and inversion
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

    # construct a dominant seventh chord
    def self.v7(tonic, inversion = 0)
      root = tonic ^ P5
      c = new [root, root ^ M3, root ^ P5, root ^ Mn7]
      inversion.times { c.invert! }
      c
    end

    # construct a diminished seventh chord
    def self.o7(tonic, inversion = 0)
      root = tonic ^ Mn2.below
      c = new [root, root ^ Mn3, root ^ D5, root ^ D7]
      inversion.times { c.invert! }
      c
    end
  end
end

