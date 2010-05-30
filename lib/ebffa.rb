require 'bloops'

SOUND = Bloops.sound Bloops::SQUARE

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

  # get the octave the note is in (middle C is octave 4)
  def octave
    @octave
  end

  # raise or lower note to the specified octave
  def va(octave)
    Note.new(@letter, @accidental, octave)
  end

  # play the note through the bloopsaphone
  def play
    b = Bloops.new
    b.tune SOUND, bloops_note
    b.play
    sleep(0.1) until b.stopped?
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

C  = Note.new(:C)
Bs = Note.new(:B, :s)
Cs = Note.new(:C, :s)
Db = Note.new(:D, :b)
D  = Note.new(:D)
Ds = Note.new(:D, :s)
Eb = Note.new(:E, :b)
E  = Note.new(:E)
Fb = Note.new(:F, :b)
F  = Note.new(:F)
Es = Note.new(:E, :s)
Fs = Note.new(:F, :s)
Gb = Note.new(:G, :b)
G  = Note.new(:G)
Gs = Note.new(:G, :s)
Ab = Note.new(:A, :b)
A  = Note.new(:A)
As = Note.new(:A, :s)
Bb = Note.new(:B, :b)
B  = Note.new(:B)
Cb = Note.new(:C, :b)

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

P1  = Interval.new(:per, 1)
D2  = Interval.new(:dim, 2)
Mn2 = Interval.new(:min, 2)
M2  = Interval.new(:maj, 2)
A2  = Interval.new(:aug, 2)
D3  = Interval.new(:dim, 3)
Mn3 = Interval.new(:min, 3)
M3  = Interval.new(:maj, 3)
A3  = Interval.new(:aug, 3)
D4  = Interval.new(:dim, 4)
P4  = Interval.new(:per, 4)
A4  = Interval.new(:aug, 4)
D5  = Interval.new(:dim, 5)
P5  = Interval.new(:per, 5)
A5  = Interval.new(:aug, 5)
D6  = Interval.new(:dim, 6)
Mn6 = Interval.new(:min, 6)
M6  = Interval.new(:maj, 6)
A6  = Interval.new(:aug, 6)
D7  = Interval.new(:dim, 7)
Mn7 = Interval.new(:min, 7)
M7  = Interval.new(:maj, 7)
A7  = Interval.new(:aug, 7)
D8  = Interval.new(:dim, 8)
P8  = Interval.new(:per, 8)
A8  = Interval.new(:aug, 8)

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
    b = Bloops.new
    case how
    when :harmonic
      @notes.each do |note|
        b.tune SOUND, note.bloops_note
      end
    when :melodic
      b.tune SOUND, @notes.map { |note| note.bloops_note }.join(" ")
    end
    b.play
    sleep(0.1) until b.stopped?
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

