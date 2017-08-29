## 0.3.1 (In progress)

#### Features

 *

## 0.3.0 (August 23, 2017)

### Breaking Changes

 * Renamed the following methods to match the `level` parameter they now optionally receive:
    * `fail_when_wrong_branching_model` to `check_wrong_branching_model`
    * `fail_when_non_single_commit_feature` to `check_non_single_commit_feature`
    * `fail_when_changelog_update_missing` to `check_changelog_update_missing`
    * `fail_when_merge_commit_detected` to `check_merge_commit_detected`
    * `warn_when_work_in_progess_pr` to `check_work_in_progess_pr`

#### Features

 * Added `level` parameter to all actions to personnalize the report level 
   (`:fail`, `:warn`, `:message`) if the check fails. 

 * Added `have_message` and `have_no_message` matchers.
 
 * Added `check_label_pr` action.

 * Added `check_acceptance_criteria` action.

 * Added `check_feature_jira_issue_number` action.

 * Added `check_fix_jira_issue_number` action.

 * Added `contains_jira_issue_number?` helper.

 * Added `jira_project_key?` helper.

 * Added `shorten_sha` helper.

 * Added `truncate` helper.

#### Support

 * Fixed grammatical errors in the `README.md`.

#### Support

 * Open source repository and now using Travis as the build system.

## 0.2.0 (May 9, 2017)

#### Breaking Changes

 * Changed `trivial_change?` logic by only flagging PR as trivial using
   the PR title and not the branch name anymore.

 * Removed `trivial_branch?` support. It was replaced by `support_branch?`
   instead to more closely follow git flow branching model.

#### Features

 * Enhanced the changelog missing action to not fail when changelog is
   not updated, project is of type `:application` and PR is on a support
   branch.

 * Added config option `project_type` which can be one of `:application`
   or `:library` and defaults to `:application`.

 * Enhanced `fix_branch?` to support `hotfix/` and `bugfix/` prefixes.

 * Added `support_branch?` support.

 * Updated `trivial_change?` helper to support variations in marker
   for `#typo` marker, now supports `#typos`.

#### Fixes

 * Fixed branching model to fully support git flow branching model which
   is the branching model we use.

#### Support

 * Added `Danger` to project, eating our own dog food.

 * Reformatted `CHANGELOG.md` a bit to split by sections.

## 0.1.1 (May 4, 2017)

#### Features

 * Open source to MIT.

## 0.1.0 (May 1, 2017)

#### Features

 * Added `fail_when_merge_commit_detected` action.

 * Added `warn_when_work_in_progess_pr` action.

 * Added `changelog_modified?` helper.

 * Updated `trivial_change?` helper to support `#typo` in PR title.

 * Added `has_app_changes?` helper.

 * Added `trivial_change?` helper.

 * Added branch helpers:
    * `fix_branch?`
    * `feature_branch?`
    * `release_branch?`
    * `trivial_branch?`

 * Added `fail_when_changelog_update_missing` action.

 * Added `fail_when_non_single_commit_feature` action.

 * Added `fail_when_wrong_branching_model` action.
