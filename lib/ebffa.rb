$:.unshift File.expand_path(File.dirname(__FILE__))

require 'ebffa/note'
require 'ebffa/interval'
require 'ebffa/constants'
require 'ebffa/chord'
require 'ebffa/sound'


# EbFFA is a musical calculator, at least that's what it's meant to be used as.
# It really is nothing special until you get the actual calculator for it. This
# has a button for each letter A to G; a button for each operator ^, -, +, <<
# and >>; a button for each Interval quality P, A, D, M, and Mn. It's a musical
# calculator and it can totally fit inside your head but, also, your pocket.
# Just whip it out and build up chords and transpose them and invert them and,
# finally, play them, melodically or harmonically. Whatever suits you!
# Whatever's your style. Whatever makes you, as a mathemusician, at your
# happiest.
#
# The library is named after Eb-F-F-A, the crater gull in the 5th chapter of
# Why's (poignant) Guide to Ruby. This gull... this gull spent weeks stranded on
# a quadruple bunkbed with this alien who was supposedly really hairy all over
# at the time, but had a lot of calculators. He had a calculator that ran Ruby,
# and he used it later to make a musical lottery for the animals. This story may
# or may not have inspired this library's sudden materialization.
#
# But you should really quit reading this documentation right now and go read
# that story, if you haven't already. It's a magnificent tale. A gundible
# journey. Besides that association, this library has no point to it at all. You
# will get nothing out of it. It's empty calories. Skittles with no sour.
#
# But if you want to just play around, start like this:
#
#     $ irb
#     irb> require 'lib/ebffa'
#       => true
#     irb> include EbFFA
#       => Object
#     irb> C ^ P5
#       => note G4
#
# You just raised a C by a P5 to a G. Crazy! There's more if you're interested.
# Just read the docs.
module EbFFA
end

