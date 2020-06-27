# frozen_string_literal: true

module Gistory
  class ChangeLog
    LOCKFILE = 'Gemfile.lock'

    def initialize(repo:)
      @repo = repo
    end

    def changelog_for_gem(gem_name)
      version_changes = []
      commits_with_changes = @repo.changes_to_file(LOCKFILE)

      # no lockfile found or no changes to the lockfile found
      return [] if commits_with_changes.empty?

      previous_commit = commits_with_changes.shift
      previous_gem_spec = gem_version_at_commit_hash(previous_commit.short_hash, gem_name)
      # only one change to the lockfile was found and the gem was not there
      return [] if previous_gem_spec.nil?

      commits_with_changes.each do |current_commit|
        current_gem_spec = gem_version_at_commit_hash(current_commit.short_hash, gem_name)

        # we reached the end, the gem didn't exist back then
        # TODO: what if it was added then removed and then added again?
        break if current_gem_spec.nil?

        if current_gem_spec != previous_gem_spec
          version_changes << VersionChange.new(commit: previous_commit, version: previous_gem_spec)
        end

        previous_gem_spec = current_gem_spec
        previous_commit = current_commit
      end

      version_changes << VersionChange.new(commit: previous_commit, version: previous_gem_spec)

      version_changes
    end

    private

    def gem_version_at_commit_hash(commit_hash, gem_name)
      lockfile_content = @repo.file_content_at_commit(commit_hash, LOCKFILE)
      LockfileParser.new(lockfile_content: lockfile_content).gem_version(gem_name)
    end
  end
end
