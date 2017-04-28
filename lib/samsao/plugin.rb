require 'samsao/config'

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
      @samsao_config = Danger::SamsaoConfig.new if @samsao_config.nil?
      return @samsao_config unless block_given?

      @samsao_config.instance_eval(&block)
    end

    # Fails when git branching model is not respected for PR branch name.
    #
    # @return [void]
    def fail_when_wrong_branching_model
      message = 'Your branch should be prefixed with feature/, fix/, trivia/ or release/!'

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

    private

    def git_branch
      github.branch_for_head
    end

    def respects_branching_model
      git_branch =~ %r{(feature|fix|release|trivia)/.*}
    end

    def feature_branch?
      git_branch.start_with?('feature/')
    end
  end
end
