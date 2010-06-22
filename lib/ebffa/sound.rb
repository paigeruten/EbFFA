require 'bloops'

module EbFFA
  module Sound
    extend self

    class << self
      attr_accessor :sound
    end

    @sound = Bloops.sound Bloops::SQUARE

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

