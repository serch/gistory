require 'date'

module Gistory
  class GitRepo
    def initialize(dir:)
      unless Dir.exist?(File.join(dir, '.git'))
        raise(Gistory::Error, 'This is not a valid git repository')
      end
      unless git_cli_available?
        raise(Gistory::Error, 'git is not available, please install it')
      end
    end

    def git_cli_available?
      system('which git > /dev/null 2>&1')
    end

    def changes_to_file(filename)
      max_count = Gistory.config.max_lockfile_changes
      hashes_and_dates = git("log --pretty=format:'%h|%cD' --max-count=#{max_count} --follow #{filename}")
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
