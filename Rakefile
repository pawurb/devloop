require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

desc "Test"
task :test do
  system("bundle exec rspec spec/")
end
