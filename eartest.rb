# note: this file contains no unit tests or anything like that.

require 'lib/ebffa'

NOTES = [C, Cs, D, Ds, E, F, Fs, G, Gs, A, As, B]

class EarTest
  def initialize
    @score = 0
    @max_score = 0
  end

  def done
    puts "The test is over."
    puts "You got #{ @score } questions right out of #{ @max_score }."
    puts "That means you got #{ @score * 100 / @max_score }%."
  end

  def next
    puts "Question ##{ @max_score + 1 }"
    puts "(press enter when you're ready)"

    STDIN.gets

    question

    puts
  end

  def correct!
    @score += 1
    @max_score += 1

    puts "You're right!"
  end

  def wrong!(answer = nil)
    @max_score += 1

    puts "Nope, you're wrong."
    puts "The answer is #{answer}." if answer
  end
end

class IntervalTest < EarTest
  INTERVALS = [Mn2, M2, Mn3, M3, P4, A4, P5, Mn6, M6, Mn7, M7, P8]

  def question
    tonic = NOTES.shuffle.first
    tonic <<= 1 if rand(2) == 0

    interval = INTERVALS.shuffle.first
    interval = interval.below if rand(2) == 0

    (tonic + (tonic ^ interval)).play(:melodic)

    print "What interval was that? "
    guess = STDIN.gets.chomp

    guess_interval, guess_direction = *guess.split
    guess_interval = eval(guess_interval)
    guess_interval = guess_interval.below if guess_direction

    if guess_interval == interval
      correct!
    else
      wrong! interval.to_s
    end
  end
end

class ChordIdentTest < EarTest
  CHORDS = {
    :major => "Major (root)",
    :minor => "Minor (root)",
    :v7 => "Dominant seventh",
    :o7 => "Diminished seventh",
    :major_1st => "Major (first)",
    :minor_1st => "Minor (first)"
  }

  def question
    chord_type = CHORDS.keys.shuffle.first
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

    choice_number = 1
    answer = nil
    CHORDS.each do |type, name|
      puts "  %d. %s" % [choice_number, name]
      answer = choice_number if type == chord_type
      choice_number += 1
    end

    guess = STDIN.gets.to_i until (1..6) === guess

    if guess == answer
      correct!
    else
      wrong! answer.to_s
    end
  end
end

Tests = [IntervalTest, ChordIdentTest]

if ARGV.empty? or ! Tests.map { |t| t.to_s }.include? ARGV[0]
  puts "Usage: #{$0} TestName"
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
  test.next
end

test.done

