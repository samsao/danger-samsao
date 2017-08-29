# rubocop:disable Style/FileName

## Config
samsao.config do
  jira_project_key 'DNG'
  project_type :library
  sources '.*'
end

## Errors
samsao.check_changelog_update_missing
samsao.check_feature_jira_issue_number
samsao.check_fix_jira_issue_number
samsao.check_merge_commit_detected
samsao.check_non_single_commit_feature
samsao.check_wrong_branching_model

## Warnings
samsao.check_acceptance_criteria
samsao.check_work_in_progess_pr

## Messages
unless status_report[:errors].empty?
  message 'If this was a trivial change, typo fix or tooling related, ' \
          'you can add #trivial, #typo or #tool respectively in your PR title.'
end
