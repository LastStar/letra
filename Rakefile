require 'bundler'
require "bundler/gem_tasks"
require 'rake/testtask'
Bundler::GemHelper.install_tasks

Rake::TestTask.new(:test) do |t|
  t.libs << 'test'
  t.pattern = 'test/**/test_*.rb'
end

task :default => :test
