require File.dirname(__FILE__) + '/test_helpers'

class NoteTest < Test::Unit::TestCase
  must "acknowledge enharmonic notes to be equal" do
    assert_equal Cs, Db
  end

  must "compare notes by pitch" do
    assert(C.va(5) < C.va(6))
  end

  must "compare notes by pitch regardless of octave" do
    assert(Gs === Ab.va(5))
  end

  must "raise or lower note to octave four" do
    assert_equal C.va(1).base, C.va(4)
  end

  must "put notes together into a chord" do
    assert_equal (C + E + G), Chord.new([C, E, G])
  end

  must "raise a note by an interval" do
    assert_equal (C ^ P5), G
  end

  must "lower a note by an interval" do
    assert_equal (C ^ P5.below), F.va(3)
  end

  must "keep the right enharmonic note and accidental when raising by an interval" do
    note = C ^ D7

    assert_equal note, A
    assert_equal note.letter.to_sym, :B
    assert_equal note.accidental.to_sym, :bb
  end

  must "raise a note by a large interval" do
    assert_equal (C ^ Interval.new(:per, 22)), C.va(7)
  end

  must "raise a note by some octaves" do
    assert_equal (C >> 3), C.va(7)
  end

  must "lower a note by some octaves" do
    assert_equal (C << 2), C.va(2)
  end

  must "find the interval between two notes" do
    assert_equal (C - G), P5
  end

  must "find the below interval between two notes" do
    assert_equal (G - C), P5.below
  end

  must "get the octave of a note" do
    assert_equal Note.new(:C, :n, 8).octave, 8
  end

  must "set the octave of a note" do
    assert_equal C.va(8), Note.new(:C, :n, 8)
  end

  must "convert note to a string that the bloops will understand" do
    assert_equal Note.new(:C, :ss, 8).bloops_note, "D8"
  end

  must "convert note to human-readable string" do
    assert_equal Note.new(:C, :ss, 8).to_s, "C##8"
  end
end

