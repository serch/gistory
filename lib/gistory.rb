require 'gistory/version'

require 'gistory/errors'
require 'gistory/commit'
require 'gistory/version_change'
require 'gistory/git_repo'
require 'gistory/change_log'
require 'gistory/cli'
require 'gistory/arg_parser'
require 'gistory/configuration'

module Gistory
  class << self
    def config
      @config ||= Gistory::Configuration.new
    end
  end
end
