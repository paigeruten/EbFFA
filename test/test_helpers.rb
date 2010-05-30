require "test/unit"

$LOAD_PATH << File.join(File.dirname(__FILE__), '..', 'lib')
require 'ebffa'

unless Test::Unit::TestCase.respond_to? :must
  # fine. I'll make my *own* must...
  class << Test::Unit::TestCase
    def must(test_name, &block)
      method_name = "test_must_" + test_name.to_s.downcase.strip.tr("^a-z0-9!?", "_")
      raise ArgumentError, "there's already a test named '#{ method_name }'" if method_defined? method_name
      define_method(method_name, block)
    end
  end
end

