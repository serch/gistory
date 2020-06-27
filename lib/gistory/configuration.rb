# frozen_string_literal: true

module Gistory
  class Configuration
    attr_accessor :gem_name, :max_fetched_commits
    attr_writer :all_branches

    def initialize
      @max_fetched_commits = 100
      @all_branches = false
    end

    def all_branches?
      @all_branches
    end
  end
end
