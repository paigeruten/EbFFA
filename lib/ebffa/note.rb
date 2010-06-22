module EbFFA
  class Note
    include Comparable

    attr_reader :semitones, :letter, :accidental, :octave

    def initialize(letter, accidental = :n, octave = 4)
      @letter, @accidental, @octave = letter, accidental, octave

      @semitones = _letter_to_semitones(@letter) +
                   _accidental_to_semitones(@accidental) +
                   _octave_to_semitones(@octave)
    end

    # compare notes by pitch
    def <=>(other)
      @semitones <=> other.semitones
    end

    # test for equality in pitch, ignoring what octave they're in
    def ===(other)
      base == other.base
    end

    # raise or lower the note to octave 4, used for comparing notes regardless of octave
    def base
      Note.new(@letter, @accidental)
    end

    # collect two notes into a Chord
    def +(other)
      Chord.new [self, other]
    end

    # raise (or lower) a note by a certain interval
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

    # raise a note by a certain number of octaves
    def >>(octaves)
      Note.new(@letter, @accidental, @octave + octaves)
    end

    # lower a note by a certain number of octaves
    def <<(octaves)
      self >> -octaves
    end

    # find the interval between two notes
    def -(other)
      delta = other.semitones - @semitones
      delta_mod = delta.abs % 12

      interval = [P1, Mn2, M2, Mn3, M3, P4, A4, P5, Mn6, M6, Mn7, M7][delta_mod]
      result_interval = Interval.new(interval.quality, interval.interval + delta.abs / 12 * 7)
      result_interval = result_interval.below if delta < 0

      result_interval
    end

    # raise or lower note to the specified octave
    def va(octave)
      Note.new(@letter, @accidental, octave)
    end

    # play the note through the bloopsaphone
    def play
      Sound.play(bloops_note)
    end

    # put the note into bloopsaphone's language
    def bloops_note
      note = ['C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#', 'A', 'A#', 'B'][@semitones % 12]
      note + octave.to_s
    end

    def to_s
      accidentals = { :n => '', :b => 'b', :bb => 'bb', :s => '#', :ss => '##' }
      @letter.to_s + accidentals[@accidental] + octave.to_s
    end

    def inspect
      "note " + to_s
    end

    def _add_note_letter(letter, interval)
      interval += interval > 0 ? -1 : 1
      %w{ A B C D E F G }[(letter.to_s.upcase[0] - ?A + interval) % 7]
    end

    def _letter_to_semitones(letter)
      { :C => 0, :D => 2, :E => 4, :F => 5, :G => 7, :A => 9, :B => 11 }[letter.to_sym]
    end

    def _accidental_to_semitones(accidental)
      { :bb => -2, :b => -1, :n => 0, :s => 1, :ss => 2 }[accidental.to_sym]
    end

    def _semitones_to_octave(semitones)
      semitones / 12 + 4
    end

    def _octave_to_semitones(octave)
      12 * (octave - 4)
    end
  end
end

