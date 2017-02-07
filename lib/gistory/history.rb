require 'bundler'

module Gistory
  class History
    def initialize(repo:, args:)
      @repo = repo
      @args = args
    end

    def run
      history(@args.shift)
    rescue Gistory::Error => error
      puts error.message
    end

    def history(gem_name)
      raise(Gistory::Error, 'No gem name provided') if gem_name.nil?
      puts "Gem: #{gem_name}"

      lockfile_changes = @repo.lockfile_changes

      latest = lockfile_changes.shift
      lockfile = Bundler::LockfileParser.new(@repo.lockfile_for_commit(latest.commit))
      gem_spec = lockfile.specs.find { |spec| spec.name == gem_name }
      puts "Current version: #{gem_spec.version}"
      puts ''

      puts 'Change history:'
      puts "#{gem_spec.version} on #{latest.date.strftime('%a, %e %b %Y %H:%M %Z')} (commit #{latest.commit[0..6]})"
      previous_version = gem_spec.version
      lockfile_changes.each do |change|
        lockfile = Bundler::LockfileParser.new(@repo.lockfile_for_commit(change.commit))
        gem_spec = lockfile.specs.find { |spec| spec.name == gem_name }

        # we got to the end, the gem didnt exist back then
        # what if it was added then removed and then added again???
        break if gem_spec.nil?

        # only print it if it changed
        if gem_spec.version.to_s != previous_version
          previous_version = gem_spec.version.to_s
          puts "#{gem_spec.version} on #{change.date.strftime('%a, %e %b %Y %H:%M %Z')} (commit #{change.commit[0..6]})"
        end
      end
    end
  end
end
