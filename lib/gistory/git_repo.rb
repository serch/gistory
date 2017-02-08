require 'date'

module Gistory
  class GitRepo
    def initialize(dir:)
      @dir = dir
      # TODO: check it valid git repo
    end

    def changes_to_file(filename)
      hashes_and_dates = git("log --pretty=format:'%h|%cD' --max-count=100 --follow #{filename}")
      to_commits(hashes_and_dates.split("\n"))
    end

    def to_commits(hashes_and_dates)
      hashes_and_dates.map do |hash_and_date|
        commit_hash, date = hash_and_date.split('|')
        Commit.new(short_hash: commit_hash, date: DateTime.parse(date))
      end
    end

    def file_content_at_commit(commit_hash, filename)
      git("show #{commit_hash}:#{filename}")
    end

    def git(command)
      `git #{command}`
    end
  end
end
