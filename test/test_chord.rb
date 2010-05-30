require File.dirname(__FILE__) + '/test_helpers'

class ChordTest < Test::Unit::TestCase
  must "compare chords by notes regardless of order" do
    assert_equal (C + E + G), (E + G + C)
    assert_not_equal (C + E + G), ((C << 1) + E + G)
  end

  must "compare chords by notes regardless of order and octave" do
    assert((C + E + G) === ((C << 1) + E + G))
  end

  must "append note to chord" do
    assert_equal (((B + E) + E) + F), Chord.new([B, E, E, F])
  end

  must "append chord to chord" do
    assert_equal ((C + A + B) + (B + A) + (G + E)), Chord.new([C, A, B, B, A, G, E])
  end

  must "raise chord by some octaves" do
    assert_equal ((C + E + G) >> 2), (C.va(6) + E.va(6) + G.va(6))
  end

  must "lower chord by some octaves" do
    assert_equal ((C + E + G) << 2), (C.va(2) + E.va(2) + G.va(2))
  end

  must "raise chord by an interval" do
    assert_equal ((D + Fs + A) ^ P5), (A + Cs.va(5) + E.va(5))
  end

  must "invert a chord" do
    assert_equal (C + E + G).invert, (E + G + C.va(5))
  end

  must "invert a chord many times" do
    assert_equal (C + E + G).invert.invert.invert, ((C + E + G) >> 1)
  end

  must "construct a major root triad" do
    assert_equal Chord.triad(D), (D + Fs + A)
  end

  must "construct a major triad in second inversion" do
    assert_equal Chord.triad(C, :maj, 2), (G + C.va(5) + E.va(5))
  end

  must "construct a minor triad" do
    assert_equal Chord.triad(F, :min), (F + Ab + C.va(5))
  end

  must "construct a diminished triad" do
    assert_equal Chord.triad(D, :dim), (D + F + Ab)
  end

  must "construct a half-diminished triad" do
    assert_equal Chord.triad(E, :halfdim), (E + Gs + Bb)
  end

  must "construct a dominant seventh chord" do
    assert_equal Chord.v7(C), (G + B + D.va(5) + F.va(5))
  end

  must "construct a diminished seventh chord" do
    assert_equal Chord.o7(C), (B.va(3) + D + F + Ab)
  end
end

