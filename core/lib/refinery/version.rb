module Refinery
  class Version
    @major = 2
<<<<<<< HEAD
    @minor = 0
    @tiny  = 10
=======
    @minor = 1
    @tiny  = 5
>>>>>>> 2-1-main
    @build = nil

    class << self
      attr_reader :major, :minor, :tiny, :build

      def to_s
        [@major, @minor, @tiny, @build].compact.join '.'
      end
    end
  end
end
