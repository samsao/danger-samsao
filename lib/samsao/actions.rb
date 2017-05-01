module Samsao
  # Actions mixin module
  module Actions
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

    # Fails when CHANGELOG is not updated on feature or fix branches
    #
    # @return [void]
    def warn_when_work_in_progess_pr
      message = 'Do not merge, PR is a work in progess [WIP]!'

      warn message if github.pr_title.include?('[WIP]')
    end
  end
end
