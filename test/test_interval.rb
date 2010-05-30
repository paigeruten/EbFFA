require File.dirname(__FILE__) + '/test_helpers'

class IntervalTest < Test::Unit::TestCase
  must "compare intervals by semitone interval" do
    assert_equal A5, Mn6
  end

  must "convert an above interval to a below interval and back again" do
    assert_equal P5, P5.below.below
    assert_equal (G ^ P5.below), C
  end

  must "convert interval into human-readable string" do
    assert_equal P5.below.to_s, "P5 B"
  end
end

