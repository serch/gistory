# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gistory/version'

Gem::Specification.new do |spec|
  spec.name = 'gistory'
  spec.version = Gistory::VERSION
  spec.authors = ['Sergio Medina']
  spec.email = ['medinasergio@gmail.com']

  spec.summary = 'Gistory: Know exactly when a gem was updated in your Gemfile.lock'
  spec.description = 'Gistory: Know exactly when a gem was updated in your Gemfile.lock'
  spec.homepage = 'https://www.github.com/serch/gistory'

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'bundler', '~> 1.14' # FIXME: what is the minimum bundler version I need?

  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'minitest', '~> 5.0'
  spec.add_development_dependency 'pry'
end
