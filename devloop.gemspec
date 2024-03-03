# -*- encoding: utf-8 -*-
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "devloop/version"

Gem::Specification.new do |s|
  s.name = "devloop"
  s.version = Devloop::VERSION
  s.authors = ["pawurb"]
  s.email = ["contact@pawelurbanek.com"]
  s.summary = %q{ Ruby test runner }
  s.description = %q{ This simple tool allows to run apps tests based on current git diff output. }
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
