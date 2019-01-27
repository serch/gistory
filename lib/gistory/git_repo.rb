# frozen_string_literal: true

require 'English'

module Gistory
  class GitRepo
    def initialize(path:)
      raise(Gistory::Error, 'This is not a valid git repository') unless Dir.exist?(File.join(path, '.git'))
      raise(Gistory::Error, 'git is not available, please install it') unless git_cli_available?
    end

    def changes_to_file(filename)
      max_count = Gistory.config.max_lockfile_changes
      hashes_and_dates = git("log --pretty=format:'%h|%cD' --max-count=#{max_count} --follow #{filename}")
      to_commits(hashes_and_dates.split("\n"))
    end

    def file_content_at_commit(commit_hash, filename)
      git("show #{commit_hash}:#{filename}")
    end

    private

    def git_cli_available?
      system('which git > /dev/null 2>&1')
    end

    def to_commits(hashes_and_dates)
      hashes_and_dates.map do |hash_and_date|
        commit_hash, date = hash_and_date.split('|')
        Commit.new(short_hash: commit_hash, date: date)
      end
    end

    def git(command)
      out = `git #{command}`
      raise 'Git CLI command failed' unless $CHILD_STATUS.success?
      out
    end
  end
end
