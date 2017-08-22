module Samsao
  # Regexp utility methods
  module Regexp
    # Turns a source entry input into a Regexp. Uses rules from [from_matcher](#from_matcher)
    # function and append a `^` to final regexp when the source if a pure String.
    #
    # @param  [String] source
    #         The source entry to transform into a Regexp
    # @return [Regexp]
    #         The source entry as a regexp
    #
    def self.from_source(source)
      from_matcher(source, when_string_pattern_prefix_with: '^')
    end

    # Turns an input into a Regexp. If the input is a String, it turns it
    # into a Regexp and escape all special characters. If the input is already
    # a Regexp, it returns it without modification.
    #
    # @param    [String] matcher
    #           The input matcher to transform into a Regexp
    # @keyword  [String] when_string_pattern_prefix_with (Default: '')
    #           The prefix that should be added to final regexp when the input matcher is a string type
    # @return   [Regexp]
    #           The input as a regexp
    #
    def self.from_matcher(matcher, when_string_pattern_prefix_with: '')
      return matcher if matcher.is_a?(::Regexp)

      /#{when_string_pattern_prefix_with}#{::Regexp.quote(matcher)}/
    end
  end
end
