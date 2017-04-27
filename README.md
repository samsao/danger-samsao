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

### Config

Some of the actions of this plugin can be configured by project to make stuff
easier. This is done by using the `config` attributes the plugin:

```
samsao.config do
  sources 'app/src'
end
```
**Note**: No actions currently use this but it's coming!

### Actions

Here all the actions you can call in your own `Dangerfile` and how to
configure them.

#### Branching Model

```
samsao.fail_when_wrong_branching_model
```

Going to make the PR fails when the branch does not respect the git branching
model.

## Development

You must have `Ruby` and `Bunlder` installed to develop this project.

1. Clone this repository.
2. Run `bundle install` to setup dependencies.
3. Run `bundle exec rake` to run the linters and the tests.
4. Use `bundle exec guard` to automatically have tests run as you make changes.
5. Make your changes.
6. Send PR.
