require 'date'

module Gistory
  class GitRepo
    Change = Struct.new(:commit, :date)
    VersionChange = Struct.new(:commit, :date, :version)

    def initialize(dir:)
      @dir = dir
      # TODO: check it valid git repo
    end

    def lockfile_changes
      commits_and_dates = `git log --pretty=format:"%h|%cD" --max-count=100 --follow Gemfile.lock`
      changes = commits_and_dates.split("\n").map do |line|
        commit_hash, date = line.split('|')
        Change.new(commit_hash, DateTime.parse(date))
      end
      changes
    end

    def lockfile_for_commit(commit_hash)
      `git show #{commit_hash}:Gemfile.lock`
    end

    def changelog_for_gem(gem_name)
      version_changes = []
      previous_version = nil

      lockfile_changes.each do |change|
        lockfile = Bundler::LockfileParser.new(lockfile_for_commit(change.commit))
        gem_spec = lockfile.specs.find { |spec| spec.name == gem_name }

        # we got to the end, the gem didnt exist back then
        # what if it was added then removed and then added again???
        break if gem_spec.nil?

        if previous_version.nil?
          version_changes << VersionChange.new(change.commit, change.date, gem_spec.version)
          previous_version = gem_spec.version.to_s
        elsif gem_spec.version.to_s != previous_version
          # only save it if it changed
          version_changes << VersionChange.new(change.commit, change.date, gem_spec.version)
          previous_version = gem_spec.version.to_s
        end
      end

      version_changes
    end
  end
end
