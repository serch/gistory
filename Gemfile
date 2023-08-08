# frozen_string_literal: true

source "https://rubygems.org"

gemspec

gem  "pry", "~> 0.13.1"
gem  "pry-byebug", "~> 3.9.0"
gem  "rake", "~> 13.0"
gem  "rspec", "~> 3.9"
gem  "rubocop"
gem  "rubocop-performance"
gem  "rubocop-rspec"

group :test do
  gem "coveralls", require: false
  gem "simplecov", require: false # code coverage
end

local_gemfile = "Gemfile.local"
eval_gemfile(local_gemfile) if File.exist?(local_gemfile)
