require 'bundler'

module Gistory
  class ChangeLog
    LOCKFILE = 'Gemfile.lock'.freeze
    VersionChange = Struct.new(:commit, :date, :version)

    def initialize(repo:)
      @repo = repo
    end

    def changelog_for_gem(gem_name)
      version_changes = []
      previous_version = nil

      lockfile_changes = @repo.changes_to_file(LOCKFILE)

      lockfile_changes.each do |change|
        lockfile_content = @repo.file_content_at_commit(change.commit, LOCKFILE)
        lockfile = Bundler::LockfileParser.new(lockfile_content)
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
