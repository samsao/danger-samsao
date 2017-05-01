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

    # Return true if the current PR branch is a feature branch
    #
    # @return [void]
    def feature_branch?
      git_branch.start_with?('feature/')
    end

    # Return true if the current PR branch is a feature branch
    #
    # @return [void]
    def fix_branch?
      git_branch.start_with?('fix/')
    end

    # Return true if the current PR branch is a release branch
    #
    # @return [void]
    def release_branch?
      git_branch.start_with?('release/')
    end

    # Return true if the current PR branch is a trivial branch
    #
    # @return [void]
    def trivial_branch?
      git_branch.start_with?('trivial/')
    end

    # Return true if the current PR is a trivial change (branch is `trivial_branch?`)
    # or PR title contains #trivial or #typo markers.
    #
    # @return [void]
    def trivial_change?
      trivial_branch? || ['#trivial', '#typo'].any? { |modifier| github.pr_title.include?(modifier) }
    end

    # Return true if any source files are in the git modified files list.
    #
    # @return [void]
    def has_app_changes?(*sources)
      sources = config.sources if sources.nil? || sources.empty?

      sources.any? do |source|
        pattern = Samsao::Regexp.from_matcher(source, when_string_pattern_prefix_with: '^')

        modified_file?(pattern)
      end
    end

    private

    def git_branch
      github.branch_for_head
    end

    def modified_file?(matcher)
      !git.modified_files.grep(matcher).empty?
    end

    def respects_branching_model
      feature_branch? || fix_branch? || release_branch? || trivial_branch?
    end
  end
end
