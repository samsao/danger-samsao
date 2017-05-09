module Danger
  # Samsao's config class
  class SamsaoConfig
    PROJECT_TYPES = [:application, :library].freeze

    def initialize
      @changelogs = ['CHANGELOG.md']
      @sources = []
      @project_type = :application
    end

    def changelogs(*entries)
      return @changelogs if entries.nil? || entries.empty?

      @changelogs = entries
    end

    def project_type(type = nil)
      return @project_type if type.nil?

      @project_type = validate_project_type(type)
    end

    def sources(*entries)
      return @sources if entries.nil? || entries.empty?

      @sources = entries
    end

    private

    def validate_project_type(type)
      return type if valid_project_type?(type)

      actual_type = type.is_a?(Symbol) ? ":#{type}" : type.to_s
      valid_types = PROJECT_TYPES.map { |valid_type| ":#{valid_type}" }.join(', ')

      raise "Project type '#{actual_type}' is invalid, must be one of '#{valid_types}'"
    end

    def valid_project_type?(type)
      PROJECT_TYPES.include?(type)
    end
  end
end
