# note: this file contains no unit tests or anything like that.

require 'ebffa'

class EarTest
  def initialize
    @score = 0
    @max_score = 0
  end

  def correct!
    @score += 1
    @max_score += 1

    puts "You're right!"
  end

  def wrong!
    @max_score += 1

    puts "Nope, you're wrong."
  end
end

class IntervalTest < EarTest
  INTERVALS = [Mn2, M2, Mn3, M3, P4, A4, P5, Mn6, M6, Mn7, M7, P8]
  NOTES = [C, Cs, D, Ds, E, F, Fs, G, Gs, A, As, B]

  def question
    interval = INTERVALS.shuffle.first
    interval = interval.below if rand(2) == 0

    first_note = NOTES.shuffle.first
    first_note -= P8 if rand(2) == 0

    last_note = first_note + interval

    chord = Chord.new [first_note, last_note]
    chord.play(:melodic)

    print "What interval was that? "
    guess = STDIN.gets.chomp

    guess_interval, guess_direction = *guess.split
    guess_interval = eval(guess_interval)
    guess_interval = guess_interval.below if guess_direction

    if guess_interval == interval
      correct!
    else
      wrong!
    end
  end
end

class ChordIdentTest < EarTest
  def question

  end
end

Tests = [IntervalTest, ChordIdentTest]

if ARGV.empty? or ! Tests.map { |t| t.to_s }.include? ARGV[0]
  puts "Usage: $0 TestName"
  puts
  puts "Available tests are:"
  Tests.each do |test|
    puts "  - #{ test }"
  end
  exit
end

test = eval(ARGV[0]).new
loop do
  test.question
end

