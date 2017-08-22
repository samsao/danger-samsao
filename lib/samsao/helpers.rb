# rubocop:disable Style/PredicateName

module Samsao
  # Helpers mixin module
  module Helpers
    # Check if any changelog were modified. When the helper receives nothing,
    # changelogs defined by the config are used.
    #
    # @return [Bool] True
    #         If any changelogs were modified in this commit
    #
    def changelog_modified?(*changelogs)
      changelogs = config.changelogs if changelogs.nil? || changelogs.empty?

      changelogs.any? { |changelog| git.modified_files.include?(changelog) }
    end

    # Return true if the current PR branch is a feature branch.
    #
    # @return [Bool]
    #
    def feature_branch?
      git_branch.start_with?('feature/')
    end

    # Return true if the current PR branch is a bug fix branch.
    #
    # @return [Bool]
    #
    def fix_branch?
      !(%r{^(bug|hot)?fix/} =~ git_branch).nil?
    end

    # Return true if the current PR branch is a release branch.
    #
    # @return [Bool]
    #
    def release_branch?
      git_branch.start_with?('release/')
    end

    # Return true if the current PR branch is a support branch.
    #
    # @return [Bool]
    #
    def support_branch?
      git_branch.start_with?('support/')
    end

    # Return true if the current PR is a trivial change, i.e. if PR title contains #trivial or #typo markers.
    #
    # @return [Bool]
    #
    def trivial_change?
      !(/#(trivial|typo(s)?)/ =~ github.pr_title).nil?
    end

    # Return true if any source files are in the git modified files list.
    #
    # @return [Bool]
    #
    def has_app_changes?(*sources)
      sources = config.sources if sources.nil? || sources.empty?

      sources.any? do |source|
        pattern = Samsao::Regexp.from_matcher(source, when_string_pattern_prefix_with: '^')

        modified_file?(pattern)
      end
    end

    # Return true if the config has a jira project key.
    #
    # @return [Bool]
    #
    def jira_project_key?
      !config.jira_project_key.nil?
    end

    # Return true if PR title contains any number of JIRA issues.
    #
    # @return [Bool]
    #
    def contains_jira_issue_number?(input)
      !(/\[#{config.jira_project_key}-\d+(,( *#{config.jira_project_key}-)? *\d+)*\]/ =~ input).nil?
    end

    # Shorten git commit's sha to seven characters.
    #
    # @param  [String] sha
    #         A git commit's sha
    # @return [String]
    #
    def shorten_sha(sha)
      return sha if sha.nil?

      sha[0..7]
    end

    # Truncate the string received.
    #
    # @param  [String] input
    #         The string to truncate
    # @param  [Number] max (Default: 30)
    #         The max size of the truncated string
    # @return [String]
    #
    def truncate(input, max = 30)
      return input if input.nil? || input.length <= max

      input[0..max - 1].gsub(/\s\w+\s*$/, '...')
    end

    private

    def git_branch
      github.branch_for_head
    end

    def modified_file?(matcher)
      !git.modified_files.grep(matcher).empty?
    end

    def respects_branching_model
      feature_branch? || fix_branch? || release_branch? || support_branch?
    end
  end
end
