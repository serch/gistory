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

      changes = @repo.changelog_for_gem(gem_name)
      puts "Current version: #{changes.first.version}"
      puts ''

      changes.each do |change|
        puts "#{change.version} on #{change.date.strftime('%a, %e %b %Y %H:%M %Z')} (commit #{change.commit})"
      end
    end
  end
end
