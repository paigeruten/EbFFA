# note: this file contains no unit tests or anything like that.

require 'ebffa'

NOTES = [C, Cs, D, Ds, E, F, Fs, G, Gs, A, As, B]

class EarTest
  def initialize
    @score = 0
    @max_score = 0
  end

  def done
    puts "The test is over."
    puts "You got #{@score} questions right out of #{@max_score}."
    puts "That means you got #{@score*100/@max_score}%."
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
  CHORDS = [:major, :minor, :v7, :o7, :major_1st, :minor_1st]

  def question
    chord_type = CHORDS.shuffle.first
    tonic = NOTES.shuffle.first

    case chord_type
    when :major
      chord = Chord.triad(tonic)
    when :minor
      chord = Chord.triad(tonic, :min)
    when :v7
      chord = Chord.v7(tonic)
    when :o7
      chord = Chord.o7(tonic)
    when :major_1st
      chord = Chord.triad(tonic, :maj, 1)
    when :minor_1st
      chord = Chord.triad(tonic, :min, 1)
    end

    chord.play

    puts "What type of chord was that?"
    puts "  1. Major (root position)"
    puts "  2. Minor (root position)"
    puts "  3. Dominant 7th"
    puts "  4. Diminished 7th"
    puts "  5. Major 1st inversion"
    puts "  6. Minor 1st inversion"
    print "Enter the # of your choice: "
    guess = STDIN.gets.to_i until (1..6) === guess

    if CHORDS[guess - 1] == chord_type
      correct!
    else
      wrong!
    end
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
print "Hey, Welcome to the #{test.class}! How many questions do you want? "
num_questions = STDIN.gets.to_i
num_questions.times do
  test.question
end

test.done

