require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new('spec')

desc "Run RSpec with code coverage"
task :coverage do
  ENV["COVERAGE"] = "true"
  Rake::Task["spec"].execute
end

task :default => :spec

task :console do
  sh "irb -rubygems -I lib -r euromail.rb"
end