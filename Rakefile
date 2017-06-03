# rubocop:disable Style/HashSyntax

require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'

task default: :check

task :check => [:lint, :tests]

task :lint => [:lint_ruby, :lint_danger]

desc 'Run RuboCop on the lib/specs directory'
RuboCop::RakeTask.new(:lint_ruby) do |task|
  task.patterns = ['lib/**/*.rb', 'spec/**/*.rb', '*.gemspec', 'Dangerfile', 'Gemfile', 'Guardfile', 'Rakefile']
end

desc 'Ensure that the plugin passes `danger plugins lint`'
task :lint_danger do
  sh 'bundle exec danger plugins lint --warnings-as-errors'
end

task :test => [:tests]
RSpec::Core::RakeTask.new(:tests)
