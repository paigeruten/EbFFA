module EbFFA
  # A musical Note. A Note has a letter, an accidental, and an octave. Like an
  # E, flatted, in octave 4. Octave 4 is the one middle C is in. The boundary
  # between octaves is between the B and the C.
  class Note
    include Comparable

    attr_reader :semitones, :letter, :accidental, :octave

    # Make a new Note. Give it a letter, an accidental (default is a natural),
    # and an octave (default is 4).
    #
    # +letter+ can be a symbol or string, upper or lower case, a letter from "A"
    # to "G".
    #
    # +accidental+ can be one of:
    #
    # - <tt>:n</tt> (natural)
    # - <tt>:b</tt> (flat)
    # - <tt>:s</tt> (sharp)
    # - <tt>:bb</tt> (double flat)
    # - <tt>:ss</tt> (double sharp)
    #
    # +octave+ can be any integer. Middle C is the first note in octave 4. If
    # you want this note to play through the bloops, you'll need to go with an
    # octave between 0 and 7.
    def initialize(letter, accidental = :n, octave = 4)
      @letter, @accidental, @octave = letter, accidental, octave

      @semitones = _letter_to_semitones(@letter) +
                   _accidental_to_semitones(@accidental) +
                   _octave_to_semitones(@octave)
    end

    # Notes are compared by pitch. Basically, play two notes on a piano
    # keyboard. The greater one is further to the right than the lesser one. Or
    # maybe they're the same note. Then they're equal.
    def <=>(other)
      @semitones <=> other.semitones
    end

    # Returns the Note one semitone above this one.
    def succ
      (self ^ Mn2).simplify_name
    end

    # The triple-equals tells you if two notes are the same, regardless of what
    # octave they're in. Basically, if the two notes *can* be designated the
    # same name (since name isn't specific to an octave), they are triply-equal.
    def ===(other)
      base == other.base
    end

    # Raises or lowers a note to octave 4 (the good and truly upright octave).
    def base
      Note.new(@letter, @accidental)
    end

    # Returns a new Note equal to this one, but with either a natural or a sharp
    # for an accidental.
    def simplify_name
      Note.new(_semitones_to_letter(@semitones),
               _semitones_to_accidental(@semitones),
               _semitones_to_octave(@semitones))
    end

    # Collect two notes into a Chord.
    def +(other)
      Chord.new [self, other]
    end

    # Raise (or lower) a note by a certain interval.
    def ^(interval)
      new_semitones = @semitones + interval.semitones
      new_letter = _add_note_letter(@letter, interval.interval)

      new_letter_semitones = _letter_to_semitones(new_letter)
      offset = (new_letter_semitones % 12) - (new_semitones % 12)

      new_accidental = { -2 => :ss, -1 => :s, 0 => :n, 1 => :b, 2 => :bb }[offset]

      # special cases for the difference between a B and C, which should really be
      # 1 semitone, but isn't the way they're being represented. might have to
      # rewrite this whole method...
      new_accidental = :s if offset == 11
      new_accidental = :b if offset == -12

      Note.new(new_letter, new_accidental, _semitones_to_octave(new_semitones))
    end

    # Raise a note by a certain number of octaves.
    def >>(octaves)
      Note.new(@letter, @accidental, @octave + octaves)
    end

    # Lower a note by a certain number of octaves.
    def <<(octaves)
      self >> -octaves
    end

    # Find the interval between two notes. Returns an Interval.
    def -(other)
      delta = other.semitones - @semitones
      delta_mod = delta.abs % 12

      interval = [P1, Mn2, M2, Mn3, M3, P4, A4, P5, Mn6, M6, Mn7, M7][delta_mod]
      result_interval = Interval.new(interval.quality, interval.interval + delta.abs / 12 * 7)
      result_interval = result_interval.below if delta < 0

      result_interval
    end

    # Raise or lower note to the specified octave.
    def va(octave)
      Note.new(@letter, @accidental, octave)
    end

    # Play the note through the speakers.
    def play
      Sound.play(bloops_note)
    end

    # Put the note into bloopsaphone's language.
    def bloops_note
      note = ['C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#', 'A', 'A#', 'B'][@semitones % 12]
      note + octave.to_s
    end

    # Display note letter, followed by accidental, followed by octave number.
    # For example: "G#4", or "Cbb8".
    def to_s
      accidentals = { :n => '', :b => 'b', :bb => 'bb', :s => '#', :ss => '##' }
      @letter.to_s + accidentals[@accidental] + octave.to_s
    end

    # Say it's a note then print what note it is.
    def inspect
      "note " + to_s
    end

    private

    def _add_note_letter(letter, interval)
      interval += interval > 0 ? -1 : 1
      %w[A B C D E F G][(letter.to_s.upcase.ord - "A".ord + interval) % 7]
    end

    def _letter_to_semitones(letter)
      { :C => 0, :D => 2, :E => 4, :F => 5, :G => 7, :A => 9, :B => 11 }[letter.to_s.upcase.to_sym]
    end

    def _semitones_to_letter(semitones)
      %w[C C D D E F F G G A A B][semitones % 12].to_sym
    end

    def _accidental_to_semitones(accidental)
      { :bb => -2, :b => -1, :n => 0, :s => 1, :ss => 2 }[accidental.to_s.downcase.to_sym]
    end

    def _semitones_to_accidental(semitones)
      %w[n s n s n n s n s n s n][semitones % 12].to_sym
    end

    def _octave_to_semitones(octave)
      12 * (octave - 4)
    end

    def _semitones_to_octave(semitones)
      semitones / 12 + 4
    end
  end
end

