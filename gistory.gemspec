# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "gistory/version"

Gem::Specification.new do |spec|
  spec.name = "gistory"
  spec.version = Gistory::VERSION
  spec.platform = Gem::Platform::RUBY
  spec.required_ruby_version = ">= 2.4"
  spec.authors = ["Sergio Medina"]
  spec.email = ["medinasergio@gmail.com"]

  spec.summary = "Gistory: Know exactly when a gem was updated in your Gemfile.lock"
  spec.description = "Gistory: Know exactly when a gem was updated in your Gemfile.lock"
  spec.homepage = "https://www.github.com/serch/gistory"
  spec.licenses = ["MIT"]

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "bundler", "~> 2.0"
  spec.add_dependency "colorize"
end
