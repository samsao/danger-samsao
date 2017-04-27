require 'pathname'
ROOT = Pathname.new(File.expand_path('../../', __FILE__))
$LOAD_PATH.unshift((ROOT + 'lib').to_s)
$LOAD_PATH.unshift((ROOT + 'spec').to_s)

require 'bundler/setup'

require 'danger'
require 'danger_plugin'
require 'pry'
require 'rspec'

# Configure RSpec
RSpec.configure do |config|
  config.filter_gems_from_backtrace 'bundler'
  config.color = true
  config.tty = true
end

Dir["#{File.expand_path('../matchers', __FILE__)}/*.rb"].each do |file|
  require file
end

# rubocop:disable Lint/NestedMethodDefinition
def testing_ui
  @output = StringIO.new
  def @output.winsize
    [20, 9999]
  end

  cork = Cork::Board.new(out: @output)
  def cork.string
    out.string.gsub(/\e\[([;\d]+)?m/, '')
  end

  cork
end
# rubocop:enable Lint/NestedMethodDefinition

# Testing environment (ENV)
def testing_env
  {
    'BITRISE_IO' => 'true',
    'BITRISE_PULL_REQUEST' => '92',
    'DANGER_GITHUB_API_BASE_URL' => 'https://api.github.com',
    'DANGER_GITHUB_API_TOKEN' => ENV['DANGER_GITHUB_API_TOKEN'],
    'GIT_REPOSITORY_URL' => 'git@github.com:samsao/verdant.git',
  }
end

# A stubbed out Dangerfile for use in tests
def testing_dangerfile
  env = Danger::EnvironmentManager.new(testing_env)

  Danger::Dangerfile.new(env, testing_ui)
end
