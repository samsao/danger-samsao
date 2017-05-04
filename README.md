# Danger Samsao

A Danger plugin bringing Samsao's PR guideline into code.

## Installation

Simply add `danger-samsao` to your `Gemfile` and configure your `Dangerfile`
using all the nice goodies.

## Usage

Methods and attributes from this plugin are available in
your `Dangerfile` under the `samsao` namespace.

### Table of Contents

 * [Config](#config)
 * [Actions](#actions)
   * [samsao.fail_when_changelog_update_missing](#changelog-update-missing)
   * [samsao.fail_when_merge_commit_detected](#merge-commits-detected)
   * [samsao.fail_when_non_single_commit_feature](#feature-branch-multiple-commits)
   * [samsao.fail_when_wrong_branching_model](#branching-model)
   * [samsao.warn_when_work_in_progess_pr](#when-work-in-progess-pr)
 * [Helpers](#helpers)
   * [samsao.changelog_modified?](#changelog-modified-)
   * [samsao.feature_branch?](#feature-branch-)
   * [samsao.fix_branch?](#fix-branch-)
   * [samsao.has_app_changes?](#has-app-changes-)
   * [samsao.release_branch?](#release-branch-)
   * [samsao.trivial_branch?](#trivial-branch-)
   * [samsao.trivial_change?](#trivial-change-)

### Config

Some of the actions of this plugin can be configured by project to make stuff
easier. This is done by using the `config` attributes the plugin:

```
samsao.config do
  changelogs 'CHANGELOG.yml'
  sources 'app/src'
end
```

#### Changelogs

Default: `CHANGELOG.md`

Enable to change the CHANGELOG file paths looked upon when checking if
CHANGELOG file has been modified or not.

#### Sources

Default: `<Empty>`

Enable to change which paths are considered has being source files of the
project. Multiple entries can be passed. Accepts multiple entries to be passed:

```
samsao.config do
  sources 'common/src', 'web/src'
end
```

Each source entry can be a `Regexp`

```
sources /^(common|mobile|web|/src)/
```

Or a pure `String`. When a pure string, matches start of git modified files list:

```
  sources 'common/src'
```

Would match `common/src/a/b.txt` but not `other/common/src/a/b.txt`.

### Actions

Here all the actions you can call in your own `Dangerfile` and how to
configure them.

#### Branching Model

```
samsao.fail_when_wrong_branching_model
```

Going to make the PR fails when the branch does not respect the git branching
model.

#### CHANGELOG Update Missing

```
samsao.fail_when_changelog_update_missing
```

Going to make the PR fails when it's a feature branch (starts with `feature/`)
or fix branch (`fix/`) and the CHANGELOG file was not updated.

#### Feature Branch Multiple Commits

```
samsao.fail_when_non_single_commit_feature
```

Going to make the PR fails when it's a feature branch (starts with `feature/`)
and the PR contains more than one commit.

#### Merge Commit(s) Detected

```
samsao.fail_when_merge_commit_detected
```

Going to make the PR fails when one or multipl merge commits are detcted.
A merge commit is one created when merging two branches and matching the
regexp `^Merge branch '<base branch>'` where `<base branch>` is the branch
the PR is being merged into (usually `develop`).

Use a Git `rebase` to get rid of those commits and correctly sync up with
`develop` branch.

#### Work in Progress PR

```
samsao.warn_when_work_in_progess_pr
```

Going to mark PR as in warning state when PR title contains the `[WIP]` marker

### Helpers

#### Changelog Modified?

```
samsao.changelog_modified?
```

When no arguments are given, returns true if any configured [changelogs](#changelogs) has
been modified in this commit.

When one or more arguments is given, returns true if any given changelog entry file has been
modified in this commit.

#### Has App Changes?

```
samsao.has_app_changes?
```

When no arguments are given, returns true if any configured [source files](#sources) has
been modified in this commit.

When one or more arguments is given, uses same rules as for [source files](#sources) (see
section for details) and returns true if any given source entry files has been modified in this
commit.

#### Feature Branch?

```
samsao.feature_branch?
```

Returns true if the PR branch starts with `feature/`.

#### Fix Branch?

```
samsao.fix_branch?
```

Returns true if the PR branch starts with `fix/`.

#### Release Branch?

```
samsao.release_branch?
```

Returns true if the PR branch starts with `release/`.

#### Trivial Branch?

```
samsao.trivial_branch?
```

Returns true if the PR branch starts with `trivial/`.

#### Trivial Change?

```
samsao.trivial_change?
```

Returns true if the PR title contains `#trivial` or `#typo` or the branch is a
trivial branch ([trivial_branch?](#trivial-branch-) helper).

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

Last thing to do is bumping to next development version. Edit back
`CHANGELOG.md` so that `## In progress` is the new section header and
add a bunch of empty lines (around 10, only 2 shown in the example for
brevity) starting with a **space** followed by a **star**:

```
## In progress

 *

 *

## 0.1.0 (May 1, 2017)
```

Also edit `lib/samsao/gem_version.rb` so that next development version
value is used `VERSION = '0.1.1.pre1'.freeze`. The `.pre1` is the lowest
possible version before the official `0.1.1` one (or higher).

Commit all this changes together in a new commit that has the following
message:

```
Bumped to next development version
```

Finally, create a PR with this branch and open a pull request and merge
right away (your team mates should known in advance that a release is
happening and branch merged faster than other ones).
