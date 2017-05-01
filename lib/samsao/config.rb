module Danger
  # Samsao's config class
  class SamsaoConfig
    def initialize
      @changelogs = ['CHANGELOG.md']
      @sources = []
    end

    def changelogs(*entries)
      return @changelogs if entries.nil? || entries.empty?

      @changelogs = entries
    end

    def sources(*entries)
      return @sources if entries.nil? || entries.empty?

      @sources = entries
    end
  end
end
