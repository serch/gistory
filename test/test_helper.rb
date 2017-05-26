# frozen_string_literal: true
require 'simplecov'
require 'coveralls'

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new([
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter
])
SimpleCov.start

$LOAD_PATH.unshift(File.expand_path('../../lib', __FILE__))
require 'gistory'

require 'pry'
require 'minitest/autorun'
require 'flexmock/minitest'
