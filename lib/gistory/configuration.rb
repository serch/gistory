# frozen_string_literal: true

module Gistory
  class Configuration
    attr_accessor :gem_name, :max_lockfile_changes, :all_commits

    def initialize
      @max_lockfile_changes = 100
      @all_commits = false
    end
  end
end
