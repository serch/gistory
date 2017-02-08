# frozen_string_literal: truew
require 'bundler'

module Gistory
  class ChangeLog
    LOCKFILE = 'Gemfile.lock'.freeze

    def initialize(repo:)
      @repo = repo
    end

    def changelog_for_gem(gem_name)
      version_changes = []
      previous_version = nil
      lockfile_changes = @repo.changes_to_file(LOCKFILE)

      lockfile_changes.each do |commit|
        gem_spec = gem_spec_at_commit_hash(commit.short_hash)

        # we reached the end, the gem didn't exist back then
        # TODO: what if it was added then removed and then added again?
        break if gem_spec.nil?

        # only store version changes of this gem
        unless gem_spec.version.to_s == previous_version
          version_changes << VersionChange.new(commit: commit, version: gem_spec.version)
          previous_version = gem_spec.version.to_s
        end
      end

      version_changes
    end

    private

    def gem_spec_at_commit_hash(commit_hash)
      lockfile_content = @repo.file_content_at_commit(commit_hash, LOCKFILE)
      lockfile = Bundler::LockfileParser.new(lockfile_content)
      gem_spec = lockfile.specs.find { |spec| spec.name == gem_name }
      gem_spec
    end
  end
end
