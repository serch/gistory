# frozen_string_literal: true
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
        lockfile_content = @repo.file_content_at_commit(commit.short_hash, LOCKFILE)
        lockfile = Bundler::LockfileParser.new(lockfile_content)
        gem_spec = lockfile.specs.find { |spec| spec.name == gem_name }

        # we got to the end, the gem didnt exist back then
        # what if it was added then removed and then added again???
        break if gem_spec.nil?

        # only save it if the version changed
        unless gem_spec.version.to_s == previous_version
          version_changes << VersionChange.new(commit: commit, version: gem_spec.version)
          previous_version = gem_spec.version.to_s
        end
      end

      version_changes
    end
  end
end
