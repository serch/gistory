# frozen_string_literal: true

source "https://rubygems.org"

gemspec

group :development, :test do
  gem "byebug"
  gem "pry", "~> 0.13.1"
  gem "pry-byebug", "~> 3.9.0"
end

group :test do
  gem "coveralls", require: false
  gem "simplecov", require: false # code coverage
end

local_gemfile = "Gemfile.local"
eval_gemfile(local_gemfile) if File.exist?(local_gemfile)
