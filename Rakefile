# frozen_string_literal: true

require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

require "rubocop/rake_task"

RuboCop::RakeTask.new

# Steep type checking
begin
  require "steep/rake_task"
rescue LoadError
  # steep not available
else
  Steep::RakeTask.new do |t|
    t.check.severity_level = :error
  end
end

# RBS file generation
namespace :rbs do
  desc "Generate RBS files from inline annotations"
  task :generate do
    sh "bundle exec rbs-inline --output lib/**/*.rb lib/*.rb"
  end

  desc "Check if RBS files are up to date"
  task :check do
    sh "bundle exec rbs-inline --output lib/**/*.rb lib/*.rb"
    sh "git diff --exit-code sig/generated || (echo 'RBS files are out of date. Run: rake rbs:generate' && exit 1)"
  end
end

# Development tasks
namespace :dev do
  desc "Setup development environment"
  task :setup do
    sh "bundle install"
    sh "bundle exec rake rbs:generate"
  end

  desc "Run all checks and generate RBS files"
  task ci: %i[rbs:generate check]
end

# Combined check task
desc "Run all checks (tests, rubocop, steep)"
task check: %i[spec rubocop steep:check]

# Update default task to include steep
task default: %i[spec rubocop steep:check]
