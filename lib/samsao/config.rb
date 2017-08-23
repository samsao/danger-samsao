module Danger
  # Samsao's config class
  class SamsaoConfig
    PROJECT_TYPES = [:application, :library].freeze

    def initialize
      @changelogs = ['CHANGELOG.md']
      @sources = []
      @project_type = :application
      @jira_project_key = nil
    end

    def changelogs(*entries)
      return @changelogs if entries.nil? || entries.empty?

      @changelogs = entries
    end

    def jira_project_key(key = nil)
      return @jira_project_key if key.nil?

      @jira_project_key = validate_jira_project_key(key)
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

    def validate_jira_project_key(key)
      return key unless (/^[A-Z]{1,10}$/ =~ key).nil?

      raise "Jira project key '#{key}' is invalid, must be uppercase and between 1 and 10 characters"
    end

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
