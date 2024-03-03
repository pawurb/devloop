# -*- encoding: utf-8 -*-
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "devloop/version"

Gem::Specification.new do |s|
  s.name = "devloop"
  s.version = Devloop::VERSION
  s.authors = ["pawurb"]
  s.email = ["contact@pawelurbanek.com"]
  s.summary = "An automated test runner for Rails applications.  Execute specs instantly based on a recent git diff output."
  s.description = "Devloop is an automated Rspec runner for Rails app. The purpose of this tool is to provide continuous and instant feedback when working on Rails app. It runs only specs from lines modified in the recent git commits. Even if you have a large user_spec.rb file, you'll receive specs feedback in a fraction of a second on each file save."
  s.homepage = "https://github.com/pawurb/devloop"
  s.files = `git ls-files`.split("\n")
  s.test_files = s.files.grep(%r{^(spec)/})
  s.require_paths = ["lib"]
  s.executables = ["devloop", "devloop_run"]
  s.license = "MIT"
  s.add_development_dependency "rake"
  s.add_development_dependency "rspec"
  s.add_development_dependency "rufo"

  if s.respond_to?(:metadata=)
    s.metadata = { "rubygems_mfa_required" => "true" }
  end
end
