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
   * [Branching Model](#branching-model)
   * [CHANGELOG update missing](#changelog-update-missing)
   * [Feature branch multiple commits](#feature-branch-multiple-commits)
 * [Helpers](#helpers)
   * [Feature branch?](#feature-branch-)
   * [Fix branch?](#fix-branch-)
   * [Release branch?](#release-branch-)
   * [Trivial branch?](#trivial-branch-)

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

### Helpers

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
