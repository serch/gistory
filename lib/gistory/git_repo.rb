require 'date'

module Gistory
  class GitRepo
    Change = Struct.new(:commit, :date)

    def initialize(dir:)
      @dir = dir
      # TODO: check it valid git repo
    end

    def changes_to_file(filename)
      commits_and_dates = `git log --pretty=format:"%h|%cD" --max-count=100 --follow #{filename}`
      changes = commits_and_dates.split("\n").map do |line|
        commit_hash, date = line.split('|')
        Change.new(commit_hash, DateTime.parse(date))
      end
      changes
    end

    def file_content_at_commit(commit_hash, filename)
      `git show #{commit_hash}:#{filename}`
    end
  end
end
