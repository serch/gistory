# frozen_string_literal: true
require 'simplecov'
SimpleCov.start

$LOAD_PATH.unshift(File.expand_path('../../lib', __FILE__))
require 'gistory'

require 'minitest/autorun'
require 'flexmock/minitest'
