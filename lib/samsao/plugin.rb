# rubocop:disable Style/PredicateName

require 'samsao/config'
require 'samsao/regexp'

module Danger
  # Samsao's Danger plugin.
  #
  # @example See README.md
  #
  # @see samsao/danger-samsao
  # @tags internal, private, enterprise
  #
  class DangerSamsao < Plugin
    # Enable to configure the plugin configuration object.
    #
    # @return [Array<String>] (if no block given)
    def config(&block)
      @config = Danger::SamsaoConfig.new if @config.nil?
      return @config unless block_given?

      @config.instance_eval(&block)
    end

    # Fails when git branching model is not respected for PR branch name.
    #
    # @return [void]
    def fail_when_wrong_branching_model
      message = 'Your branch should be prefixed with feature/, fix/, trivial/ or release/!'

      fail message unless respects_branching_model
    end

    # Fails when a feature branch have than one commit
    #
    # @return [void]
    def fail_when_non_single_commit_feature
      commit_count = git.commits.size
      message = "Your feature branch should have a single commit but found #{commit_count}, squash them together!"

      fail message if feature_branch? && commit_count > 1
    end

    # Fails when CHANGELOG is not updated on feature or fix branches
    #
    # @return [void]
    def fail_when_changelog_update_missing
      return if trivial_change?

      message = 'You did a fix or a feature without updating CHANGELOG file!'

      fail message unless changelog_modified?
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

    def changelog_modified?
      config.changelogs.any? { |changelog| git.modified_files.include?(changelog) }
    end

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
