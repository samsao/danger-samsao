module Danger
  # Samsao's config class
  class SamsaoConfig
    def sources(*entries)
      return @sources if entries.nil? || entries.empty?

      @sources = entries
    end
  end
end
