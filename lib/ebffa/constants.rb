module EbFFA
  # These 21 note constants are included into the EbFFA module so they can just
  # be referred to like EbFFA::C, or EbFFA::Cb, etc.  Ideally, if you're going
  # to be using these, you'll probably be including the EbFFA module into the
  # top level of your script so you can just refer to them as C or Cb and so on.
  #
  # Each note is of the fourth octave.
  module Notes
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
  end

  # These 26 interval constants are included into the EbFFA module so they can
  # just be referred to like EbFFA::P5, or EbFFA::Mn6, etc.  Ideally, if you're
  # going to be using these, you'll probably be including the EbFFA module into
  # the top level of your script so you can just refer to them as P5 or Mn6 and
  # so on.
  #
  # - P stands for perfect
  # - D stands for diminished
  # - M stands for major
  # - Mn stands for minor
  # - A stands for augmented
  module Intervals
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
  end

  include Notes
  include Intervals
end

