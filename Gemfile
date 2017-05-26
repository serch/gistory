# frozen_string_literal: true

source 'https://rubygems.org'

gemspec

group :development, :test do
  gem 'byebug' # debugger
  gem 'pry' # better console
  gem 'pry-byebug' # pry integration for byebug
end

group :test do
  gem 'coveralls', require: false
  gem 'flexmock' # mock library
  gem 'simplecov', require: false # code coverage
end

local_gemfile = 'Gemfile.local'
eval_gemfile(local_gemfile) if File.exist?(local_gemfile)
