# frozen_string_literal: true

module Gistory
  class Configuration
    attr_accessor :gem_name, :max_fetched_commits
    attr_writer :all_branches, :output_commit_hashes_only

    def initialize
      @max_fetched_commits = 100
      @all_branches = false
      @output_commit_hashes_only = false
    end

    def all_branches?
      @all_branches
    end

    def output_commit_hashes_only?
      @output_commit_hashes_only
    end
  end
end
