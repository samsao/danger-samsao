# rubocop:disable Style/PredicateName

module Samsao
  # Helpers mixin module
  module Helpers
    # Check if any changelog were modified. When the helper receives nothing,
    # changelogs defined by the config are used.
    #
    # @return [Boolean] True if any changelogs were modified in this commit
    def changelog_modified?(*changelogs)
      changelogs = config.changelogs if changelogs.nil? || changelogs.empty?

      changelogs.any? { |changelog| git.modified_files.include?(changelog) }
    end

    # Return true if the current PR branch is a feature branch.
    #
    # @return [Boolean]
    def feature_branch?
      git_branch.start_with?('feature/')
    end

    # Return true if the current PR branch is a bug fix branch.
    #
    # @return [Boolean]
    def fix_branch?
      !(%r{^(bug|hot)?fix/} =~ git_branch).nil?
    end

    # Return true if the current PR branch is a release branch.
    #
    # @return [Boolean]
    def release_branch?
      git_branch.start_with?('release/')
    end

    # Return true if the current PR branch is a support branch.
    #
    # @return [Boolean]
    def support_branch?
      git_branch.start_with?('support/')
    end

    # Return true if the current PR is a trivial change, i.e. if
    # PR title contains #trivial or #typo markers.
    #
    # @return [Boolean]
    def trivial_change?
      !(/#(trivial|typo(s)?)/ =~ github.pr_title).nil?
    end

    # Return true if any source files are in the git modified files list.
    #
    # @return [Boolean]
    def has_app_changes?(*sources)
      sources = config.sources if sources.nil? || sources.empty?

      sources.any? do |source|
        pattern = Samsao::Regexp.from_matcher(source, when_string_pattern_prefix_with: '^')

        modified_file?(pattern)
      end
    end

    # Return true if the config has a project key.
    #
    # @return [Boolean]
    def project_key?
      !config.project_key.nil?
    end

    # Return true if PR title contains a single JIRA issue number.
    #
    # @return [Boolean]
    def contains_single_jira_issue_number?
      !(/^\[#{config.project_key}-\d+\]/ =~ github.pr_title).nil?
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
