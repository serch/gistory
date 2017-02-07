require 'date'

module Gistory
  class GitRepo
    Change = Struct.new(:commit, :date)

    def initialize(dir:)
      @dir = dir
      # TODO: check it valid git repo
    end

    def lockfile_changes
      commits_and_dates = `git log --pretty=format:"%H|%cD" --max-count=100 --follow Gemfile.lock`
      changes = commits_and_dates.split("\n").map do |line|
        commit_hash, date = line.split('|')
        Change.new(commit_hash, DateTime.parse(date))
      end
      changes
    end

    def lockfile_for_commit(commit_hash)
      `git show #{commit_hash}:Gemfile.lock`
    end
  end
end
