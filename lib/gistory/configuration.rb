# frozen_string_literal: true

module Gistory
  class Configuration
    attr_accessor :gem_name, :max_lockfile_changes
    attr_writer :all_commits

    def initialize
      @max_lockfile_changes = 100
      @all_commits = false
    end

    def all_commits?
      @all_commits
    end
  end
end
