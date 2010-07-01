require 'bloops'

module EbFFA
  # This module spews out harmonies and melodies for EbFFA through your very own
  # speakers, with the help of the bloopsaphone.
  module Sound
    extend self

    class << self
      attr_accessor :sound
    end

    @sound = Bloops.sound Bloops::SQUARE

    # Play a bloopsaphone-formatted +tune+ in a <tt>:harmonic</tt> or
    # <tt>:melodic</tt> style. Bloopsatunes look something like "Eb F F A", at
    # their simplest.
    #
    # If you choose <tt>:harmonic</tt>, the method will set up a stack of
    # bloopsaphone tunes with one note each, and'll play them all at once. If
    # you go <tt>:melodic</tt>, you'll get a single tune with all your notes in
    # series, so the bloops will play each note in turn.
    def play(tune, how = :harmonic)
      b = Bloops.new

      case how
      when :harmonic
        tune.split(/\s+/).each do |note|
          b.tune @sound, note
        end
      when :melodic
        b.tune @sound, tune
      end

      b.play
      sleep(0.1) until b.stopped?
    end
  end
end

