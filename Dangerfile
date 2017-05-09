# rubocop:disable Style/FileName

## Config
samsao.config do
  project_type :library
  sources '.*'
end

## Errors
samsao.fail_when_changelog_update_missing
samsao.fail_when_merge_commit_detected
samsao.fail_when_non_single_commit_feature
samsao.fail_when_wrong_branching_model

## Warnings
samsao.warn_when_work_in_progess_pr

## Messages
unless status_report[:errors].empty?
  message 'If this was a trivial change, typo fix or tooling related, ' \
          'you can add #trivial, #typo or #tool respectively in your PR title.'
end
