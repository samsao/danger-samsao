# Danger Samsao [![Build Status](https://travis-ci.org/samsao/danger-samsao.svg?branch=develop)](https://travis-ci.org/samsao/danger-samsao)

A Danger plugin bringing Samsao's PR guideline into code.

## Installation

Simply add `danger-samsao` to your `Gemfile` and configure your `Dangerfile`
using all the nice goodies.

## Quick Start

Here a sample `Dangerfile` that you can use to bootstrap your project:

```
## Config
samsao.config do
  sources '.*'
end

## Errors
samsao.check_changelog_update_missing
samsao.check_merge_commit_detected
samsao.check_non_single_commit_feature
samsao.check_wrong_branching_model

## Warnings
samsao.check_work_in_progess_pr

## Messages
unless status_report[:errors].empty?
  message 'If this was a trivial change, typo fix or tooling related, ' \
          'you can add #trivial, #typo or #tool respectively in your PR title.'
end
```

## Usage

Methods and attributes from this plugin are available in
your `Dangerfile` under the `samsao` namespace.

### Table of Contents

 * [Config](#config)
   * [Changelogs](#changelogs)
   * [Jira Project Key](#jira-project-key)
   * [Project Type](#project-type)
   * [Sources](#sources)
 * [Actions](#actions)
   * [Report Levels](#report-levels)
   * [samsao.check_acceptance_criteria](#acceptance-criteria)
   * [samsao.check_changelog_update_missing](#changelog-update-missing)
   * [samsao.check_feature_jira_issue_number](#feature-jira-issue-number)
   * [samsao.check_fix_jira_issue_number](#fix-jira-issue-number) 
   * [samsao.check_label_pr](#label_pr)
   * [samsao.check_merge_commit_detected](#merge-commits-detected)
   * [samsao.check_non_single_commit_feature](#feature-branch-multiple-commits)
   * [samsao.check_wrong_branching_model](#branching-model)
   * [samsao.check_work_in_progess_pr](#when-work-in-progess-pr)
 * [Helpers](#helpers)
   * [samsao.changelog_modified?](#changelog-modified)
   * [samsao.contains_any_jira_issue_number?](#contains-any-jira-issue-number) 
   * [samsao.contains_single_jira_issue_number?](#contains-single-jira-issue-number)
   * [samsao.feature_branch?](#feature-branch)
   * [samsao.fix_branch?](#fix-branch)
   * [samsao.has_app_changes?](#has-app-changes)
   * [samsao.jira_project_key?](#has-jira-project-key)
   * [samsao.release_branch?](#release-branch)
   * [samsao.shorten_sha](#shorten-sha) 
   * [samsao.support_branch?](#support-branch)
   * [samsao.trivial_change?](#trivial-change)
   * [samsao.truncate](#truncate) 

### Config

Some of the actions of this plugin can be configured by project to make stuff
easier. This is done by using the `config` attributes the plugin:

```
samsao.config do
  changelogs 'CHANGELOG.md'
  jira_project_key 'VER'
  project_type :library
  sources 'app/src'
end
```

#### Changelogs

Defaults: `[CHANGELOG.md]`

Enable to change the CHANGELOG file paths looked upon when checking if CHANGELOG 
file has been modified or not.

#### Jira Project Key

Defaults: nil

Example: `VER`

This refers to the project key on Jira. This settings affects these actions and helpers:

 * [samsao.check_feature_jira_issue_number](#feature-jira-issue-number)
 * [samsao.check_fix_jira_issue_number](#fix-jira-issue-number)

See the exact actions or helpers for precise details about implications.

#### Project Type

Defaults: `:application`

Change the kind of project you are currently developing. This settings affects 
these actions and helpers:

 * [samsao.check_when_changelog_update_missing](#changelog-update-missing)

See the exact actions or helpers for precise details about implications.

#### Sources

Default: `[]`

Enable to change which paths are considered as being source files of the project. 
Multiple entries can be passed. Accepts multiple entries to be passed:

```
samsao.config do
  sources 'common/src', 'web/src'
end
```

Each source entry can be a `Regexp`

```
sources /^(common|mobile|web|/src)/
```

Or a pure `String`. When a pure string, matches the start of git modified files list:

```
  sources 'common/src'
```

Would match `common/src/a/b.txt` but not `other/common/src/a/b.txt`.

### Actions

Here all the actions you can call in your own `Dangerfile` and how to configure them. 

#### Report Levels

Each action as a `level` parameter that can be set to fail, warn or simply write 
a message if the check fails. Each action also has a default value for the check.

The possible values for `level` are the following:
 * `:fail`
 * `:warn`
 * `:message`

For example since `check_wrong_branching_model` has the default value of `:fail`. 
If you don't want this check to reject your PR, you can overwrite it by writing :

```
samsao.check_wrong_branching_model :warn
```

Note that only a `:fail` will reject the PR.

#### Acceptance Criteria

```
samsao.check_acceptance_criteria(level = :warn)
```

Parameters:
 * `level` |  The [report level](#report-levels) to use when the check does not pass.

Check if it's a feature branch (starts with `feature/`) and if the PR body contains
the string `acceptance criteria`.

#### Branching Model

```
samsao.check_wrong_branching_model(level = :fail)
```

Parameters:
 * `level` |  The [report level](#report-levels) to use when the check does not pass.

Check if the branch does not respect the git branching model. We follow git flow 
branching model and if the branch name does not start with one of the following 
prefixes:

 * `fix/`
 * `bugfix/`
 * `hotfix/`
 * `feature/`
 * `release/`
 * `support/`

#### CHANGELOG Update Missing

```
samsao.check_changelog_update_missing(level = :fail)
```

Parameters:
 * `level` |  The [report level](#report-levels) to use when the check does not pass.

Check if when a PR is made that is not flagged as a [trivial change](#trivial-change) 
and the changelog (based on `changelogs` config options) has not been modified.

When the project is of type `:application`, a change made to a [support branch]
(#support-branch) will pass even if the changelog is not updated.

#### Label PR

```
samsao.check_label_pr(level = :fail)
```

Parameters:
 * `level` |  The [report level](#report-levels) to use when the check does not pass.

Check if the PR has at least one label added to it.

#### Feature Branch Multiple Commits

```
samsao.check_non_single_commit_feature(level = :fail)
```

Parameters:
 * `level` |  The [report level](#report-levels) to use when the check does not pass.

Check if it's a feature branch (starts with `feature/`) and the PR contains more 
than one commit.

#### Feature Jira Issue Number

```
samsao.check_feature_jira_issue_number(level = :fail)
```

Parameters:
 * `level` |  The [report level](#report-levels) to use when the check does not pass.

Check if it's a feature branch (starts with `feature/`) and the PR title contains the
issue number using your configuration's [jira project key](#jira-project-key).

Example : `[VER-123] Adding new screen.`

#### Fix Jira Issue Number

```
samsao.check_fix_jira_issue_number(level = :warn)
```

Parameters:
 * `level` |  The [report level](#report-levels) to use when the check does not pass.

Check if it's a feature branch (starts with `fix/`, `bugfix/` or `hotfix/`.) and if every
commit message contains any issue number using your configuration's [jira project key](#jira-project-key).

Example : `[VER-123, VER-124, VER-125] Bug fixes.`

#### Merge Commit(s) Detected

```
samsao.check_merge_commit_detected(level = :fail)
```

Parameters:
 * `level` |  The [report level](#report-levels) to use when the check does not pass.

Check if one or multiple merge commits are detected.

A merge commit is one created when merging two branches and matching the
regexp `^Merge branch '<base branch>'` where `<base branch>` is the branch
the PR is being merged into (usually `develop`).

Use a Git `rebase` to get rid of those commits and correctly sync up with `develop` branch.

#### Work in Progress PR

```
samsao.check_work_in_progess_pr(level = :warn)
```

Parameters:
 * `level` |  The [report level](#report-levels) to use when the check does not pass.

Check if the PR title contains the `[WIP]` marker

### Helpers

#### Changelog Modified?

```
samsao.changelog_modified?
```

When no arguments are given, returns true if any configured [changelogs](#changelogs) 
has been modified in this commit.

When one or more arguments are given, returns true if any given changelog entry 
file has been modified in this commit.

#### Contains Jira Issue Number?

```
samsao.contains_jira_issue_number?(input)
```

Return true if input contains the issue number using your configuration's
[jira project key](#jira-project-key). The input could be a PR title or a commit message.

Example : `[VER-123] Adding new screen.` or `[VER-123, VER-124, VER-125] Bug fixes.`

#### Feature Branch?

```
samsao.feature_branch?
```

Returns true if the PR branch starts with `feature/`.

#### Fix Branch?

```
samsao.fix_branch?
```

Returns true if the PR branch starts with `fix/`, `bugfix/` or `hotfix/`.

#### Has App Changes?

```
samsao.has_app_changes?
```

When no arguments are given, returns true if any configured [source files](#sources) 
has been modified in this commit.

When one or more arguments are given, uses same rules as for [source files](#sources) 
(see section for details) and returns true if any given source entry files have 
been modified in this commit.

#### Has Jira Project Key?

```
samsao.jira_project_key?
```

Return true if the config has a [jira project key](#jira-project-key).

#### Release Branch?

```
samsao.release_branch?
```

Returns true if the PR branch starts with `release/`.

#### Shorten Sha

```
samsao.shorten_sha(sha)
```

Parameters:
 * `sha` |  The sha to shorten.

Shorten the git sha to 8 characters mostly for readability.

#### Support Branch?

```
samsao.support_branch?
```

Returns true if the PR branch starts with `support/`.

#### Trivial Change?

```
samsao.trivial_change?
```

Returns true if the PR title contains `#trivial`, `#typo` or `#typos`.

#### Truncate

```
samsao.truncate(input, max = 30)
```

Parameters:
 * `input` |  The input to truncate.
 * `max` |  The max length of the truncated input.

Truncate the input received to the max size passed as a parameter. the default value for
the max is 30 characters.

## Development

You must have `Ruby` and `Bundler` installed to develop this project as well
as a GitHub token (see [Testing](#tests) section below).

1. Clone this repository.
2. Run `bundle install` to setup dependencies.
3. Run `bundle exec rake` to run the linters and the tests (See notes below about [testing](#tests)).
4. Use `bundle exec guard` to automatically have tests run as you make changes.
5. Make your changes.
6. Send PR.

### Tests

Prior running test, you need to setup a GitHub API token. Connect to GitHub
and then go to your profile's settings page. There, go to
`Developer Settings > Personal access tokens` and click the `Generate new token`
button. Enter a `Description` for the token something like `Danger Testing` and
then check the `repo` box (`Full control of private repositories`) then click
`Generate` at the bottom of the page.

Once you have the token, make it available as an environment variable named
`DANGER_GITHUB_API_TOKEN`. Preferred way is to use a `.env` file at the root
of this project. Simply do `cp .env.example .env` and edit the copied `.env`
and enter the token to the side of `DANGER_GITHUB_API_TOKEN` line.

### Publish

The release process is quite simple. It consists of doing a release commit,
run a rake task and finally doing a bump to next version commit and push it.
Assume for the rest of this section that we are releasing version `0.1.0`
and today's date is `May 1st, 2017`. Terminal commands are given, but feel
free to use `SourceTree` or anything else.

Start by checking out the `develop` branch and ensure you are up-to-date
with remote

```
git checkout develop
git pull
```

Once on the branch, modify `CHANGELOG.md` so that `In progress` is replaced by
the current version and released date `## 0.1.0 (May 1, 2017)`. Then modify
`lib/samsao/gem_version.rb` to ensure the version is set to current value
`VERSION = '0.1.0'.freeze`. Lastly, run `bundle install` just to ensure
`Gemfile.lock` has correct new version also.

With all these changes, make a release commit and use the following normalized
text as the commit message:

```
Released version 0.1.0
```

Once the commit is done, simply run `bundle exec rake release`. This will
ask you for the Samsao's RubyGems credentials (only if it's your first
release, ask a system administrator to get them). It will create a tag
on the current commit of the current branch (should be the release commit
made earlier) named `v0.1.0`. And it will finally push the branch & tag to the
repository as well as building and publishing the gem on RubyGems.

The last thing to do is bumping to next development version. Edit back
`CHANGELOG.md` so that `## In progress` is the new section header and
add a bunch of empty lines (around 10, only 2 shown in the example for
brevity) into single `Features` section (add other sections when updating
the CHANGELOG). Each line should be starting with a **space** followed by
a **star**:

```
## In progress

#### Features

 *

 *

## 0.1.0 (May 1, 2017)
```

Also edit `lib/samsao/gem_version.rb` so that next development version
value is used `VERSION = '0.1.1.pre1'.freeze`. The `.pre1` is the lowest
possible version before the official `0.1.1` one (or higher).

Commit all these changes together in a new commit that has the following
message:

```
Bumped to next development version
```

Finally, create a PR with this branch and open a pull request and merge
right away (your teammates should know in advance that a release is
happening and branch merged faster than other ones).
