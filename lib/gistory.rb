# frozen_string_literal: true
require 'gistory/version'

require 'gistory/cli/main'
require 'gistory/cli/arg_parser'
require 'gistory/configuration'

require 'gistory/errors'
require 'gistory/commit'
require 'gistory/version_change'
require 'gistory/git_repo'
require 'gistory/change_log'

module Gistory
  class << self
    def config
      @config ||= Gistory::Configuration.new
    end
  end
end
