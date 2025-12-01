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

task default: %i[spec rubocop]
