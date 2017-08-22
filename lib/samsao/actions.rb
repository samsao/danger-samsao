module Samsao
  # Actions mixin module
  module Actions
    # Check if the git branching model is not respected for PR branch name.
    #
    # @param level (Default: :fail) The report level (:fail, :warn, :message) if the check fails [report](#report)
    #
    # @return [void]
    def check_wrong_branching_model(level = :fail)
      message = 'Your branch should be prefixed with feature/, fix/, bugfix/, hotfix/, release/ or support/!'

      report(level, message) unless respects_branching_model
    end

    # Check if a feature branch have more than one commit.
    #
    # @param level (Default: :fail) The report level (:fail, :warn, :message) if the check fails [report](#report)
    #
    # @return [void]
    def check_non_single_commit_feature(level = :fail)
      commit_count = git.commits.size
      message = "Your feature branch should have a single commit but found #{commit_count}, squash them together!"

      report(level, message) if feature_branch? && commit_count > 1
    end

    # Check if the CHANGELOG wasn't updated on feature or fix branches.
    #
    # @param level (Default: :fail) The report level (:fail, :warn, :message) if the check fails [report](#report)
    #
    # @return [void]
    def check_changelog_update_missing(level = :fail)
      return if trivial_change?
      return if support_branch? && config.project_type == :application

      report(level, 'You did a change without updating CHANGELOG file!') unless changelog_modified?
    end

    # Check if one or more merge commit is detected.
    #
    # @param level (Default: :fail) The report level (:fail, :warn, :message) if the check fails [report](#report)
    #
    # @return [void]
    def check_merge_commit_detected(level = :fail)
      message = 'Some merge commits were detected, you must use rebase to sync with base branch.'
      merge_commit_detector = /^Merge branch '#{github.branch_for_base}'/

      report(level, message) if git.commits.any? { |commit| commit.message =~ merge_commit_detector }
    end

    # Check for work in progress commit message in PR.
    #
    # @param level (Default: :warn) The report level (:fail, :warn, :message) if the check fails [report](#report)
    #
    # @return [void]
    def check_work_in_progess_pr(level = :warn)
      report(level, 'Do not merge, PR is a work in progess [WIP]!') if github.pr_title.include?('[WIP]')
    end

    # Check if it's a feature branch and if the PR body contains acceptance criteria
    #
    # @param  [Symbol] level (Default: :warn)
    #         The report level (:fail, :warn, :message) if the check fails [report](#report)
    # @return [void]
    #
    def check_acceptance_criteria(level = :warn)
      return unless samsao.feature_branch?

      message = 'The PR should have the acceptance criteria in the body.'

      report(level, message) if (/acceptance criteria/i =~ github.pr_body).nil?
    end

    # Check if the PR has at least one label added to it.
    #
    # @param  [Symbol] level (Default: :fail)
    #         The report level (:fail, :warn, :message) if the check fails [report](#report)
    # @return [void]
    #
    def check_label_pr(level = :fail)
      message = 'The PR should have at least one label added to it.'

      report(level, message) if github.pr_labels.nil? || github.pr_labels.empty?
    end

    # Send report to danger depending on the level
    #
    # @param level The report level sent to Danger :
    #   :message  > Comment a message to the table
    #   :warn     > Declares a CI warning
    #   :fail  > Declares a CI blocking error
    # @param content The message of the report sent to Danger
    #
    # @return [void]
    def report(level, content)
      case level
      when :warn
        warn content
      when :fail
        fail content
      when :message
        message content
      else
        raise "Report level '#{level}' is invalid."
      end
    end
  end
end
